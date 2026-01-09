#import "../lib.typ": *

= Parallel Algorithms & Concurrency

== Locks and Atomic Operations

#big_question("Locks, Atomics, ABA, Lock-free vs Lock-based")[
  Describe locks and atomic primitives (CAS, LL/SC). Design and analyze a lock-free stack. Explain the ABA problem and its fix. Compare parallelization of data structures with locks vs using atomic primitives (lock-free), including typical pitfalls for both approaches.
]

=== Basic Primitives

*Locks*:
- *Mutex / exclusive lock*: Only one thread enters the critical section; prevents races but can deadlock.
- *Readers-writer lock*: Multiple readers or a single writer; avoids writer starvation by preferring writers or using fair queues.
- Common problems: *deadlock* (circular wait), *livelock* (spinning without progress), *priority inversion* (low-priority thread holds lock while high-priority waits), *convoying* (many threads queue behind a lock holder), *blocking* (one stalled thread halts others).

*Atomics*:
- *CAS (Compare-And-Swap)*: Atomically compare memory with `expected`; if equal, write `new`. Fails otherwise.
- *LL/SC (Load-Linked / Store-Conditional)*: LL reads a location and marks it; SC succeeds only if no intervening write occurred. Avoids ABA on platforms that invalidate the reservation on any write.
- Atomics are non-blocking; progress guarantees depend on algorithm (lock-free, wait-free).

=== Lock-free Stack (Treiber) with ABA Fix

#small_question("Lock-free Stack with ABA Mitigation")[
  Design and analyze a lock-free stack using atomics; explain ABA and how to fix it.
]

*Algorithm (Treiber)*:
- `Head` is an atomic pointer (optionally paired with a counter/version).
- *Push(x)*: allocate node $N$; loop: read `old=Head`; set `N.next=old`; CAS `Head` from `old` to `N`.
- *Pop()*: loop: read `old=Head`; if null return Empty; `next=old.next`; CAS `Head` from `old` to `next`; return `old.value`.

*ABA Fixes*:
- *Tagged pointer / version counter*: Store `(ptr, tag)`; increment tag on every CAS. CAS compares both, so reuse of the same address is detected.
- *LL/SC*: SC fails if any write occurred after LL, inherently preventing ABA on supported hardware.
- *Memory reclamation*: Use hazard pointers or epoch-based reclamation so popped nodes are not freed while still visible to other threads.

*Cost*: Expected $O(1)$ per operation. Under contention, retries increase but overall system makes progress (lock-free).

=== Atomic Primitives & ABA (Recap)

#small_question("Atomic Primitives & ABA")[
  Describe atomic primitives and their properties. Explain the ABA problem and its solution.
]

*ABA Problem*: CAS only observes equality, not object identity. A location can go A -> B -> A; CAS sees A and succeeds even though state changed.

*Solutions*:
- Version counters / tagged pointers.
- LL/SC (reservation cleared by any write).
- Safe reclamation (hazard pointers, epochs) to avoid pointer reuse.

=== Locks vs Lock-free: Pros / Pitfalls

*Lock-based advantages*: Simple reasoning, composability, easy memory management.
*Lock-based pitfalls*: deadlock (cycle), livelock (spinners), priority inversion, convoying, blocking when a lock holder is preempted.

*Lock-free advantages*: Non-blocking progress (at least one thread moves), resilient to preemption of other threads, often better latency tails.
*Lock-free pitfalls*: ABA, memory reclamation complexity, starvation under high contention, cache thrashing due to retries.

Use locks when critical sections are coarse and contention low; prefer lock-free for fine-grained, latency-sensitive hot paths where progress under preemption matters.

== Parallel (a,b)-trees with Locks

#small_question("Parallel (a,b)-trees")[
  Show how to parallelize an (a,b)-tree using locks.
]

*Goals*: Concurrent Find/Insert/Delete with correctness (tree invariants) and bounded contention.

*Locking Strategy (top-down, latch coupling)*:
- Use reader-writer locks on nodes. Reads can share; writers are exclusive.
- *Traversal*: Hold lock on parent, acquire lock on child, then release parent (hand-over-hand) to keep parent->child link stable.
- *Preemptive split/merge*: On the way down, if a node is full (size $b$), split it before descending. If near-underflow, prepare to borrow/merge. This guarantees space at the leaf and avoids upward propagation while holding long lock chains.
- *Insert*: Start at root with write lock. While descending, split full nodes, then move down with latch coupling. Insert at leaf; release leaf lock.
- *Delete*: Descend with coupling. If a child would underflow, fix (borrow/merge) before going down so you never need to backtrack while holding multiple locks.
- *Find*: Use read locks; release as you descend. For higher throughput, allow lock-free reads on immutable fields when structural modifications use versioning, but simplest is read locks.

*Problems & mitigations*:
- Deadlock: Impose top-down locking order; never acquire a parent after a child. Avoid upgrading read->write in place; release and retry if needed.
- Starvation: Use fair reader-writer locks or writer preference to avoid writers being blocked by continuous readers.
- Contention hotspots: Root lock becomes bottleneck; use root splitting rarely and keep root high fan-out to reduce root modifications.

*Complexity*: Operations remain $O(log n)$; locking adds small constant factors. Preemptive fixes ensure each operation holds at most two locks simultaneously.

== Lock-free Stack

#small_question("Lock-free Stack")[
  Design and analyze lock-free implementation of a stack.
]

*Concept*: Implement a stack without mutexes, using hardware atomic instructions.

*Atomic Primitive: CAS (Compare-And-Swap)*
- `CAS(address, expected_value, new_value)`
- Atomically: If `*address == expected_value`, set `*address = new_value` and return `true`. Else return `false`.

*Treiber Stack Algorithm*:
- *Structure*: A singly linked list. `Head` is an atomic pointer to the top node.
- *Push(x)*:
  1. Allocate node $N$, set $N."value" = x$.
  2. `do { old = Head; N.next = old; } while (!CAS(&Head, old, N))`
  3. If CAS fails (Head changed by another thread), retry.
- *Pop()*:
  1. `do { old = Head; if (old == null) return Empty; next = old.next; } while (!CAS(&Head, old, next))`
  2. Return `old."value"`.

*Analysis*:
- *Lock-free*: If a CAS fails, it means another thread succeeded. System-wide progress is guaranteed.
- *Contention*: Under high load, many retries can occur (exponential backoff helps).

== Atomic Primitives & ABA

#small_question("Atomic Primitives & ABA")[
  Describe atomic primitives and their properties. Explain the ABA problem and its solution.
]

*The ABA Problem*:
A subtle bug in lock-free algorithms where a pointer value is recycled, fooling the CAS check.

*Scenario*:
1.  Stack contains: Top -> A -> B.
2.  *Thread 1*: Wants to Pop. Reads `old = A`, `next = A.next (B)`. Prepares `CAS(&Head, A, B)`.
3.  *Context Switch* -> Thread 1 pauses.
4.  *Thread 2*:
    - Pops A. Stack: Top -> B.
    - Pops B. Stack: Top -> (empty).
    - Pushes A (memory allocator reuses address of A). Stack: Top -> A.
5.  *Thread 1 Resumes*:
    - Executes `CAS(&Head, A, B)`.
    - The Head is indeed A (the new one). CAS succeeds.
    - Head is set to B.
6.  *Disaster*: B was already popped and freed! The stack is now corrupt (pointing to freed memory).

*Solution: Tagged Pointers (Version Counters)*
- Instead of storing just a pointer `ptr`, store a pair `(ptr, counter)` in a double-width atomic word (e.g., `CMPXCHG16B` on x64).
- Every time the pointer is updated, increment the counter.
- *Scenario Fixed*:
  - Thread 1 reads `(A, 1)`.
  - Thread 2 pops `(A, 1)`, pops `(B, 2)`, pushes `(A, 3)`.
  - Thread 1 tries `CAS(&Head, (A, 1), (B, 2))`.
  - Fails because `(A, 1) != (A, 3)`.