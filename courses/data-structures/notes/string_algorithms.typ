#import "../../../shared/lib.typ": *

= String Algorithms

#question("Suffix Array & LCP")[
  Define a suffix array and an LCP array. Describe and analyze algorithms for their construction (for suffix arrays, almost linear time is sufficient). Describe an example problem that these arrays can solve effectively.
]

#definition("Suffix Array (SA)")[
  Let $S$ be a string of length $n$. The Suffix Array $"SA"$ is a permutation of indices ${0, ..., n-1}$ such that $S["SA"[0]..] < S["SA"[1]..] < ... < S["SA"[n-1]..]$ lexicographically. Essentially, it stores the starting indices of all suffixes of $S$ in sorted order. The inverse suffix array is called *rank array* $R[i]$, which determines the lexicographic position of suffix $"SA"[I:]$.
]

== Construction: Prefix Doubling (Karp-Miller-Rosenberg)
Goal: Construct SA in $O(n log n)$.

*Main Idea*:
We iteratively sort suffixes by their prefixes of length $L = 1, 2, 4, ...$.
Let $R_L[i]$ be the rank of the suffix starting at $i$ when considering only its first $L$ characters.
In step $L$ (where we know ranks for length $L$), we determine the order for length $2L$.

*Logic*:
For any two suffixes starting at $i$ and $j$, the comparison of their prefixes of length $2L$ is defined as:
$
  "suffix"[i] <=_(2L) "suffix"[j] <==> ("suffix"[i] <_L "suffix"[j]) or (("suffix"[i] =_L "suffix"[j]) and ("suffix"[i+L] <=_L "suffix"[j+L]))
$
Using the ranking array $R_L$, this is equivalent to comparing the pairs:
$ (R_L[i], R_L[i+L]) <= (R_L[j], R_L[j+L]) $
(We handle indices out of bounds by assigning them rank 0, corresponding to an empty suffix which is lexicographically smallest).

*Algorithm*:
1. *Initialization*: Sort suffixes by their first character ($L=1$). Construct the initial rank array $R_1$, where $R_1[i]$ is the number of suffixes strictly smaller than suffix $i$ in the first character.
2. *Iteration*: For length $L = 1, 2, 4, ..., < n$:
  - Assign a pair $P[i] = (R_L [i], R_L [i+L])$ to each suffix $i$.
  - *Sort*: Sort these pairs. Since the ranks are integers in $[0, n]$, we can use *Radix Sort* (Bucketsort) with 2 passes of $n$ buckets. This takes $O(n)$ time.
  - *Re-rank*: After sorting, the suffixes are arranged in the correct order for length $2L$. We construct the new ranking array by scanning this sorted order.
  - Update $R = R_{2L}$.
  - Update $L = 2L$.

*Complexity*:
There are $O(log n)$ steps. Each step uses Radix Sort taking $O(n)$. Total time: $O(n log n)$. Space: $O(n)$. The initial sort by first character takes $O(n log n)$.

#definition("LCP Array")[
  The Longest Common Prefix array stores the length of the common prefix between consecutive suffixes in the suffix array.
  $ "LCP"[i] = "prefixlength"(S["SA"[i-1]..], S["SA"[i]..]) $
  Defined for $i=1..n-1$. $"LCP"[0]$ is usually undefined or 0.
]

== Construction: LCP Array (Kasai's Algorithm)
Goal: Construct LCP in $O(n)$ given SA and S.

*Key Observation*:
Let $"rank"[i]$ be the position of suffix $i$ in $"SA"$.
If $"LCP"["rank"[i]] = h$, then $"LCP"["rank"[i+1]] >= h-1$.
*Intuition*: If suffix $i$ and its predecessor in $"SA"$ share a prefix of length $h$ (say "banana" and "bandana", $h=3$ "ban"), then suffix $i+1$ ("anana") and the suffix starting after the predecessor ("andana") share a prefix of length $h-1$ ("an"). Note that the predecessor of $i+1$ in SA might not be exactly the shifted predecessor of $i$, but it will be lexicographically closer, so the LCP can only be larger or equal to $h-1$.

*Algorithm Kasai*:
```
1. k = 0
2. For i = 0 to n-1:
3.   if rank[i] > 0:
4.     j = SA[rank[i] - 1]
5.     While S[i+k] == S[j+k]:
6.       k = k + 1
7.     LCP[rank[i]] = k
8.     if k > 0: k = k - 1
```
*Complexity*: The pointer for comparison increases $h$. $h$ decreases by at most 1 per iteration. Total increments bounded by $2n$. Time $O(n)$.

== Applications: Pattern Matching
Find $P$ in $S$.
- Binary search on $"SA"$. Comparison takes $O(|P|)$. Total $O(|P| log n)$.
- With $"LCP"$ and precomputed $"RMQ"$ (Range Minimum Query), can be $O(|P| + log n)$.

== Longest Common Substring

#question("Longest Common Substring")[
  Show how to use a suffix array and an LCP array to find the longest common substring of two strings.
]

*Problem*: Find the longest string that is a substring of both $S_1$ and $S_2$.

*Construction*:
1. Construct a new string $S = S_1 + \# + S_2 + \$$, where $\#$ and $\$$ are unique separators smaller than any character in the alphabet of $S_1, S_2$, and $\# != \$$.
2. Build the Suffix Array (SA) and LCP array for $S$.

*Algorithm*:
Iterate through the $"LCP"$ array. For every adjacent pair of suffixes in the sorted order, $u = "SA"[i]$ and $v = "SA"[i-1]$, check if they belong to different original strings.
If they do, then $"LCP"[i]$ is the length of a common substring. We want the maximum such length.
```
1. S = S1 + "#" + S2 + "$"
2. Build SA and LCP for S
3. max_len = 0
4. For i = 1 to |S|-1:
5.   u = SA[i], v = SA[i-1]
6.   // Check if suffixes start in different strings
7.   If (u < |S1| and v > |S1|) or (u > |S1| and v < |S1|):
8.     max_len = max(max_len, LCP[i])
9. Return max_len
```

We use the index relative to $|S_1|$ to check origin. The separators are not strictly needed for this check, but the length $|S_1|$ is.
Let $N = |S_1|$.
- If $"SA"[i] < N$, the suffix starts in $S_1$.
- If $"SA"[i] > N$, the suffix starts in $S_2$.

If $S_1$ and $S_2$ share a substring $w$, there is a suffix in $S_1$ starting with $w$ and a suffix in $S_2$ starting with $w$. In the Suffix Array, all suffixes starting with $w$ will appear consecutively in a contiguous block.
Within this block, there must be at least one position where a suffix from $S_1$ is immediately followed by a suffix from $S_2$ (or vice-versa). We pick maximum LCP of the block, which is equivalent to $|w|$.

*Complexity*: $O(|S_1| + |S_2|)$ time and space.
