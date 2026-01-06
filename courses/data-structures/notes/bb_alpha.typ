#import "../lib.typ": *

= BB[α]-Trees

#small_question("BB[α]-Trees")[
  Describe search trees with lazy balancing (BB[α]-trees). Analyze their amortized complexity. Give an example of their use.
]

#definition("BB[α] Tree")[
  BB[$alpha$] (Bounded Balance) trees are weight-balanced trees. For every node $v$, let $s(v)$ be the number of nodes in the subtree rooted at $v$ (including $v$). If $v_l$ and $v_r$ are the left/right children, the balance condition for parameter $alpha in (0, 1/2]$ is:
  $ alpha <= s(v_l) / s(v) <= 1 - alpha $
]

=== Lazy Balancing
Instead of rebalancing immediately upon every update, we allow the tree to become slightly unbalanced. When a node violates the condition, we *rebuild* the entire subtree rooted at that node to be perfectly balanced.

=== Amortized Analysis

- Rebuilding a subtree of size $k$ takes $O(k)$ time.
- A node only requires rebuilding if one of its children has become too heavy relative to the other. This requires a sequence of $Ω(k)$ updates (inserts/deletes) passing through this node since the last rebuild.
- Therefore, the $O(k)$ cost is amortized over $Ω(k)$ operations.
- *Result*: Amortized cost per update is $O(log n)$.

=== Usage

- Used when rotations are expensive or impossible (e.g., in multi-dimensional data structures like k-d trees).
- Used when maintaining augmented data (subtree sizes) is required for the balance condition itself.