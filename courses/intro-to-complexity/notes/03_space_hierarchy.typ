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
  - #smallcaps[SPACE] ($f(n)$) is the class of languages decided by a deterministic Turing machine that uses $cal(O)(f(n))$ space.
  - #smallcaps[NSPACE] ($f(n)$) is the class of languages decided by a nondeterministic Turing machine that uses $cal(O)(f(n))$ space.
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
  We need to show that if a language $L$ is decided by a nondeterministic Turing machine $N$ in time $cal(O)(f(n))$, then it can be decided by a deterministic Turing machine $D$ in space $cal(O)(f(n))$.

  *1. Space usage of $N$ on a single path*
  Consider any single computation path of $N$ on input $x$ of length $n$. $N$ runs for at most $T = c dot f(n)$ steps for some constant $c$.
  In one computational step, the tape head of a Turing machine can move at most one cell distance from its current position. Starting from the initial position, after $T$ steps, the head can reach at most the cells in the range [-T, T] relative to the start. Thus, the machine can visit (read or write) at most $T + 1$ distinct tape cells.
  Consequently, on any single execution branch, $N$ uses space bounded by $cal(O)(f(n))$.

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
  - *Keeping track of the current path:* $D$ stores the sequence $y$, which has length proportional to the time bound of $N$, i.e., $cal(O)(f(n))$.
  - *Simulation:* $D$ needs to store the tape contents of $N$ for the current simulation. As established in step 1, this requires at most $cal(O)(f(n))$ space. $D$ can reuse this space for each path.

  The total space required by $D$ is sum of these, which remains $cal(O)(f(n))$. Thus, $L in #smallcaps("SPACE") (f(n))$.
]


#question_B(
  "(B5) Definition of basic complexity classes and proof of space-time relationship",
)[Prove the relationship between space and time: $#smallcaps("NSPACE") (f(n)) subset.eq union.big_(c in bb(N)) #smallcaps("TIME") 2^(c f(n))$.
]

#theorem("Nondeterministic Space vs. Time")[
  For any function $f(n) >= log n$,
  $
    L in #smallcaps[NSPACE] (f(n)) ==> exists c_L in NN: L in #smallcaps[TIME] (2^(c_L f(n))) 
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

  This reachability problem can be solved by DFS. The time complexity is proportional to the size of the graph, i.e., $cal(O)(|V| + |E|)$. Since the number of possible next moves from any configuration is bounded by a constant (the degree of nondeterminism), we have $|E| = cal(O)(|V|)$.

  Therefore, the deterministic time required is $cal(O)(|V|) = cal(O)(2^(c_M f(n)))$. This shows that $L in #smallcaps("TIME") (2^(c f(n)))$ for some constant $c$.

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
  For any function $f(n) >= log n$,
  $ #smallcaps("NSPACE") (f(n)) subset.eq #smallcaps("SPACE") (f^2(n)) $
]

#proof[
  Let $M$ be a non-deterministic Turing machine that accepts a language $L$ in space $f(n)$.
  We can assume without loss of generality that $M$ has a single accepting state and that when $M$ accepts, it clears its work tape and moves its head to a standard position. These are standard normalizations for Turing machines and do not affect the space complexity.

  The maximum number of configurations of a Turing machine using $f(n)$ space is $2^(cal(O)(f(n)))$.
  A configuration is defined by:
  - The state of the finite control.
  - The head position on the input tape (if applicable, or simply the current position).
  - The contents of the work tape(s).
  - The head position(s) on the work tape(s).

  Since $M$ is an $f(n)$-space bounded machine, the number of distinct configurations is bounded by $2^(c f(n))$ for some constant $c$. Let $N = 2^(c f(n))$ be the maximum number of reachable configurations. If $M$ accepts an input $x$, it must do so within $N$ steps, otherwise it would loop or repeat a configuration. Thus, if a configuration $C_2$ is reachable from $C_1$, it must be reachable in at most $N$ steps.

  The core idea of Savitch's Theorem is to solve the configuration reachability problem using a divide-and-conquer approach. We want to check if the accepting configuration $C_{"acc"}$ is reachable from the initial configuration $C_{"start"}$ in at most $T$ steps, where $T$ is bounded by the total number of possible configurations $2^(cal(O)(f(n)))$.

  Let's define a recursive predicate $"REACH"(C_1, C_2, t)$ which returns true if configuration $C_2$ is reachable from $C_1$ in at most $t$ steps, and false otherwise.

  The $"REACH"$ procedure is implemented by a deterministic Turing machine $D$ as follows:

  ```
  function REACH(C_start, C_end, t):
    if t == 1:
      return C_start == C_end

    // Divide the problem in half and check if there is an 
    // satisfying intermediate configuration C_mid
    for each possible configuration C_mid using at most f(n) space:
      if REACH(C_start, C_mid, t/2) and REACH(C_mid, C_end, t/2):
        return true
    return false
  ]
  ```
  #fig("savitch.png")

  The deterministic Turing machine $D$ starts by calling $"REACH" (C_{"start"}, C_{"acc"}, N)$, where $N = 2^(c f(n))$ is an upper bound on the number of steps.

  Now, let's analyze the space complexity of this simulation:

  *1. Depth of Recursion:*
  The value $t$ is halved in each recursive call until it reaches 1.
  The initial value of $t$ is $N = 2^(c f(n))$.
  The recursion depth is $log_2 N = log_2 (2^(c f(n))) = c f(n) = cal(O)(f(n))$.

  *2. Space per Recursive Call:*
  At each level of recursion, the machine $D$ needs to store:
    - The current input parameters to $"REACH"$ ($C_{"start"}, C_{"end"}, t$).
    - The intermediate configuration $C_{"mid"}$.
  Each configuration $(C)$ requires $cal(O)(f(n))$ space to store (state, tape contents, head positions).
  So, storing the parameters for one call frame requires $cal(O)(f(n))$ space.

  *3. Total Space:*
  Since the recursion depth is $cal(O)(f(n))$ and each recursive call stores $cal(O)(f(n))$ information on the stack (which is a part of $D$'s work tape), the total space required by $D$ is the product of the depth and the space per level:
  Total Space is depth of recursion times space per call frame $ =cal(O)(f(n)) times cal(O)(f(n)) =cal(O)(f^2(n)) $

  Therefore, any language in $#smallcaps("NSPACE") (f(n))$ can be decided by a deterministic Turing machine in $#smallcaps("SPACE") (f^2(n))$.

  *Handling unknown $f(n)$:*
  If the function $f(n)$ is not space-constructible or is unknown, the machine $D$ cannot pre-calculate the recursion depth. In this case, $D$ can proceed by iterating through space bounds $i = 1, 2, dots$:
  1. Try to find the accepting configuration using space parameter $i$. If found, accept.
  2. If not found, check if there exists _any_ configuration using space $i+1$ that is reachable from the start configuration (using the reachability test with parameter $i$).
  3. If such a configuration exists, it implies the computation might use more space, so increment $i$ to $i+1$ and repeat.
  4. If no configuration using space $i+1$ is reachable, and the accepting configuration was not found, then the machine halts and rejects.
  This adaptive approach ensures $D$ still operates within $cal(O)(f^2(n))$ space.
]

#corollary("Non-determinism does not help in space hierarchy")[
  $ #smallcaps[PSPACE] = #smallcaps[NPSPACE] $
]

== Space Constructibility

Before stating the Space Hierarchy Theorem, we need to define the concept of space-constructible functions.

#definition("Space Constructibility")[
  A function $f: bb(N) -> bb(N)$, where $f(n) >= log n$, is called *space-constructible* if the function that maps $1^n$ to the binary representation of $f(n)$ is computable in space $cal(O) (f(n))$.
]

Commonly used functions for measuring space complexity are space-constructible, for example: $log n$, $n$, $n^k$ (polynomials), $2^n$ (esponentials).

#question_A("(A3) Deterministic Space Hierarchy")[
  State and prove the Deterministic Space Hierarchy Theorem.
]

== Deterministic Space Hierarchy

The Space Hierarchy Theorem states that giving a machine more space allows it to solve strictly more problems.

#theorem("Space Hierarchy Theorem")[
  For any space-constructible function $f: bb(N) -> bb(N)$, there exists a language $L$ such that $L$ is decidable in space $cal(O)(f(n))$ but not in space $o(f(n))$.
]

#proof[
  The proof uses diagonalization. We explicitly construct a deterministic Turing machine $D$ that decides a language $A$ in space $cal(O)(f(n))$, such that $A$ cannot be decided by any machine operating in space $g(n) in o(f(n))$.

  *1. Construction of Machine $D$*
  Machine $D$ operates on an input $x$ as follows:
  1. Let $n = |x|$. Since $f$ is space-constructible, $D$ computes $f(n)$ and marks off $f(n)$ cells on its work tape. If the head moves outside this marked region during subsequent steps, $D$ immediately rejects.
  2. $D$ checks if the input $x$ is of the form $chevron.l M chevron.r 10^*$, where $chevron.l M chevron.r$ is the encoding of some Turing machine $M$ and $10^*$ is a padding string. If $x$ is not in this format, $D$ rejects.
  3. $D$ simulates $M$ on input $x$ within the marked space $f(n)$.
  4. To prevent infinite loops (since $M$ might loop within the space bound), $D$ maintains a step counter. The maximum number of configurations for $M$ within space $f(n)$ is bounded by $2^(c f(n))$ for some constant $c$. $D$ runs the simulation for at most $2^(f(n))$ steps.
  5. *Diagonalization:*
     - If $M$ accepts $x$ within the space and time limits, $D$ *rejects*.
     - If $M$ rejects $x$ within the limits, $D$ *accepts*.
     - If the simulation exceeds the space bound $f(n)$ or the time limit $2^(f(n))$, $D$ *rejects* (arbitrarily, to ensure $D$ always halts).

  *2. Space Complexity of $D$:*
  $D$ uses $f(n)$ space for the simulation. The step counter requires counting up to $2^(f(n))$, which takes $log(2^(f(n))) = f(n)$ bits. Thus, $D$ runs in space $cal(O)(f(n))$, so $L(D) in #smallcaps("SPACE") (f(n))$.

  *3. Correctness:*
  Let $M$ be any Turing machine that decides a language in space $g(n) in o(f(n))$. We show that $L(M) != L(D)$.

  Since $M$ works in space $g(n)$, simulating $M$ on an input of length $n$ requires space at most $c_M dot g(n)$ for some constant $c_M$ (dependent on $M$'s alphabet size and number of states). Furthermore, since $M$ always halts, it must finish within $2^{c_M dot g(n)}$ steps.

  Because $g(n) in o(f(n))$, we have $lim_(n -> infinity) (g(n)) / f(n) = 0$. This implies that for the constant $c_M$, there exists an integer $n_0$ such that for all $n >= n_0$:
  $ c_M dot g(n) lt.eq f(n) $
  and consequently for the time complexity:
  $ 2^(c_M dot g(n)) lt.eq 2^(f(n)) $

  Now consider the input $x = chevron.l M chevron.r 10^k$ padded with enough zeros such that $|x| = n >= n_0$.
  When $D$ is run on input $x$:
  1. The space bound $f(n)$ is sufficient to simulate $M(x)$ because $c_M dot g(n) lt.eq f(n)$.
  2. The time limit $2^{f(n)}$ is sufficient because $M(x)$ halts in $2^{c_M dot g(n)} lt.eq 2^{f(n)}$ steps.
  3. Therefore, $D$ completes the simulation and outputs the opposite of $M(x)$.

  Thus, $D(x) != M(x)$, which means $L(D) != L(M)$. Since this holds for any machine $M$ operating in $o(f(n))$ space, the language $L(D)$ cannot be decided in space $o(f(n))$.
]

#corollary("Deterministic space hierarchy")[
  If for functions $f_1, f_2: NN -> NN$ holds that $f_1(n) in o(f_2(n))$ and $f_2$ is space constructible then $ #smallcaps[SPACE] (f_1(n)) subset.neq #smallcaps[SPACE] (f_2(n)) $

  Combining this which the Savitch theorem we get: $ #smallcaps[NL] = #smallcaps[NSPACE] (log n) subset.eq #smallcaps[SPACE] (log^2(n)) subset.neq #smallcaps[PSPACE] subset.neq #smallcaps[EXPSPACE] $
]