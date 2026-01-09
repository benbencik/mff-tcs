#import "../lib.typ": *

= Parallel Algorithms & Concurrency

#big_question("Locks, Atomics, ABA, Lock-free vs Lock-based")[
  Describe locks and atomic primitives (CAS, LL/SC). Design and analyze a lock-free stack. Explain the ABA problem and its fix. Compare parallelization of data structures with locks vs using atomic primitives (lock-free), including typical pitfalls for both approaches.
]

== Locking: Problems and Solutions

=== Problems with Locks

*Common pitfalls of lock-based parallelization*:
- *Deadlock*: Circular wait for locks. Process A holds lock 1 and waits for lock 2, while process B holds lock 2 and waits for lock 1. Both processes wait forever.
- *Livelock*: Processes keep retrying operations without making progress (spinning without advancing).
- *Priority inversion*: Low-priority process holds a lock while high-priority process waits. Solution: *priority inheritance* — a process holding a lock has its priority raised to the maximum priority of processes waiting for the lock.
- *Convoying*: Many threads queue behind a single lock holder, serializing execution.
- *Blocking*: One stalled thread (e.g., preempted while holding a lock) halts all other threads.
- *Performance overhead*: Lock operations consume CPU cycles and memory, especially with fine-grained locking.
- *Fault tolerance*: If a process terminates abnormally while holding locks, those locks remain locked forever, causing other processes to wait indefinitely.

=== Correctness: Serializability

#definition("Serializability")[
  A sequence of operations on a data structure is *serializable* if there exists a linear (total) order on all operations such that:
  1. The result of each operation is consistent with the operations preceding it in the order.
  2. From the point of view of every process, the order of operations executed by that process is consistent with the total order.
]

This provides a formal definition of correctness for concurrent data structures. For example, if one process searches for an item while another inserts it, the search can return either "not found" or "found" — both are correct under serializability.

*Sequential consistency* is a stronger concept requiring a single linear order common to all data structures. While easier to reason about, it is inefficient on current hardware.

== Atomic Primitives

#definition("Atomic Operations")[
  Atomic operations guarantee consistency without locks. They operate on special memory locations called *atomic registers*, where operations are serializable.
]

*Basic atomic operations*:
- *Read and Write*: Atomic register can be read or written as a whole. Concurrent accesses are resolved in an unknown but consistent order.
- *Exchange*: Swap contents of atomic register with a value. Can implement mutex: unlocked = 0, locking exchanges with 1.
- *Test and Set Bit*: Set a bit and return original value. Common building block for locks.
- *Fetch and Add*: Add to register and return original value.
- *Compare and Swap (CAS)*: Given register $R$, values $"old"$ and $"new"$: if $R = "old"$, set $R := "new"$. Always returns original value of $R$.
- *Load Linked / Store Conditional (LL/SC)*: LL reads and monitors address. Later SC to same address succeeds only if no other processor wrote to it. Otherwise SC reports failure.

*Key differences*:
- *CAS* can be simulated using LL/SC, but not vice versa.
- *LL/SC* inherently avoids the ABA problem (see below) because monitoring detects any intervening write.
- Current hardware implements atomic read/write plus either CAS or LL/SC.

== Locking in Search Trees

=== Locking a Path (Naive Approach)

*Strategy*: Follow path from root downward, locking nodes as visited.
- *Find*: Lock path, search for key.
- *Insert* (without balancing): Lock path, add leaf at end.
- *Delete*: Lock path, remove node with ≤1 child or replace with successor.

*Correctness*: All decisions remain valid because locked nodes cannot be modified. Can add rebalancing traversing path bottom-up.

*Deadlock freedom*: Order nodes by depth; every downward path forms a chain in this partial order. No cycles possible.

*Fatal flaw*: Every path contains the root → all operations serialized by root lock. Other locks have no effect.

=== Locking a Sliding Window

For Find and Insert (no balancing), keep only a window of size 2 locked: current node and its child.

*Algorithm*:
1. Compare key with current node (locked).
2. Read pointer to appropriate child.
3. Lock child.
4. Unlock current node.
5. Move to child.
6. For Insert: create new node (no lock needed — we're the only one with pointer), attach to current node (locked).

*Advantages*:
- Much greater concurrency: root quickly unlocked, paths diverge.
- Deadlock impossible: locks taken in order of increasing depth.

*Limitations*:
- Cannot add Delete or traditional balancing (AVL, red-black) which propagate changes upward.
- Contention at root still significant if number of processes exceeds tree height.

== Parallel (a,b)-trees with Locks

#small_question("Parallel (a,b)-trees")[
  Show how to parallelize an (a,b)-tree using locks.
]

*Strategy*: Use top-down (a,b)-trees with preemptive restructuring.

=== Locking Protocol

*Window size*: Lock current node and its parent (sometimes also a sibling for Delete).

*Insert*:
1. Hold lock on current node and parent.
2. If current node is full (size $b$), split it preemptively.
3. Unlock parent.
4. Find appropriate child, lock it.
5. Move to child and repeat.
6. At leaf: insert key, unlock.

*Delete*:
1. Hold lock on current node and parent.
2. If child would underflow after deletion, fix preemptively (borrow from sibling or merge).
3. Need to lock sibling for borrow/merge operations.
4. Unlock parent, move to child.
5. At leaf: delete key, unlock.

*Find*:
- Use read locks (reader-writer locks allow multiple concurrent reads).
- Release locks as you descend.
- Alternative: Lock-free reads on immutable fields with versioning, but simplest approach is read locks.

=== Deadlock Avoidance

*Primary ordering*: By level (depth) — never acquire parent after child.
*Secondary ordering*: Within same level, order left-to-right.

*Problem*: After examining current node, may need left sibling.
*Solutions*:
1. Always lock left sibling before current node, even if not accessed.
2. If parent is locked first, can safely lock its children in any order (Exercise 2 in lecture notes).

*Lock upgrade issue*: Never upgrade read→write lock in place. Release and retry if needed.

=== Key Deletion Issue

Traditional approach: Replace non-leaf key with successor requires keeping current node locked while finding successor. If current node is root, this locks entire tree.

*Solution*: Mark key as deleted instead of physical removal. Periodically clean up marked keys (e.g., ensure at most half of keys are marked deleted).

=== Complexity and Benefits

*Time complexity*: $O(log n)$ per operation (same as sequential).
*Lock overhead*: Small constant factors; at most 2-3 locks held simultaneously.
*Contention*: Root can be bottleneck, but high fan-out and rare root splits mitigate this.
*Fault tolerance*: Still problematic — abnormal termination leaves locks held.

== Lock-free Data Structures

=== Lock-free Stack (Treiber)

#small_question("Lock-free Stack")[
  Design and analyze lock-free implementation of a stack.
]

*Structure*: Linked list of nodes. Each node contains data and an atomic pointer to next. Keep atomic pointer `Head` to top of stack.

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
- CAS guarantees detection of interference → restart operation.
- *Livelock* possible: loop indefinitely without completing. In practice, extremely improbable due to random scheduling factors.
- System makes progress: if CAS fails, another process succeeded.
- *Lock-free* guarantee (defined below).

=== The ABA Problem

#small_question("Atomic Primitives & ABA")[
  Describe atomic primitives and their properties. Explain the ABA problem and its solution.
]

#definition("ABA Problem")[
  A subtle bug in lock-free algorithms where a pointer value is recycled, fooling CAS. The core issue: CAS assumes all nodes ever pushed are distinct. Original node A confused with logically different node at same address.
]

*Scenario*:
1. Initial stack: `Head → A → B → null`
2. *Process 1*: Starts Pop. Executes steps 2-3: `h = A`, `s = B`. Prepares `CAS(Head, A, B)`.
3. *Context switch* → Process 1 pauses.
4. *Process 2* executes:
   - `Pop()` → removes A. Stack: `Head → B`
   - `Pop()` → removes B. Stack: `Head → null`
   - `Push(A)` → memory allocator reuses address of A. Stack: `Head → A → null`
5. *Process 1 resumes*: Executes CAS. Head is A (the new one), so CAS succeeds! Sets `Head := B`.
6. *Disaster*: B was already freed! Stack now points to freed memory → corruption or crash.

=== Solutions to ABA

*Solution 1: LL/SC instead of CAS*
- If step 2 of Pop is LL and step 4 is SC, the SC fails even if head changed A → B → A in the meantime.
- LL/SC inherently detects intervening writes.

*Solution 2: Double-CAS (CAS2)*
- Simultaneously CAS on pair of registers: `CAS2(⟨stack.head, h.next⟩, ⟨h, n⟩, ⟨n, n⟩)`.
- Detects that head node was reconnected with different successor.
- *Problem*: No current processor supports general CAS2.

*Solution 3: Wide CAS (WCAS / Double-Width CAS)*
- CAS2 on two adjacent memory locations.
- *Versioning*: Pair each pointer with integer version counter. Increment version on every change.
- Step 2 becomes: `⟨h, v⟩ ← ⟨stack.head, stack.head_version⟩`
- Step 4 becomes: `If WCAS(⟨stack.head, stack.head_version⟩, ⟨h, v⟩, ⟨n, v+1⟩) = ⟨h, v⟩`
- Version overflow harmless as long as it doesn't wrap within single Pop invocation.
- *Advantage*: Often supported by hardware (e.g., `CMPXCHG16B` on x64).

*Solution 4: Avoid node recycling*
- Allocate new node for every Push.
- Requires separate memory reclamation scheme (see next section).

=== Memory Reclamation

*Problem*: With locks, free node memory after Pop. With lock-free: other processes may still access popped node (obtained pointer before Pop finished). Their CAS will fail, but they might access invalid memory first → crash.

*Solution*: Collect unused nodes in free list (managed as lock-free stack). Free after ensuring no processes reference them.

*Approach 1: Global Synchronization*
- Periodically synchronize all processes at point where they hold no pointers.
- Free all chunks from free list.
- Simple, but synchronization points hard to find.

*Approach 2: Reference Counting*
- Each node has atomic counter of references (local variables pointing to node).
- Maintain free list. Periodically scan and free nodes with zero references.
- *Amortization*: With $P$ processes, each holding $<= R$ references, at most $R P$ references exist. Start scan when free list accumulates $>= 2 R P$ items → always free $>= 1/2$ of nodes. Time charged to freed nodes: $O(1)$ per node.

*Modified Pop with reference counting*:
```
1. Repeat:
2.   h ← stack.head
3.   Increment h.ref_cnt
4.   If h ≠ stack.head:
5.     Decrement h.ref_cnt and retry
6.   s ← h.next
7.   If CAS(stack.head, h, s) = h:
8.     Decrement h.ref_cnt and return h
9.   Decrement h.ref_cnt
```

*Subtlety*: Between reading pointer (step 2) and incrementing counter (step 3), node might be freed. Re-check pointer (step 4). If node already recycled for different use, might temporarily corrupt unrelated structure → recycle memory only as nodes of same layout with counter at fixed position.

*Approach 3: Hazard Pointers*
- Instead of per-node tracking, collect all "hazardous references" in single global array.
- Array split to fixed-size blocks, each owned by one process.
- Process sets hazard pointer before accessing node, re-checks node still connected.

*Modified Pop with hazard pointers*:
```
1. Repeat:
2.   h ← stack.head
3.   hp ← h              // One of our hazard pointers
4.   If h ≠ stack.head:
5.     Retry             // No need to reset hp
6.   s ← h.next
7.   If CAS(stack.head, h, s) = h:
8.     hp ← ∅ and return h
```

*Freeing with hazard pointers*:
- Take snapshot of hazard pointer array.
- Build search structure (e.g., sorted array with binary search).
- For each node in free list, query if still accessed.
- *Correctness*: Node disconnected before entering free list. Any concurrent Pop reaching step 6 with pointer to node → hazard pointer set before node enters free list → snapshot includes all relevant pointers.

=== Hierarchy of Concurrent Data Structures

#definition("Progress Guarantees")[
  Concurrent data structures differ in strength of guarantees:
]

- *Blocking*: Correct, but operation can wait indefinitely (e.g., for lock held by another process).
- *Obstruction-free*: If all other processes stop, my operation succeeds in finite time.
- *Lock-free*: If multiple processes execute, at least one succeeds in finite time. No fairness guarantee — livelocks allowed.
- *Wait-free*: Every operation guaranteed to succeed in finite time.
- *Bounded wait-free*: Wait-free with upper bound on time (typically function of number of processes).

Our Treiber stack is *lock-free* but not wait-free.

=== Comparison: Locks vs Lock-free

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Lock-based*], [*Lock-free*],
  [Simple reasoning and implementation], [Complex: ABA, memory reclamation],
  [Easy composability], [Hard to compose operations],
  [Straightforward memory management], [Requires hazard pointers or epochs],
  [Deadlock, livelock, priority inversion], [Potential starvation under contention],
  [Convoying, blocking on preemption], [Non-blocking progress, resilient to preemption],
  [Fault intolerant (locks held by crashed process)], [More fault tolerant],
  [Good for coarse-grained, low contention], [Good for fine-grained, latency-sensitive hot paths]
)

*Recommendation*: Use locks when critical sections are coarse and contention low. Prefer lock-free for fine-grained, high-throughput scenarios where tail latency and preemption resilience matter.