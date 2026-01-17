#import "../lib.typ": *

= Time Complexity

#question_A("(A4) Deterministic Time Hierarchy")[
  State and prove the Deterministic Time Hierarchy Theorem.
]

== Deterministic Time Hierarchy

Similar to space, giving a machine more time allows it to solve strictly more problems. However, the gap required is slightly larger due to simulation overhead.

#theorem("Time Hierarchy Theorem")[
  For any time-constructible function $f: bb(N) -> bb(N)$, there exists a language $L$ such that $L$ is decidable in time cal(O)(f(n)) but not in time $o(f(n) / log f(n))$.
]

#proof[
  The proof uses diagonalization. We construct a machine $D$ that runs in time cal(O)(f(n)).
  On input $w = chevron.l M chevron.r$:
  1. $D$ simulates $M$ on input $w$.
  2. $D$ keeps track of the number of steps used by $M$.
  3. If $M$ halts within the time limit (roughly $f(n)$) and accepts, $D$ rejects.
  4. If $M$ halts within the time limit and rejects, $D$ accepts.
  5. If $M$ runs out of time, $D$ rejects (arbitrarily).

  The simulation of a machine $M$ with $t$ steps can be done by a universal Turing machine in cal(O)(t log t) time (for multi-tape to 2-tape simulation). This overhead is why the hierarchy theorem has the $log f(n)$ factor.

  Thus, $L(D)$ differs from any language decidable in time $o(f(n) / log f(n))$.
]

== Time Complexity Classes

Time complexity measures the number of steps a Turing machine takes to solve a problem.

#definition("Time Complexity Classes")[
  Let $f: bb(N) -> bb(N)$ be a function.
  - #smallcaps[TIME] ($f(n)$) is the class of languages decided by a deterministic Turing machine that runs in time cal(O)(f(n)).
  - #smallcaps[NTIME] ($f(n)$) is the class of languages decided by a nondeterministic Turing machine that runs in time cal(O)(f(n)).
]

Common time complexity classes:
- #smallcaps[P] = $union.big_(k in bb(N)) #smallcaps("TIME") n^k$
- #smallcaps[NP] = $union.big_(k in bb(N)) #smallcaps("NTIME") n^k$
- #smallcaps[EXP] = $union.big_(k in bb(N)) #smallcaps("TIME") 2^(n^k)$
