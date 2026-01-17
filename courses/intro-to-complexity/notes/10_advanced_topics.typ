#import "../lib.typ": *

= Advanced Topics

#question_B(
  "(B12) Pseudorandom generators, one-way functions and their connection to cryptography",
)[
  Explain pseudorandom generators, one-way functions, and their connection to cryptography (symmetric encryption, bit-commitment).
]

== Cryptography and Complexity

Modern cryptography relies on the assumption that certain computational problems are hard to solve (e.g., cannot be solved in polynomial time).

=== One-Way Functions (OWF)

#definition("One-Way Function")[
  A function $f: {0, 1}^* -> {0, 1}^*$ is a one-way function if:
  1. *Easy to compute:* There is a polynomial-time algorithm to compute $f(x)$ for all $x$.
  2. *Hard to invert:* For every probabilistic polynomial-time algorithm $A$, the probability that $A(f(x))$ outputs a preimage of $f(x)$ (an $x'$ such that $f(x') = f(x)$) is negligible (smaller than any inverse polynomial).
]

Candidates for OWF:
- Integer factorization (multiplication is easy, factoring is hard).
- Discrete logarithm.

=== Pseudorandom Generators (PRG)

#definition("Pseudorandom Generator")[
  A function $G: {0, 1}^n -> {0, 1}^(l(n))$ is a pseudorandom generator if:
  1. $G$ is computable by a deterministic polynomial-time algorithm.
  2. $l(n) > n$ for every $n in bb(N)$ (stretch).
  3. For every probabilistic polynomial-time algorithm $cal(A)$, it holds that
    $
      | Pr_(y in {0,1}^(l(n))) [cal(A)(y) = 1] - Pr_(x in {0,1}^n) [cal(A)(G(x)) = 1] | lt.eq epsilon(n)
    $
    for some negligible function $epsilon(n)$.
]

A function $epsilon(n)$ is *negligible* if for every polynomial $p(n)$, there exists $n_0$ such that for all $n > n_0$, $epsilon(n) < 1/p(n)$.

*Connection:* It has been proven that *One-Way Functions exist if and only if Pseudorandom Generators exist* (HILL Theorem).

=== Symmetric Encryption

Pseudorandom generators are fundamental to symmetric encryption, particularly in stream ciphers. In a stream cipher, a short secret key (seed) is used by a PRG to generate a long sequence of pseudorandom bits, known as the *key stream*. This key stream is then XORed with the plaintext to produce the ciphertext. Decryption involves XORing the ciphertext with the same key stream (generated from the same secret key). The security of such a system relies on the cryptographic strength of the PRG: if the PRG's output is computationally indistinguishable from truly random bits, then the ciphertext is indistinguishable from random noise without knowledge of the secret key.

=== Bit Commitment

Bit commitment is a cryptographic primitive where Alice can "commit" to a value (e.g., a bit) without revealing it to Bob, and later reveal it in a way that Bob can verify she didn't change her mind.

*Phases:*
1. *Commitment Phase:* Alice chooses a bit $b$ and computes a commitment $c$. She sends $c$ to Bob. Bob cannot determine $b$ from $c$ (hiding).
2. *Reveal Phase:* Alice reveals $b$ and proof of validity to Bob. Bob can verify that $c$ was indeed a commitment to $b$. Alice cannot successfully reveal $1-b$ if she committed to $b$ (binding).

*Scheme using PRG with stretch $l(n) = 3n$:*
1. *Commitment:*
  - Bob generates a random $3n$-bit string $r$ and sends it to Alice.
  - Alice generates a random $n$-bit seed $y$.
  - If Alice wants to commit to $b=1$, she computes $c = G(y)$.
  - If Alice wants to commit to $b=0$, she computes $c = G(y) plus.o r$.
  - Alice sends $c$ to Bob.
2. *Reveal:*
  - Alice sends the seed $y$ to Bob.
  - Bob computes $G(y)$.
  - If $c = G(y)$, Bob concludes $b=1$.
  - If $c = G(y) plus.o r$, Bob concludes $b=0$.
  - Otherwise, Bob rejects (Alice cheated).

This scheme is hiding because $G(y)$ is indistinguishable from random, and binding because $G(y)$ and $G(y') plus.o r$ are unlikely to collide.


#question_B(
  "(B13) Example of fine-grained reduction (SETH to OV or OV to regex matching)",
)[
  Provide an example of a fine-grained reduction, such as reducing SETH to Orthogonal Vectors.
]

== Fine-Grained Complexity

Fine-grained complexity classifies problems within #smallcaps[P] or checks exact exponential times for #smallcaps[NP] problems. It relies on stronger hypotheses than $#smallcaps("P") != #smallcaps("NP")$.

=== #smallcaps[Strong Exponential Time Hypothesis] (#smallcaps[SETH])

Let $s_k = inf { delta | k#smallcaps("-SAT") text(" can be solved in ") cal(O)(2^(delta n)) }$.
The #smallcaps[Strong Exponential Time Hypothesis] (#smallcaps[SETH]) states that $lim_(k -> oo) s_k = 1$.
This implies that for any $epsilon > 0$, there exists a $k$ such that $k$-#smallcaps[SAT] cannot be solved in $O(2^{(1-epsilon)n})$.

=== #smallcaps[Orthogonal Vectors] (#smallcaps[OV])

*Problem:* Given two sets $A, B$ of $N$ vectors in $\{0, 1\}^d$, are there $u in A, v in B$ such that $u dot v = 0$ (orthogonal)?
Trivial algorithm: $O(N^2 d)$.

*#smallcaps[OV] Conjecture:* For every $epsilon > 0$, #smallcaps[OV] cannot be solved in $O(N^(2-epsilon))$ (assuming $d approx log N$).

*Reduction #smallcaps[SETH] $=>$ #smallcaps[OV] (Contrapositive):*
We prove that if the #smallcaps[OV] Conjecture is false, then #smallcaps[SETH] is false.
Specifically, we show that if #smallcaps[OV] can be solved in time $cal(O)(N^(2-delta))$ for some $delta > 0$, then $k$-#smallcaps[SAT] can be solved in time $cal(O)(2^{(1 - delta/2)n})$, which contradicts #smallcaps[SETH] (as the exponent $1 - delta/2$ is strictly less than 1 and independent of $k$).

*Construction:*
Let $phi = C_1 and ... and C_m$ be a $k$-#smallcaps[CNF] formula with $n$ variables.
1.  Split variables into two sets $X_1 = {x_1, ..., x_(n/2)}$ and $X_2 = {x_(n/2+1), ..., x_n}$.
2.  Construct set $A$ consisting of all $N = 2^(n/2)$ partial assignments $alpha: X_1 -> {0, 1}$.
    For each $alpha$, create a vector $a^alpha in {0, 1}^m$ where $a^alpha [j] = 0$ if assignment $alpha$ *satisfies* clause $C_j$, and $1$ otherwise.
3.  Construct set $B$ consisting of all $N = 2^(n/2)$ partial assignments $beta: X_2 -> {0, 1}$.
    For each $beta$, create a vector $b^beta in {0, 1}^m$ where $b^beta [j] = 0$ if assignment $beta$ *satisfies* clause $C_j$, and $1$ otherwise.

*Correctness:*
For any pair of partial assignments $alpha$ and $beta$, let $alpha circle.small beta$ be the full assignment.
$ a^alpha dot b^beta = 0 &<=> forall j in {1, ..., m}: a^alpha [j] dot b^beta [j] = 0 \
&<=> forall j: (a^alpha [j] = 0) or (b^beta [j] = 0) \
&<=> forall j: (alpha text(" satisfies ") C_j) or (beta text(" satisfies ") C_j) \
&<=> alpha circle.small beta text(" satisfies ") phi $
Thus, $phi$ is satisfiable iff there exists a pair of vectors $a^alpha in A, b^beta in B$ that are orthogonal.

*Complexity Analysis:*
- Size of sets: $N = |A| = |B| = 2^(n/2)$.
- Dimension: $d = m$. For $k$-SAT, $m = cal(O)(n^k)$.
- If #smallcaps[OV] can be solved in $cal(O)(N^(2-delta))$, then satisfiability can be decided in:
  $ T(n) = cal(O)(N^(2-delta) dot "poly"(d)) = cal(O)((2^(n/2))^(2-delta) dot "poly"(n)) = cal(O)(2^(n(1-delta/2)) dot "poly"(n)) $
- This algorithm solves $k$-#smallcaps[SAT] in time $cal(O)(2^(c n))$ where $c = 1 - delta/2 < 1$.
- Since this speedup $c$ depends only on the OV algorithm's $delta$ and not on $k$, it applies for all $k$. This implies $s_k \le 1 - delta/2$ for all $k$, so $lim_(k -> oo) s_k \le 1 - delta/2 < 1$, violating #smallcaps[SETH].
