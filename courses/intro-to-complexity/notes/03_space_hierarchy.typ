#import "../lib.typ": *

= Space Complexity

#question_B(
  "(B4) Definition of space complexity classes",
)[Define the basic space complexity classes and prove that $#smallcaps("NTIME") (f(n)) subset.eq #smallcaps("SPACE") (f(n))$.
]

== Space Complexity Classes

Space complexity measures the amount of memory (space) required by a Turing machine to solve a problem.

#definition("Space Complexity Classes")[
  Let $f: bb(N) -> bb(N)$ be a function.
  - #smallcaps[SPACE] ($f(n)$) is the class of languages decided by a deterministic Turing machine that uses cal(O)(f(n)) space.
  - #smallcaps[NSPACE] ($f(n)$) is the class of languages decided by a nondeterministic Turing machine that uses cal(O)(f(n)) space.
]

Common space complexity classes:
- #smallcaps[L] = #smallcaps[SPACE] ($log n$)
- #smallcaps[NL] = #smallcaps[NSPACE] ($log n$)
- #smallcaps[PSPACE] = $union.big_(k in bb(N)) #smallcaps("SPACE") n^k$
- #smallcaps[NPSPACE] = $union.big_(k in bb(N)) #smallcaps("NSPACE") n^k$

== Relationship between Time and Space

There are fundamental relationships between the time and space resources required for computation.

#theorem("Nondeterministic Time vs. Space")[
  For any function $f: bb(N) -> bb(N)$,
  $ #smallcaps("NTIME") (f(n)) subset.eq #smallcaps("SPACE") (f(n)) $
]

#proof[
  We need to show that if a language $L$ is decided by a nondeterministic Turing machine $N$ in time cal(O)(f(n)), then it can be decided by a deterministic Turing machine $D$ in space cal(O)(f(n)).

  *1. Space usage of $N$ on a single path*
  Consider any single computation path of $N$ on input $x$ of length $n$. $N$ runs for at most $T = c dot f(n)$ steps for some constant $c$.
  In one computational step, the tape head of a Turing machine can move at most one cell distance from its current position. Starting from the initial position, after $T$ steps, the head can reach at most the cells in the range [-T, T] relative to the start. Thus, the machine can visit (read or write) at most $T + 1$ distinct tape cells.
  Consequently, on any single execution branch, $N$ uses space bounded by cal(O)(f(n)).

  *2. Deterministic simulation*
  We construct a deterministic machine $D$ that simulates $N$. Since $N$ is nondeterministic, its computation forms a tree where each node represents a configuration and branches represent possible transitions. $D$ performs a search (e.g., Depth-First Search) on this tree to determine if an accepting configuration is reachable.

  Let $r$ be the maximum branching factor of $N$ (the maximum number of choices $N$ can make in any state). We can represent any specific sequence of nondeterministic choices (a computation path) of length up to $T$ as a sequence of numbers $y in {1, dots, r}^T$.

  Machine $D$ operates as follows:
  1. It iterates through all possible choice sequences $y$ (corresponding to paths in the computation tree).
  2. For each $y$, $D$ simulates $N$ deterministically on input $x$ following the choices specified by $y$.
  3. If the simulation leads to an accepting state, $D$ accepts.
  4. If $D$ exhausts all possible sequences without accepting, it rejects.

  *3. Total Space Analysis*
  Machine $D$ needs space for:
  - *Keeping track of the current path:* $D$ stores the sequence $y$, which has length proportional to the time bound of $N$, i.e., cal(O)(f(n)).
  - *Simulation:* $D$ needs to store the tape contents of $N$ for the current simulation. As established in step 1, this requires at most cal(O)(f(n)) space. $D$ can reuse this space for each path.

  The total space required by $D$ is sum of these, which remains cal(O)(f(n)). Thus, $L in #smallcaps("SPACE") (f(n))$.
]


#question_B(
  "(B5) Definition of basic complexity classes and proof of space-time relationship",
)[Prove the relationship between space and time: $#smallcaps("NSPACE") (f(n)) subset.eq union.big_(c in bb(N)) #smallcaps("TIME") 2^(c f(n))$.
]

#theorem("Nondeterministic Space vs. Time")[
  For any function $f(n) >= log n$,
  $
    #smallcaps("NSPACE") (f(n)) subset.eq union.big_(c in bb(N)) #smallcaps("TIME") 2^(c f(n))
  $
]

#proof[
  Let $M = (Q, Sigma, delta, q_0, F)$ be a nondeterministic Turing machine that decides a language $L$ in space $f(n)$, with $f(n) >= log n$. We assume $M$ has one read-only input tape and one work tape.

  A configuration of $M$ on input $x$ of length $n$ is uniquely determined by:
  - The current state $q in Q$ (size $|Q|$).
  - The head position on the input tape (at most $n$ positions).
  - The head position on the work tape (at most $f(n)$ positions).
  - The content of the work tape (a string $w in Sigma^*$ with $|w| <= f(n)$).

  The total number of distinct configurations, denoted by $|V|$, is bounded by the product of these possibilities:
  $ |V| <= |Q| dot n dot f(n) dot |Sigma|^(f(n)) $

  We can express this bound as a power of 2. Since $f(n) >= log n$, we have $log n <= f(n)$ (and thus $n <= 2^(f(n))$). We can bound each term:
  $
    |V| & <= 2^(log |Q|) dot 2^(log(n)) dot 2^(log f(n)) dot 2^(f(n) log |Sigma|) \
        & <= 2^(c_M f(n))
  $
  for some constant $c_M$ that depends on the machine $M$ but not on $n$.

  We can model the computation of $M$ as a directed graph $G_M = (V, E)$, where vertices are configurations and edges represent valid transitions according to $delta$. $M$ accepts $x$ if and only if there is a path from the start configuration to an accepting configuration in $G_M$.

  This reachability problem can be solved by a deterministic search algorithm (e.g., BFS or DFS). The time complexity is proportional to the size of the graph, i.e., cal(O)(|V| + |E|). Since the number of possible next moves from any configuration is bounded by a constant (the degree of nondeterminism), we have $|E| = cal(O)(|V|)$.

  Therefore, the deterministic time required is cal(O)(|V|) = cal(O)(2^(c_M f(n))). This shows that $L in #smallcaps("TIME") (2^(c f(n)))$ for some constant $c$.

]


#corollary("Hierarchy of Complexity Classes")[

  The relationships between time and space complexity imply the following chain of inclusions:

  $
    #smallcaps("L") subset.eq #smallcaps("NL") subset.eq #smallcaps("P") subset.eq #smallcaps("NP") subset.eq #smallcaps("PSPACE") subset.eq #smallcaps("NPSPACE") subset.eq #smallcaps("EXPTIME")
  $

  Justification:

  - $#smallcaps("L") subset.eq #smallcaps("NL")$ and $#smallcaps("P") subset.eq #smallcaps("NP")$ and $#smallcaps("PSPACE") subset.eq #smallcaps("NPSPACE")$: Trivial inclusions
  - $#smallcaps("NL") subset.eq #smallcaps("P")$: Since $#smallcaps("NSPACE") (log n) subset.eq #smallcaps("TIME") (2^(cal(O)(log n))) = #smallcaps("TIME") cal(O)(n^(cal(O)(1))) = #smallcaps("P")$.
  - $#smallcaps("NP") subset.eq #smallcaps("PSPACE")$: Since $#smallcaps("NTIME") (n^k) subset.eq #smallcaps("SPACE") (n^k)$.
  - $#smallcaps("NPSPACE") subset.eq #smallcaps("EXPTIME")$: Since $#smallcaps("NSPACE") (n^k) subset.eq #smallcaps("TIME") (2^(cal(O)(n^k)))$.

]


#question_A("(A2) Savitch's Theorem")[
  State and prove Savitch's Theorem.
]

== Savitch's Theorem

Savitch's Theorem shows that nondeterminism does not provide an exponential advantage in terms of space.

#theorem("Savitch's Theorem")[
  For any space-constructible function $f(n) >= log n$,
  $ #smallcaps("NSPACE") (f(n)) subset.eq #smallcaps("SPACE") (f^2(n)) $
]

#proof[
  We want to check if an accepting configuration $C_{"acc"}$ is reachable from the start configuration $C_{"start"}$ in at most $2^(cal(O)(f(n)))$ steps.
  Let $"REACH"(C_1, C_2, k)$ be a predicate that is true if $C_2$ is reachable from $C_1$ in at most $2^k$ steps.

  We can compute $"REACH"(C_1, C_2, k)$ recursively:
  - Base case ($k=0$): Check if $C_1 = C_2$ or $C_1 -> C_2$ in one step.
  - Recursive step: $C_2$ is reachable from $C_1$ in $2^k$ steps iff there exists an intermediate configuration $C_{mid}$ such that $C_{mid}$ is reachable from $C_1$ in $2^(k-1)$ steps AND $C_2$ is reachable from $C_{mid}$ in $2^(k-1)$ steps.

  Algorithm:
  ```
  function Reach(C1, C2, k):
    if k == 0: return (C1 == C2 or C1 -> C2)
    for each possible configuration C_mid using space f(n):
      if Reach(C1, C_mid, k-1) and Reach(C_mid, C2, k-1):
        return true
    return false
  ```

  The recursion depth is $k = cal(O)(f(n))$ (since time is $2^(cal(O)(f(n))))$.
  At each level, we need to store the current configuration $C_{mid}$, which takes cal(O)(f(n)) space.
  Total space = depth times space per level = cal(O)(f(n)) times cal(O)(f(n)) = cal(O)(f^2(n)).
]


#question_A("(A3) Deterministic Space Hierarchy")[
  State and prove the Deterministic Space Hierarchy Theorem.
]

== Deterministic Space Hierarchy

The Space Hierarchy Theorem states that giving a machine more space allows it to solve strictly more problems.

#theorem("Space Hierarchy Theorem")[
  For any space-constructible function $f: bb(N) -> bb(N)$, there exists a language $L$ such that $L$ is decidable in space cal(O)(f(n)) but not in space $o(f(n))$.
]

#proof[
  The proof uses diagonalization. We construct a machine $D$ that decides $L$ in space cal(O)(f(n)).
  On input $w$, $D$ interprets $w$ as a description of a Turing machine $M$.
  $D$ runs $M$ on input $w$ within space limit $f(|w|)$.
  - If $M$ exceeds space $f(|w|)$, $D$ rejects (or accepts, just needs to halt).
  - If $M$ halts and accepts within the space limit, $D$ rejects.
  - If $M$ halts and rejects within the space limit, $D$ accepts.
  - To handle potential infinite loops of $M$ within the space bound, $D$ maintains a counter of steps and halts if a limit ($2^(cal(O)(f(n)))$) is exceeded.

  Thus, for any machine $M$ operating in $o(f(n))$ space, $D$ behaves differently from $M$ on the input $chevron.l M chevron.r$. Therefore, $L(D)$ cannot be decided by any machine using $o(f(n))$ space.
]
