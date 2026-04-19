#import "../lib.typ": *

= Introduction to Parameterized Algorithms and Complexity

Unlike classical complexity theory, which analyzes running time solely based on input size, parameterized algorithmics examines how runtime depends on one or more parameters of the input instance. This approach allows for a finer-grained analysis of problem complexity.

== Motivation: The #smallcaps("Bar Fight Prevention") Problem

Consider the #smallcaps("Bar Fight Prevention") problem: You need to decide which guests to admit to a bar, knowing who might fight whom. The goal is to maximize the number of admitted guests while ensuring no fights break out, allowing for at most $k$ "troublemakers" to be refused entry.

  Imagine a graph where each person is a vertex, and an edge connects two people who will fight if both are admitted. The problem then becomes: find a minimum set of vertices (troublemakers) whose removal leaves a graph with no edges (an independent set). This is equivalent to finding a vertex cover of size at most $k$.

  If there are $n=1000$ people, a brute-force approach trying all $2^n$ subsets of people, or even $binom(n, k)$ subsets of $k$ troublemakers, is computationally infeasible for realistic $k$ values (e.g., $k=10$).

=== Initial Algorithmic Insights

Simple observations can significantly reduce the search space:
*   If a person has no potential conflicts with anyone else, they can be safely admitted.
*   If a person would fight with $k+1$ or more other people, they must be among the $k$ refused, so they can be removed, and $k$ is decremented.

A more advanced approach involves branching:
1. Identify an unresolved conflict between two people, say Alice and Bob.
2. Create two subproblems:
  - *Option 1:* Refuse Alice. The budget for troublemakers ($k$) decreases by 1.
  - *Option 2:* Refuse Bob. The budget for troublemakers ($k$) decreases by 1.
3. The algorithm recurses on these subproblems. When $k$ reaches 0, check for any remaining conflicts.

This recursive strategy can solve the #smallcaps("Bar Fight Prevention") problem in $cal(O)^*(2^k)$ time (where $cal(O)^*$ suppresses polynomial factors in $n$). This is a significant improvement over brute-force for small $k$, illustrating the power of parameterized algorithms.

== Formal Definitions of Parameterized Complexity

#definition("Parameterized Problem", [
  A parameterized problem is a language $L subset.eq Sigma^* times NN$, where $Sigma$ is a fixed, finite alphabet. For an instance $(x, k) in Sigma^* times NN$, $k$ is called the *parameter*.
])

The #smallcaps("Clique") problem, parameterized by solution size, is a pair $(G, k)$, where $G$ is an undirected graph and $k$ is a positive integer. $(G, k)$ belongs to the #smallcaps("Clique") parameterized language if $G$ contains a clique of $k$ vertices.


#definition("Fixed-Parameter Tractable (FPT)", [
A parameterized problem $L$ is *fixed-parameter tractable (FPT)* if there exists an algorithm $A$, a computable function $f: NN -> NN$, and a constant $c$ such that, given $(x, k) in Sigma^* times NN$, the algorithm $A$ correctly decides whether $(x, k) in L$ in time bounded by $f(k) dot |(x, k)|^c$. The class of problems containing all fixed-parameter tractable problems is called *FPT*.
])

#definition("XP Algorithms (Slice-wise Polynomial)", [
  A parameterized problem $L$ is called *slice-wise polynomial (XP)* if there exists an algorithm $A$ and two computable functions $f, g: NN -> NN$ such that, given $(x, k) in Sigma^* times NN$, the algorithm $A$ correctly decides whether $(x, k) in L$ in time bounded by $f(k) dot |(x, k)|^(g(k))$. The class of problems containing all slice-wise polynomial problems is called *XP*.
])

The key difference between FPT and XP is that for FPT problems, the exponent $c$ of the polynomial in input size $|(x, k)|$ is a constant independent of $k$, while for XP problems, the exponent $g(k)$ can depend on $k$. This often means FPT algorithms are significantly more efficient for small $k$.

== The Role of the Parameter $k$

The parameter $k$ can represent various aspects of a problem instance:
*   The size of the solution sought (e.g., number of troublemakers, clique size).
*   A measure describing how "structured" the input instance is (e.g., maximum degree, treewidth).

=== Hard Parameterized Problems

Not all problems benefit from parameterization. For example, #smallcaps("Vertex Coloring") remains NP-complete even for small fixed values of $k$. 
Another example is #smallcaps("Clique") parameterized by $k$: the naive $O(n^k)$ algorithm is XP, but no FPT algorithm is known. This suggests that #smallcaps("Clique") is a "hard" parameterized problem.


#example(smallcaps("Clique") + " Parameterized by Maximum Degree", [
  If we are looking for a $k$-clique in a graph with maximum degree $d$:
  1. Guess one vertex $v$ in the clique.
  2. The remaining $k-1$ vertices must be in $N(v)$, the neighborhood of $v$.
  3. We can then try all subsets of $N(v)$ of size $k-1$.

  The running time is $O^*(2^d dot d^2)$, which is FPT if $d$ is considered the parameter. This demonstrates that the choice of parameter is crucial for fixed-parameter tractability.
])

== Review Questions

1. What is the fundamental difference between classical complexity theory and parameterized algorithmics?

2. What defines a *Fixed-Parameter Tractable (FPT)* algorithm, and how does it differ from an *XP* algorithm?

3. Why is #smallcaps("Vertex Coloring") generally not considered FPT, even for small values of the parameter?

4. Discuss how the choice of parameter can influence whether a problem is FPT, using #smallcaps("Clique") as an example.

== Solutions

1. Classical complexity analyzes running time based on input size alone (e.g., $O(n^c)$). Parameterized algorithmics analyzes running time based on input size and a parameter $k$, aiming for $f(k) dot n^c$, which allows exponential time in $k$ while remaining polynomial in $n$.

2. An FPT algorithm runs in $f(k) dot n^c$ time, where the exponent of $n$ is constant. An XP algorithm runs in $n^(g(k))$ time, where the exponent depends on $k$. FPT is generally faster for larger $n$ even if $k$ is small, while XP becomes impractical as $k$ grows. 

3. #smallcaps("Vertex Coloring") parameterized by the number of colors $k$ is NP-complete for $k >= 3$. Unless $P="NP"$, there is no polynomial-time algorithm for fixed $k$, so it cannot be FPT (which would imply polynomial time for constant $k$). It is not even XP.

4. #smallcaps("Clique") parameterized by solution size $k$ is likely not FPT (it is $W[1]$-hard). However, #smallcaps("Clique") parameterized by the maximum degree $d$ is FPT, because the search space is limited to the neighbors of a vertex, allowing an algorithm with runtime dependent on $2^d$.