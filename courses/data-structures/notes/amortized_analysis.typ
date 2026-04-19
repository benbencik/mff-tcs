#import "../../../shared/lib.typ": *

= Amortized Analysis


*Amortized analysis* provides a way to analyze the average performance of a sequence of operations, even when individual operations may be expensive. Unlike average-case analysis (which assumes probability distributions), amortized analysis considers the worst-case sequence of operations.

#definition("Amortized Cost")[
  The amortized cost of an operation is the average cost per operation over a worst-case sequence of operations. If $n$ operations have total cost $T(n)$, the amortized cost per operation is $T(n)/n$.
]

== The Potential Method

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

== Application: Dynamic Arrays
#question("Dynamic Array")[
  Describe a dynamic array, i.e., an "inflatable array" with growing and shrinking. Analyze its amortized complexity.
]

A dynamic array is a resizable array that automatically grows and shrinks. It maintains:
- *Size* $s$: Number of elements currently stored
- *Capacity* $c$: Allocated space ($c >= s$)

=== Operations and Resizing Strategy

- *Insert*: Add element at the end. If $s = c$, allocate new array of size $2c$, copy all elements.
- *Delete*: Remove element from the end. If $s = c/4$, allocate new array of size $c/2$, copy all elements.

  Shrinking at $1/4$ (not $1/2$) prevents thrashing: alternating insert/delete won't trigger repeated resizing.

=== Amortized Analysis

Let us analyze the cost of an arbitrary sequence of $m$ operations (inserts and deletes). We divide the sequence into *blocks*, where each block ends when the array is reallocated (or when the sequence ends).

- The first block starts with capacity 1, so its reallocation takes constant time.
- The last block does not end with a reallocation.
- Consider any other block. It starts immediately after a reallocation, so at the beginning of the block, the number of elements is $s = c/2$.
  - If the block ends with a *growth* (because $s$ reached $c$), the size must have increased from $c/2$ to $c$. Thus, at least $c - c/2 = c/2$ insertions must have occurred in this block.
  - If the block ends with a *shrink* (because $s$ dropped to $c/4$), the size must have decreased from $c/2$ to $c/4$. Thus, at least $c/2 - c/4 = c/4$ deletions must have occurred.

In either case, a block ending with a reallocation of cost $Theta(c)$ contains at least $c/4 = Theta(c)$ operations. We can redistribute the cost of the reallocation to these operations, increasing the cost of each operation by a constant amount.

