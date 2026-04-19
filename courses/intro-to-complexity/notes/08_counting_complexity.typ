#import "../../../shared/lib.typ": *

= Counting Complexity

#question(
  "(B10) #P class and #P-completeness, hardness of counting cycles in a graph",
)[
  Define the class #smallcaps[#sym.hash P] and #smallcaps[#sym.hash P]-completeness. Discuss the hardness of counting cycles in a graph.
]

== The Class #smallcaps[#sym.hash P]

The class #smallcaps[#sym.hash P] (Sharp-P) captures the difficulty of counting solutions for #smallcaps[NP] problems.

#definition("P")[
  A function $f: Sigma^* -> bb(N)$ is in #smallcaps[#sym.hash P] if there exists a polynomial-time nondeterministic Turing machine $M$ such that for every input $x$, $f(x)$ equals the number of accepting computation paths of $M$ on $x$.
]

Equivalently, counting the number of certificates for a verifier in #smallcaps[NP].

== #smallcaps[#sym.hash P]-Completeness

Just as SAT is the prototypical #smallcaps[NP]-complete problem, #smallcaps[#sym.hash SAT] is the prototypical #smallcaps[#sym.hash P]-complete problem.

#definition("SAT")[
  Given a boolean formula $phi$, find the number of satisfying truth assignments.
]

#theorem("Valiant's Theorem")[
  #smallcaps[#sym.hash SAT] is #smallcaps[#sym.hash P]-complete.
]

This implies that if we can compute #smallcaps[#sym.hash SAT] in polynomial time, then $#smallcaps("P") = #smallcaps("NP")$. In fact, #smallcaps[#sym.hash P]-complete problems are generally considered much harder than #smallcaps[NP]-complete problems. Even if $#smallcaps("P")=#smallcaps("NP")$, it is not guaranteed that #smallcaps[#sym.hash P] problems are solvable in polynomial time (though the hierarchy would collapse).

== Counting Cycles

Counting the number of simple cycles in a directed graph is a #smallcaps[#sym.hash P]-complete problem. This implies that if we could count cycles efficiently, we could solve #smallcaps[NP]-complete problems like the Hamiltonian Cycle problem.

*Problem:* #smallcaps("CYCLE")
- *Input:* Directed graph $G = (V, E)$.
- *Output:* The number of simple cycles in $G$.

#theorem("Hardness of Counting Cycles")[
  If #smallcaps("CYCLE") can be computed in polynomial time, then $#smallcaps("P") = #smallcaps("NP")$.
]

#proof[
  Let $G = (V, E)$ be a directed graph with $n = |V|$ vertices. We want to decide if $G$ contains a Hamiltonian cycle (a simple cycle of length $n$). We will use the fact that the problem of finding *Hamiltonian cycle is #smallcaps[NP]-complete*. We construct a new graph $G'$ such that the number of cycles in $G'$ reveals the existence of a Hamiltonian cycle in $G$.

  *Construction of $G'$:*
  We replace every edge $(u, v)$ in $G$ with a "gadget" structure.
  1. Let $m = n ceil(log_2 n)$.
  2. For each edge $(u, v) in E$, we substitute it with a directed acyclic subgraph connecting $u$ to $v$ that contains exactly $2^m$ distinct paths. This subgraph can be constructed using $m$ levels of branching nodes.
  3. Since the gadgets are acyclic, any simple cycle in $G'$ must correspond to a simple cycle in $G$ that traverses the gadgets corresponding to its edges.

  #fig("../courses/intro-to-complexity/figs/counting-cycles.png")

  *Analysis:*
  Let $C$ be a simple cycle in $G$ of length $ell$. In $G'$, this cycle corresponds to a closed walk that passes through $ell$ gadgets. Since each gadget offers $2^m$ paths, this single cycle $C$ gives rise to $(2^m)^ell$ distinct simple cycles in $G'$.

  The total number of cycles in $G'$ is:
  $ N = sum_(C in cal(C)_G) (2^m)^(|C|) $
  where $cal(C)_G$ is the set of simple cycles in $G$.

  We use the value of $m$ to create a gap between the count for a Hamiltonian cycle and all other cycles.

  - *Case 1: $G$ has a Hamiltonian Cycle.*
    There exists at least one cycle of length $n$. The contribution of this single cycle to the total count is $(2^m)^n$.
    Substituting $m = n log_2 n$ (assuming $n$ is a power of 2 for simplicity, or sufficiently large):
    $ (2^m)^n = (2^(n log_2 n))^n = (n^n)^n = n^(n^2) $
    Therefore, the total number of cycles $N$ is at least $n^(n^2)$.

  - *Case 2: $G$ has no Hamiltonian Cycle.*
    Every simple cycle in $G$ has length at most $n-1$.
    A loose upper bound on the number of simple cycles in any graph with $n$ vertices is $n^n$ (specifically $n^{n-1}$ is used in the lecture for the bound estimation).
    The contribution of any single cycle is at most $(2^m)^(n-1)$.
    The total count $N$ is bounded by:
    $
      N & lt.eq ("number of cycles") dot (2^m)^(n-1) \
        & lt.eq n^(n-1) dot (n^n)^(n-1) \
        & = n^(n-1) dot n^(n^2 - n) \
        & = n^(n^2 - 1)
    $
    Thus, $N < n^(n^2)$.

  *Conclusion:*
  By calculating $N = #smallcaps("CYCLE") (G')$, we can decide the Hamiltonian Cycle problem:
  - If $N >= n^(n^2)$, $G$ has a Hamiltonian cycle.
  - If $N < n^(n^2)$, $G$ does not.

  The construction of $G'$ is polynomial in size (since $m$ is polynomial in $n$), so #smallcaps("CYCLE") is #smallcaps[NP]-hard (and in fact #smallcaps[#sym.hash P]-complete).
]
