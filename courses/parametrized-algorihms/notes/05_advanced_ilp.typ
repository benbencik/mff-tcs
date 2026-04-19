#import "../lib.typ": *

= Advanced Integer Programming and Applications

In this chapter, we explore more advanced applications of Integer Programming in parameterized complexity, focusing on the *n-fold Integer Programming* framework and other specialized IP solvers.

== n-fold Integer Programming

*n-fold IP* is a specific block-structured IP format that allows for efficient FPT algorithms even when the dimension is variable, provided the structure is rigid.

The constraint matrix $A$ of an n-fold IP has the following structure:
$ A = mat(
  A_1, A_1, ..., A_1;
  A_2, 0, ..., 0;
  0, A_2, ..., 0;
  dots.v, dots.v, dots.down, dots.v;
  0, 0, ..., A_2
) $
where $A_1$ is an $r times t$ matrix and $A_2$ is an $s times t$ matrix. The total number of variables is $n dot t$. The important parameters are the block dimensions $r, s, t$ and the largest coefficient $Delta = ||A||_infinity$.

#theorem("n-fold IP Algorithm")[
  n-fold IP can be solved in time $f(r, s, t, Delta) dot L^{O(1)}$, where $L$ is the input size. Thus, it is FPT parameterized by the block dimensions and the maximum coefficient.
]

=== Birds-eye View of the Algorithm

The algorithm relies on the concept of a *Graver basis*.
1.  *Graver Basis:* The Graver basis $cal(G)(A)$ is a set of "primitive" directions in the integer lattice. For n-fold matrices, the elements of the Graver basis have a bounded norm and a specific structure (short support).
2.  *Iterative Augmentation:* We start with a feasible solution. We then iteratively look for an "augmenting step" $g in cal(G)(A)$ such that moving in direction $g$ improves the objective function while staying feasible.
3.  *Convergence:* Because the Graver basis elements are small and well-structured, we can find the best augmenting step efficiently (using dynamic programming) and we converge to the optimum quickly.

== Scheduling ($P || C_{max}$ and variants)

The problem of scheduling $n$ jobs on $m$ machines to minimize the makespan (maximum completion time) can be modeled using n-fold IP when the number of *job types* or *machine types* is small.

For $R || C_{max}$ (Unrelated machines), if we have a constant number of machine types and job types, we can use n-fold IP.
-   *Variables:* $x_{i,j}$ = number of jobs of type $j$ assigned to a machine of type $i$.
-   *Constraints:*
    -   All jobs of type $j$ must be assigned ($A_1$ block constraints).
    -   Machine capacities (if modeling decision version) or machine configurations can be handled in $A_2$ blocks.

== Borda-Shift Bribery

In computational social choice, the *Borda-Shift Bribery* problem asks if we can make a preferred candidate $p$ win an election by shifting $p$ forward in the voters' preference orders, incurring a cost for each shift, within a total budget $B$.

This is FPT parameterized by the number of candidates $m$.
-   *Voter Types:* Voters with the same preference order form a type. There are $m!$ types (which is function of parameter $m$).
-   *Model:* We can use n-fold IP where variables represent how many voters of a certain type we shift by a certain amount.
    -   $A_1$ constraints ensure we shift the correct number of voters of each type.
    -   $A_2$ constraints can track the score of $p$ versus other candidates.
-   Since the number of candidates $m$ is the parameter, the block sizes depend only on $m$, making it FPT via n-fold IP.

== Max $q$-Cut and Indefinite Quadratic Programming

The *Max $q$-Cut* problem generalizes Max Cut: partition vertices into $q$ sets to maximize edges between sets.
For neighborhood diversity $k$, we can model this. However, the objective function involves terms like $x_i dot x_j$ (edges between cluster $i$ and cluster $j$).

*Geometric Intuition:* The function $f(x, y) = x dot y$ is *not convex*. (Its graph is a saddle). Therefore, we cannot use the standard Convex IP solvers discussed in Chapter 4.

However, Lokshtanov demonstrated that *Indefinite Quadratic Integer Programming* with fixed dimension and bounded coefficients is FPT.
-   *Model:* Variables $x_{i, c}$ = number of vertices of twin class $i$ assigned to color $c$.
-   *Objective:* Maximize $sum x_{i, c} dot x_{j, d}$ for compatible $i,j,c,d$. This is a quadratic form $x^T Q x$.
-   Since the dimension is small ($k dot q$) and coefficients are small, this is FPT.

== $P || C_{max}$ with Unary Processing Times

If we consider scheduling on identical machines ($P || C_{max}$) where the maximum processing time $p_{max}$ is bounded (unary encoded), the problem is FPT parameterized by the number of distinct processing times $d$ (or $p_{max}$).

This uses the algorithm of *Goemans and Rothvoss*.
-   They showed that one can solve a specific type of IP where the constraint matrix has small coordinates, but the number of variables can be large, provided the *rank* of the matrix is small.
-   This allows optimizing over the polytope of "configurations" of machines.

== Equitable Coloring

*Equitable Coloring* asks for a proper coloring where color classes differ in size by at most 1.
Parameterized by neighborhood diversity $"nd"(G)$:
-   This can be modeled using the machinery of *n-fold IP* or *Convex IP*.
-   We need to decide how many vertices of each twin class $V_i$ go to each color class.
-   The constraint that color classes are nearly equal adds global constraints, which fits the $A_1$ block of n-fold IP (sum of variables across all twin classes = size of color class).

== Hardness of Uniform n-fold IP

While n-fold IP is FPT when coefficients $A$ are small, it becomes hard if coefficients are large (unary encoded).

#lemma("Hardness from Unary Bin Packing")[
  There is a reduction from *Unary Bin Packing* (parameterized by $k$, number of bins) to uniform n-fold IP where dimensions $r, s, t$ and domain size $||D||_infinity$ are small, but the coefficients $||A||_infinity$ are unary.
]
*Reduction Sketch:*
-   Bin Packing with item sizes $w_1, ..., w_n$ and bin capacity $B$.
-   We want to put items into $k$ bins.
-   If we let variables represent "is item $i$ in bin $j$", the capacity constraint involves sums weighted by $w_i$.
-   If $w_i$ are large (unary), the coefficients in $A$ are large.
-   This proves that the dependence on $||A||_infinity$ in the n-fold complexity is necessary.
