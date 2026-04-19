#import "../../../shared/lib.typ": *

= Parameterized Intractability

Not all problems are fixed-parameter tractable. We need a theory to classify problems that are unlikely to have FPT algorithms. This theory is built on the $W$-hierarchy.

== The W-Hierarchy

The classes of the W-hierarchy are defined based on the complexity of boolean circuits or by weighted satisfiability problems.
-   *FPT:* The class of tractable problems.
-   *W[1]:* The first level of intractability. A canonical W[1]-complete problem is #smallcaps("Clique").
-   *W[2]:* A higher level. A canonical W[2]-complete problem is #smallcaps("Dominating Set").
-   *XP:* Problems solvable in time $n^{f(k)}$. All W-classes are contained in XP.

If $#smallcaps[P] != #smallcaps[NP]$, then $#smallcaps[FPT] != W[1]$. It is widely believed that $#smallcaps[FPT] subset.neq W[1] subset.neq W[2]$.

== W[1]-complete Problems: Clique

The #smallcaps("Clique") problem parameterized by solution size $k$ is fundamental to W[1]-hardness.
-   *Input:* Graph $G$, integer $k$.
-   *Parameter:* $k$.
-   *Question:* Does $G$ have a clique of size $k$?

There is no known algorithm running in $f(k) \cdot n^{O(1)}$. The brute force takes $O(n^k)$.

== Parameterized Reductions

To prove a problem is W[1]-hard, we use *parameterized reductions*. A reduction from problem $A$ to $B$ maps instance $(I, k)$ of $A$ to $(I', k')$ of $B$ such that:
1.  $(I, k)$ is Yes iff $(I', k')$ is Yes.
2.  The reduction runs in FPT time (w.r.t $k$).
3.  The new parameter $k'$ is bounded by a function of $k$: $k' \le g(k)$.

=== Reduction: Clique $->$ Independent Set

This is a standard polynomial-time reduction, which also works as a parameterized reduction.
-   *Transformation:* Given $(G, k)$ for Clique, output $(overline{G}, k)$ for Independent Set, where $overline{G}$ is the complement graph.
-   *Parameter:* $k' = k$.
-   *Result:* #smallcaps("Independent Set") is W[1]-complete.

=== Reduction: Independent Set $->$ Clique on Regular Graphs

We can restrict the graph class while maintaining hardness.
-   *Goal:* Prove #smallcaps("Clique") is W[1]-hard even on regular graphs.
-   *Idea:* Take an instance of IS. Complement it to get Clique. To make it regular, add "garbage" vertices or structure to equalize degrees without creating new large cliques. (Or reduce directly from Clique to Clique on regular graphs).

=== Reduction: Clique $->$ Partial Vertex Cover

#smallcaps("Partial Vertex Cover"): Given $G, k, s$, cover at least $s$ edges with $k$ vertices. Parameter is $k$.
-   *Reduction:* From #smallcaps("Independent Set") (parameter $k'$).
-   We want to find $k'$ independent vertices.
-   This is equivalent to finding $k'$ vertices that cover *fewest* edges? No.
-   Let's reduce from #smallcaps("Clique") ($k$). A clique of size $k$ has $binom{k}{2}$ edges.
-   We want to select $k$ vertices that cover $binom{k}{2}$ edges *within the set*.
-   This relates to "Dense $k$-Subgraph".
-   *Correction from [PA 13.1]:* The reduction usually goes from #smallcaps("Independent Set") to #smallcaps("Partial Vertex Cover").
    -   IS of size $k <=>$ set of $k$ vertices covering 0 edges (induced).
    -   This is "Dual" to Partial VC?
    -   *Standard Reduction:* To cover at least $S_{"target"}$ edges with $k$ vertices.
    -   This problem is W[1]-hard.

=== Reduction: Clique $->$ Multicolored Clique

In #smallcaps("Multicolored Clique"), vertices are partitioned into $k$ color classes $V_1, ..., V_k$. We want a clique picking exactly one vertex from each class.
-   *Reduction:* From #smallcaps("Clique") $(G, k)$.
-   *Construction:* Create $G'$ with $V_1, ..., V_k$ where each $V_i$ is a copy of $V(G)$.
    -   Connect $u \in V_i$ and $v \in V_j$ ($i \neq j$) if $u, v$ are adjacent in $G$.
-   *Correctness:* A clique in $G'$ must pick one from each $V_i$ (since $V_i$ is independent in $G'$ construction typically, or we just enforce the constraint). If they form a clique, they correspond to a clique in $G$.
-   *Parameter:* $k' = k$.
-   *Significance:* This version is very useful for further reductions (e.g., to Dominating Set for W[2]-hardness).
