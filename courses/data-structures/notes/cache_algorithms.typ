#import "../lib.typ": *

= Cache Algorithms

#big_question("I/O Model & Matrix Transposition")[
  Define I/O model for cache management and compare cache-aware and cache-oblivious algorithms. Formulate cache-aware and cache-oblivious algorithms for square matrix transposition. Analyze their time complexity and I/O complexity.
]

#definition("I/O Model (External Memory Model)")[
  The system consists of:
  - *CPU* with limited internal memory (Cache) of size $M$.
  - *Disk* (External Memory) of infinite size.
  - Data is transferred in blocks of size $B$.
  - *Complexity Measure*: The number of block transfers (I/Os) between disk and cache. Computation time is ignored.
]

=== Cache-Aware vs. Cache-Oblivious

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Cache-Aware*], [*Cache-Oblivious*],
  [Algorithms know parameters $M$ and $B$.], [Algorithms do *not* know $M$ and $B$.],
  [Can be tuned for specific hardware.], [Portable across different machines.],
  [Explicitly manages blocks/tiles.], [Relies on recursive structure and optimal replacement policy (LRU).]
)

=== Matrix Transposition ($N times N$)

Goal: Compute $B = A^T$. Assume $N$ is large ($N^2 > M$).

1. *Naive Algorithm*:
   - Iterate $i, j$: $B[j][i] = A[i][j]$.
   - *Analysis*: Reading $A$ is sequential ($N^2/B$ I/Os). Writing $B$ is column-wise. If $N > M/B$, every write incurs a cache miss.
   - *Total I/O*: $O(N^2)$.

2. *Cache-Aware Algorithm (Tiling)*:
   - Divide matrix into tiles of size $s times s$ where $s approx B$ (specifically $s^2 < M$).
   - Load a tile of $A$, transpose it in memory, write to $B$.
   - *Analysis*: Each block is read once and written once.
   - *Total I/O*: $O(N^2/B)$.

3. *Cache-Oblivious Algorithm (Recursive)*:
   - Divide $A$ and $B$ into $2 times 2$ submatrices.
   - Recursively transpose submatrices: $B_{11} = A_{11}^T, B_{12} = A_{21}^T$, etc.
   - *Base Case*: When submatrix fits in cache, cost is linear scan.
   - *Analysis*: Similar to tiling, but the "tile size" is determined implicitly by recursion depth where the problem fits in cache.
   - *Total I/O*: $O(N^2/B)$.

#line(length: 100%, stroke: gray)

#small_question("k-way Mergesort (Cache-Aware)")[
  Analyze k-way Mergesort in cache-aware model. What is the optimal choice of k?
]

*Algorithm*:
1. Sort chunks of size $M$ in memory ($N/M$ chunks). Write to disk.
2. Merge $k$ sorted runs into one larger run. Repeat until one run remains.

*Analysis*:
- Each pass reads and writes $N$ items: $2(N/B)$ I/Os.
- Number of passes: $log_k (N/M)$.
- Total I/O: $O(N/B log_k (N/M))$.

*Constraint*:
To merge $k$ runs, we need 1 block for each input run and 1 block for the output in cache.
$ k + 1 <= M/B ==> k approx M/B $

*Optimal Choice*:
Choose $k = Theta(M/B)$. This minimizes the height of the merge tree.
*Optimal Complexity*: $O(N/B log_(M/B) (N/B))$.

#line(length: 100%, stroke: gray)

#small_question("Sleator-Tarjan Theorem (LRU)")[
  State and prove Sleator-Tarjan theorem about competitiveness of LRU. Describe the contribution of this theorem for analysis of cache-oblivious algorithms.
]

#theorem("Sleator-Tarjan Competitiveness")[
  Let $F_"LRU"(S)$ be the number of page faults incurred by LRU on sequence $S$ with cache size $K$.
  Let $F_"OPT"(S)$ be the number of page faults incurred by the optimal offline algorithm (OPT) with cache size $H <= K$.
  Then:
  $ F_"LRU"(S) <= K / (K - H + 1) dot F_"OPT"(S) + H $
]

#proof[
  (Sketch)
  Partition the sequence $S$ into phases. A phase ends when $K+1$ distinct pages have been accessed.
  - *LRU*: In each phase, LRU faults at most $K$ times (since it keeps the $K$ most recent).
  - *OPT*: In each phase, there are $K+1$ distinct pages. OPT has capacity $H$. It must fault at least $(K+1) - H$ times.
  - *Ratio*: $K / (K - H + 1)$.
]

*Relevance to Cache-Oblivious*:
Cache-oblivious algorithms are analyzed assuming an optimal cache replacement strategy. This theorem guarantees that running them on a standard LRU cache only increases the number of I/Os by a constant factor (if we assume the machine has slightly more memory than the ideal model, e.g., $K=2H ==>$ factor 2).