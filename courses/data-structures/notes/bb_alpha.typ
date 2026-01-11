#import "../lib.typ": *

= BB[α]-Trees

#small_question("BB[α]-Trees")[
  Describe search trees with lazy balancing (BB[α]-trees). Analyze their amortized complexity. Give an example of their use.
]

=== Definition and Balance

#definition("BB[α] Tree")[
  BB[$alpha$] (Bounded Balance) trees are weight-balanced trees. For every node $v$, let $s(v)$ be the number of nodes in the subtree rooted at $v$ (including $v$). If $v_l$ and $v_r$ are the left/right children, the balance condition for parameter $alpha in (0, 1/2]$ is:
  $ alpha <= s(v_l) / s(v) <= 1 - alpha $
]

*Lazy Balancing:*
Instead of rebalancing immediately upon every update, we allow the tree to become slightly unbalanced. When a node violates the condition, we *rebuild* the entire subtree rooted at that node to be perfectly balanced.

=== Amortized Analysis

We analyze the amortized cost of `Insert` using the *potential method*. We assign a potential to the tree that grows with updates and drops significantly during a rebuild, paying for the expensive operation.

#theorem("Amortized Cost of Insert")[
  The amortized time complexity of the `Insert` operation in a lazily balanced tree is $O(log n)$.
]

#proof[
  We define the potential of the tree $Phi$ as the sum of contributions from individual nodes:
  $ Phi = sum_v phi(v) $
  where the contribution $phi(v)$ measures the imbalance at node $v$:
  $
    phi(v) = cases(
      |s(v_l) - s(v_r)| & quad "if" |s(v_l) - s(v_r)| >= 2,
      0 & quad "otherwise"
    )
  $
  Here, $s(v)$ is the size of the subtree at $v$, and $v_l, v_r$ are its children. The condition "$\ge 2$" ensures that a perfectly balanced tree (difference $\le 1$) has zero potential.

  *1. Cost of Insertion (without rebuild):*
  Adding a leaf increases the size of all $O(log n)$ ancestors by 1. For each ancestor, the difference $|s(v_l) - s(v_r)|$ changes by exactly 1. Due to the clamping at 0, the potential $phi(v)$ increases by at most 2. Thus, the total increase in potential is $Delta Phi = O(log n)$. The real cost is $O(log n)$, so the amortized cost is $O(log n)$.

  *2. Cost of Rebuild:*
  Suppose a node $v$ violates the balance condition (e.g., $s(v_l) > 2/3 s(v)$). We rebuild the subtree at $v$ into a perfectly balanced tree.
  - *Real cost:* $T_"rebuild" = Theta(s(v))$ (linear in the size of the subtree).
  - *Potential change:* Before the rebuild, the imbalance was large. Specifically, since $s(v_l) > 2 s(v_r)$, the difference is linear in $s(v)$: $|s(v_l) - s(v_r)| > 1/3 s(v)$. Thus, $phi(v) in Omega(s(v))$.
  - After the rebuild, the subtree is perfectly balanced, so the new contributions of all nodes in the subtree are 0.
  - The drop in potential is $Delta Phi in -Omega(s(v))$.

  By scaling the potential function (multiplying by a suitable constant), the drop in potential cancels out the real cost of rebuilding. Thus, the amortized cost of the rebuild is zero (or negative).

  *Conclusion:* The total amortized cost is dominated by the insertion path updates, which is $O(log n)$.
]

=== Usage

- Used when rotations are expensive or impossible (e.g., in multi-dimensional data structures like k-d trees).
- Used when maintaining augmented data (subtree sizes) is required for the balance condition itself.
