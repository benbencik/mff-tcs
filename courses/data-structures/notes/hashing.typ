#import "../lib.typ": *
#set heading(numbering: "1.")

== Hashing

#big_question("Hash Families & Chaining")[
  Define c-universal and k-independent families of hash functions. Give examples where a c-universal family is not enough, but a k-independent family must be used. Formulate and prove the theorem about the expected chain length in hashing with chaining. Show examples of c-universal and k-independent families for hashing natural numbers. For one example, prove c-universality or k-independence, for k >= 2.
]

=== Hash Families

#definition("Hash Families")[
    Let $cal(H)$ be a family of functions from $U$ to $[m]$.
    1. *c-Universal*: The family is $c$-universal for some $c > 0$ if for every pair $x, y$ of distinct elements of $U$ we have
       $ P_(h in cal(H))[h(x) = h(y)] <= c/m $
    2. *(k, c)-Independent*: The family is $(k, c)$-independent for integer $k$ ($1 <= k <= |U|$) and real $c > 0$ iff for every $k$-tuple $x_1, ..., x_k$ of distinct elements of $U$ and every $k$-tuple $a_1, ..., a_k$ of buckets in $[m]$, we have
       $ P_(h in cal(H))[h(x_1) = a_1 and ... and h(x_k) = a_k] <= c/m^k $]

=== Expected Chain Length

#theorem("Expected Collisions (Chain Length)")[

  Let $cal(H)$ be a $c$-universal family of functions from $U$ to $[m]$, $X = {x_1, ..., x_n} subset U$ a set of items stored in the data structure, and $y in U without X$ another item not stored in the data structure. Then we have

  $ E_(h in cal(H))[\#i : h(x_i) = h(y)] <= (c n) / m $

  That is, the expected number of items that collide with $y$ is at most $c n / m$.

]



#proof[

  Let $h$ be a function picked uniformly at random from $cal(H)$. We introduce indicator random variables

  $ A_i = cases(1 "if" h(x_i) = h(y)\, , 0 "otherwise".) $

  Expectation of zero-one random variables is easy to calculate: $E[A_i] = P[A_i = 1] = P[h(x_i) = h(y)]$. Because $cal(H)$ is universal, this probability is at most $c/m$.
  The theorem asks for the expectation of a random variable $A$, which counts $i$ such that $h(x_i) = h(y)$. This variable is a sum of the indicators $A_i$. By linearity of expectation, we have
  $ E[A] = E[sum_i A_i] = sum_i E[A_i] <= sum_i c/m = (c n) / m $
]

*Corollary (Complexity of hashing with chaining)*:
- *Unsuccessful search* for $y$: Expected number of items visited is at most $c n / m$.
- *Successful search* for $x_i$: Expected time is bounded by the expected time complexity of the previous insert of $x_i$.
- If $m$ is $Omega(n)$, expected time complexity of all operations is constant.

=== When c-Universality is Insufficient
While c-universality suffices for chaining, stronger independence is needed elsewhere:
- *Linear Probing*: Requires 5-independence to guarantee constant expected time. With only pairwise independence (c-universality), the hash values are not sufficiently random to prevent the formation of long contiguous runs of occupied cells (clustering). This leads to an expected operation cost of $O(sqrt(n))$ instead of $O(1)$. See @linear-probing for details.
- *Cuckoo Hashing*: Requires $O(log n)$-independence (or Tabulation Hashing) for the insertion to succeed with high probability.

=== Examples of Families for Natural Numbers
1. *Linear Congruence*: $h_(a,b)(x) = ((a x+b) mod p) mod m$. (2-universal).
2. *Polynomial Hashing*: $h_t(x) = (sum t_i x^i mod p) mod m$. (k-independent, see @k-independent-hashing).
3. *Tabulation Hashing*: We interpret the key $x$ as a vector of $c$ characters $x_1, ..., x_c$. We initialize $c$ fully random lookup tables $T_1, ..., T_c$, where each table maps a character to a random value in $[m]$. The hash value is computed as $h(x) = T_1[x_1] xor ... xor T_c[x_c]$. (3-independent)

#big_question("Linear Probing")[
  Describe and analyze hashing with linear probing using a fully random hash function and, e.g., one-third fill factor. Describe the advantages and disadvantages compared to other data structures, especially those based on hashing.
]

=== Linear Probing <linear-probing>

*Mechanism*:
We fix a hash function $h$ from $U$ to $[m]$. The probe sequence for $x$ will be $h(x), h(x)+1, h(x)+2, ...$, taken modulo $m$.

*Claim (Basic properties of linear probing)*:
Suppose that $m >= (1 + epsilon) dot n$. Then the expected number of probes during an operation is:
- $O(1/epsilon^2)$ for completely random hash functions.
- $O(1/epsilon^(13/6))$ for hash function chosen from a 5-independent family.
- $Omega(log n)$ for at least one 4-independent family.
- $Omega(sqrt(n))$ for at least one 2-independent family.
- $Omega(log n)$ for multiply-shift hashing.
- $O(1/epsilon^2)$ for tabulation hashing.

#theorem("Linear Probing Constant Time")[
  Let $m$ (table size) be a power of two, $n <= m/3$ (the number of items), $h$ a completely random hash function, and $x$ an item. Then the expected number of probes when searching for $x$ is bounded by a constant independent of $n, m, h, x$, and the universe.
]

#proof[
  We assume $n = m/3$. We construct a complete binary tree over the table. A node at height $t$ represents a *block* of size $2^t$. A block is called *critical* if more than $2/3 \cdot 2^t$ items hash into it.

  *Step 1: Probability of a critical block.*
  For a block of size $2^t$, the expected number of hashed items is $mu = n dot 2^t / m = 2^t / 3$. Being critical means receiving $> 2 mu$ items. By Chernoff bound, this probability is at most $q^(2^t)$ for some constant $q < 1$ (specifically $q approx 0.88$).

  *Step 2: Runs and critical blocks.*
  A *run* is a contiguous sequence of occupied cells. If a run $R$ is long ($|R| >= 2^(l+2)$), it must contain a high density of items. Specifically, it can be shown that if a run intersects blocks of size $2^l$, at least one of them must be critical to support such a long sequence of items.

  *Step 3: Expected probe length.*
  The number of probes for $x$ is at most the length of the run containing $h(x)$.
  Let $P_l$ be the probability that the run length is in $[2^(l+2), 2^(l+3))$. For this to happen, one of roughly 12 blocks of size $2^l$ near $h(x)$ must be critical.
  Thus, $P_l <= 12 dot q^(2^l)$.

  The expected number of probes is bounded by summing over all lengths:
  $
    E["probes"] <= 3 + sum_(l>=0) 2^(l+3) dot P_l <= 3 + sum_(l>=0) 2^(l+3) dot 12 dot q^(2^l)
  $
  Since $q < 1$, the term $q^(2^l)$ decays extremely fast (much faster than $2^l$ grows), so the sum converges to a constant.
]

=== Scalar Product Hashing <scalar-product-hashing>

#small_question("Scalar Product Hashing")[
  Describe a system of hash functions derived from scalar product. Prove that it is a 1-universal system from $ZZ_d^k$ to $ZZ_p$.
]


*Scalar Product Family*: For a prime $p$ and vector size $d >= 1$, we define the family of scalar product hash functions $cal(S) = {h_bold(t) | bold(t) in ZZ_p^d}$ from $ZZ_p^d$ to $ZZ_p$, where $h_bold(t)(bold(x)) = bold(t) dot bold(x)$.

#theorem("1-Universality of Scalar Product")[
  The family $cal(S)$ is 1-universal. A function can be picked at random from $cal(S)$ in time $Theta(d)$ and evaluated in the same time.
]

#proof[
  Consider two distinct vectors $bold(x), bold(y) in ZZ_p^d$. Let $k$ be a coordinate for which $x_k != y_k$. As the vector product does not depend on ordering of components, we can renumber the components, so that $k=d$.
  For a random choice of the parameter $bold(t)$, we have (in $ZZ_p$):
  $
    P[h_bold(t)(bold(x)) = h_bold(t)(bold(y))] = P[bold(x) dot bold(t) = bold(y) dot bold(t)] = P[(bold(x) - bold(y)) dot bold(t) = 0]
  $
  $
    = P[sum_{i=1}^d (x_i - y_i)t_i = 0] = P[(x_d - y_d)t_d = - sum_{i=1}^{d-1} (x_i - y_i)t_i]
  $
  For every choice of $t_1, ..., t_(d-1)$, there exists exactly one value of $t_d$ for which the last equality holds. Therefore it holds with probability $1/p$.
]


#small_question("Linear Congruence Hashing")[
  Describe a system of hash functions based on linear congruence. Prove that it is a 2-independent system from $ZZ_p$ to $[m]$ (you can use the lemma about modulo, which you should formulate but do not need to prove).
]

=== Linear Congruence Hashing

*Linear Congruence Family*: For any prime $p$ and $m <= p$, we define the family of linear functions $cal(L) = {h_(a,b) | a, b in [p]}$ from $[p]$ to $[m]$, where $h_(a,b)(x) = ((a x + b) mod p) mod m$.

#lemma("Composition Modulo m")[
  Let $cal(H)$ be a $(2, c)$-independent family of functions from $U$ to $[r]$ and $m < r$. Then the family $cal(H) mod m = {h mod m | h in cal(H)}$ is $2c$-universal and $(2, 4c)$-independent.
]

#proof[
  We use Lemma M.
  1. *Analysis of Linear Functions in $ZZ_p$*: Consider the family $cal(L)' = {h_(a,b)(x) = (a x + b) mod p}$ mapping $ZZ_p$ to $ZZ_p$.
  2. *Bijection Property*: As shown previously, the map $(a, b) arrow.r (h(x), h(y))$ is a bijection for distinct $x, y$. Specifically, for any $r, s in ZZ_p$, there is exactly one pair $(a, b)$ such that $a x + b = r$ and $a y + b = s$.
  3. *(2, 1)-Independence*: Since there is exactly 1 solution out of $p^2$ total pairs $(a, b)$, the probability $P[h(x)=r and h(y)=s] = 1/p^2$. This means $cal(L)'$ is $(2, 1)$-independent (where $c=1$).
  4. *Conclusion*: The family $cal(L)$ is obtained by taking $cal(L)'$ modulo $m$. By Lemma M with $c=1$, $cal(L)$ is $2(1) = 2$-universal and $(2, 4(1)) = (2, 4)$-independent.
]


=== k-independent Hashing <k-independent-hashing>

#small_question("k-independent Hashing")[
  Construct a k-independent system of hash functions from $ZZ_p$ to $[m]$. Justify k-independence (you can use the lemma about modulo, which you should formulate but do not need to prove).
]

*Polynomial Hashing*: For any field $ZZ_p$ and $k >= 1$, the family $cal(P)_k = {h_bold(t) | bold(t) in ZZ_p^k}$ where $h_bold(t)(x) = sum_{i=0}^{k-1} t_i x^i$ is $(k, 1)
$-independent.

#lemma("k-independent composition modulo m")[
  Let $cal(H)$ be a $(k, c)$-independent family of functions from $U$ to $[r]$ and $m$ integer such that $r >= 2 k m$. Then the family $cal(H) mod m = {h mod m | h in cal(H)}$ is $(k, 2c)$-independent.
]


#proof[
  Let $x_1, ..., x_k in ZZ_p$ be distinct keys and $y_1, ..., y_k in ZZ_p$ be target values. By standard results on polynomials, there is exactly one polynomial $h$ of degree at most $k-1$ (determined by $k$ coefficients) such that $h(x_i) = y_i$ for every $i$.
  Since there are $p^k$ possible polynomials (choices of coefficients $bold(t)$) and exactly one satisfies the condition, the probability that a random polynomial from $cal(P)_k$ has this property is $1/p^k$.

  The family $cal(P)_k$ maps $ZZ_p$ to $ZZ_p$, so the target range size is $r = p$. It is $(k, 1)$-independent, so $c=1$. Lemma K states that if the range size $r$ (here $p$) is at least $2k m$, then taking the result modulo $m$ yields a family that is $(k, 2c)$-independent. Substituting $c=1$, we get $(k, 2)$-independence.
]


=== Rolling Hash <rolling-hash>

#small_question("Rolling Hash (Strings)")[
  Construct a 2-independent system hashing strings of length at most L over alphabet [a] to [m] based on polynomials, i.e., "rolling hash". Describe the advantage of using this system compared to other hash functions.
]


*Polynomial Rolling Hash*:For a prime $p$ and vector size $d$, define the family $cal(R) = {h_a | a in ZZ_p}$ from $ZZ_p^d$ to $ZZ_p$, where $h_a (bold(x)) = sum_{i=0}^{d-1} x_(i+1) dot a^(d-1-i)$.

#theorem("d-Universality")[
  The family $cal(R)$ is $d$-universal. A function can be picked from $cal(R)$ in constant time and evaluated in $Theta(d)$.
]

#proof[
  Consider two distinct vectors $bold(x) != bold(y)$ and a hash function $h_a$ chosen at random from $cal(R)$.
  A collision happens whenever $sum x_(i+1) a^i = sum y_(i+1) a^i$. This is the same condition as $sum (x_(i+1) - y_(i+1)) a^i = 0$, that is if the number $a$ is a root of the polynomial $P(z) = sum (x_(i+1) - y_(i+1)) z^i$.
  Since $bold(x) != bold(y)$, $P(z)$ is not the zero polynomial. Its degree is at most $d-1$.
  Over a field $ZZ_p$, a polynomial of degree $k$ has at most $k$ roots. Thus, there are at most $d-1$ bad choices for $a$.
  The probability of collision is at most $(d-1)/p < d/p$. This implies $d$-universality.
]

#lemma("General Composition (Lemma G)")[
  Let $cal(F)$ be a $c$-universal family of functions from $U$ to $[r]$. Let $cal(G)$ be a $(2, d)$-independent family of functions from $[r]$ to $[m]$. Then the family $cal(H) = cal(F) circle cal(G) = {f circle g | f in cal(F), g in cal(G)}$ is $(2, c')$-independent for $c' = (c m/r + 1)d$.
]

*Construction of 2-independent family*:
The family $cal(R)$ is universal but not 2-independent. To get a 2-independent family mapping to $[m]$, we compose $cal(R)$ with the linear family $cal(L)$ (which maps $ZZ_p -> [m]$).
$ h(bold(x)) = ((A dot h_a (bold(x)) + B) mod p) mod m $
where $a, A, B$ are chosen uniformly from $ZZ_p$ (with $A != 0$). By applying the above lemma we get a composite hashing function that is $(2, c')$-independent.


Advantages of the rolling hash:
1. *Rolling Property*: Crucial for Rabin-Karp algorithm. We can update the polynomial hash value $H$ (in $ZZ_p$) of a sliding window in $O(1)$ time.
  $
    H_"new" = ((H_"old" - "char"_("out") dot a^(d-1)) dot a + "char"_("in")) mod p
  $
  The final bucket index is then computed as $((A dot H_"new" + B) mod p) mod m$.
2. *Space Efficiency*: Requires storing only $O(1)$ random parameters ($a, A, B$), unlike scalar product hashing which requires a random vector of size $d$.

=== Bloom Filters

#small_question("Bloom Filters")[
  Describe and analyze a Bloom filter. Give an example of its practical use.
]


*Description*:
A probabilistic data structure used to test whether an element is a member of a set. It is space-efficient but allows for *false positives* (it may say an element is in the set when it is not). It never produces *false negatives*.

*Structure & Operations*:
- *Memory*: An array $B$ of $m$ bits, initially all set to 0.
- *Hash Functions*: $k$ independent hash functions $h_1, ..., h_k$ mapping items to $[m]$.

*Insert(x)*:
```
1. For i = 1 to k:
2.   idx = h_i(x)
3.   B[idx] = 1
```

*Query(x)*:
```
1. For i = 1 to k:
2.   If B[h_i(x)] == 0:
3.     Return NO
4. Return YES
```

*Variants*:
- *Single-table Filter*: All $k$ hash functions map to the same bit array of size $m$.
- *Multi-band Filter*: We have $k$ separate arrays (bands) $B_1, ..., B_k$, each with its own hash function $h_i$.
  - *Insert*: Set the bit in $B_i$ at index $h_i (x)$ for all $i$.
  - *Query*: Return YES only if the bit is set in *every* band $B_i$ at $h_i (x)$.

*Analysis (False Positive Probability)*:
Let $n$ be the number of inserted items
1. The probability that a specific bit remains 0 after inserting one item (using $k$ hashes) is $(1 - 1/m)^k$.
2. After inserting $n$ items, the probability that a bit remains 0 is $p_0 = (1 - 1/m)^(k n) approx e^(-k n/m)$.
3. The probability that a bit is set to 1 is $p_1 = 1 - p_0$.
4. A false positive occurs if all $k$ bits for a query are 1. Assuming independence, this happens with probability $P_"FP" approx (p_1)^k = (1 - e^(-k n/m))^k$.

*Optimizing Parameters*:
It can be shown that for a fixed memory size $m$, the false positive probability $P_"FP"$ is minimized exactly when $p_0 = 1/2$. In other words, a Bloom filter works best when the bit array is 50% full.
1. *Optimal Error Rate*: When parameters are optimal (table 50% full), the probability a bit is 1 is $1/2$. Thus, the false positive rate is simply $(1/2)^k = 2^(-k)$.
2. *Required Hash Functions*: To achieve a specific error rate $epsilon$, we must push $2^(-k)$ under $epsilon$. Thus we set $k = ceil(log_2(1/epsilon))$.
3. *Required Memory*: Since the optimal state implies $e^(-k n/m) = 1/2$, we have $k n / m = ln 2$.
   Solving for $m$, we get the minimum memory requirement:
   $ m = (k n) / (ln 2) $

*Counting Filters (Supporting Deletion)*:
Standard Bloom filters do not support deletion. If we simply unset the bits for an element $x$, we might unset a bit shared with another element $y$, creating a false negative for $y$. To solve this, we use *Counting Bloom Filters*:
- *Structure*: Replace the bit array with an array of $b$-bit counters (typically $b=4$).
- *Insert(x)*: Increment the counters at indices $h_1(x), ..., h_k(x)$.
- *Delete(x)*: Decrement the counters at indices $h_1(x), ..., h_k(x)$.
- *Query(x)*: Return *YES* if all counters at $h_1(x), ..., h_k(x)$ are strictly greater than 0.
- *Overflow Handling*: If a counter reaches its maximum value ($2^b - 1$), it becomes *stuck*. A stuck counter is left at the maximum value and is never decremented. This ensures that we never accidentally delete information about items hashing to that slot, preserving the "no false negatives" property.

*Practical Use Cases*:
1. *Databases (LSM Trees)*: Systems like Cassandra, HBase, or LevelDB use Bloom filters to avoid expensive disk lookups for non-existent keys. If the filter returns NO, the system skips reading the disk block.
2. *Web Browsers*: Checking malicious URLs. A local Bloom filter checks if a URL might be malicious. Only if it returns YES does the browser perform a slower, precise check against a remote database.
