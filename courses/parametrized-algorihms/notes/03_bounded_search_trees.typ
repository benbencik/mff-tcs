#import "../lib.typ": *

= Bounded Search Trees

The *bounded search tree* technique, also known as branching, is a widely used method in parameterized algorithms. It is a systematic way to build a feasible solution by making a sequence of decisions. This process can be visualized as a search tree, where each node represents a subproblem. The algorithm explores various possibilities, branching into new subproblems, until a solution is found in one of the leaves.

For a branching algorithm to be FPT, it generally adheres to these conditions:
1. *Solution Preservation:* Every feasible solution to a subproblem must correspond to a feasible solution of the original problem.
2. *Bounded Branching Factor:* The number of subproblems (children) created at each branching step is small, typically bounded by a function of the parameter $k$.
3. *Parameter Reduction:* In each branch, the value of the parameter $k$ must decrease by at least a constant amount.

If these conditions are met, the total number of nodes in the search tree (and thus the total runtime) can be bounded by a function of $k$ multiplied by a polynomial in the input size.

== Application to #smallcaps("Vertex Cover")

We revisit the #smallcaps("Vertex Cover") problem to demonstrate how branching can lead to efficient FPT algorithms.

=== Branching Algorithm for #smallcaps("Vertex Cover")

Given a graph $G$ and an integer $k$, the goal is to find a vertex cover of size at most $k$. The algorithm proceeds as follows:
1. *Base Cases:*
  - If $k < 0$, return "No solution".
  - If $G$ has no edges, return "Solution found" (the empty set is a vertex cover).
2. *Preprocessing:* Apply kernelization rules (VC.1, VC.2, VC.3 from Chapter 2) to reduce the instance size.
3. *Branching Step:* Pick an arbitrary vertex $v$ with the maximum degree from $G$. (If all vertices have degree 0 or 1, the problem can be solved trivially).
  - *Option 1: Include $v$ in the Vertex Cover.* Remove $v$ and all its incident edges from $G$. Decrement $k$ by 1. Recursively call the algorithm with the new instance $(G - v, k - 1)$.
  - *Option 2: Exclude $v$ from the Vertex Cover.* If $v$ is not in the vertex cover, all its neighbors $N(v)$ *must* be in the vertex cover to cover edges incident to $v$. Remove $v$, all its neighbors $N(v)$, and all their incident edges from $G$. Decrement $k$ by $|N(v)|$. Recursively call the algorithm with the new instance $(G - N[v], k - |N(v)|)$.

=== Running Time Analysis for #smallcaps("Vertex Cover")

The worst-case running time of this algorithm is determined by the branching factor of its recurrence relation. We analyze the branching step based on the degree of the chosen vertex $v$.

Preprocessing ensures that the graph has a minimum degree of at least 2 (degree 0 and 1 vertices are handled by kernelization/simplification rules). Therefore, when we branch on a vertex $v$, it has at least 2 neighbors.

The recurrence relation for the number of leaves in the search tree $T(k)$ is given by the two branches:
1.  *Include $v$:* The parameter decreases by 1 ($k -> k-1$).
2.  *Exclude $v$:* All neighbors of $v$ must be included. Since $|N(v)| >= 2$, the parameter decreases by at least 2 ($k -> k-|N(v)| <= k-2$).

The worst-case recurrence corresponds to the smallest reduction in $k$, which occurs when $v$ has exactly degree 2:
$ T(k) <= T(k-1) + T(k-2) $
To solve this linear recurrence, we look at the characteristic equation $x^k = x^(k-1) + x^(k-2)$, which simplifies to:
$ x^2 - x - 1 = 0 $
The roots of this quadratic equation are $x = (1 plus.minus sqrt(5)) / 2$. The positive root is the golden ratio $phi = (1 + sqrt(5)) / 2 approx 1.6181$.

Thus, the number of nodes in the search tree is bounded by $O(phi^k)$, and the total running time is $O^*(1.6181^k)$.

== Application to #smallcaps("Closest String")

The #smallcaps("Closest String") problem is another example that benefits from the bounded search tree technique. Given $k$ strings $x_1, ..., x_k$, each of length $L$, and an integer $d$. The goal is to find a string $y$ of length $L$ such that the Hamming distance $d_H (y, x_i) <= d$ for all $i in {1, ..., k}$.

=== Kernelization for #smallcaps("Closest String")

Before branching, we can apply two reduction rules:
  - *CS.1 (Delete Good Columns):* If all input strings $x_1, ..., x_k$ have the same character at a position $j$, then the optimal string $y$ must also have that character at position $j$. This position can be removed from consideration.
  - *CS.2 (Bound Bad Columns):* A "bad column" is a position $j$ where the strings $x_1, ..., x_k$ do not all have the same character. It can be shown that in a "yes" instance, there are at most $k d$ bad columns. If, after applying CS.1, there are more than $k d$ bad columns, the instance is a "no" instance.

=== Branching Algorithm for #smallcaps("Closest String")

The branching algorithm works by iteratively refining a candidate string $z$.
1. Initialize $z = x_1$.
2. If $d_H(z, x_i) <= d$ for all $x_i$, then $z$ is a solution.
3. Otherwise, pick an $x_i$ such that $d_H(z, x_i) > d$. Let $P$ be the set of positions where $z$ and $x_i$ differ.
4. For each position $p in P$, create a new subproblem: set $z[p] := x_i[p]$ and decrease $d$ (implicitly, as we're getting closer to $x_i$). Recursively call with $d-1$.

  The branching factor for this algorithm is $(d+1)$, and the depth of the search tree is $d$. Thus, the total time complexity is $O((d+1)^d)$ multiplied by polynomial factors in $k$ and $L$.

== Feedback Vertex Set

The #smallcaps("Feedback Vertex Set") (FVS) problem asks for a minimum set of vertices $S$ in a graph $G$ such that $G - S$ is a forest (contains no cycles). We are looking for a set of size at most $k$.

To solve this efficiently, we first apply simplification rules (similar to kernelization) to handle easy cases:
1.  *Loop:* If a vertex $v$ has a self-loop, it must be in $S$. Remove $v$, decrease $k$.
2.  *Multiedge:* If edges $u v$ have multiplicity $>2$, reduce to 2. (A cycle of length 2 is still a cycle).
3.  *Degree 1:* Vertices of degree 1 cannot be part of a simple cycle. Remove them.
4.  *Degree 2:* If $v$ has degree 2 with neighbors $u, w$, we can contract $v$. Any cycle passing through $v$ must pass through $u$ and $w$. (If $u=w$, we have a multiedge handled by rule 2).

After exhaustive application, the graph has minimum degree 3.

=== Branching Strategy

The core idea relies on the fact that if a graph has minimum degree 3, any feedback vertex set of size $k$ must contain at least one vertex from the set of $3k$ vertices with the highest degrees.

#lemma("High Degree Vertices in FVS")[
  If $G$ has minimum degree 3, then any feedback vertex set of size at most $k$ contains at least one vertex from $V_(3k)$, the set of $3k$ vertices with highest degrees in $G$.
]

*Algorithm:*
1.  Preprocess the graph to have minimum degree 3.
2.  If the graph is empty, return Yes. If $k=0$ and graph not empty (and min degree 3), return No.
3.  Identify the set $V_(3k)$ of $3k$ vertices with largest degrees.
4.  Branch: For each $v in V_(3k)$, try including $v$ in the solution.
    -   $S <- S union {v}$, $G <- G - v$, $k <- k - 1$.
    -   Since we know at least one vertex from $V_(3k)$ must be in an optimal solution, we can branch into $|V_(3k)|$ subproblems.

*Complexity:* The recurrence is $T(k) <= 3k dot T(k-1)$, which solves to $O^*((3k)^k)$.

== Vertex Cover Above LP

We can parameterize #smallcaps("Vertex Cover") not just by the solution size $k$, but by how much $k$ exceeds the Linear Programming (LP) relaxation optimum. Let $"vc"^*(G)$ be the value of the optimal LP solution for Vertex Cover on $G$. We define the parameter $d = k - "vc"^*(G)$.

=== The Algorithm

The algorithm relies on the properties of the LP solution. Let $x$ be an optimal half-integral LP solution (values in ${0, 1/2, 1}$).
1.  Let $V_1 = {v | x_v = 1}$ and $V_0 = {v | x_v = 0}$. We can include $V_1$ in the cover and exclude $V_0$.
2.  The remaining vertices $V_(1/2) = {v | x_v = 1/2}$ form the core of the problem.
3.  Pick a vertex $v in V_(1/2)$. We branch:
    -   *Case 1: $v$ is in the cover.* $k$ decreases by 1. The LP optimum decreases by at least $1/2$ (since we force $x_v$ from $1/2$ to 1). So $d$ decreases by $1 - 1/2 = 1/2$.
    -   *Case 2: $v$ is not in the cover.* Then all neighbors $N(v)$ are in the cover.

This branching on the parameter $d$ leads to a recurrence roughly $T(d) <= 2 T(d - 0.5)$, which gives a runtime of $O^*(4^d)$.

== Review Questions

1. Explain the general concept of a bounded search tree algorithm. What are the key properties that allow such an algorithm to be Fixed-Parameter Tractable (FPT)?

2. Describe the branching rule for #smallcaps("Vertex Cover") based on the maximum degree vertex. How does this rule lead to the recurrence relation $T(k) = T(k-1) + T(k-2)$?

3. What are "good" and "bad" columns in the #smallcaps("Closest String") problem, and how are they used in kernelization?

4. Outline the branching strategy for #smallcaps("Closest String"). What is the recurrence relation for the number of leaves in its search tree?

== Answers

1. It is a recursive algorithm where the depth of the recursion is bounded by the parameter $k$, and the number of branches at each step is bounded by a constant (or function of $k$). This ensures the tree size depends only on $k$, while work at each node is polynomial in $n$, resulting in FPT time.

2. Pick a vertex $v$. Two cases:
  1. $v in$ Cover: remove $v$, $k <- k-1$.
  2. $v in.not$ Cover: all neighbors $N(v)$ must be in Cover. Remove $N(v)$, $k <- k-|N(v)|$.
  If degree $>= 2$, $|N(v)| >= 2$, leading to $T(k) <= T(k-1) + T(k-2)$.

3. A "good" column has the same character in all strings; it can be deleted. A "bad" column has differences. If there are $> k d$ bad columns, it's impossible to satisfy the distance constraint $d$ for all strings, so reject.

4. Start with candidate $z = x_1$. Find string $x_i$ with dist $> d$. Branch on the $d+1$ positions where they differ to "fix" the mismatch. Recurrence: $T(d) <= (d+1)T(d-1)$, leading to $(d+1)^d$.