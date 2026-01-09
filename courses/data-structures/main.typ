#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
)
#set text(
  font: "New Computer Modern",
  size: 11pt,
  lang: "en"
)
#set heading(numbering: "1.1.")

// --- Imports ---
#import "lib.typ": *

// --- Document Content ---

#align(center, text(1.5em)[*Data Structures Exam Preparation*])
#v(2em)

#outline(indent: auto)
#pagebreak()

// Chapters: each starts on a new page
#include "notes/amortized_analysis.typ"
#pagebreak()
#include "notes/splay_trees.typ"
#pagebreak()
#include "notes/ab_trees.typ"
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
