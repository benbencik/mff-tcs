#import "../../../shared/lib.typ": *

= Computability and Decidability

#question(
  "(B1) Universal Turing Machine and undecidability of the universal language",
)[
  Define the Universal Turing Machine and prove the undecidability of the universal language $L_u$.
]

== Universal Turing Machine

A Universal Turing Machine (UTM), denoted $cal(U)$, is a Turing machine that can simulate any other Turing machine on any input. The UTM takes as input a description of a Turing machine $M$ and an input string $w$, typically encoded as a pair $chevron.l M, w chevron.r$.

The language of the UTM is the *Universal Language*:
$ L_u = { (M, w) | w in L(M) } $

The language $L_u$ corresponds to the problem of checking whether a given TM $M$ accepts a given input $w$.

== Undecidability of the Universal Language

#theorem("Undecidability of the Universal Language")[
  The language $L_u = { (M, x) | x in L(M) }$ is partially decidable but *not* decidable.
]

#proof[
  *1. Partial Decidability*
  The language $L_u$ is partially decidable because the Universal Turing Machine $cal(U)$ accepts it. On input $(M, x)$, $cal(U)$ simulates $M$ on $x$. If $M$ accepts, $cal(U)$ accepts. If $M$ does not accept (rejects or loops), $cal(U)$ does not accept (rejects or loops).

  *2. Undecidability (Diagonalization)*
  We prove the undecidability of $L_u$ using diagonalization.

  We can represent the universal language as an infinite matrix $A$. Rows correspond to Turing machines $M_1, M_2, dots$ (ordered by their Gödel numbers) and columns correspond to input strings $w_1, w_2, dots$ (where $w_j$ is the binary string with index $j$).

  The matrix entries are defined as:
  $
    A_(i,j) = cases(1 &text("if ") M_i text(" accepts ") w_j (i.e., w_j in L(M_i)), 0 &text("if ") M_i text(" does not accept ") w_j (i.e., w_j in.not L(M_i)))
  $

  We define the *Diagonal Language* ($text("DIAG")$) based on the complement of the diagonal of matrix $A$:
  $
    text("DIAG") = { chevron.l M chevron.r | chevron.l M chevron.r in.not L(M) }
  $
  $ text("DIAG") = { w_i | w_i in.not L(M_i) } $ (identifying $w_i$ with $chevron.l M_i chevron.r$)

  #fig("../courses/intro-to-complexity/figs/diag-lang.png")

  The proof proceeds in two steps:
  1. Show that $text("DIAG")$ is not partially decidable.
  2. Show that if $L_u$ was decidable, then $text("DIAG")$ would be decidable (contradiction).

  The language $text("DIAG") = { chevron.l M chevron.r | chevron.l M chevron.r in.not L(M) }$ is not partially decidable.
  We prove this by contradiction. Suppose there exists a Turing machine $M_D$ that accepts $text("DIAG")$ (i.e., $L(M_D) = text("DIAG")$).

  Consider the input $chevron.l M_D chevron.r$:
  $
    chevron.l M_D chevron.r in text("DIAG") &<=> chevron.l M_D chevron.r in.not L(M_D) quad &text("(definition of DIAG)") \
    chevron.l M_D chevron.r in text("DIAG") &<=> chevron.l M_D chevron.r in L(M_D) quad &text("(assumption " L(M_D) = text("DIAG") ")")
  $

  Combining these, we get:
  $
    chevron.l M_D chevron.r in L(M_D) <=> chevron.l M_D chevron.r in.not L(M_D)
  $
  This is a contradiction. Therefore, no such machine $M_D$ exists, and $text("DIAG")$ is not partially decidable.
  Now we return to the proof of the undecidability of $L_u$.
  We proceed by contradiction. Suppose $L_u$ is decidable. Then there exists a Turing machine $M_u$ that decides $L_u$. This means $M_u$ halts on every input and:
  - $M_u$ accepts $(M, x)$ if $x in L(M)$.
  - $M_u$ rejects $(M, x)$ if $x in.not L(M)$.

  We can use $M_u$ to construct a decider $D$ for $text("DIAG")$.

  *Algorithm for $D$ on input $w = chevron.l M chevron.r$:*
  1. Construct the pair $(M, w)$.
  2. Run $M_u$ on $(M, w)$.
  3. If $M_u$ accepts, reject.
  4. If $M_u$ rejects, accept.

  *Correctness:*
  $
    D text(" accepts ") chevron.l M chevron.r & <=> M_u text(" rejects ") (M, chevron.l M chevron.r) \
    & <=> chevron.l M chevron.r in.not L(M) \
    & <=> chevron.l M chevron.r in text("DIAG")
  $

  Thus, $D$ decides $text("DIAG")$. If $text("DIAG")$ is decidable, it is partially decidable. But we established in the Lemma that $text("DIAG")$ is *not* partially decidable.

  This is a contradiction. Therefore, $L_u$ is not decidable.
]

#exam_question("(B3) Properties of decidable and partially decidable languages")[
  Discuss the properties of decidable and partially decidable languages (closure properties, Post's theorem, enumerators).
]

== Decidable and Partially Decidable Languages

We classify languages based on whether a Turing machine can accept or decide them.

#definition("Partially Decidable / Recursively Enumerable")[
  A language $L$ is *partially decidable* (or Turing-recognizable, recursively enumerable) if there exists a Turing machine $M$ such that $L(M) = L$.
  - If $w in L$, $M$ halts and accepts.
  - If $w in.not L$, $M$ either halts and rejects or runs forever.
]

#definition("Decidable / Recursive")[
  A language $L$ is *decidable* (or Turing-decidable, recursive) if there exists a Turing machine $M$ such that $L(M) = L$ and $M$ halts on *all* inputs.
  - If $w in L$, $M$ halts and accepts.
  - If $w in.not L$, $M$ halts and rejects.
]

== Closure Properties

*Decidable languages* are closed under:
- Union, Intersection, Complement, Concatenation, Kleene Star (iteration)
*Partially decidable languages* are closed under:
- Union, Intersection, Concatenation, Kleene Star (iteration)
- *NOT* closed under Complement (if a language and its complement are both partially decidable, they are decidable).

== Post's Theorem

#theorem("Post's Theorem")[
  A language $L$ is decidable if and only if both $L$ and its complement $overline(L)$ are partially decidable.
]

#proof[
  ($==>$) If $L$ is decidable, then it is partially decidable. Also, decidable languages are closed under complement, so $overline(L)$ is decidable and thus partially decidable.

  ($<==$) Let $M_1$ recognize $L$ and $M_2$ recognize $overline(L)$. We can construct a decider $M$ for $L$ as follows:
  On input $w$:
  1. Run $M_1$ and $M_2$ on $w$ in parallel (e.g., alternating steps).
  2. If $M_1$ accepts, accept.
  3. If $M_2$ accepts, reject (since $w in overline(L) => w in.not L$).

  Since $w$ must be in either $L$ or $overline(L)$, one of the machines will eventually accept, so $M$ always halts, therefore the language $L$ is decidable.
]

#corollary("Post's Theorem")[
  Class of decidable languages is trivially closed under complement, however class of partially decidable languages is not.

  The language $L_u$ is partially decidable, because we can construct an Universal Turing machine. If the language $overline(L_u)$ was partially decidable, then from the Post's theorem it would follow that $L_u$ is decidable. But we have already proven that $L_u$ is not decidable. Therefore the partially decidable languages are not closed under complement.
]

== Enumerators

#definition("Enumerator")[
  An enumerator for a language $L$ is a Turing machine $E$ that:
  - Ignores its input.
  - Writes strings $w in L$ to a dedicated output tape (e.g., separated by the symbol $\#$).
  - Ensures every string $w in L$ is eventually written by $E$.
  - If $L$ is infinite, $E$ never terminates.
]

#theorem("Equivalence with Partially Decidable")[
  A language $L$ is partially decidable if and only if there exists an enumerator $E$ for $L$.
]

#proof[
  ($==>$) Let $L$ be partially decidable. Then there exists a Turing machine $M$ that accepts $L$.
  We can characterize $L$ using a decidable condition. $M$ accepts $x$ if and only if there exists a number of steps $n$ such that $M$ accepts $x$ within $n$ steps.

  We construct an enumerator $E$ for $L$ as follows:
  1. Iterate through all pairs $chevron.l x, n chevron.r$ in a systematic order (e.g., shortlex order).
  2. For each pair, simulate $M$ on input $x$ for at most $n$ steps.
  3. If $M$ accepts $x$ within $n$ steps, write $x$ to the output tape.

  This ensures that every $x in L$ is eventually printed (since an accepting computation exists), and only $x in L$ are printed. (Note: $x$ might be printed multiple times, but this can be avoided by keeping a list of printed strings).

  ($<==$) Let $E$ be an enumerator for $L$. We construct a Turing machine $M$ recognizing $L$:
  On input $x$:
  1. Run $E$ and monitor its output.
  2. If $E$ writes $x$, accept.

  - If $x in L$, $E$ eventually writes $x$, so $M$ accepts.
  - If $x in.not L$, $E$ never writes $x$, so $M$ loops forever.
  Thus $L(M) = L$.
]


#exam_question("(A1) Rice's Theorem")[
  State and prove Rice's Theorem using m-reducibility.
]

== Reducibility

#definition("m-reducibility")[
  A language $A$ is *mapping-reducible* (or $m$-reducible) to language $B$, denoted $A scripts(<=)_m B$, if there exists a total computable function $f: Sigma^* -> Sigma^*$ such that for every $x in Sigma^*$:
  $ x in A <==> f(x) in B $
]

It holds that if $A scripts(<=)_m B$ and the language $B$ is (partially decidable) then also $A$ is (partially decidable). The relation $scripts(<=)_m$ is reflexive and transitive.


== Rice's Theorem

#theorem("Rice's Theorem")[
  Let $cal(C)$ be a class of partially decidable languages and let
  $ L_cal(C) = { chevron.l M chevron.r | L(M) in cal(C) } $
  The language $L_cal(C)$ is decidable if and only if the class $cal(C)$ is *trivial*, i.e., it is either empty ($cal(C) = emptyset$) or it contains all partially decidable languages.
]

#proof[
  If $cal(C)$ is trivial, then $L_cal(C)$ is obviously decidable:
  - If $cal(C) = emptyset$, then $L_cal(C) = emptyset$, which is decidable.
  - If $cal(C)$ contains all partially decidable languages, then $L_cal(C) = Sigma^*$, which is decidable.

  Now assume that $cal(C)$ is *non-trivial*. We show that $L_cal(C)$ is undecidable.
  The proof distinguishes two cases based on whether the empty language $emptyset$ belongs to $cal(C)$.

  *Case 1: $emptyset in.not cal(C)$*

  Since $cal(C)$ is non-trivial and does not contain $emptyset$, there must be at least one language $L_1 in cal(C)$ such that $L_1 != emptyset$. Let $M_1$ be a Turing machine such that $L(M_1) = L_1$.

  We show that $L_u scripts(<=)_m L_cal(C)$. We construct a computable function $f$ that takes an input $chevron.l M, x chevron.r$ and returns $chevron.l M' chevron.r$ such that:
  $ chevron.l M, x chevron.r in L_u <==> chevron.l M' chevron.r in L_cal(C) $

  *Construction of $M'$:*
  On input $y$:
  1. Simulate $M$ on input $x$.
  2. If $M$ accepts $x$, then simulate $M_1$ on $y$.
  3. If $M_1$ accepts $y$, then accept.
  4. Otherwise, reject

  #fig("../courses/intro-to-complexity/figs/rice-theorem.png")

  *Correctness:*
  - If $M$ accepts $x$ ($x in L(M)$): The simulation proceeds to step 2, and $M'$ behaves exactly like $M_1$. Thus $L(M') = L(M_1) = L_1$. Since $L_1 in cal(C)$, we have $chevron.l M' chevron.r in L_cal(C)$.
  - If $M$ does not accept $x$ ($x in.not L(M)$): The simulation never reaches step 2 (it loops or rejects). Thus $M'$ never accepts any input, so $L(M') = emptyset$. Since $emptyset in.not cal(C)$, we have $chevron.l M' chevron.r in.not L_cal(C)$.

  This reduction shows that $L_u scripts(<=)_m L_cal(C)$. Since $L_u$ is undecidable, $L_cal(C)$ is also undecidable.

  *Case 2: $emptyset in cal(C)$*

  Consider the complement class $overline(cal(C))$, which contains all partially decidable languages that are *not* in $cal(C)$.
  Since $cal(C)$ is non-trivial, $overline(cal(C))$ is also non-trivial.
  Since $emptyset in cal(C)$, we have $emptyset in.not overline(cal(C))$.

  By the proof in Case 1, the language associated with $overline(cal(C))$ is undecidable (specifically, $L_u scripts(<=)_m L_(overline(cal(C)))$).

  Note that $L_(overline(cal(C)))$ corresponds to the complement of $L_cal(C)$. Since undecidability is preserved under complement (if a language was decidable, its complement would be too), $L_cal(C)$ must be undecidable.
]
