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
- *Theorem*: Worst-case range query time in 2D k-d tree is $Omega(sqrt(n))$.
- *Proof Sketch*:
  - Consider a query line (thin rectangle).
  - The recurrence for number of visited nodes $Q(n)$:
    - Splitting line parallel to query line: Visit both children ($2 Q(n/4)$).
    - Splitting line perpendicular: Visit one child ($Q(n/2)$).
    - Alternating levels: $Q(n) = 2 Q(n/4) + 2 ==> Q(n) = O(sqrt(n))$.
  - We can construct a set of points and a query line that intersects $sqrt(n)$ cells.


#small_question("Dynamic Range Trees")[
  Show how to dynamize two-dimensional interval trees (i.e., Range trees); Insert is sufficient.
]

=== Dynamic Range Trees

*Problem*: Insertions/Deletions in 2D Range Tree.
*Problem*: Range trees are static. Insertions require rebalancing, which is expensive ($O(n)$ worst case) because of associated structures.

*Solution 1: Amortized Rebuilding (Weight-Balanced Trees)*
- Use a *BB[$alpha$]* tree (Bounded Balance) for the primary structure.
- *Property*: If a node $v$ becomes unbalanced, it means $Omega("size"(v))$ updates have occurred in its subtree since it was last perfectly balanced.
- *Algorithm*:
  - Insert/Delete as usual.
  - If a node violates balance condition, rebuild the entire subtree rooted at $v$ and all associated structures.
- *Cost*: Rebuilding a node of size $m$ takes $O(m log^(d-1) m)$.
- *Amortized Analysis*: Each update contributes to rebuilding costs at each ancestor level.
- *Total*: $O(log^d n)$ amortized update time.

*Solution 2: Logarithmic Method (Decomposable Structures)*
- Maintain a set of static range trees of sizes $2^0, 2^1, 2^2, ...$ based on the binary representation of $n$.
- *Insert*: Create a tree of size 1. If a tree of size 1 exists, merge them to size 2. If size 2 exists, merge to 4, etc. (Like binary addition).
- *Query*: Query all $O(log n)$ trees and combine results.
- *Complexity*:
  - Query: $O(log n dot log^d n) = O(log^(d+1) n)$.
  - Insert: Amortized $O(log n dot ("build cost"/n)) = O(log^d n)$.
