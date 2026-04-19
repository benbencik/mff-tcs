#import "../../../shared/lib.typ": *

= Cache Algorithms


#question("I/O Model & Sleator-Tarjan Theorem")[
  Define the I/O model for cache management and compare cache-aware and cache-oblivious algorithms. State and prove Sleator-Tarjan's theorem on LRU competitiveness. Describe the contribution of this theorem to the analysis of cache-oblivious algorithms.
]

#fig("../courses/data-structures/figs/io-model.png")

#definition("I/O Model (External Memory Model)")[
  Also known as the *External Memory Model*, it models algorithms processing data too large for main memory.
  The machine has two levels of memory:
  - *External Memory*: Potentially infinite size, organized in blocks of size $B$. (Sizes measured in arbitrary "items").
  - *Internal Memory*: Limited size $M$ items, also organized in $B$-item blocks.

  *Operations*:
  - All computations occur in *internal memory*.
  - Data is transferred between memories only in whole blocks (*I/Os*).
  - Explicit instructions load a block from external to internal memory or write it back.

  *Complexity Measure*: The *I/O complexity* is the number of block transfers (reads/writes). CPU time and internal memory access are ignored.
]


#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Cache-Aware*], [*Cache-Oblivious*],
  [Algorithms know parameters $M$ and $B$.],
  [Algorithms do *not* know $M$ and $B$.],

  [Can be tuned for specific hardware.], [Portable across different machines.],
  [Explicitly manages blocks/tiles.],
  [Relies on recursive structure and optimal replacement policy (LRU).],
)

== Sleator-Tarjan Theorem (LRU)

#theorem("Sleator-Tarjan Competitiveness")[
  Let $C_"LRU"$ be the cost (number of cache misses) of the LRU strategy with cache size $M_"LRU"$.
  Let $C_"OPT"$ be the cost of the optimal offline strategy (OPT) with cache size $M_"OPT"$.
  For every $M_"LRU" > M_"OPT" >= 1$ and every request sequence, we have:
  $ C_"LRU" <= (M_"LRU" / (M_"LRU" - M_"OPT")) dot C_"OPT" + M_"OPT" $

]

#proof[
  *Partitioning Strategy:*
  We split the request sequence into epochs $E_0, E_1, ..., E_k$.
  - We define the epochs based on LRU's misses. Each epoch $E_1, ..., E_k$ corresponds to a sequence of requests where LRU incurs exactly $M_"LRU"$ misses.
  - The first epoch $E_0$ is treated separately to handle the initial state of the caches (startup phase). It ends when LRU has incurred $M_"LRU"$ misses (or fewer if the sequence ends).

  *Analysis of a full epoch $E_i$ ($i > 0$):*
  Consider a full epoch where LRU incurs exactly $M_"LRU"$ misses. We distinguish two cases based on the distinct blocks accessed:
  1. *Many distinct blocks*: The sequence contains at least $M_"LRU"$ distinct blocks. Even if OPT starts the epoch with a full cache (containing $M_"OPT"$ relevant blocks), it can hold at most $M_"OPT"$ of these distinct blocks. Thus, OPT must miss at least $M_"LRU" - M_"OPT"$ times.
  2. *Repeated misses on the same block*: LRU misses twice on some block $b$. For $b$ to be evicted from LRU's cache (causing the second miss), at least $M_"LRU"$ *other* distinct blocks must have been accessed since $b$'s last use. This implies the epoch contains at least $M_"LRU"$ distinct blocks (including $b$). Again, OPT must miss at least $M_"LRU" - M_"OPT"$ times.

  In both cases, for every $M_"LRU"$ misses of LRU, OPT misses at least $M_"LRU" - M_"OPT"$ times.
  $ C_"LRU"(E_i) / C_"OPT"(E_i) <= M_"LRU" / (M_"LRU" - M_"OPT") $

  *Epoch $E_0$ (Startup Phase):*
  The first epoch captures the transition from the initial state.
  - If we assume empty caches, all blocks missed by LRU are distinct (filling the empty slots), so OPT must miss on them too. The ratio is $<= 1$.
  - If OPT starts with a "hot" cache (containing future requests) and LRU does not, OPT saves misses. However, OPT can save at most $M_"OPT"$ misses (the size of its cache). This "head start" is accounted for by the additive constant $+ M_"OPT"$ in the theorem statement.
]

*Relevance to Cache-Oblivious*:
Cache-oblivious algorithms are analyzed assuming an optimal cache replacement strategy. This theorem guarantees that if $M_"LRU" = 2 M_"OPT"$ then the LRU strategy is 2-competitive with the optimal caching strategy.

== Matrix Transposition ($N times N$)
#question("Matrix Transposition")[
  Formulate a cache-oblivious algorithm for square matrix transposition. Analyze its time complexity and I/O complexity.
]

#fig("../courses/data-structures/figs/matrix-transpose.png", width: 60%)

1. *Cache-Aware Algorithm (Tiling)*:
  ```
  1. s = sqrt(M/2) // Tile size fitting in cache
  2. For i = 0 to N-1 step s:
  3.   For j = 0 to N-1 step s:
  4.     Load tile A[i..i+s][j..j+s]
  5.     Transpose tile in memory to B[j..j+s][i..i+s]
  ```
  - *Intuition*: In a naive column-by-column traversal, every access might load a new block if the matrix is large (stride > block size), causing cache thrashing. Tiling ensures that once a $s times s$ block is loaded, we process all its elements before evicting it, maximizing spatial locality.
  - *Analysis*:
    - We assume a *tall cache* ($M >= B^2$), meaning the cache can hold a full $B times B$ tile ($s = B$).
    - The matrix is processed in $(N/B)^2$ tiles.
    - Loading one tile requires reading $B$ distinct rows. In the worst case (no two rows share a block), this costs $O(B)$ I/Os.
    - Total I/O: $(N/B)^2 dot O(B) = O(N^2/B)$.

2. *Cache-Oblivious Algorithm (Recursive)*:
  ```
  Transpose(A, B, n):
  1. If n == 1:
  2.   Swap(A, B) // Base case: swap single elements
  3. Else:
  4.   n1 = ceil(n/2); n2 = floor(n/2)
  5.   Transpose(A11, B11, n1)      // Top-left
  6.   Transpose(A12, B21, n1, n2)  // Top-right <-> Bottom-left
  7.   Transpose(A21, B12, n2, n1)  // Bottom-left <-> Top-right
  8.   Transpose(A22, B22, n2)      // Bottom-right
  ```
  The function `Transpose(A, B, n)` is generalized to "Transpose matrix A into B and matrix B into A" (effectively swapping them while transposing). For the initial call on a single matrix $M$, we call `Transpose(M, M, n)`.

  *Why two matrices?* A standard divide-and-conquer approach would transpose quadrants recursively and then *swap* the off-diagonal quadrants ($A_{12}$ and $A_{21}$). However, swapping two $N/2 times N/2$ matrices takes $O(N^2)$ time. Doing this at every level of recursion would yield $T(N) = 4T(N/2) + O(N^2) => O(N^2 log N)$, which is suboptimal.
  By generalizing the problem to "Transpose-and-Swap", we push the swapping logic down to the leaves ($n=1$). Internal nodes only perform $O(1)$ pointer arithmetic.

  *What if N is not a power of 2?*
  When $N$ is odd, we split it into $ceil(N/2)$ and $floor(N/2)$. This results in off-diagonal submatrices that are rectangular. However, they are always *almost-square*, meaning their dimensions differ by at most 1. The recursion works correctly on these shapes, and the I/O analysis holds because almost-square matrices satisfy the same "tall cache" fitting properties as square ones (up to constant factors).

  *Time Complexity*: The recurrence is $T(N) = 4T(N/2) + O(1)$. By Master Theorem, $T(N) = O(N^2)$.

  *I/O Analysis*:
  - We conceptually stop recursion at the largest subproblem size $d$ that fits in cache ($B/2 < d <= B$).
  - *Tall Cache Assumption* ($M >= B^2$): The submatrix of size $d times d$ fits fully in cache.
  - *Base Case Cost*: At this level, the operation is equivalent to running the *Naive Transpose* entirely within the fast internal memory (cache), causing no extra misses.
  - *Total I/O*: The recursion does not actually load anything from the exetrnal memory. The transpose is handled at lower level therefore this algorithm inherits the optimal I/O complexity of the cache-aware algorithm.


== k-way Mergesort
#question("k-way Mergesort (Cache-Aware)")[
  Analyze k-way Mergesort in a cache-aware model. What is the optimal choice of k?
]


*Algorithm*:
A $K$-way Mergesort combines $K$ runs at once, so the number of passes decreases to $ceil(log_K N) = ceil((log N) / (log K))$.
A $K$-way merge needs to locate a minimum of $K$ items in every step, which can be done using a *heap*.
- Every step takes time $Theta(log K)$.
- Merging $T$ items takes $Theta(T log K)$.
- The whole Mergesort takes $Theta(N log K dot (log N) / (log K)) = Theta(N log N)$ for any $K$.

*I/O Analysis*:
If we have a large enough cache during the merge, every input array has its own scan and the heap fits in cache.
- The total I/O complexity of a merge of $T$ items is $O(T/B)$.
- All merges during a pass perform $O(N/B)$ transfers.
- Multiplying this by the number of passes yields $O(N/B dot (log N) / (log K))$.

*Constraint (Choice of $K$)*:
How large $K$ does our cache allow?
- Each scan requires its own cached block, which is $K$ blocks total.
- Another $K$ blocks are needed for the heap.
- So $M >= 2 B K$ is sufficient and we can set $K = floor(M / (2B))$
