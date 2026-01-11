#import "../lib.typ": *

= Balanced Search Trees

== (a,b)-Trees
#big_question("(a,b)-Tree")[
  Define an (a,b)-tree. Describe how the Find, Insert, and Delete operations work on it. State and prove the theorem about the amortized number of node changes for Insert and Delete operations on (a,2a)-trees. How does this differ for (a,2a-1)-trees? Describe the advantages and disadvantages compared to other data structures, especially balanced binary search trees.
]

#definition("(a,b)-Tree")[
  A multi-way search tree satisfying the following properties:
  1. *Structure*: All external nodes (leaves) are at the same depth
  2. *Internal Nodes*: Every internal node (except the root) has at least $a$ and at most $b$ children
  3. *Root*: The root has at least 2 and at most $b$ children (unless it is a leaf)
  4. *Parameters*: $a >= 2$ and $b >= 2a - 1$
]

=== Operations

*Find(x)*:
```
1. v = root
2. While v is internal:
3.   i = find_child_index(v, x) // smallest i such that x < keys[i]
4.   v = v.children[i]
5. Return v // external node (leaf)
```

*Insert(x)*:
```
1. v = Find(x)
2. p = v.parent
3. Insert key x and child v into p
4. While p.size > b:
5.   Split p into p1, p2
6.   Promote middle key to p.parent
7.   p = p.parent
8. If root was split:
9.   Create new root with 1 key and 2 children
```

#fig("ab-split.png")

*Delete(x)*:
```
1. v = Search(x)
2. If x is in internal node:
3.   Swap x with successor(x) (which is in a leaf-parent)
4. Remove x from leaf-parent p
5. While p.size < a - 1:
6.   If sibling s has > a - 1 keys:
7.     Borrow key from s (rotate through parent)
8.   Else (sibling s has a - 1 keys):
9.     Merge p and s (pull separator from parent)
10.    p = p.parent
11. If root is empty (after merge):
12.   Delete root, child becomes new root
```

#fig("ab-merge.png")

#fig("ab-borrow.png", width: 70%)

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Advantages*], [*Disadvantages*],
  [Disk Optimization: Nodes can be sized to match disk blocks (minimizing I/O) .],
  [Space Waste: Nodes are not always full (utilization varies between $a$ and $b$).],

  [Uniform Depth: Perfectly balanced height ensures consistent logarithmic performance.],
  [Complexity: Implementation is more complex than standard BSTs due to splitting/merging.],
)

=== Complexity Analysis

*Worst-Case Time Complexity*:
- *Find*: $Theta(log n)$ (assuming $b$ is small constant relative to $a$)
- *Insert Calculation*: In the worst case, we visit $Theta(1)$ nodes on each level and spend $Theta(b)$ time on each node. This makes $Theta(b dot log n / log a)$ total time
  - *Correctness of Split*: We must show that nodes created by splitting are not undersized (have at least $a$ children). We split a node when it reaches $b+1$ children (having $b$ keys). We send one key to the parent, so the new nodes take roughly $(b-1)/2$ keys. If they were undersized, we would have $(b-1)/2 < a-1$, implying $b < 2a-1$. This explains the definition condition $b >= 2a-1$
- *Delete Calculation*: Similar to Insert, Delete visits $Theta(1)$ nodes per level in the worst case (merging up to root). With $Theta(b)$ work per node, the complexity is $Theta(b dot log n / log a)$

=== Amortized Analysis

While worst-case modification cost is $O(log n)$, the amortized cost of structural changes is lower if we provide "breathing space" between rebalancing thresholds.

#theorem("Amortized Update Cost")[
  For an $(a,b)$-tree where $b >= 2a$ (specifically analyzing $(a, 2a)$), a sequence of $m$ Insert and Delete operations on an initially empty tree performs $O(m)$ node modifications.
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
    [$2a$], [4], [Overflow (needs split)],
  )

  - *Insert*: Adding a key costs $O(1)$ real work. If a split occurs (node full at $2a$), the potential drops from 4 to 0 for the new nodes, releasing 4 units. This "released" potential pays for the split
  - *Delete*: Removing a key costs $O(1)$. Merging/borrowing releases potential accumulated in the "Risk" states ($a-1$ or $a-2$), paying for the merge

  Since $Phi >= 0$ and starts at 0, the total real cost is bounded by the initial work plus the potential changes, resulting in $O(1)$ amortized structural changes
]

*$(a,2a)$-trees*:
- The "safe" zone spans keys $a .. 2a-2$; risk states are $a-2, a-1$ (underflow side) and $2a-1, 2a$ (overflow side).
- With the potential assignment in the table above (high potential on risk states), each split at $2a$ and each merge from $a-2$ releases a constant amount of potential that pays for the restructure.
- Result: A sequence of $m$ updates performs $O(m)$ structural changes. Amortized node modifications per operation are $O(1)$.

*$(a,2a-1)$-trees*:
- In the minimal case ($b = 2a-1$), the thresholds for splitting and merging are adjacent. Splitting a node with $2a-1$ keys produces two nodes with $a-1$ keys.
- If we immediately delete a key from one of these new nodes, it drops to $a-2$, triggering a merge.
- This leads to *thrashing* (or oscillation): a sequence of alternating Insert/Delete operations can cause repeated expensive split/merge operations up to the root.
- Consequently, the amortized cost per operation is $Omega(log n)$, not $O(1)$.
- To fix this, we can allow $b >= 2a$, creating a "breathing space" between split and merge thresholds.

#small_question("Depth of (a,b)-trees")[
  Analyze the depth of (a,b)-trees.
]

The height $h$ of an (a,b)-tree with $n$ keys satisfies: $ log_b (n + 1) <= h <= 1 + log_a ((n + 1) / 2) $

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
