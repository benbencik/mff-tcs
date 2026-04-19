#import "../../../shared/lib.typ": *

= Kernelization

Kernelization is a fundamental preprocessing technique in parameterized algorithms. Its primary goal is to efficiently reduce a problem instance to a smaller, equivalent "core" structure, called the *kernel*, in polynomial time. This kernel can then be solved by a slower, exact algorithm.

== Formal Definitions

#definition("Data Reduction Rule", [
  A data reduction rule is a function $phi: Sigma^* times NN -> Sigma^* times NN$ that maps an instance $(I, k)$ of a parameterized problem $Q$ to an equivalent instance $(I', k')$ of $Q$. This rule must be computable in time polynomial in $|I|$ and $k$.

  *Soundness:* $(I, k) in Q$ if and only if $(I', k') in Q$.
])

#definition("Kernelization Algorithm", [
  A kernelization algorithm for a parameterized problem $Q$ is an algorithm $A$ that:
  1. Takes an instance $(I, k)$ of $Q$ as input.
  2. Works in polynomial time.
  3. Returns an equivalent instance $(I', k')$ of $Q$.
  4. The size of the output instance, $|I'| + k'$, is bounded by a computable function $g(k)$ of the parameter $k$ alone $ "size"(k') <= g(k) $

  If $g(k)$ is a polynomial function (e.g., $k^c$), it is called a *polynomial kernel*. If $g(k)$ is linear (e.g., $c k$), it is a *linear kernel*.
])

#lemma("FPT Implies Kernelization", [
  If a parameterized problem $Q$ is Fixed-Parameter Tractable (FPT), then it admits a kernelization algorithm.
])

An FPT algorithm solves the problem in $f(k) dot |I|^c$ time. If it doesn't terminate within $|I|^{c+1}$ steps, it means $f(k) dot |I|^c > |I|^{c+1}$, implying $|I| < f(k)$. Thus, $(I, k)$ itself can be returned as a kernel whose size is bounded by $f(k) + k$.

== Simple Kernelization Rules: #smallcaps("Vertex Cover")

The #smallcaps("Vertex Cover") problem (find a minimum set of vertices $S$ such that every edge has at least one endpoint in $S$) is a classic example for illustrating simple kernelization rules. Given a graph $G$ and a positive integer $k$, decide if there exists a vertex cover of size at most $k$.

The following rules are applied exhaustively to simplify the graph:
- *VC.1 (Isolated Vertices):* If $G$ contains an isolated vertex $v$, delete $v$. The new instance is $(G - v, k)$. (Safe because isolated vertices do not cover any edges.)
- *VC.2 (High-Degree Vertices):* If there is a vertex $v$ with degree $"deg"(v) > k$, include $v$ in the vertex cover. Delete $v$ (and its incident edges) from $G$ and decrement $k$ by 1. The new instance is $(G - v, k - 1)$. (Safe because if $v$ is not in the vertex cover, all its $"deg"(v)$ incident edges must be covered by its neighbors, requiring more than $k$ vertices if $"deg"(v) > k$).

After applying VC.1 and VC.2 exhaustively, we can bound the size of the remaining graph:

#lemma("Bounding Graph Size for " + smallcaps("Vertex Cover"), [
  If $(G, k)$ is a yes-instance for #smallcaps("Vertex Cover") and neither VC.1 nor VC.2 is applicable, then:
  *   $|V(G)| <= k^2 + k$
  *   $|E(G)| <= k^2$

])
*Proof sketch:* Since VC.1 is not applicable, $G$ has no isolated vertices. Since VC.2 is not applicable, every vertex has degree at most $k$. If there's a vertex cover $S$ of size at most $k$, then $|V(G)| = |S| + |V(G) without S|$. Each vertex in $V(G) without S$ must be adjacent to at least one vertex in $S$. Since $"deg"(v) <= k$ for all $v$, each vertex in $S$ can cover edges incident to at most $k$ other vertices.

*VC.3 (Large Instances):* If $G$ has more than $k^2 + k$ vertices or more than $k^2$ edges, then conclude it is a no-instance.


The #smallcaps("Vertex Cover") problem admits a kernel with $O(k^2)$ vertices and $O(k^2)$ edges.

== Crown Decomposition

Crown decomposition is a powerful technique to find polynomial kernels by exploiting the structural properties of graphs, often related to matchings.

#definition("Crown Decomposition", [
  A crown decomposition of a graph $G$ is a partition of its vertex set $V(G)$ into three disjoint sets $C$, $H$, and $R$, such that:
  1. $C$ is non-empty.
  2. $C$ is an independent set (no two vertices in $C$ are adjacent).
  3. There are no edges between vertices in $C$ and $R$ (i.e., $H$ separates $C$ and $R$).
  4. There exists a matching $M$ of $H$ into $C$ (meaning $M$ saturates all vertices in $H$).
])

#fig("../courses/parametrized-algorihms/figs/crown-decomposition.png", width: 50%)

#theorem("Kőnig's Theorem", [
  In any undirected bipartite graph, the size of a maximum matching equals the size of a minimum #smallcaps("Vertex Cover").
])

#theorem("Hall's Theorem", [
  Let $G$ be an undirected bipartite graph with bipartition $(V_1, V_2)$. $G$ has a matching saturating $V_1$ if and only if for every subset $X subset.eq V_1$, $|N(X)| >= |X|$.
])

#lemma("Crown Lemma", [
  Let $G$ be a graph without isolated vertices and with at least $3k+1$ vertices. There is a polynomial-time algorithm that either:
  *   Finds a matching of size $k+1$ in $G$, or
  *   Finds a crown decomposition of $G$.
])

=== Applying Crown Decomposition to #smallcaps("Vertex Cover")

The crown lemma can be applied to #smallcaps("Vertex Cover") to obtain an even smaller kernel:

If the crown lemma finds a matching $M$ of size $k+1$, then $G$ is a no-instance for #smallcaps("Vertex Cover") of size $k$, because at least $k+1$ vertices are needed to cover $k+1$ disjoint edges.

#example(smallcaps("Vertex Cover") + " with Crown Decomposition", [
  If the crown lemma yields a crown decomposition $(C, H, R)$:
  1. A vertex cover must include all vertices in $H$ (since $H$ is matched into $C$, and $C$ is an independent set, no vertex in $C$ can cover an edge incident to $H$).
  2. The problem can be reduced to finding a vertex cover in $G - H$ with budget $k - |H|$.
  3. Since $C$ is an independent set and is separated from $R$ by $H$, vertices in $C$ become isolated in $G - H$ and can be removed by VC.1.
  
  As result the #smallcaps("Vertex Cover") problem admits a kernel with at most $3k$ vertices.
])


== Review Questions

1. What is kernelization, and what are its primary objectives in parameterized algorithmics?

2. Describe the three main reduction rules (VC.1, VC.2, VC.3) used to obtain a quadratic kernel for #smallcaps("Vertex Cover").

3. Explain what a *crown decomposition* is. How do *Kőnig's Theorem* and *Hall's Theorem* relate to finding one?

4. How can a crown decomposition be used to further reduce the instance size for #smallcaps("Vertex Cover"), leading to a $3k$-vertex kernel?

5. If a problem is FPT, does it necessarily have a polynomial kernel? Explain your answer.

== Answers

1. Kernelization is a polynomial-time preprocessing algorithm that takes an instance $(I, k)$ and outputs an equivalent instance $(I', k')$ such that the size of $(I', k')$ is bounded by a function $g(k)$. Its objective is to reduce the "easy" parts of the problem so that any subsequent exponential-time algorithm only has to deal with a small core whose size depends only on $k$.

2. The rules are:
  - *VC.1:* Remove isolated vertices (they don't cover edges).
  - *VC.2:* If a vertex has degree $> k$, select it (otherwise its neighbors exceed the budget $k$).
  - *VC.3:* After applying 1 & 2, if $|E| > k^2$ or $|V| > k^2+k$, the instance is a "No" (since bounded degree vertices cannot cover that many edges with budget $k$).

3. A crown decomposition partitions vertices into $(C, H, R)$ where $C$ is an independent set, $H$ separates $C$ from $R$, and there is a matching saturating $H$ into $C$. The decomposition is found by finding a maximum matching in the graph. If the matching is small, we are done. If large, Kőnig's theorem allows constructing a vertex cover in a related bipartite graph, and the structure of this cover (via Hall's condition properties) yields the sets $C$ and $H$.

4. In a crown decomposition $(C, H, R)$, any vertex cover must contain $H$ to cover the edges between $C$ and $H$ (since $C$ is independent). We can select $H$, reduce $k$ by $|H|$, and delete $H$. The vertices in $C$ become isolated and are removed. If the remaining graph still has $>3k$ vertices, another crown can be found.

5. No. While every FPT problem admits *a* kernel (by simply solving the instance if it's small, or outputting the instance if it's smaller than the FPT runtime bound), it is not guaranteed to be *polynomial*. Some FPT problems are known not to have polynomial kernels unless $"NP" subset.eq "coNP"/"poly"$.