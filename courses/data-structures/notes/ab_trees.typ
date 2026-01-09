#import "../lib.typ": *

= Balanced Search Trees

== (a,b)-Trees
#big_question("(a,b)-Trees")[
  Define (a,b)-tree. Describe how Find, Insert and Delete operations work on it. Describe advantages and disadvantages compared to other data structures, especially balanced binary search trees. Analyze their worst-case and amortized complexity.
]

#definition("(a,b)-Tree")[
  A multi-way search tree satisfying the following properties:
  1. *Structure*: All external nodes (leaves) are at the same depth
  2. *Internal Nodes*: Every internal node (except the root) has at least $a$ and at most $b$ children
  3. *Root*: The root has at least 2 and at most $b$ children (unless it is a leaf)
  4. *Parameters*: $a >= 2$ and $b >= 2a - 1$
]

=== Operations

1. *Find(x)*: Start at the root. In each node, compare $x$ with the keys to identify the correct child pointer. Repeat until $x$ is found or an external node is reached 

2. *Insert(x)*: Search for the correct leaf. Insert the key into the parent of the external node 
   - *Overflow Handling*: If a node has $b$ keys (reaching $b+1$ children)
     - *Split*: Divide the node into two nodes.
     - *Promote*: Move the middle key up to the parent 
     - *Propagate*: If the parent overflows, repeat the split upwards

#fig("ab-split.png") 

3. *Delete(x)*: Find $x$. If $x$ is in an internal node, swap it with its successor and delete from the leaf 
   - *Underflow Handling*: If a node size drops below $a-1$ keys
     - *Transfer (Borrow)*: If a sibling has enough keys, move a key from the sibling to the parent, and a key from the parent to the underflowing node
     - *Merge*: If the sibling has only the minimum number of keys, merge the node with the sibling and bring down the separator key from the parent
     - *Propagate*: If the parent underflows, repeat up the tree

#fig("ab-merge.png")

#fig("ab-borrow.png", width: 70%)

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Advantages*], [*Disadvantages*],
  [Disk Optimization: Nodes can be sized to match disk blocks (minimizing I/O) .], [Space Waste: Nodes are not always full (utilization varies between $a$ and $b$).],
  [Uniform Depth: Perfectly balanced height ensures consistent logarithmic performance.], [Complexity: Implementation is more complex than standard BSTs due to splitting/merging.]
)
)

=== Complexity Analysis

*Worst-Case Time Complexity*: 
- *Find*: $Theta(log n)$ (assuming $b$ is small constant relative to $a$)
- *Insert Calculation*: In the worst case, we visit $Theta(1)$ nodes on each level and spend $Theta(b)$ time on each node. This makes $Theta(b dot log n / log a)$ total time 
  - *Correctness of Split*: We must show that nodes created by splitting are not undersized (have at least $a$ children). We split a node when it reaches $b+1$ children (having $b$ keys). We send one key to the parent, so the new nodes take roughly $(b-1)/2$ keys. If they were undersized, we would have $(b-1)/2 < a-1$, implying $b < 2a-1$. This explains the definition condition $b >= 2a-1$ 
- *Delete Calculation*: Similar to Insert, Delete visits $Theta(1)$ nodes per level in the worst case (merging up to root). With $Theta(b)$ work per node, the complexity is $Theta(b dot log n / log a)$ 

#lemma("Depth of (a,b)-tree")[
  The height $h$ of an (a,b)-tree with $n$ keys satisfies:
  $ log_b (n + 1) <= h <= 1 + log_a ((n + 1) / 2) $ 
]

#proof[
  We bound the number of keys $n$ for a fixed height $h$.
  
  *1. Upper Bound on Height (Minimum Keys)*
  To maximize height, we minimize keys per node ($a-1$ keys).
  - Root: 1 key.
  - Level $i$: $2 dot a^(i-1)$ nodes.
  - Total keys: $ n >= 1 + sum_(i=1)^(h-1) 2 a^(i-1) (a-1) = 2 a^(h-1) - 1 $ 
  - Solving for $h$: $h <= 1 + log_a ((n+1)/2)$ 

  *2. Lower Bound on Height (Maximum Keys)*
  To minimize height, we maximize keys per node ($b-1$ keys).
  - Level $i$: $b^i$ nodes.
  - Total keys: $ n <= sum_(i=0)^(h-1) b^i (b-1) = b^h - 1 $ 
  - Solving for $h$: $h >= log_b (n+1)$ 
]

=== Amortized Analysis

While worst-case modification cost is $O(log n)$, the amortized cost of structural changes is lower if we provide "breathing space" between rebalancing thresholds.


#theorem("Amortized Update Cost")[
  For an $(a,b)$-tree where $b >= 2a$ (specifically analyzing $(a, 2a)$), a sequence of $m$ Insert and Delete operations on an initially empty tree performs $O(m)$ node modifications. Thus, the amortized number of modifi/ations per operation is $O(1)$
]

#proof[
  The function $f(k)$ maps the number of keys $k$ in a node to a potential value. To ensure $O(1)$ amortized cost, it must satisfy three conditions :

  1. *Limited Change*: $|f(i) - f(i+1)| <= c$. 
    - *Insight*: Changing a node by one key (standard insert/delete) should only change the potential by a constant amount
  2. *Free Splits*: $f(2a) >= f(a) + f(a-1) + c + 1$. 
    - *Insight*: A node at the splitting threshold ($2a$ keys) must have enough stored potential to pay for the cost of the split (creating two new nodes) and still result in a net potential drop 
  3. *Free Merges*: $f(a-2) + f(a-1) >= f(2a-2) + c + 1$.
    - *Insight*: An underflowing node ($a-2$) and its sibling ($a-1$) must have enough combined potential to pay for the merge operation

  We use a *Potential Function* $Phi = sum_(v) f(k_v)$. The function $f(k)$ assigns high potential to nodes near overflow/underflow

  #table(
    columns: (auto, auto, 1fr),
    align: (center, center, left),
    [*Keys $k$*], [*Potential $f(k)$*], [*Status*],
    [$a-2$], [2], [Underflow (needs merge)],
    [$a-1$], [1], [Risk of underflow],
    [$a$ ... $2a-2$], [0], [Safe Zone (Stable)],
    [$2a-1$], [2], [Risk of split],
    [$2a$], [4], [Overflow (needs split)]
  )

  - *Insert*: Adding a key costs $O(1)$ real work. If a split occurs (node full at $2a$), the potential drops from 4 to 0 for the new nodes, releasing 4 units. This "released" potential pays for the split
  - *Delete*: Removing a key costs $O(1)$. Merging/borrowing releases potential accumulated in the "Risk" states ($a-1$ or $a-2$), paying for the merge
  
  Since $Phi >= 0$ and starts at 0, the total real cost is bounded by the initial work plus the potential changes, resulting in $O(1)$ amortized structural changes
]

#small_question("Amortized Node Changes: (a,2a) vs (a,2a-1)")[
  State and prove the theorem about amortized number of node changes for Insert and Delete on $(a,2a)$-trees. How does this differ for $(a,2a-1)$-trees?
]

*$(a,2a)$-trees (Wide Slack, Clean Amortization)*:
- The "safe" zone spans keys $a .. 2a-2$; risk states are $a-2, a-1$ (underflow side) and $2a-1, 2a$ (overflow side).
- With the potential assignment in the table above (high potential on risk states), each split at $2a$ and each merge from $a-2$ releases a constant amount of potential that pays for the restructure.
- Result: A sequence of $m$ updates performs $O(m)$ structural changes. Amortized node modifications per operation are $O(1)$.

*$(a,2a-1)$-trees (Narrower Slack, Extra Local Fixes)*:
- Splitting a full node of size $2a-1$ may produce children with about $(a-1)$ and $(a-1)$ keys, which is closer to the minimum and can trigger an immediate transfer/borrow at the next update.
- Likewise, underflows occur at $a-2$ more often relative to the width of the safe zone, so local "borrow"/"merge" steps happen slightly more frequently.
- Adjusted potential: Increase weights on the near-minimum state ($a-1$) and near-maximum state ($2a-1$) to ensure a split/merge causes a net drop that pays for its cost.
- Result: The asymptotic bound remains the same: $O(1)$ amortized node modifications per operation. The difference is in constants and in the need to account for an extra local transfer after some splits.

#theorem("Amortized Updates on $(a,2a-1)$-trees")[
  There exists a potential function over node occupancies such that any sequence of $m$ Inserts/Deletes on an $(a,2a-1)$-tree performs $O(m)$ node modifications. Hence, the amortized number of node changes per operation is $O(1)$.
]

#proof[
  Define $f(k)$ to assign higher potential to boundary occupancies $k in {a-2, a-1, 2a-2, 2a-1}$, with strictly larger weights on $a-1$ and $2a-1$ than in the $(a,2a)$ case. The conditions analogous to the three constraints (limited change, free splits, free merges) still hold:
  1. *Limited Change*: $|f(k+1) - f(k)| <= c$ ensures single-key updates cost $O(1)$ amortized.
  2. *Free Split at $2a-1$*: Post-split children sit near $a-1$; the potential drop across parent and children covers the split work and any immediate transfer if needed.
  3. *Free Merge at $a-2$*: Combined potential of the underflowing node and its sibling pays for the merge and rebalancing at the parent.
  Since total potential is non-negative and decreases sufficiently on rebalancing events, total real work across $m$ updates is $O(m)$, yielding $O(1)$ amortized node changes.
]

== BB[α]-Trees

#small_question("BB[α]-Trees")[
  Describe search trees with lazy balancing (BB[α]-trees). Analyze their amortized complexity. Give an example of their use.
]

#definition("Lazily Balanced Tree")[
  Let $s(v)$ be the size of the subtree rooted at $v$ (number of nodes).
  A node $v$ is *in balance* if for each child $c$:
  $ s(c) <= 2/3 s(v) $
  A tree is *balanced* if all its nodes are in balance. This guarantees logarithmic height.
]

=== Lazy Balancing Strategy

Instead of rebalancing immediately upon every update (like AVL or Red-Black trees), we allow the tree to become slightly unbalanced. When a node violates the balance condition, we *rebuild* the entire subtree rooted at that node to be *perfectly balanced*.

*Rebuilding Process*:
1.  Identify the highest node $v$ that is out of balance.
2.  Collect all elements in the subtree and build a perfectly balanced tree (where for every node, sizes of children differ by at most 1).
3.  This takes $Theta(s(v))$ time.

=== Amortized Analysis

#theorem("Amortized Complexity")[
  The amortized cost of the `Insert` operation on a lazily balanced tree is $O(log n)$.
]

#proof[
  We use the *Potential Method*. We define the potential to quantify the imbalance.
  
  *Potential Function*:
  $ Phi = sum_(v in T) phi(v), quad "where" phi(v) = cases(
    |s(v_l) - s(v_r)| &"if" |s(v_l) - s(v_r)| >= 2,
    0 &"otherwise"
  ) $
  ($v_l, v_r$ are children of $v$). Perfectly balanced nodes contribute 0.

  *1. Analysis of Insert (Path Update)*:
  - Adding a leaf increases the size $s(v)$ of all ancestors by 1.
  - The difference $|s(v_l) - s(v_r)|$ changes by exactly 1 for these nodes.
  - Due to the clamping (0 if difference < 2), the contribution $phi(v)$ increases by at most 2.
  - Since the tree height is $O(log n)$, the total potential increase is $Delta Phi <= 2 dot O(log n) = O(log n)$.
  - The real cost of the insertion (without rebuild) is $O(log n)$.
  
  *2. Analysis of Rebuild*:
  - Suppose we rebuild at node $v$. The invariant was broken, so for some child $c$: $s(c) > 2/3 s(v)$.
  - This implies the imbalance is $|s(v_l) - s(v_r)| > 1/3 s(v)$.
  - Before rebuilding, the contribution was $phi(v) > 1/3 s(v)$.
  - After rebuilding, the subtree is perfectly balanced, so $phi(u) = 0$ for all $u$ in the subtree.
  - The potential decreases by at least $1/3 s(v)$.
  - The real cost of rebuilding is $Theta(s(v))$.
  - The drop in potential covers the real cost. Thus, the amortized cost of rebuilding is $<= 0$.

  *Conclusion*: The total amortized cost is dominated by the insertion path update, which is $O(log n)$.
]

=== Advantages and Use Cases

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Advantages*], [*Use Cases*],
  [Simplicity: No rotations needed, just rebuild when necessary.], [Multi-dimensional structures: Used in k-d trees where rotations are complex or impossible.],
  [Flexibility: Balance parameter $alpha$ can be tuned for different workloads.], [Augmented data: When maintaining subtree sizes or other aggregate information.],
  [Good cache behavior: Rebuilding creates a perfectly balanced subtree.], [Persistent structures: Easier to make persistent than rotation-based trees.]
)

#observation[
  BB[$alpha$]-trees are particularly useful when:
  - Rotations are expensive or impossible (e.g., in spatial data structures)
  - Maintaining augmented data (like subtree sizes) is required
  - Perfect balance after rebuilding provides better cache locality
]