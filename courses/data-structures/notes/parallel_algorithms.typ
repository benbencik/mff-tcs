#import "../lib.typ": *

= Parallel Algorithms & Concurrency

#small_question("Parallel (a,b)-trees")[
  Show how to parallelize (a,b)-tree.
]

*Goal*: Allow concurrent Find, Insert, Delete.

*Techniques*:

1.  *Lock Coupling (Hand-over-hand locking)*:
    - A thread holding a lock on node $u$ requests a lock on child $v$.
    - Only after granting lock on $v$ does it release $u$.
    - *Benefit*: Ensures the link $u -> v$ remains valid during traversal. No other thread can cut the branch while we are traversing.

2.  *Read-Write Locks*:
    - *Find*: Acquires Read locks. Multiple readers allowed.
    - *Update*: Acquires Write locks. Exclusive.

3.  *Top-Down Preemptive Restructuring*:
    - In standard B-trees, insertion splits nodes bottom-up. This requires releasing locks and re-acquiring parent locks (or holding a path of locks), which causes high contention or deadlocks.
    - *Preemptive Split*: As we traverse *down* for an Insert, if we encounter a full node (size $b$), we split it immediately.
    - *Benefit*: When we reach the leaf, we are guaranteed that the parent has space. We never need to propagate splits upward.
    - *Locking*: We only need to hold locks on the current node and its parent. We can release ancestors earlier.

#line(length: 100%, stroke: gray)

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

#line(length: 100%, stroke: gray)

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