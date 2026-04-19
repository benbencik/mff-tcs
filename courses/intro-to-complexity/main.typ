#import "../../shared/lib.typ": *


#set document(
  title: "Introduction to Complexity and Computability: Lecture Notes",
  author: "Benjamín Benčík",
  date: auto
)

#show: page-setup
#v(1cm)
#align(center, text(
  2em,
  weight: "bold",
  "Introduction to Complexity and Computability: Lecture Notes",
))
#align(center, text(
  1.2em,
  "Faculty of Mathematics and Physics, Charles University in Prague",
))
#align(center, text(1.2em, "Created by AI, reviewed and edited by human"))
#align(center, text(
  1.2em,
  "2025/2026, Course code: NTIN090",
))
#v(0.5cm)
#align(center)[
  This document was created as learning material for the course. It is not an exact representation of the course; some parts may be omitted. Feel free to fix any mistakes and improve the text.
]

#outline(indent: auto)

#include "notes/01_turing_machines.typ"
#include "notes/02_computability.typ"
#include "notes/03_space_hierarchy.typ"
#include "notes/04_time_hierarchy.typ"
#include "notes/05_np_completeness.typ"
#include "notes/06_reductions.typ"
#include "notes/07_fpt_algorithms.typ"
#include "notes/08_counting_complexity.typ"
#include "notes/09_complementary_classes.typ"
#include "notes/10_advanced_topics.typ"