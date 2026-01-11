#import "../lib.typ": *

= Amortized Analysis

#small_question("Dynamic Array")[
  Describe a dynamic array, i.e., an "inflatable array" with growing and shrinking. Analyze its amortized complexity.
]

=== Introduction

*Amortized analysis* provides a way to analyze the average performance of a sequence of operations, even when individual operations may be expensive. Unlike average-case analysis (which assumes probability distributions), amortized analysis considers the worst-case sequence of operations.

#definition("Amortized Cost")[
  The amortized cost of an operation is the average cost per operation over a worst-case sequence of operations. If $n$ operations have total cost $T(n)$, the amortized cost per operation is $T(n)/n$.
]

=== The Potential Method

The *potential method* is a technique for amortized analysis that assigns a "potential" $Phi$ to the data structure state.

#definition("Potential Method")[
  Define a potential function $Phi: "states" -> RR$ where:
  - $Phi("initial state") = 0$
  - $Phi("any state") >= 0$

  The *amortized cost* of operation $i$ is:
  $ hat(C)_i = C_i + Delta Phi_i = C_i + (Phi_i - Phi_(i-1)) $

  where $C_i$ is the actual (real) cost of operation $i$.
]

The total actual cost of $n$ operations is:
$
  sum_(i=1)^n C_i = sum_(i=1)^n hat(C)_i - (Phi_n - Phi_0) = sum_(i=1)^n hat(C)_i - Phi_n <= sum_(i=1)^n hat(C)_i
$

Thus, if we can bound each $hat(C)_i$, we bound the total cost.

=== Application: Dynamic Arrays

#definition("Dynamic Array")[
  A dynamic array is a resizable array that automatically grows and shrinks. It maintains:
  - *Size* $s$: Number of elements currently stored
  - *Capacity* $c$: Allocated space ($c >= s$)
]

==== Operations and Resizing Strategy

- *Insert*: Add element at the end. If $s = c$, allocate new array of size $2c$, copy all elements.
- *Delete*: Remove element from the end. If $s = c/4$, allocate new array of size $c/2$, copy all elements.

  Shrinking at $1/4$ (not $1/2$) prevents thrashing: alternating insert/delete won't trigger repeated resizing.

==== Amortized Analysis with Potential Method

*Potential Function:*
$
  Phi = cases(
    2s - c quad & "if" s >= c/2,
    c/2 - s quad & "if" s < c/2
  )
$

Note: $Phi >= 0$ always, and $Phi = 0$ initially.

*Analysis of Insert:*

1. *No resize* ($s < c$):
  - Real cost: $C_i = 1$
  - If $s >= c/2$: $Delta Phi = 2$, so $hat(C)_i = 1 + 2 = 3$
  - If $s < c/2$: $Delta Phi = -1$, so $hat(C)_i = 1 - 1 = 0$
  - Amortized cost: $O(1)$

2. *Resize needed* ($s = c$):
  - Real cost: $C_i = c + 1$ (copy $c$ elements + insert)
  - Before: $s = c$, $Phi = 2c - c = c$
  - After: $s = c + 1$, $c' = 2c$, $Phi' = 2(c+1) - 2c = 2$
  - $Delta Phi = 2 - c$
  - Amortized cost: $hat(C)_i = (c + 1) + (2 - c) = 3 = O(1)$

*Analysis of Delete:*

1. *No resize* ($s > c/4$):
  - Real cost: $C_i = 1$
  - $|Delta Phi| <= 2$
  - Amortized cost: $hat(C)_i <= 3 = O(1)$

2. *Resize needed* ($s = c/4$):
  - Real cost: $C_i = c/4 + 1$ (copy $c/4$ elements + delete)
  - Before: $s = c/4$, $Phi = c/2 - c/4 = c/4$
  - After: $s = c/4 - 1$, $c' = c/2$, $Phi' approx 0$
  - $Delta Phi approx -c/4$
  - Amortized cost: $hat(C)_i = (c/4 + 1) - c/4 = 1 = O(1)$

#theorem("Dynamic Array Amortized Complexity")[
  Using the potential method, both insert and delete operations on a dynamic array have $O(1)$ amortized cost.
]

==== Key Insight

Between any two consecutive resizing operations, at least $c/4$ regular operations must occur:
- After doubling to size $c$, need $c/2$ inserts to fill again
- After halving to size $c$, need $c/4$ deletes to trigger shrink

Since resizing costs $O(c)$ and happens every $Omega(c)$ operations, the cost is "spread out" to $O(1)$ per operation.
