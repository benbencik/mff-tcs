#import "../../../shared/lib.typ": *

#set page(
  header: [
    #set text(size: 9pt, fill: gray)
    #emph("Integer Programming in Parameterized Complexity")
  ],
)
= Integer Programming in Parameterized Complexity

Integer Linear Programming (ILP) is a powerful tool in algorithm design. While ILP is NP-hard in general, it becomes tractable when the number of variables is small. This observation, due to Lenstra, has profound implications for parameterized complexity.

#theorem("Lenstra's Algorithm", [
  The #smallcaps("Integer Linear Programming") problem with $p$ variables can be solved in time $p^(2.5p + o(p)) dot L$, where $L$ is the length of the input. In particular, it is FPT parameterized by the number of variables.
])

This result (and subsequent improvements by Kannan, Frank and Tardos) allows us to solve combinatorial problems by modeling them as ILPs with a number of variables bounded by the parameter.

== Neighborhood Diversity

A key structural parameter that allows for efficient ILP formulations is *neighborhood diversity*. It measures how "simple" a graph is by grouping vertices that behave identically.

#definition("Neighborhood Diversity", [
  Two vertices $u, v$ in a graph $G$ are called *twins* if $N(u) without {v} = N(v) without {u}$. This is an equivalence relation. The *neighborhood diversity* of $G$, denoted $"nd"(G)$, is the number of equivalence classes.
])

Each equivalence class is either:
-   A *clique*: All vertices in the class are pairwise adjacent.
-   An *independent set*: No two vertices in the class are adjacent.

Furthermore, for any two classes $A$ and $B$, either every vertex in $A$ is adjacent to every vertex in $B$, or no vertex in $A$ is adjacent to any vertex in $B$. This structure can be captured by a *type graph* $T(G)$, where vertices represent the classes (weighted by class size) and edges represent adjacency between classes.

== Graph Coloring

The #smallcaps("Graph Coloring") problem asks for the minimum number of colors needed to color a graph $G$. While hard in general, it is FPT parameterized by neighborhood diversity.

Let $V_1, ..., V_k$ be the twin classes of $G$, where $k = "nd"(G)$.
Observation: In an optimal coloring:
1.  If $V_i$ is a clique, every vertex must get a distinct color.
2.  If $V_i$ is an independent set, all vertices in $V_i$ can receive the same color (if they don't, we can recolor them to the same color without conflict).

We can model this as an ILP. Let $cal(I)$ be the set of maximal independent sets of the type graph $T(G)$. A variable $x_I$ for each $I in cal(I)$ represents the number of colors that are used exactly on the union of classes in $I$.

*ILP Formulation:*
-   *Variables:* $x_I$ for each $I in cal(I)$ (non-negative integers).
-   *Minimize:* $sum_(I in cal(I)) x_I$
-   *Constraints:*
    -   For each clique class $V_i$: $sum_(I : i in I) x_I >= |V_i|$ (we need distinct colors for each vertex).
    -   For each independent set class $V_i$: $sum_(I : i in I) x_I >= 1$ (we need at least one color for the set).

The number of variables is $|cal(I)| <= 2^k$. Since $k$ is the parameter, this ILP can be solved in FPT time.

#example("Graph Coloring with Neighborhood Diversity", [
  Consider a graph $G$ consisting of a clique $C$ of size 3 ($V_1 = {a, b, c}$) and an independent set $S$ of size 2 ($V_2 = {d, e}$). Every vertex in $C$ is connected to every vertex in $S$.
  
  1.  *Type Graph $T(G)$*:
      -   Vertex 1 (representing $V_1$): Weight 3, has a self-loop (clique).
      -   Vertex 2 (representing $V_2$): Weight 2, no self-loop (independent set).
      -   Edge (1, 2): $V_1$ and $V_2$ are fully connected.
  2.  *Maximal Independent Sets of $T(G)$*:
      -   The definition of $cal(I)$ is "maximal independent sets of the type graph $T(G)$".
      -   In $T(G)$, 1 and 2 are adjacent. So independent sets are ${1}$ and ${2}$ (ignoring self-loops for the concept of independent set in $T(G)$ itself, but considering connectivity).
      -   Wait, the graph $G$ coloring requires color classes to be independent sets in $G$.
      -   An independent set in $G$ is a union of subsets of $V_i$ where the $V_i$ indices form an independent set in $T(G)$ (and if $V_i$ is a clique, only one vertex can be taken).
      -   Our variables $x_I$ correspond to color types. $I$ is an independent set of types in $T(G)$.
      -   Types here: $I_1 = {1}$ (subset of $V_1$) and $I_2 = {2}$ (subset of $V_2$).
  3.  *ILP Variables*:
      -   $x_1$: Number of colors of type $I_1$.
      -   $x_2$: Number of colors of type $I_2$.
  4.  *Objective*: Minimize $x_1 + x_2$.
  5.  *Constraints*:
      -   Clique $V_1$ (size 3): $x_1 >= 3$.
      -   Indep. Set $V_2$ (size 2): $x_2 >= 1$.
  6.  *Solution*: Minimal $x_1 = 3, x_2 = 1$. Total colors = 4.
  
  Indeed, we need 3 colors for the clique $C$, and since $S$ is fully connected to $C$, we cannot reuse those colors. $S$ is an independent set, so 1 extra color suffices. Total $chi(G) = 4$.
])

== Capacitated Dominating Set

In the #smallcaps("Capacitated Dominating Set") problem, each vertex $v$ has a capacity $c(v)$. We want to find a set $D subset.eq V$ and a mapping from $V without D$ to $D$ such that each $u in D$ "covers" at most $c(u)$ neighbors.

On graphs of bounded neighborhood diversity, this can be modeled as a *Convex Integer Program* in fixed dimension.
Let $V_1, ..., V_k$ be the twin classes.
-   *Variables:* $x_i$, representing the number of vertices in $V_i$ that are included in the dominating set $D$ (i.e., $|D inter V_i|$).
-   *Variables:* $y_(i j)$, representing the number of vertices in $V_j without D$ that are dominated by vertices in $D inter V_i$.

The constraints involve capacity functions $f_i(x_i)$, which denote the maximum number of vertices that $x_i$ vertices from class $V_i$ can dominate. Since the vertices in $V_i$ are twins, we should pick those with highest capacities first. The function $f_i(x_i)$ is therefore concave (sum of largest $x_i$ capacities), making the constraint $sum_j y_(i j) <= f_i(x_i)$ define a convex region.

Since convex IP in fixed dimension is FPT, #smallcaps("Capacitated Dominating Set") is FPT parameterized by $"nd"(G)$.

== Sum Coloring

In #smallcaps("Sum Coloring"), we assign colors $c(v) in NN$ to vertices to minimize $sum_(v in V) c(v)$.
This can be solved using *n-fold Integer Programming*.

An n-fold IP has a specific block structure in its constraint matrix that allows for faster algorithms than general ILP.
For #smallcaps("Sum Coloring") on bounded $"nd"(G)$, we can also use a Convex IP formulation.
The cost of coloring a set of vertices with color $c$ contributes $c$ times the number of vertices to the sum.
By carefully defining variables representing the number of color classes of a certain "type" (subset of twin classes covered), the objective function becomes a separable convex function, which can be minimized efficiently.

#theorem("Sum Coloring FPT", [
  #smallcaps("Sum Coloring") parameterized by neighborhood diversity is FPT. It can be solved by modeling it as an n-fold IP or a convex IP in fixed dimension.
])

== Review Questions

1.  What is neighborhood diversity, and how does it relate to the complexity of ILP-based algorithms?
2.  Why is #smallcaps("Graph Coloring") FPT when parameterized by neighborhood diversity?
3.  How does the convexity of the capacity constraint help in solving #smallcaps("Capacitated Dominating Set")?
4.  What is the advantage of using n-fold IP over standard ILP for problems like #smallcaps("Sum Coloring")?