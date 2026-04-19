#import "../lib.typ": *

= Prerequisites: Linear and Integer Programming

Some advanced techniques in parameterized algorithms, particularly those involving bounded search trees and kernelization, rely on concepts from mathematical optimization. This chapter provides a brief introduction to *Linear Programming* (LP) and *Integer Linear Programming* (ILP) to establish the necessary context.

== Linear Programming (LP)

*Linear Programming* is a method to achieve the best outcome (such as maximum profit or lowest cost) in a mathematical model whose requirements are represented by linear relationships.

An LP problem consists of three parts:
1.  *Variables:* Real-valued unknowns, e.g., $x_1, x_2, ..., x_n$.
2.  *Objective Function:* A linear formula to maximize or minimize, e.g., $"maximize " c_1 x_1 + ... + c_n x_n$.
3.  *Constraints:* A set of linear inequalities that limit the values of the variables, e.g., $a_1 x_1 + ... + a_n x_n <= b$.

#definition("Linear Programming")[
  The problem of minimizing (or maximizing) a linear objective function subject to a finite number of linear equality and inequality constraints. The variables can take any real values satisfying the constraints.
]

A key property of Linear Programming is that it is *computationally tractable*. Algorithms like the Simplex algorithm (efficient in practice) or Interior Point methods (efficient in worst-case theory) can solve LP instances in polynomial time.

== Integer Linear Programming (ILP)

*Integer Linear Programming* is a variation of LP with one additional, strict constraint: some or all of the variables are required to be *integers*.

#definition("Integer Linear Programming")[
  An optimization problem identical to Linear Programming, but with the added constraint that the variables $x_1, ..., x_n$ must belong to the set of integers $ZZ$ (or often ${0, 1}$).
]

Unlike LP, solving an ILP is generally *NP-hard*. The restriction to integers turns a smooth optimization problem into a discrete combinatorial one, which is much harder to solve.

=== Example: Vertex Cover as ILP

Many graph problems can be directly translated into ILP. Consider the #smallcaps("Vertex Cover") problem. We want to select a minimum set of vertices to cover all edges.

We can formulate this as follows:
-   *Variables:* For each vertex $v$, let $x_v$ be a variable.
    -   $x_v = 1$ implies $v$ is in the vertex cover.
    -   $x_v = 0$ implies $v$ is not in the vertex cover.
-   *Constraints:* For every edge $u v in E$, at least one endpoint must be selected.
    $ x_u + x_v >= 1 $
-   *Objective:* Minimize the total number of selected vertices.
    $ "minimize" sum_(v in V) x_v $

This formulation exactly captures the Vertex Cover problem. If we could solve ILP efficiently, we could solve Vertex Cover (and P would equal NP).

== LP Relaxation

Since ILP is hard but LP is easy, a common strategy is *relaxation*. We "relax" the integer constraint ($x_v in {0, 1}$) and allow the variables to take fractional values ($0 <= x_v <= 1$).

This transforms the hard combinatorial problem into an easy continuous one.

#example("LP Relaxation for Vertex Cover")[
  In the Vertex Cover example above, the LP relaxation allows $x_v$ to be $0.5$.
  -   If we have an edge $u v$, setting $x_u = 0.5$ and $x_v = 0.5$ satisfies the constraint $0.5 + 0.5 >= 1$.
  -   The cost of this "fractional vertex" is only 0.5.
]

*Why is this useful?*
1.  *Lower Bound:* The optimal value of the LP relaxation (denoted $"vc"^*(G)$) is always less than or equal to the optimal integer solution ($k$). It provides a lower bound on the true answer.
2.  *Approximation:* We can sometimes "round" the fractional values to get a valid integer solution. For Vertex Cover, taking all $v$ where $x_v >= 0.5$ gives a valid vertex cover of size at most $2 dot "vc"^*(G)$.
3.  *Parameterization:* The difference between the integer solution and the LP solution ($k - "vc"^*(G)$) can be used as a parameter. If the LP solution is very close to the integer solution, the problem might be easier to solve.

== ILP in Parameterized Complexity

While ILP is NP-hard in general, it becomes tractable under specific conditions. A fundamental result by Lenstra states that ILP is *fixed-parameter tractable* if the parameter is the *number of variables*.

#theorem("Lenstra's Theorem (Simplified)")[
  An Integer Linear Programming problem with $p$ variables can be solved in time $f(p) dot n^O(1)$.
]

This means that if we can model a problem using an ILP where the number of variables is small (even if the number of constraints is large), we can solve it efficiently. This technique is used in algorithms for problems like *Neighborhood Diversity*.

== Overview of Key Problems

This course explores various problems through the lens of parameterized algorithms. Below is a glossary of the central problems covered, their definitions, and the algorithmic techniques they serve to illustrate.

- #smallcaps("Vertex Cover")
  - *Definition:* Given a graph $G$ and an integer $k$, find a subset of vertices $S subset.eq V$ of size at most $k$ such that every edge in $G$ has at least one endpoint in $S$.
  - *Techniques:* Kernelization, Bounded Search Trees, Integer Linear Programming (Above LP).

- #smallcaps("Feedback Vertex Set")
  - *Definition:* Given a graph $G$ and an integer $k$, find a subset of vertices $S subset.eq V$ of size at most $k$ such that the graph $G - S$ is acyclic (contains no cycles).
  - *Techniques:* Bounded Search Trees (branching on cycles or high-degree vertices).

- #smallcaps("Closest String")
  - *Definition:* Given a set of $k$ strings of length $L$ and an integer $d$, find a string $s$ of length $L$ such that the Hamming distance between $s$ and every input string is at most $d$.
  - *Techniques:* Bounded Search Trees.

- #smallcaps("Graph Coloring")
  - *Definition:* Assign a color to each vertex of a graph $G$ such that no two adjacent vertices share the same color, using the minimum number of colors.
  - *Variants:* #smallcaps("Sum Coloring") (minimize the sum of integer colors assigned), #smallcaps("Equitable Coloring") (color classes differ in size by at most 1).
  - *Techniques:* Integer Linear Programming (on graphs of bounded neighborhood diversity).

- #smallcaps("Capacitated Dominating Set")
  - *Definition:* Given a graph where vertices have capacities, find a dominating set $D$ and a mapping of dominated vertices to $D$ such that no vertex in $D$ exceeds its capacity.
  - *Techniques:* Convex Integer Programming in fixed dimension.

- #smallcaps("Scheduling") ($R || C_{max}$)
  - *Definition:* Assign $n$ jobs to $m$ machines to minimize the maximum completion time (makespan).
  - *Techniques:* n-fold Integer Programming (parameterized by job/machine types).

- #smallcaps("Borda-Shift Bribery")
  - *Definition:* In an election, determine if a specific candidate can win by shifting them earlier in voters' preference lists, subject to a total shift budget.
  - *Techniques:* n-fold Integer Programming.

- #smallcaps("Max $q$-Cut")
  - *Definition:* Partition the vertices of a graph into $q$ sets to maximize the total number of edges having endpoints in different sets.
  - *Techniques:* Indefinite Quadratic Integer Programming.

- #smallcaps("Clique")
  - *Definition:* Given a graph $G$ and an integer $k$, determine if $G$ contains a subset of $k$ vertices that are all pairwise adjacent.
  - *Context:* The canonical $W[1]$-complete problem, used to prove intractability of other problems.

- #smallcaps("Independent Set")
  - *Definition:* Given a graph $G$ and an integer $k$, determine if $G$ contains a subset of $k$ vertices such that no two are adjacent.
  - *Techniques:* Treewidth (Dynamic Programming), $W[1]$-hard in general.

- #smallcaps("Partial Vertex Cover")
  - *Definition:* Given a graph $G$, integers $k$ and $s$, find a subset of $k$ vertices that covers at least $s$ edges.
  - *Context:* $W[1]$-complete.

- #smallcaps("Multicolored Clique")
  - *Definition:* Given a graph $G$ with a vertex partition $V_1, dots, V_k$, find a clique of size $k$ that contains exactly one vertex from each set $V_i$.
  - *Context:* $W[1]$-complete, useful for reductions.

- #smallcaps("Unary Bin Packing")
  - *Definition:* Pack $n$ items with sizes $s_1, dots, s_n$ into $k$ bins of capacity $B$, where sizes are encoded in unary.
  - *Context:* Used to show hardness results for n-fold IP when coefficients are large.
