#import "../lib.typ": *

= NP and NP-Completeness

#question_B("(B6) Two definitions of NP class and their equivalence")[
  Provide two definitions of the class #smallcaps("NP") and prove their equivalence.
]

== The Class #smallcaps[NP]

The complexity class #smallcaps[NP] (Nondeterministic Polynomial time) contains problems that are "hard to solve, but easy to verify". There are two equivalent definitions for #smallcaps[NP].

#definition("NP (Verifier Definition)")[
  A language $L$ is in #smallcaps[NP] if there exists a polynomial-time deterministic Turing machine $V$ (verifier) and a polynomial $p(n)$ such that for every string $x in Sigma^*$:
  $
    x in L <=> exists c in Sigma^*, |c| lt.eq p(|x|) : V(x, c) text(" accepts")
  $
  The string $c$ is called a *certificate* or *witness* for $x$.
]

#definition("NP (Nondeterministic Definition)")[
  A language $L$ is in #smallcaps[NP] if there exists a nondeterministic Turing machine $M$ that decides $L$ in polynomial time.
  That is, for any $x in L$, there exists at least one accepting computation path of length $cal(O) (n^k)$, and for any $x in.not L$, all computation paths reject.
]

#theorem("Alternative Definition of NP")[
  $ #smallcaps("NP") = union.big_(k in NN) #smallcaps("NTIME") (n^k) $
]

#proof[
  The proof shows inclusion in both directions.

  *1. $#smallcaps("NP") subset.eq union_(k in NN) #smallcaps("NTIME") (n^k)$*

  Let $L in #smallcaps("NP")$. Then there exists a polynomial-time verifier $V(x, y)$ and a polynomial $p(n)$ such that:
  $ x in L <=> exists y, |y| lt.eq p(|x|) : V(x, y) text(" accepts") $

  We construct an NTM $M$ that accepts $L$ in polynomial time.
  *Computation of $M$ on input $x$:*
  1. Simulate the verifier $V$.
  2. Whenever $V$ needs to read a character of the certificate $y$, nondeterministically guess it.
  3. If $V$ accepts, accept; otherwise, reject.

  *Correctness:*
  $
    x in L & <=> exists y: V(x, y) text(" accepts") \
           & <=> text("some computation branch of ") M(x) text(" accepts") \
           & <=> x in L(M)
  $
  Since $V$ runs in polynomial time, $M$ also accepts $L$ in polynomial time.

  *2. $union_(k in NN) #smallcaps("NTIME") (n^k) subset.eq #smallcaps("NP")$*

  Let $L$ be accepted by some NTM $M = (Q, Sigma, delta, q_0, F)$ in polynomial time $p(n)$.
  Let $r = max_(q, a) |delta(q, a)|$ be the maximum number of nondeterministic choices at any step (branching factor). Note that $r$ is a constant depending only on $M$.

  Any computation of $M$ on input $x$ can be described by a sequence of choices $y in {1, ..., r}^(p(|x|))$, where $y_i$ represents the branch chosen at step $i$. This string $y$ serves as the certificate.

  We construct a deterministic verifier $V(x, y)$:
  1. Simulate $M$ on input $x$, resolving nondeterminism according to the sequence $y$.
  2. If the simulation ends in an accepting state, accept; otherwise, reject.

  *Correctness:*
  $
    x in L &<=> text("some computation of ") M(x) text(" accepts") \
    &<=> exists y, |y| lt.eq p(|x|) : text("simulation of ") M(x) text(" with choices ") y text(" accepts") \
    &<=> exists y, |y| lt.eq p(|x|) : V(x, y) text(" accepts")
  $

  The verifier $V$ runs in polynomial time because simulating $M$ takes time proportional to $p(|x|)$. Thus $L in #smallcaps("NP")$.
]


#question_A("(A5) Cook-Levin Theorem (NP-completeness of SAT)")[
  State and prove the Cook-Levin Theorem.
]

== NP-Completeness

#definition("NP-Completeness")[
  A language $L$ is #smallcaps[NP]-complete if:
  1. $L in #smallcaps[NP]$.
  2. $L$ is #smallcaps[NP]-hard, i.e., for every $A in #smallcaps[NP]$, $A lt.eq_p L$ (every problem in #smallcaps[NP] is polynomial-time reducible to $L$).
]

== The Cook-Levin Theorem

The Cook-Levin Theorem provides the first #smallcaps[NP]-complete problem: SAT (Boolean Satisfiability).

#theorem("Cook-Levin Theorem")[
  SAT is #smallcaps[NP]-complete.
]

#proof[
  *1. SAT is in #smallcaps[NP]:* Given a boolean formula $phi$ and an assignment of truth values to variables (certificate), we can evaluate the formula in polynomial time to check if it evaluates to TRUE.

  *2. SAT is #smallcaps[NP]-hard:* Let $L$ be any language in #smallcaps[NP]. Then there exists a polynomial-time NTM $M$ that decides $L$ in time $cal(O) (n^k)$. We need to show that for any input $w$, we can construct a formula $phi$ such that $M$ accepts $w$ iff $phi$ is satisfiable.

  *Construction of $phi$:*
  We construct a "tableau" of dimensions $n^k times n^k$ representing the computation history of $M$ on $w$.
  We define variables $x_{i,j,s}$ which are true iff cell $(i, j)$ contains symbol $s$ at step $i$.

  The formula $phi$ is the conjunction of several conditions:
  - *Cell constraints:* Each cell contains exactly one symbol.
  - *Start configuration:* The first row corresponds to the initial configuration (input $w$, state $q_0$).
  - *Transition consistency:* Each row follows from the previous row according to the transition function $delta$ of $M$. This can be checked locally by looking at $2 times 3$ windows of cells.
  - *Acceptance:* The last row contains an accepting state.

  If $M$ accepts $w$, there is a valid computation history, so the variables can be set to satisfy all conditions, making $phi$ satisfiable.
  If $M$ rejects $w$, no valid history exists, so $phi$ is unsatisfiable.

  The construction of $phi$ takes polynomial time. Thus, $L lt.eq_p #smallcaps[SAT]$.
]
