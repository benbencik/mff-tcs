#import "../lib.typ": *

= Polynomial-Time Reductions

#question_B("(B7) Polynomial reduction from 3-SAT to Vertex Cover")[
  Describe the polynomial-time reduction from 3-SAT to Vertex Cover.
]

== Polynomial-Time Reduction

#definition("Polynomial-Time Reduction")[
  A language $A$ is polynomial-time reducible to language $B$, denoted $A scripts(<=)_m^p B$, if there exists a polynomial-time computable function $f: Sigma^* -> Sigma^*$ such that for every $w$:
  $ w in A <=> f(w) in B $
]

It also holds that the relation $scripts(<=)_m^p$ is reflexive and transitive.

*Key Properties:*
- If $A scripts(<=)_m^p B$ and $B in #smallcaps[P]$, then $A in #smallcaps[P]$.
- If $A scripts(<=)_m^p B$ and $B in #smallcaps[NP]$, then $A in #smallcaps[NP]$.
- If $A scripts(<=)_m^p B$ and $A$ is #smallcaps[NP]-hard, then $B$ is #smallcaps[NP]-hard.
- $A scripts(<=)_m^p B <=> overline(A) scripts(<=)_m^p overline(B)$.

Currently we know the following relationships between classes.

#fig("inclusions.png")

== Reduction from 3-SAT to Vertex Cover

We show that Vertex Cover is #smallcaps[NP]-complete by reducing 3-SAT to it.

*3-SAT:* Given a boolean formula in 3-CNF (conjunctive normal form where each clause has 3 literals), is it satisfiable?
*Vertex Cover:* Given a graph $G$ and integer $k$, is there a subset of vertices $S$ of size at most $k$ such that every edge in $G$ touches at least one vertex in $S$?

#theorem("3-SAT reduces to Vertex Cover")[
  $#smallcaps[3-SAT] scripts(<=)_m^p "Vertex Cover"$.
]

#proof[
  Let $phi$ be a 3-CNF formula with $n$ variables $x_1, ..., x_n$ and $m$ clauses $C_1, ..., C_m$. We construct a graph $G$ and integer $k$.

  *Construction:*
  1. *Variable Gadgets:* For each variable $x_i$, create two nodes labeled $x_i$ and $not x_i$, connected by an edge.
    - To cover this edge, we must pick at least one of $x_i$ or $not x_i$. This corresponds to setting the variable to true or false.

  2. *Clause Gadgets:* For each clause $C_j = (l_1 or l_2 or l_3)$, create three nodes labeled with the literals $l_1, l_2, l_3$ and connect them in a triangle.
    - To cover the edges of a triangle, we need at least 2 vertices.

  3. *Connecting Gadgets:* Add edges connecting the variable gadget nodes to the corresponding nodes in the clause gadgets.
    - If clause $C_j$ contains literal $x_i$, connect the node $x_i$ in the variable gadget to the node $x_i$ in the clause gadget for $C_j$.

  #fig("3sat-vc.png")

  *Setting k:*
  Set $k = n + 2m$.

  *Correctness:*
  - ($==>$): If $phi$ is satisfiable, select the node corresponding to the true literal in each variable gadget ($n$ nodes). In each clause gadget, since at least one literal is true (and connected to a chosen variable node), the edge connecting to the variable gadget is covered. We pick the other 2 nodes in the clause triangle to cover the triangle edges. Total nodes: $n + 2m = k$.

  - ($<==$): If $G$ has a vertex cover of size $k$, it must pick exactly one node per variable gadget (to minimize usage) and exactly 2 nodes per clause gadget. The remaining edges between gadgets must be covered by the variable nodes. This implies that for every clause, at least one literal node is not picked in the clause gadget, meaning its connector edge is covered by the variable gadget node. This corresponds to a valid truth assignment satisfying all clauses.
]
