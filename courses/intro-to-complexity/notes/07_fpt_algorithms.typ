#import "../lib.typ": *

= Parameterized Complexity and #smallcaps[FPT]

#question_B(
  "(B8) Definition of FPT class and kernels, and kernelization of Vertex Cover",
)[
  Define the #smallcaps[FPT] class and the concept of a kernel. Describe the kernelization algorithm for Vertex Cover.
]

== The Class #smallcaps[FPT]

A parameterized problem is a language $L subset.eq Sigma^* times bb(N)$. The input consists of a main part $x$ and a parameter $k$.

#definition("Fixed-Parameter Tractable (FPT)")[
  A parameterized problem $L$ is in #smallcaps[FPT] if there exists an algorithm that decides whether $(x, k) in L$ in time:
  $ cal(O)(f(k) dot |x|^c) $
  where $f$ is an arbitrary computable function and $c$ is a constant independent of $k$.
]

== Kernelization

Kernelization is a preprocessing technique that reduces the input instance to a smaller "kernel" whose size depends only on the parameter $k$.

#definition("Kernelization")[
  A kernelization algorithm for a parameterized problem $L$ is a polynomial-time algorithm that takes an instance $(x, k)$ and outputs an instance $(x', k')$ such that:
  1. $(x, k) in L <=> (x', k') in L$.
  2. $|x'| lt.eq g(k)$ and $k' lt.eq g(k)$ for some computable function $g$.
  The instance $(x', k')$ is called the *kernel*.
]

#theorem("FPT and Kernelization")[
  A decidable parameterized problem $L$ is in #smallcaps[FPT] if and only if it has a kernelization algorithm.
]

#proof[
  ($arrow.l$) *Kernel $=>$ FPT:*
  Let $L$ have a kernelization algorithm that produces a kernel $(x', k')$ of size $g(k)$ in polynomial time $|x|^c$.
  Since $L$ is decidable, there exists an algorithm $B$ that solves it.
  We can define an FPT algorithm $A$ for $L$:
  1. Run the kernelization algorithm to get $(x', k')$.
  2. Run $B$ on $(x', k')$.
  Since $|x'| lt.eq g(k)$, the running time of step 2 depends only on $k$ (let's say $h(k)$).
  Total time is $cal(O)(|x|^c + h(k))$, which is in #smallcaps[FPT].

  ($=>$) *FPT $=>$ Kernel:*
  Let $L$ be in #smallcaps[FPT] decided by algorithm $A$ in time $f(k) dot |x|^c$.
  We construct a kernelization algorithm:
  Run $A$ on input $(x, k)$ for $|x|^{c+1}$ steps.
  1. If $A$ terminates and accepts, output a trivial "YES" instance (of constant size).
  2. If $A$ terminates and rejects, output a trivial "NO" instance (of constant size).
  3. If $A$ does not terminate within $|x|^{c+1}$ steps, then it must be that $f(k) dot |x|^c > |x|^{c+1}$, which implies $|x| < f(k)$.
    In this case, the instance $(x, k)$ itself is small (size bounded by $f(k) + k$), so we output $(x, k)$ as the kernel.
]

== Vertex Cover Kernelization

We can construct a kernel for Vertex Cover.
*Problem:* Given $(G, k)$, does $G$ have a vertex cover of size $k$?

The kernelization algorithm applies the following reduction rules exhaustively:

1. *Isolated vertex rule (VP1):* If $v$ is an isolated vertex, remove it.
  - $v$ cannot cover any edges, so $(G, k)$ is equivalent to $(G - v, k)$.

2. *High-degree rule (VP2):* If a vertex $v$ has degree $> k$, then $v$ must be in the vertex cover.
  - If $v$ were not in the cover, all its neighbors would have to be included. Since $|N(v)| > k$, this would exceed the budget $k$.
  - Thus, $(G, k)$ is equivalent to $(G - v, k - 1)$.

3. *Size bound (VP3):* If neither VP1 nor VP2 applies, check the size of the graph.
  - If $|E| > k^2$ or $|V| > k^2 + k$, reject (return a trivial NO-instance).
  - Otherwise, output $(G, k)$ as the kernel.

#lemma("Kernel Size")[
  If $(G, k)$ is a reduced instance (VP1 and VP2 do not apply) and it is a YES-instance, then $|V| lt.eq k^2 + k$ and $|E| lt.eq k^2$.
]

#proof[
  Let $S$ be a vertex cover with $|S| lt.eq k$.
  - Since VP2 does not apply, every vertex has degree at most $k$.
  - Since $S$ covers all edges, every edge is incident to at least one vertex in $S$. Thus, $|E| lt.eq sum_(v in S) deg(v) lt.eq |S| dot k lt.eq k^2$.
  - Since VP1 does not apply, there are no isolated vertices. Every vertex in $V without S$ must be connected to at least one vertex in $S$ (otherwise the edge would be uncovered).
  - Thus, $|V without S| lt.eq sum_(v in S) deg(v) lt.eq k^2$.
  - Total vertices: $|V| = |S| + |V without S| lt.eq k + k^2$.
]

The resulting kernel has size cal(O)(k^2).


#question_B(
  "(B9) Bounded search tree Vertex Cover",
)[
  Describe a parameterized algorithm for Vertex Cover based on bounded search trees with complexity lower than $cal(O)^*(2^k)$.
]

== Bounded Search Tree Algorithm

The Bounded Search Tree (or Depth-Bounded Search Tree) technique is a fundamental method for designing #smallcaps[FPT] algorithms. The idea is to find a small set of subproblems such that the original instance is a YES-instance if and only if at least one of the subproblems is a YES-instance. By recursively solving these subproblems, we generate a search tree.

*Algorithm for Vertex Cover:*
To check if $G$ has a VC of size $k$:
1. If $G$ has no edges, return *accept*.
2. If $k=0$ and $G$ has edges, *continue*.
3. Pick an arbitrary edge $(u, v)$.
  - Branch 1: Assume $u$ is in the VC. Recursively check $(G - u, k - 1)$.
  - Branch 2: Assume $v$ is in the VC. Recursively check $(G - v, k - 1)$.
4. Return *reject*.

*Analysis:*
The depth of the recursion tree is at most $k$.
At each step, we branch into 2 subproblems.
Total nodes in the tree: $2^k$.
Work per node: cal(O)(n).
Total runtime: cal(O)(2^k dot n).
This shows Vertex Cover is in #smallcaps[FPT].

(Note: The simple bounded search tree algorithm presented yields an cal(O)(2^k dot n) runtime. More advanced branching rules and techniques can achieve significantly better runtimes, such as cal(O)(1.2738^k + k n).)
