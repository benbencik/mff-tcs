#import "../../../shared/lib.typ": *

= NP and NP-Completeness

#exam_question("(B6) Two definitions of NP class and their equivalence")[
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

#definition("NP-Completeness")[
  A language $L$ is #smallcaps[NP]-complete if:
  1. $L in #smallcaps[NP]$.
  2. $L$ is #smallcaps[NP]-hard, i.e., for every $A in #smallcaps[NP]$, $A scripts(<=)_m^p L$ (every problem in #smallcaps[NP] is polynomial-time reducible to $L$).
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

== The Cook-Levin Theorem

#exam_question("(A5) Cook-Levin Theorem (NP-completeness of SAT)")[
  State and prove the Cook-Levin Theorem.
]

The Cook-Levin Theorem provides the first #smallcaps[NP]-complete problem: SAT (Boolean Satisfiability). In the lecture slides, the Cook-Levin Theorem specifically refers to the consequence regarding P vs NP.

#theorem("SAT is NP-complete")[
  SAT is #smallcaps[NP]-complete.
]

#proof[
  *1. SAT is in #smallcaps[NP]:* Given a boolean formula $phi$ and an assignment of truth values to variables (certificate), we can evaluate the formula in polynomial time to check if it evaluates to TRUE.

  *2. SAT is #smallcaps[NP]-hard:* Let $L$ be any language in #smallcaps[NP]. Then there exists a polynomial-time nondeterministic Turing machine $M = (Q, Sigma, delta, q_0, F)$ that decides $L$ in time $n^k$. We need to show that for any input $w$, we can construct a boolean formula $phi$ in polynomial time such that $M$ accepts $w$ if and only if $phi$ is satisfiable.

  *Construction of $phi$:*
  We construct a "tableau" $T$ of dimensions $n^k times n^k$ representing the computation history of $M$ on $w$. The rows of the tableau correspond to the configurations of $M$ at each step of the computation.
  - The first row represents the initial configuration.
  - Each subsequent row represents the configuration after one step of computation.
  - We assume without loss of generality that if $M$ accepts, it does so in a configuration where the state is $q_{"accept"}$ (and we can pad the computation with trivial transitions to fill the tableau).

  #fig("../courses/intro-to-complexity/figs/tablo.png")

  *Variables:*
  We define variables $x_{i,j,s}$ for $1 lt.eq i, j lt.eq n^k$ and $s in S = Q union Sigma union {#sym.hash}$.
  The variable $x_{i,j,s}$ is TRUE if and only if the cell $T[i, j]$ contains the symbol $s$.

  The formula $phi$ is the conjunction of four parts:
  $ phi = phi_("cell") and phi_("start") and phi_("move") and phi_("accept") $

  *1. Cell Consistency ($phi_("cell")$):*
  Ensures that each cell in the tableau contains exactly one symbol from $S$.
  $ phi_("cell") = and.big_(1 lt.eq i, j lt.eq n^k) [ (or.big_(s in S) x_{i,j,s}) and (and.big_(s, t in S, s != t) (not x_{i,j,s} or not x_{i,j,t})) ] $

  *2. Start Configuration ($phi_("start")$):*
  Ensures the first row corresponds to the initial configuration of $M$ on input $w = w_1 w_2 ... w_n$.
  The configuration is: `#` $q_0$ $w_1$ ... $w_n$ $lambda$ ... $lambda$ `#`.
  $ phi_("start") = x_{1,1,#sym.hash} and x_{1,2,q_0} and (and_(l=1)^n x_{1, 2+l, w_l}) and (and_(l=n+3)^(n^k-1) x_{1, l, lambda}) and x_{1, n^k, #sym.hash} $

  *3. Transition Consistency ($phi_("move")$):*
  Ensures that each row follows from the previous row according to the transition function $delta$ of $M$.
  This condition can be checked locally. The content of a cell $T[i, j]$ is determined by the contents of the cells $T[i-1, j-1]$, $T[i-1, j]$, and $T[i-1, j+1]$.
  We define a $2 times 3$ window as "legal" if the transition from the top row (3 cells) to the bottom row (middle cell) is valid according to $delta$ (or if the head is not present, the symbol remains unchanged).
  Let $"legal"(c_1, c_2, c_3, c_4, c_5, c_6)$ be true if the $2 times 3$ window formed by these symbols is valid. This can be expressed as a fixed-size boolean formula $"legal"_{i,j}$.
  $ phi_("move") = and_(1 lt.eq i < n^k, 1 < j < n^k) "legal"_{i,j} $
  Note: The boundary cells (column 1 and $n^k$) contain `#` and do not change.

  *4. Acceptance ($phi_("accept")$):*
  Ensures that the computation enters an accepting state. Since we can assume the machine cleans up or loops in an accepting state, it suffices to say that some cell contains an accepting state $q_{"acc"} in F$.
  $ phi_("accept") = or_(1 lt.eq i, j lt.eq n^k) x_{i,j,q_{"acc"}} $

  *Correctness and Complexity:*
  - If $M$ accepts $w$, there exists a valid tableau representing the accepting path. Setting the variables $x_{i,j,s}$ according to this tableau satisfies $phi$.
  - If $phi$ is satisfiable, the satisfying assignment reconstructs a valid accepting computation path for $M$ on $w$.
  - The size of the tableau is $N times N$ where $N = n^k$. The number of variables is $|S| dot N^2$. The size of $phi$ is polynomial in $n$ (specifically $cal(O)(n^(2k))$).
  - The construction can be performed in polynomial time.

  Therefore, $L scripts(<=)_m^p #smallcaps[SAT]$. Since $L$ was an arbitrary language in #smallcaps[NP], SAT is #smallcaps[NP]-complete.
]

#theorem("Cook-Levin Theorem")[
  SAT $in$ #smallcaps[P] $<=>$ #smallcaps[P] $=$ #smallcaps[NP]
]

#proof[
  *1. If #smallcaps[P] = #smallcaps[NP]:*
  Since SAT $in$ #smallcaps[NP], and #smallcaps[NP] = #smallcaps[P], then SAT $in$ #smallcaps[P].

  *2. If SAT $in$ #smallcaps[P]:*
  We know that SAT is #smallcaps[NP]-complete. This means that for every $L in #smallcaps[NP]$, there exists a polynomial-time reduction $L scripts(<=)_m^p$ SAT.
  If SAT $in$ #smallcaps[P], then there exists a deterministic polynomial-time algorithm $A$ for SAT.
  To decide $L$, we can transform any instance $x$ of $L$ into an instance $phi$ of SAT in polynomial time, and then run $A$ on $phi$.
  Since both the reduction and $A$ run in polynomial time, $L$ is decidable in polynomial time.
  Thus, $#smallcaps[NP] subset.eq #smallcaps[P]$. Since $#smallcaps[P] subset.eq #smallcaps[NP]$ is always true, we have $#smallcaps[P] = #smallcaps[NP]$.
]
