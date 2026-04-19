#import "../lib.typ": *

= Treewidth

Treewidth is a measure of how "tree-like" a graph is. Many NP-hard problems become tractable (FPT) on graphs of bounded treewidth.

== Tree Decomposition

A *tree decomposition* of a graph $G=(V, E)$ is a pair $(T, \{X_t\}_{t \in V(T)})$ where $T$ is a tree and each node $t$ of $T$ is assigned a bag $X_t subset.eq V$, satisfying:
1.  *Vertex Coverage:* Every vertex $v \in V$ is in at least one bag.
2.  *Edge Coverage:* For every edge $u v \in E$, there is a bag $X_t$ containing both $u$ and $v$.
3.  *Coherence (Connectivity):* For any vertex $v$, the set of nodes \{t \mid v \in X_t\} forms a connected subtree of $T$.

The *width* of a decomposition is $max_t |X_t| - 1$. The *treewidth* $"tw"(G)$ is the minimum width over all tree decompositions.
-   Trees have treewidth 1.
-   Cycles have treewidth 2.
-   $K_n$ has treewidth $n-1$.

== Nice Tree Decompositions

To design algorithms, it is convenient to use a *nice tree decomposition*. A rooted tree decomposition is *nice* if every node is one of:
-   *Leaf:* A leaf node $t$ with $|X_t|=1$.
-   *Introduce:* Node $t$ has one child $t'$ and $X_t = X_{t'} union \{v\}$.
-   *Forget:* Node $t$ has one child $t'$ and $X_t = X_{t'} without \{v\}$.
-   *Join:* Node $t$ has two children $t_1, t_2$ with $X_t = X_{t_1} = X_{t_2}$.

Every tree decomposition can be converted into a nice one with width $k$ and $O(k n)$ nodes in linear time.

== Dynamic Programming: Independent Set

We can solve #smallcaps("Maximum Independent Set") on graphs of treewidth $k$ in time $2^k \cdot n^{O(1)}$.
Let $"dp"[t, S]$ be the size of the max IS in the subgraph induced by the subtree rooted at $t$, such that the intersection with the bag $X_t$ is exactly $S$ (where $S subset.eq X_t$ is independent).

-   *Leaf:* Trivial.
-   *Introduce ($v$):*
    -   If $v \in S$, check edges with $S inter X_{t'}$. If valid, $"dp"[t, S] = "dp"[t', S without \{v\}] + 1$.
    -   If $v in.not S$, $"dp"[t, S] = "dp"[t', S]$.
-   *Forget ($v$):* We no longer care if $v$ was in the IS or not.
    -   $"dp"[t, S] = max("dp"[t', S], "dp"[t', S union \{v\}])$.
-   *Join:* Combine solutions from children.
    -   $"dp"[t, S] = "dp"[t_1, S] + "dp"[t_2, S] - |S|$ (subtract $|S|$ because vertices in $S$ are counted twice).

== Grid Minors and Bidimensionality

How do we relate treewidth to grid-like structures?

=== The Grid Theorem
#theorem("Excluded Grid Theorem")[ 
  There is a function $f$ such that if $"tw"(G)$ is large ($ >= f(k)$), then $G$ contains a $k times k$ grid as a minor.
]This is a powerful tool. For planar graphs, the bound is linear: $"tw"(G) \ge 9k/2 ==> G$ has a $k times k$ grid minor.

// === Bidimensionality

// Bidimensionality Theory uses the Grid Theorem to give sub-exponential algorithms (e.g., $2^{\sqrt{n}}$) for problems on planar graphs (and $H$-minor free graphs).

// A parameter $P$ is *minor-bidimensional* if:
// 1.  $P(G) \ge P(H)$ if $H$ is a minor of $G$.
// 2.  For a $k \times k$ grid, $P(\text{grid}) \ge c \cdot k^2$.

// *Win/Win Approach:*
// 1.  If $tw(G)$ is small ($< c' \sqrt{k}$), use DP on treewidth.
// 2.  If $tw(G)$ is large, $G$ contains a large grid. Since $P$ is bidimensional, the solution size must be huge ($P(G) \ge c \cdot \text{grid-size} \ge c \cdot k$).
// 3.  If we are checking if $P(G) \le k$, and $tw(G)$ is large, the answer is immediately NO.

// For planar graphs, this leads to algorithms with running time $2^{O(\sqrt{k})} \cdot n^{O(1)}$. Examples: Vertex Cover, Dominating Set.
