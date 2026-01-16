#import "../lib.typ": *

= Turing Machines and Computation Models

#definition("Turing Machine")[
  A (one-tape deterministic) Turing Machine is a 5-tuple $M = (Q, Sigma, delta, q_0, F)$, where:
  - $Q$ is a finite set of states.
  - $Sigma$ is a finite tape alphabet containing a blank symbol $lambda$.
  - $delta: Q times Sigma -> Q times Sigma times {L, N, R} union {bot}$ is the transition function, where $bot$ denotes an undefined transition.
  - $q_0 in Q$ is the initial state.
  - $F subset.eq Q$ is the set of accepting states.
]

The machine operates on an infinite tape divided into cells. Each cell contains a symbol from $Sigma$. The machine has a head that can read and write symbols and move left ($L$), right ($R$), or stay ($N$).

The computation starts in the initial state $q_0$ with the input string written on the tape and the head positioned at the leftmost symbol. All other cells contain the blank symbol $lambda$.

#definition("Configuration")[
  A configuration of a TM captures the current state of the computation. It consists of:
  - The current state $q in Q$.
  - The content of the tape (non-blank portion).
  - The position of the head.
]

A computation step is determined by the current state $q$ and the symbol $a$ under the head. If $delta(q, a) = (q', a', D)$, the machine:
1. Changes state to $q'$.
2. Writes $a'$ to the current cell.
3. Moves the head according to $D in {L, N, R}$.

The computation stops if the transition is undefined ($bot$). If the machine stops in a state $q in F$, the input is *accepted*. Otherwise, it is *rejected*.


There are several variants of Turing machines, such as:
- *Multi-tape TM:* Has $k$ tapes, each with its own head.
- *Two-way infinite tape TM:* The tape extends infinitely in both directions.
- *Nondeterministic TM:* The transition function maps to a set of possible next moves.

All these variants are equivalent in power to the standard single-tape deterministic TM.

#theorem("Equivalence of k-tape and 1-tape TM")[
  For every $k$-tape Turing machine $M$, there exists a single-tape Turing machine $M'$ that accepts the same language and computes the same function.
]


#question("(B2) RAM and equivalence with Turing machines")[
  Explain the Random Access Machine (RAM) model and prove its equivalence with Turing machines.
]

== Random Access Machine (RAM)

The Random Access Machine (RAM) is a model closer to real-world computers. It consists of a CPU and an unbounded memory organized into registers $r_0, r_1, dots$, each capable of holding an arbitrary natural number.

A RAM program is a sequence of instructions. Common instructions include:
- `LOAD(C, ri)`: Load constant $C$ into $r_i$.
- `ADD(ri, rj, rk)`: $r_k arrow [r_i] + [r_j]$.
- `SUB(ri, rj, rk)`: $r_k arrow max([r_i] - [r_j], 0)$.
- `COPY([rp], rd)`: Indirect addressing (load from address in $r_p$).
- `COPY(rs, [rd])`: Indirect addressing (store to address in $r_d$).
- `JNZ(ri, label)`: Jump if $[r_i] > 0$.
- `READ(ri)`: Read input into $r_i$.
- `PRINT(ri)`: Print $[r_i]$.


A key result in computability theory is that RAMs and Turing machines are equivalent in computational power.

#theorem("Equivalence of RAM and TM")[
  For every RAM program, there exists an equivalent Turing machine, and for every Turing machine, there exists an equivalent RAM program.
]

#proof[
  The proof involves constructing simulations in both directions.

  *RAM $==>$ Turing Machine*

  We construct a multi-tape Turing machine $M$ to simulate a RAM program $R$. $M$ uses 4 tapes:
  - *Input Tape:* Read-only, contains the input string.
  - *Memory Tape:* Stores the content of the RAM registers. We store pairs $(i, c(i))$ for every non-zero register $r_i$ with value $c(i)$. The format is $\# i_1 \# v_1 \# i_2 \# v_2 dots$, where $i_j$ is the binary index and $v_j$ is the binary value.
  - *Working Tape:* Used for arithmetic operations and auxiliary data.
  - *Output tape*: Here $M$ writes the same output that $R$ writes on output

  $M$ simulates the execution cycle of $R$:
  1.  *Fetch:* The current instruction is determined by the state of $M$.
  2.  *Execute:*
      -   For `LOAD C, r_i`: $M$ writes $C$ to the Working Tape, scans the Memory Tape for index $i$. If found, it updates the value. If not, it appends $\# i \# C$ to the end.
      -   For `ADD r_i, r_j, r_k`: $M$ finds values of $r_i$ and $r_j$ on the Memory Tape, copies them to the Working Tape, performs addition, and updates $r_k$ on the Memory Tape (shifting the tape content if the length of $v_k$ changes).
      -   For `READ r_i`: $M$ reads a symbol from the Input Tape and stores it in $r_i$.
      -   For `JNZ r_i, label`: $M$ checks if $r_i$ is non-zero on the Memory Tape. If so, it transitions to the state corresponding to `label`.

  Since RAM instructions (arithmetic, memory access) can be simulated by TM subroutines in finite steps (relative to data size), $M$ can simulate $R$.

  *RAM $<==$ Turing Machine*

  We construct a RAM program $R$ to simulate a Turing machine $M = (Q, Sigma, delta, q_0, F)$.

  *Representation:*
  -   The tape is represented by registers. We map cell $k$ to register $r_k$ (mapping $ZZ$ to $NN$ if necessary).
  -   Register $r_{"head"}$ stores the head position.
  -   Register $r_{"state"}$ stores the current state index.

  *Simulation:*
  $R$ runs an infinite loop:
  1.  *Read Symbol:* Use indirect addressing to read the cell under the head: `COPY [r_head], r_symbol`.
  2.  *Transition:* Based on $r_{"state"}$ and $r_{"symbol"}$, determine the next action using conditional jumps.
  3.  *Execute Action:*
      -   Update $r_{"state"}$ to the new state.
      -   Write the new symbol: `COPY r_new_symbol, [r_head]`.
      -   Update $r_{"head"}$ (increment or decrement).
  4.  *Check Termination:* If the new state is accepting/rejecting, $R$ halts.

  Thus, a RAM can simulate a Turing Machine.
]


