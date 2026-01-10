#import "../lib.typ": *

= Splay Trees

#big_question("Splay Tree")[
  Define a Splay tree. Describe how the Splay, Find, Insert, and Delete operations work on it. Describe the advantages and disadvantages compared to other data structures, especially balanced search trees. State and prove the theorem about the amortized complexity of the Splay operation.
]

#definition("Splay Tree")[
  A Splay tree is a self-adjusting binary search tree (BST) with the additional property that recently accessed elements are quick to access again. It performs basic operations such as insertion, look-up, and removal in $O(log n)$ amortized time.
]

=== Splay Operation

The core operation is *Splay(x)*, which moves node $x$ to the root using a sequence of rotations.

#fig("splay-rotatios.png", width: 80%)

*Splay(x)*: Depending on the structure of the tree around $x$, we perform one of three steps until $x$ is the root:
   - *Zig Step*: Standard single rotation executed when $"parent"(x)$ is the root.
   - *Zig-Zig Step*: Executed when $"parent"(x)$ is not root moreover $x$ and $"parent"(x)$ are both left or both right children. Rotate $"parent"(x)$ with $"parent"("parent"(x))$, then rotate $x$ with $"parent"(x)$.
   - *Zig-Zag Step*: Executed when $p(x)$ is not root and $x$ is a left child while $p(x)$ is a right child (or vice versa). Rotate $x$ with $"parent"(x)$, then rotate $x$ with $"parent"("parent"(x))$.

=== Advantages and Disadvantages

#table(
  columns: (1fr, 1fr),
  inset: 10pt,
  align: horizon,
  [*Advantages*], [*Disadvantages*],
  [Amortized Efficiency: $O(log n)$ for all operations.], [Worst Case: $O(n)$ for a single operation (linear height possible).],
  [Locality of Reference: Frequently accessed nodes stay near the root.], [No benefit on randomized data],
  [Simplicity: No extra storage required for balance information.], [Modifies on Read: `Find` changes the tree structure (concurrency issues).]
)

=== Amortized Analysis of Splay

#observation[
  For any positive $alpha, beta$ it holds $log(alpha) + log(beta) <= 2log(alpha + beta) - 2$

From the image below for concave functions it holds that $ (log(alpha) + log(beta)) / 2 <= log((alpha + beta) / 2)$. Since $log((alpha + beta) / 2) = log(alpha+beta)-1$ we get the above claim. 

#fig("splay-lemma.png", width: 80%)
]

#theorem("Access Lemma")[
  The amortized cost of the `Splay(x)` operation is at most $3(r(root) - r(x)) + 1 = O(log n)$, where $r(x)$ is the rank of node $x$.
]

#proof[
  We use the *Potential Method*.
  1. *Definitions*:
     - $s(x)$: Size of the subtree rooted at $x$ (number of nodes).
     - $r(x)$: Rank of $x$, defined as $log_2 s(x)$.
     - Potential function $Phi = sum_{x in T} r(x)$.
  2. *Amortized Cost*: The amortized cost of a step is $A_i = C_i + Phi_i - Phi_{i-1}$, where $C_i$ is the number of rotations (1 for Zig, 2 for Zig-Zig/Zig-Zag).
  3. *Analysis of Steps*:
     We use the inequality $log alpha + log beta <= 2 log(alpha + beta) - 2$ (derived from concavity of log).
     Let $x$ be the node being splayed, $p$ its parent, and $g$ its grandparent. Let $r$ be ranks before and $r'$ after the step.
     
     - *Zig (x is child of root):*
       $ A_"zig" = 1 + r'(x) + r'(p) - r(x) - r(p) $
       Since $r'(p) < r'(x)$ and $r(x) < r(p)$, we have $A_"zig" <= 1 + 3(r'(x) - r(x))$.
     
     - *Zig-Zig (x and p are both left or both right children):*
       $ A_"zig-zig" = 2 + r'(x) + r'(p) + r'(g) - r(x) - r(p) - r(g) $
       Using $r'(g) = r(x)$ and applying the log sum inequality to $s(x) + s'(g)$, we can simplify this to:
       $ A_"zig-zig" <= 3(r'(x) - r(x)) $
       
     - *Zig-Zag (x is inner grandchild):*
       $ A_"zig-zag" = 2 + r'(x) + r'(p) + r'(g) - r(x) - r(p) - r(g) $
       Using the log sum inequality on pairs of subtrees, we similarly derive:
       $ A_"zig-zag" <= 3(r'(x) - r(x)) $

  4. *Total Cost*: Summing over the sequence of $k$ steps telescopes the ranks. Let $r_0(x)$ be the initial rank and $r_k(x)$ be the final rank.
     $ sum A_"step" <= 1 + sum_(i=1)^k 3(r_i (x) - r_(i-1)(x)) = 1 + 3(r_k (x) - r_0 (x)) $
     Since $r_k (x) = r("root") = log n$ and $r_0 (x) <= log n$, the cost is $O(log n)$.
]


#small_question("Splay Operations (Design & Analysis)")[
  Design Find, Insert, and Delete operations on a Splay tree. Analyze their amortized complexity. It is sufficient to state the theorem about the complexity of the Splay operation, you do not need to prove it.
]

=== Splay Operations

*Find(x)*:
```
1. v = TreeSearch(x)
2. If v != null:
3.   Splay(v)
4.   Return v
5. Else:
6.   Splay(last_visited_node)
7.   Return null
```
The operation `Splay` traverses the path in the other direction. Since, `splay` has complexity $cal(O)(log(n))$, we can claim that also the search has complexity $cal(O)(log(n))$. We are not changing the potential of the tree therefore, the find is logarithmic in amortized complexity.


*Insert(x)*:
```
1. Standard BST Insert(x) -> new node v
2. Splay(v)
```
Adding a leaf to the tree increases potential by $O(log n)$. Let $v_1, ..., v_(t+1)$ denote the path from the root $v_1$ to the new leaf $v_(t+1)$. Use $r(v_i)$ for the rank before the operation and $r'(v_i)$ for the new rank. The potential difference is: $ Delta Phi = r'(v_(t+1)) + sum_(i=1)^t (r'(v_i) - r(v_i)) $
  
  As leaves have size 1, the rank $r'(v_(t+1)) = 0$. For the other ranks: we know that $s'(v_i) = s(v_i) + 1$, which is at most $s(v_(i-1))$. So for $i > 1$, we have $r'(v_i) <= r(v_(i-1))$. The sum telescopes:
  $ Delta Phi <= r'(v_1) - r(v_t) = O(log n) $
  
  The total amortized cost of `Insert` is therefore $O(log n)$.

*Delete(x)*:
```
1. Find(x) // Splays x to root
2. T_L = x.left, T_R = x.right
3. Delete node x
4. If T_L is empty: Root = T_R
5. Else:
6.   m = Max(T_L)
7.   Splay(m) // in T_L, making m the root of T_L
8.   m.right = T_R
9.   Root = m
```
This has the same complexity as the find but we also delete the element. Deleting the element has constant real cost and the potential decreses in our favor. Therefore we can upperbound the amortized complexity is logarithmic.