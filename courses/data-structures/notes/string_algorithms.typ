#import "../lib.typ": *

= String Algorithms

#big_question("Suffix Array & LCP")[
  Define a suffix array and an LCP array. Describe and analyze algorithms for their construction (for suffix arrays, almost linear time is sufficient). Describe an example problem that these arrays can solve effectively.
]

#definition("Suffix Array (SA)")[
  Let $S$ be a string of length $n$. The Suffix Array $"SA"$ is a permutation of indices ${0, ..., n-1}$ such that $S["SA"[0]..] < S["SA"[1]..] < ... < S["SA"[n-1]..]$ lexicographically. Essentially, it stores the starting indices of all suffixes of $S$ in sorted order.

  The inverse suffix array is called *rank array* $R[i]$, which determines the lexicographic position of suffix $"SA"[I:]$.
]

#definition("LCP Array")[
  The Longest Common Prefix array stores the length of the common prefix between consecutive suffixes in the suffix array.
  $ "LCP"[i] = "length"("LCP"(S["SA"[i-1]..], S["SA"[i]..])) $
  Defined for $i=1..n-1$. $"LCP"[0]$ is usually undefined or 0.
]

=== Construction: Prefix Doubling (Karp-Miller-Rosenberg)
Goal: Construct SA in $O(n log n)$. 
We iteratively sort suffixes by their prefixes of length $2^k$. In the first step, we sort by the first character. In step $k$, assuming we have computed ranks for prefixes of length $k$ (where $k$ is a power of 2), we can determine the order for length $2k$ by comparing pairs of ranks $(R[i], R[i+k])$. The first component determines the order of the first half (length $k$), and the second component determines the order of the second half. We repeat this doubling until the prefix length covers the whole string.


=== Construction: LCP Array (Kasai's Algorithm)
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

=== Applications: Pattern Matching
Find $P$ in $S$.
- Binary search on $"SA"$. Comparison takes $O(|P|)$. Total $O(|P| log n)$.
- With $"LCP"$ and precomputed $"RMQ"$ (Range Minimum Query), can be $O(|P| + log n)$.

#small_question("Longest Common Substring")[
  Show how to use a suffix array and an LCP array to find the longest common substring of two strings.
]

=== Longest Common Substring

*Problem*: Find the longest string that is a substring of both $S_1$ and $S_2$.

*Algorithm LongestCommonSubstring*:
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

*Why adjacent?*
If a substring is common to both, it appears as a prefix of some suffix in $S_1$ and some suffix in $S_2$. In the sorted $"SA"$, these suffixes will be close. The $"LCP"$ between any two suffixes is the minimum $"LCP"$ in the interval between them. Thus, the maximum $"LCP"$ between a type-1 and type-2 suffix must occur when they are adjacent in $"SA"$ (or separated by suffixes that share an even longer prefix, which would eventually be checked).

*Complexity*: $O(|S_1| + |S_2|)$ time and space.
