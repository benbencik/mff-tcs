#import "../lib.typ": *

= Complementary Classes and co-#smallcaps[NP]

#question_B("(B11) co-NP class and co-NP-completeness")[
  Define the class co-#smallcaps[NP] and co-#smallcaps[NP]-completeness. (Prove that TAUT is co-#smallcaps[NP]-complete.)
]

== The Class co-#smallcaps[NP]

Complementary classes deal with the complements of languages.

#definition("co-NP")[
  A language $L$ is in co-#smallcaps[NP] if its complement $overline(L) = Sigma^* without L$ is in #smallcaps[NP].
]

Intuitively, if #smallcaps[NP] is the class of problems with efficiently verifiable "yes" certificates, co-#smallcaps[NP] is the class of problems with efficiently verifiable "no" certificates (counter-examples).

Example:
- *SAT* is in #smallcaps[NP]: If a formula is satisfiable, a satisfying assignment is a proof.
- *UNSAT* (Unsatisfiability) is in co-#smallcaps[NP]: If a formula is unsatisfiable, there isn't necessarily a short proof of this fact. But if it *were* satisfiable, a satisfying assignment would disprove UNSAT.
- *TAUT* (Tautology) is in co-#smallcaps[NP]: A formula is a tautology iff it is never false. A counter-example is a proof that it is *not* a tautology. The language is defined as $#smallcaps[TAUT] = { chevron.l psi chevron.r | psi "is tautology"}$

== Properties

- *Relation to #smallcaps("P"):* Since #smallcaps("P") is closed under complement, $#smallcaps("P") subset.eq #smallcaps("NP") inter #smallcaps("co-NP")$. Problems in the intersection have efficient certificates for both "yes" and "no" answers.
- *#smallcaps("NP") vs. #smallcaps("co-NP"):* It is widely believed that $#smallcaps("NP") != #smallcaps("co-NP")$. If they were equal, it would imply a collapse of the Polynomial Hierarchy.
- *Hierarchy:* $#smallcaps("P") subset.eq #smallcaps("NP") inter #smallcaps("co-NP") subset.eq #smallcaps("NP") union #smallcaps("co-NP") subset.eq #smallcaps("PSPACE")$.
- *Collapse Theorem:* If any #smallcaps("NP")-complete problem is in #smallcaps("co-NP"), then $#smallcaps("NP") = #smallcaps("co-NP")$.
  - *Proof idea:* Let $L$ be #smallcaps("NP")-complete and $L in #smallcaps("co-NP")$. For any $A in #smallcaps("NP")$, $A lt.eq_p L$. Since #smallcaps("co-NP") is closed under reductions, $A in #smallcaps("co-NP")$, so $#smallcaps("NP") subset.eq #smallcaps("co-NP")$. Symmetry gives equality.

== co-#smallcaps[NP]-Completeness

#definition("co-NP-Completeness")[
  A language $L$ is co-#smallcaps[NP]-complete if:
  1. $L in$ co-#smallcaps[NP].
  2. For every $A in$ co-#smallcaps[NP], $A scripts(<=)_m^p L$.
]

#theorem("TAUT is co-NP-complete")[
  The language of tautologies TAUT is co-#smallcaps[NP]-complete.
]

#proof[
  *1. TAUT is in co-#smallcaps[NP]:*
  To show that #smallcaps("TAUT") is in co-#smallcaps("NP"), we must show that its complement, $overline(#smallcaps("TAUT"))$, is in #smallcaps("NP").
  The complement $overline(#smallcaps("TAUT"))$ contains all formulas that are *not* tautologies. A formula $phi$ is not a tautology if there exists at least one truth assignment $alpha$ such that $phi(alpha) = 0$ (FALSE).
  We can verify this in polynomial time: given a formula $phi$ and a certificate $alpha$ (an assignment), a deterministic TM can evaluate $phi$ on $alpha$. If the result is 0, the verifier accepts.
  Thus, $overline(#smallcaps("TAUT")) in #smallcaps("NP")$, which implies $#smallcaps("TAUT") in$ co-#smallcaps("NP").

  *2. TAUT is co-#smallcaps[NP]-hard:*
  We know that #smallcaps("SAT") is #smallcaps("NP")-complete. This implies that its complement, #smallcaps("UNSAT") (the set of unsatisfiable formulas), is co-#smallcaps("NP")-complete.
  We show that $#smallcaps("UNSAT") scripts(<=)_m^p #smallcaps("TAUT")$.
  Let $phi$ be an instance of #smallcaps("UNSAT"). We construct the formula $psi = not phi$.
  $
    phi in #smallcaps("UNSAT") & <=> phi text(" is unsatisfiable") \
                               & <=> forall alpha: phi(alpha) = 0 \
                               & <=> forall alpha: not phi(alpha) = 1 \
                               & <=> not phi text(" is a tautology") \
                               & <=> psi in #smallcaps("TAUT")
  $
  The reduction function $f(phi) = not phi$ is clearly computable in polynomial time.
  Since #smallcaps("UNSAT") is co-#smallcaps("NP")-complete and reduces to #smallcaps("TAUT"), #smallcaps("TAUT") is co-#smallcaps("NP")-hard.
]
