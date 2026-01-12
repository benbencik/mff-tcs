#import "lib.typ": *
#set heading(numbering: "1.1.")

#set document(
  title: "Data Structures 1: Lecture Notes",
  author: "Benjamín Benčík",
  date: auto
)

#v(1cm)
#align(center, text(
  2em,
  weight: "bold",
  "Data Structures 1: Lecture Notes",
))

#align(center, text(
  1.2em,
  "Faculty of Mathematics and Physics, Charles University in Prague",
))

#align(center, text(1.2em, "Created by AI reviewed and edited by human"))

#align(center, text(
  1.2em,
  "2025/2026, Course code: NTIN066",
))



#v(0.5cm)
#align(center)[
  This document was created as learning material for the course. It is not exact representation of the course, some parts may be omitted. Feel free to fix any mistakes and improve the text.
]


#outline(indent: auto)
#pagebreak()

// Chapters: each starts on a new page
#include "notes/amortized_analysis.typ"
#pagebreak()
#include "notes/ab_trees.typ"
#include "notes/splay_trees.typ"
#include "notes/bb_alpha.typ"
#pagebreak()
#pagebreak()
#include "notes/cache_algorithms.typ"
#pagebreak()
#include "notes/hashing.typ"
#pagebreak()
#include "notes/string_algorithms.typ"
#pagebreak()
#include "notes/range_trees.typ"
#pagebreak()
#include "notes/parallel_algorithms.typ"
