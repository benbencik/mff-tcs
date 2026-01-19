#import "../lib.typ": *

= Time Complexity

== Time Complexity Classes

Time complexity measures the number of steps a Turing machine takes to solve a problem.

#definition("Time Complexity Classes")[
  Let $f: bb(N) -> bb(N)$ be a function.
  #smallcaps[TIME] $(f(n))$ is the class of languages decided by a deterministic Turing machine that runs in time $cal(O)(f(n))$.
  #smallcaps[NTIME] $(f(n))$ is the class of languages decided by a nondeterministic Turing machine that runs in time $cal(O)(f(n))$.
]

Common time complexity classes:
- #smallcaps[P] = $union.big_(k in bb(N)) #smallcaps("TIME") n^k$
- #smallcaps[NP] = $union.big_(k in bb(N)) #smallcaps("NTIME") n^k$
- #smallcaps[EXP] = $union.big_(k in bb(N)) #smallcaps("TIME") 2^(n^k)$
#question_A("(A4) Deterministic Time Hierarchy")[
  State and prove the Deterministic Time Hierarchy Theorem.
]

== Time Constructibility

#definition("Time Constructibility")[
  A function $f: bb(N) -> bb(N)$, where $f(n) in Omega(n log n)$, is called *time-constructible* if the function that maps $1^n$ to the binary representation of $f(n)$ is computable in time $cal(O)(f(n))$.
]

Common time-constructible functions include $n log n$, $n sqrt(n)$, polynomials $n^k$, and exponentials $2^n$.

== Deterministic Time Hierarchy

Similar to space, giving a machine more time allows it to solve strictly more problems. However, the gap required is slightly larger due to simulation overhead.

#theorem("Time Hierarchy Theorem")[
  For any time-constructible function $f: bb(N) -> bb(N)$, there exists a language $L$ such that $L$ is decidable in time cal(O)(f(n)) but not in time $o(f(n) / log(f(n)))$.
]

#proof[
  The proof uses diagonalization. We explicitly construct a deterministic Turing machine $D$ that decides a language $L$ in time $cal(O)(f(n))$, such that $L$ cannot be decided by any machine operating in time $g(n) in o(f(n) / log(f(n)))$.

  *Construction of Machine $D$:*
  Machine $D$ operates on an input $x$ of length $n$. $D$ uses a multi-track tape (specifically 3 tracks) to perform efficient simulation:
  - *Track 1 (Simulation):* Stores the content of $M$'s tape.
  - *Track 2 (State & Description):* Stores the description of $M$ and its current state $q$. 
  - *Track 3 (Timer):* Stores a binary counter initialized to $T = ceil(f(n) / log(f(n)))$.

  #fig("time-hierarchy.png")

  *Algorithm:*
  1. *Input Check:* $D$ checks if $x$ is of the form $chevron.l M chevron.r 10^*$. If not, $D$ *rejects*.
  2. *Initialization:* of the tapes
    - $D$ computes $f(n)$ (possible in $cal(O)(f(n))$)
    - $D$ copies $M$'s description to Track 2 and the input to Track 1
    - $D$ initializes the counter on Track 3 to $T$
  3. *Simulation Loop:* $D$ simulates $M$ step-by-step:
     - Read the symbol on Track 1 and the state on Track 2.
     - Look up the transition in $M$'s description (on Track 2).
     - Update Track 1 (write symbol, move head) and Track 2 (update state).
     - *Counter Update:* Decrement the counter on Track 3. Move the counter bits to align with the active head position to ensure access in the next step.
  4. *Termination:*
     - If the counter reaches 0, $D$ stops and *rejects*.
     - If $M$ halts before the counter expires(diagonalization):
       - If $M$ accepts, $D$ *rejects*
       - If $M$ rejects, $D$ *accepts*

  *Analysis:*
  We analyze the running time of $D$:
  - *Simulation Step Cost:* Finding the transition and updating the tape/state takes constant time $c_M$ (dependent on $M$ but not $n$) because the description and state are moved along with the head.
  - *Counter Update Cost:* The counter has value roughly $f(n) / log(f(n))$, so it has $cal(O)(log(f(n)))$ bits. Decrementing and moving these bits takes $cal(O)(log(f(n)))$ time per step.
  - *Total Time:*
    $ "Time"(D) & approx T dot ("Simulation Cost" + "Counter Cost") \
                & approx (f(n) / log(f(n))) dot (c_M + log(f(n)) \
                & = cal(O)(f(n)) $
  Thus, $D$ runs in time $cal(O)(f(n))$.

  *Correctness (Diagonalization):*
  Assume for contradiction that there exists a machine $M$ that decides $L(D)$ in time $g(n) in o(f(n) / log f(n))$.
  Let $c_M$ be the constant simulation overhead for machine $M$ (i.e., one step of $M$ takes at most $c_M$ steps of $D$, effectively $c_M$ covers the constant factor in the $O(log f(n))$ counter update per step).

  From the definition of $o(dot)$, since $g(n) in o(f(n) / log f(n))$, it implies that for any constant $epsilon > 0$ (specifically choosing $epsilon = 1/c_M$), the function $g(n)$ is eventually bounded by $epsilon dot (f(n) / log f(n))$.
  Formally:
  $ exists n_0 in bb(N) med forall n >= n_0: c_M dot g(n) <= f(n) / log f(n) $

  Now, consider an input $x = chevron.l M chevron.r 10^k$ where $k$ is chosen such that $n = |x| >= n_0$.
  The simulation of $M(x)$ by $D$ requires at most $c_M dot g(n)$ steps. Since $n >= n_0$, we have $c_M dot g(n) <= f(n) / log f(n) approx T$. Thus, $D$ will complete the simulation of $M$ without running out of time.

  - *Case 1: $M(x)$ accepts.*
    $D$ completes the simulation, sees that $M$ accepted, and thus $D$ *rejects*.
    So $D(x) != M(x)$.

  - *Case 2: $M(x)$ rejects.*
    $D$ completes the simulation, sees that $M$ rejected, and thus $D$ *accepts*.
    So $D(x) != M(x)$.

  In both cases, $D(x) != M(x)$, which contradicts the assumption that $M$ decides $L(D)$. Therefore, no such machine $M$ exists.
]

#corollary("Consequence of time hierarchy")[
  For any two real numbers $1 <= epsilon_1 < epsilon_2$, $ #smallcaps[TIME] (n^(epsilon_1)) subset.neq #smallcaps[TIME] (n^(epsilon_2)) $
  
  Moreover for any $k in NN$ it holds that $#smallcaps[TIME] (n^k) subset #smallcaps[TIME] (2^n)$ thus $ #smallcaps[P] subset.neq #smallcaps[EXPTIME] $
]

#fig("inclusions2.png")
