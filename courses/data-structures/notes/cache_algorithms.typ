#import "../lib.typ": *

= Cache Algorithms

#big_question("I/O Model & Sleator-Tarjan Theorem")[
  Define the I/O model for cache management and compare cache-aware and cache-oblivious algorithms. State and prove Sleator-Tarjan's theorem on LRU competitiveness. Describe the contribution of this theorem to the analysis of cache-oblivious algorithms.
]

=== I/O Model (External Memory Model)

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

=== Sleator-Tarjan Theorem (LRU)

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

#small_question("Matrix Transposition")[
  Formulate a cache-oblivious algorithm for square matrix transposition. Analyze its time complexity and I/O complexity.
]

=== Matrix Transposition ($N times N$)

Goal: Compute $B = A^T$. Assume $N$ is large ($N^2 > M$).

1. *Naive Algorithm*:
   ```
   1. For i = 0 to N-1:
   2.   For j = 0 to N-1:
   3.     B[j][i] = A[i][j]
   ```
   - *Analysis*: Reading $A$ is sequential ($N^2/B$ I/Os). Writing $B$ is column-wise. If $N > M/B$, every write incurs a cache miss.
   - *Total I/O*: $O(N^2)$.

2. *Cache-Aware Algorithm (Tiling)*:
   ```
   1. s = sqrt(M/2) // Tile size fitting in cache
   2. For i = 0 to N-1 step s:
   3.   For j = 0 to N-1 step s:
   4.     Load tile A[i..i+s][j..j+s]
   5.     Transpose tile in memory to B[j..j+s][i..i+s]
   ```
   - *Analysis*: Each block is read once and written once.
   - *Total I/O*: $O(N^2/B)$.

3. *Cache-Oblivious Algorithm (Recursive)*:
   ```
   Transpose(A, B, n):
   1. If n <= threshold:
   2.   NaiveTranspose(A, B, n)
   3. Else:
   4.   Divide A, B into 2x2 quadrants
   5.   Transpose(A11, B11, n/2)
   6.   Transpose(A12, B21, n/2)
   7.   Transpose(A21, B12, n/2)
   8.   Transpose(A22, B22, n/2)
   ```
   - *Base Case*: When submatrix fits in cache, cost is linear scan.
   - *Analysis*: Similar to tiling, but the "tile size" is determined implicitly by recursion depth where the problem fits in cache.
   - *Total I/O*: $O(N^2/B)$.


#small_question("k-way Mergesort (Cache-Aware)")[
  Analyze k-way Mergesort in a cache-aware model. What is the optimal choice of k?
]

=== k-way Mergesort

*Algorithm*:
```
1. Divide input into N/M chunks
2. Sort each chunk in memory and write to disk (Runs)
3. While number_of_runs > 1:
4.   Take k runs
5.   Merge k runs into 1 larger run
```

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
