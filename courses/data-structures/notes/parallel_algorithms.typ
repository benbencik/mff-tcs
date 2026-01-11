#import "../lib.typ": *

= Parallel Algorithms & Concurrency

#big_question("Locks, Atomics, ABA, Lock-free vs Lock-based")[
  Describe locks and atomic CAS and LL/SC operations. Design and analyze a lock-free stack. Explain the ABA problem and propose its solution. Compare the parallelization of data structures using locks versus using atomic operations (so-called lock-free data structures), explaining potential problems in both cases.
]

=== Locks and Problems

*Locks (Mutexes)* are synchronization primitives that enforce mutual exclusion. At any moment, a mutex is either locked or unlocked.
- *LOCK*: Waits until unlocked, then locks it.
- *UNLOCK*: Unlocks the mutex.

*Common pitfalls of lock-based parallelization*:
- *Deadlock*: Circular wait for locks (e.g., A waits for B, B waits for A). Solved by ordering locks.
- *Livelock*: Processes keep retrying operations without making progress.
- *Priority inversion*: Low-priority process holds a lock needed by a high-priority process.
- *Convoying*: Threads queue behind a bottleneck lock.
- *Blocking*: Stalled thread halts others waiting for the lock.
- *Fault tolerance*: If a thread crashes holding a lock, the system hangs.

=== Atomic Primitives

Atomic operations are indivisible instructions on shared memory (atomic registers). They are the building blocks for lock-free structures.

- *Read/Write*: Basic access.
- *Exchange*: Swaps register value with a local value (can implement locks).
- *Test and Set*: Sets a bit and returns old value.
- *Fetch and Add*: Atomically increments a value.
- *Compare and Swap (CAS)*: `CAS(R, old, new)` atomically sets register `R` to `new` only if it currently equals `old`. Returns the original value.
- *Load Linked / Store Conditional (LL/SC)*: `LL` reads a value. `SC` writes a new value only if the address hasn't changed since `LL`.

=== Lock-free Stack (Treiber Stack)

A stack implemented using a linked list and CAS on the head pointer.

*Structure*:
- `Head`: Atomic pointer to the top node.
- Nodes: Contain data and `next` pointer.

*Push(x)*:
```
1. Repeat:
2.   h ← stack.head
3.   n.next ← h
4.   If CAS(stack.head, h, n) = h:
5.     Return
```

*Pop()*:
```
1. Repeat:
2.   h ← stack.head
3.   s ← h.next
4.   If CAS(stack.head, h, s) = h:
5.     Return h
```

*Analysis*:
- *Correctness*: Serializes operations at the linearization point (the CAS).
- *Progress*: Lock-free. If a CAS fails, it means another process succeeded, so system-wide progress is guaranteed.
- *Livelock*: Possible theoretically, but rare in practice.

=== The ABA Problem

*Definition*: A subtle bug where a pointer is recycled. Process $P_1$ reads value $A$. Process $P_2$ changes it to $B$ and then back to $A$. $P_1$'s CAS succeeds (seeing $A$), assuming nothing changed, but the state is actually different (e.g., node $A$ was freed and reallocated).

*Scenario*:
1. Stack: $A arrow B$. $P_1$ reads head $A$, next $B$.
2. $P_2$ pops $A$, pops $B$, pushes $A$ back. Stack: $A$.
3. $P_1$ performs `CAS(head, A, B)`. It succeeds!
4. *Result*: Stack head is now $B$, but $B$ was already removed/freed. Corruption.

*Solutions*:
1. *LL/SC*: Inherently detects writes, even if value is restored.
2. *Versioned Pointers (Wide CAS)*: Store `{ptr, version}`. Increment version on every update. CAS checks both.
3. *Hazard Pointers / GC*: Delay memory reclamation so $A$ isn't reused while $P_1$ holds a reference.

=== Memory Reclamation (Safe Memory Reuse)

In lock-free structures, we cannot free nodes immediately after popping because other threads might have read pointers to them.

*Techniques*:
- *Reference Counting*: Atomic counters for active references.
- *Hazard Pointers*: Threads publish pointers they are accessing. Nodes are freed only when no hazard pointers reference them.
- *Epochs / RCU*: Free nodes only after all threads have passed a "quiescent" state.

=== Comparison: Locks vs. Lock-free

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Lock-based*], [*Lock-free*],
  [Simple reasoning (mutual exclusion).],
  [Complex reasoning (linearizability, ABA).],

  [Easy memory management.], [Hard memory management (reclamation).],
  [Deadlocks, Priority Inversion.], [No deadlocks.],
  [Blocking (preemption halts progress).],
  [Non-blocking (resilient to preemption).],

  [Fault intolerant (crash holds lock).],
  [Fault tolerant (crash doesn't block others).],

  [Good for low contention.], [Good for high contention.],
)

#small_question("Parallel (a,b)-trees")[
  Show how to parallelize an (a,b)-tree using locks.
]

=== Locking Strategies in Search Trees

To parallelize tree operations, we avoid locking the entire tree.

*Locking a Path (Hand-over-hand)*:
- Lock node, access child, lock child, unlock parent.
- *Problem*: Rebalancing propagates up. Deadlocks if not careful.

*Sliding Window*:
- For `Find` / `Insert` (top-down), lock a small window (e.g., node and child).
- Allows concurrent access to different parts of the tree.

=== Parallel (a,b)-trees

We use a *top-down* approach (preemptive splitting/merging) to avoid upward propagation, allowing efficient fine-grained locking.

*Protocol*:
- Use a "sliding window" of locks.
- Insert/Delete always fix nodes *on the way down* so no return path is needed.

*Insert(x)*:
```
1. Lock root.
2. Window: {current, parent}.
3. While not at leaf:
4.   If current is full:
5.     Split current (safe because parent has space).
6.   Unlock parent.
7.   Lock appropriate child -> becomes current.
8. Insert into leaf.
```

*Delete(x)*:
```
1. Lock root.
2. Window: {current, parent, sibling}.
3. While not at leaf:
4.   If current is thin (min keys):
5.     Lock sibling.
6.     Borrow or Merge (safe because parent has keys).
7.     Unlock sibling.
8.   Unlock parent.
9.   Lock child -> becomes current.
10. Delete from leaf.
```

*Deadlock Avoidance*:
- Always lock parent before child (depth order).
- At same level (sibling), lock left-to-right or always lock sibling before accessing.

*Properties*:
- *Concurrency*: High. Operations only block if paths overlap.
- *Complexity*: $O(log n)$ time, constant number of locks held.
- *Correctness*: Serializes operations on local windows.
