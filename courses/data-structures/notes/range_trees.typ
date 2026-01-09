#import "../lib.typ": *

= Range Trees & k-d Trees

#big_question("Multi-dimensional Range Trees")[
  Define multi-dimensional interval trees (range trees). Analyze the space complexity of the data structure and time complexity of construction and rectangular queries (bonus: including acceleration by cascading).
]

#definition("Range Tree")[
  A data structure for storing a set of points $P$ in $d$-dimensional space to support orthogonal range queries.
  - *1D*: A balanced BST on the coordinates.
  - *d-Dimensions*: A balanced BST on the first coordinate. Each node $v$ stores an associated structure (canonical subset $P_v$) which is a $(d-1)$-dimensional range tree on the remaining coordinates of points in $v$'s subtree.
]

*Space Complexity*:
- 1D: $O(n)$.
- 2D: Each point is stored in $O(log n)$ associated structures. Total $O(n log n)$.
- d-D: $O(n log^(d-1) n)$.

*Construction Time*:
- Sort points by first coordinate. Build tree. Recursively build associated structures.
- $T(n, d) = O(n log n) + 2 T(n/2, d) + O(T(n, d-1))$.
- Result: $O(n log^(d-1) n)$.

*Query Time (Rectangular)*:
- 1D: Find split node, follow paths to leaves. $O(log n + k)$.
- d-D: Select $O(log n)$ canonical nodes in the primary tree. For each, query the $(d-1)$-dimensional structure.
- $Q(n, d) = O(log n) dot Q(n, d-1) = O(log^d n + k)$.

*Fractional Cascading (2D)*:
- Optimization to avoid binary search in associated arrays (if last dim is stored as arrays).
- Store pointers from element in parent array to position in child arrays.
- Reduces factor by $log n$.
- Query: $O(log^(d-1) n + k)$.

== k-d Trees

#small_question("k-d Trees")[
  Define k-d trees and show that 2-d interval queries take $Omega(sqrt(n))$.
]

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

== Dynamic Range Trees

#small_question("Dynamic Range Trees")[
  Show how to dynamize two-dimensional interval trees (Range trees), Insert is sufficient.
]

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