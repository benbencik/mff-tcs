#import "../lib.typ": *

= Range Trees & k-d Trees

#big_question("Multi-dimensional Range Trees")[
  Define multi-dimensional interval trees (range trees). Analyze the space complexity of the data structure and the time complexity of construction and rectangular queries (bonus: including acceleration by fractional cascading).
]

#definition("Range Tree")[
  A data structure for storing a set of points $P$ in $d$-dimensional space to support orthogonal range queries. It is defined recursively:
  - *1D*: A simple balanced binary search tree (BST) storing the scalar values. Each node corresponds to an interval covering its subtree.
  - *2D*: A primary 1D range tree (x-tree) built on the $x$-coordinates. Each node $v$ in the x-tree stores an *associated structure* (or secondary structure). This associated structure is a 1D range tree (y-tree) containing all points in the subtree of $v$, sorted by their $y$-coordinates.
  - *d-Dimensions*: A primary tree on the first coordinate where each node stores a $(d-1)$-dimensional range tree on the remaining coordinates for the points in its subtree.
]

=== Complexity Analysis

*Space Complexity*:
Why does it take super-linear space?
- *1D*: Standard BST takes $O(n)$.
- *2D*: Every point $p$ is stored in the primary x-tree once. However, $p$ is also stored in the y-tree of every node $v$ in the x-tree such that $p$ is in $v$'s subtree. Since the x-tree is balanced, each point has $O(log n)$ ancestors. Thus, each point appears in $O(log n)$ y-trees.
  - Total Space: $O(n log n)$.
- *d-Dimensions*: By induction, each dimension adds a factor of $log n$.
  - Total Space: $O(n log^(d-1) n)$.

*Construction Time*:
- *2D*: To build the structure, we first sort points by $x$. Building the x-tree takes $O(n)$. For each level of the x-tree, we build all associated y-trees. At any depth level of the x-tree, the total size of all disjoint subtrees is $n$. Since merging/building y-trees (sorted arrays/BSTs) takes linear time with respect to their size, each level takes $O(n)$. There are $O(log n)$ levels.
  - Total time: $O(n log n)$.
- *d-Dimensions*: $O(n log^(d-1) n)$.

*Query Time (Rectangular)*:
How the query works:
- *1D Query*: $O(log n + k)$. Find the split node, then traverse left and right paths. All subtrees between the paths are reported.
- *2D Query*:
  1. Perform a 1D range search on the x-tree for the range $[x_1, x_2]$.
  2. This selects $O(log n)$ canonical nodes (subtrees) whose x-ranges are fully contained in $[x_1, x_2]$.
  3. For each of these $O(log n)$ nodes, query its associated y-tree for the range $[y_1, y_2]$.
  4. Each y-query takes $O(log n)$.
  - Total Time: $O(log n) dot O(log n) + k = O(log^2 n + k)$.
- *d-Dimensions*: Each dimension adds a factor of $log n$ to the search.
  - Total Time: $O(log^d n + k)$.

*Fractional Cascading (Optimization)*:
- *Goal*: Eliminate the binary search in secondary structures to improve query time.
- *Mechanism*: In 2D, instead of fully independent y-trees (or sorted arrays), we link them. If we know the position of $y_1$ in a node's array, we can find its position in the children's arrays in $O(1)$ time using precomputed pointers (bridges).
- *Result*: The first binary search takes $O(log n)$. Subsequent searches in canonical nodes take $O(1)$ each.
- *Improved Query Time*: $O(log^(d-1) n + k)$. (e.g., $O(log n + k)$ for 2D).


#small_question("k-d Trees")[
  Define k-d trees and show that 2-d interval queries take $Omega(sqrt(n))$.
]

=== k-d Trees

#definition("k-d Tree")[
  A binary tree that partitions space using hyperplanes orthogonal to coordinate axes.
  - Root splits based on $x_1$ (median).
  - Children split based on $x_2$, etc.
  - Cycle through dimensions $1, ..., d$.
]

*2D Range Query Lower Bound*:
#theorem("Worst case query foe 2d tree")[
  Worst-case range query time in 2D k-d tree is $Omega(sqrt(n))$.
]

#proof[
  Consider a tree built for the set of points ${(i, i) | 1 <= i <= n}$ for $n = 2^t - 1$. It is a complete binary tree with $t$ levels. Let us observe what happens when we query a range ${0} times RR$. On levels where the $x$ coordinate is compared, we always go to the left. On levels comparing $y$, both subtrees lie in the query range, so we recurse on both of them. This means that the number of visited nodes doubles at every other level, so at level $t$ we visit $2^(t/2) approx sqrt(n)$ nodes.
]


#small_question("Dynamic Range Trees")[
  Show how to dynamize two-dimensional interval trees (i.e., Range trees); Insert is sufficient.
]

=== Dynamic Range Trees

*The Challenge of Dynamization*
Making range trees dynamic is non-trivial. Standard balanced binary search trees (like AVL or Red-Black trees) rely on *rotations* to maintain balance. In a multi-dimensional range tree, this strategy fails.
Recall that every node in the primary tree (x-tree) stores a secondary data structure (y-tree) containing _all_ points in its subtree. If we perform a rotation in the x-tree, the parent-child relationships change, and thus the set of points in the subtrees of the affected nodes changes drastically. We would have to rebuild the associated y-trees for these nodes from scratch. In the worst case, this takes $Theta(n)$ time per update, which is too slow.

*Solution: Weight-Balanced Trees*
To achieve poly-logarithmic update time, we need a balancing strategy that avoids frequent expensive structural changes. We use *weight-balanced trees* (also known as BB[$alpha$] trees).
The key idea is lazy rebalancing: we allow the tree to become somewhat unbalanced. We only intervene when a node $v$ becomes "too unbalanced" (e.g., one child becomes significantly heavier than the other). When this condition is violated, we completely *rebuild* the entire subtree rooted at $v$ into a perfectly balanced state.

*Detailed Insert Operation Analysis*
Suppose we want to insert a new point $p = (p_x, p_y)$.
1.  *Update y-trees*: We traverse the path from the root of the x-tree to the leaf for $p_x$. For every node $v$ on this path, $p$ belongs to the subtree of $v$, so we must insert $p_y$ into the associated y-tree of $v$.
    - There are $O(log n)$ such nodes.
    - Each insertion into a y-tree (which is also a weight-balanced tree) takes amortized $O(log n)$ time.
    - Total time for updating y-trees: $O(log^2 n)$.

2.  *Update x-tree*: We insert $p_x$ into the x-tree.
    - If the x-tree becomes unbalanced at some node $v$, we must rebuild the entire subtree rooted at $v$.
    - Rebuilding a subtree of size $m$ in the x-tree is expensive because we must also rebuild the y-trees for every node in that subtree. This takes $O(m log m)$ time (sorting points by y takes linear time if we merge lists from children, or $O(m log m)$ if we resort).
    - However, in a weight-balanced tree, a node of size $m$ is rebuilt only after $Omega(m)$ updates have passed through it.
    - Therefore, the amortized cost of rebuilding the x-tree per insertion is $O(log^2 n)$ (derived from charging $O(log n)$ cost at each of the $O(log n)$ levels).

*Result*: The total amortized time complexity for *Insert* (and similarly *Delete*) is $O(log^2 n)$ for 2D trees. By induction, it is $O(log^d n)$ for $d$-dimensional trees.

*Summary of Complexities ($d$-dim)*:
- *Space*: $O(n log^(d-1) n)$
- *Build Time*: $O(n log^(d-1) n)$
- *Query Time*: $O(log^d n + k)$ (can be improved to $O(log^(d-1) n + k)$ with fractional cascading)
- *Update Time*: $O(log^d n)$ amortized
