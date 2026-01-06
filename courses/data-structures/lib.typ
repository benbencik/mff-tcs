// ============================================================
// GLOBAL LIBRARY: Styling, components, and definitions
// ============================================================

#import "@preview/algorithmic:1.0.7": *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// ============================================================
// DOCUMENT CONFIGURATION
// ============================================================

#let page-setup() = {
  set page(
    paper: "a4",
    margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),
    numbering: "1",
    header: [
      #set text(size: 9pt, fill: gray)
      #emph("Master's Studies Notes")
    ],
    footer: [
      #set text(size: 9pt, fill: gray)
      #align(right, [#counter(page).display()])
    ]
  )
  
  set text(
    font: "New Computer Modern",
    size: 11pt,
    lang: "en"
  )
  
  set heading(numbering: "1.1.1")
  
  show heading: it => {
    set text(weight: "bold", fill: rgb("#1f4788"))
    it
    v(0.5em)
  }
}

// ============================================================
// FIGURE HELPER
// ============================================================

#let fig(filename, width: 80%, caption: none) = {
  let img = image("figs/" + filename)
  if caption != none {
    figure(
      img,
      caption: caption
    )
  } else {
    figure(img)
  }
}

// ============================================================
// DEFINITION BOX
// ============================================================

#let definition(title, body) = {
  block(
    fill: rgb("#f0f4f8"),
    stroke: rgb("#2c5aa0"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#1f4788"))
      *Definition: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// THEOREM BOX
// ============================================================

#let theorem(title, body) = {
  block(
    fill: rgb("#fffbf0"),
    stroke: rgb("#d97706"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#b45309"))
      *Theorem: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// LEMMA BOX
// ============================================================

#let lemma(title, body) = {
  block(
    fill: rgb("#f3f0ff"),
    stroke: rgb("#7c3aed"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#6d28d9"))
      *Lemma: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// PROOF BOX
// ============================================================

#let proof(body) = {
  block(
    fill: rgb("#fafaf9"),
    stroke: rgb("#78716c"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(style: "italic", fill: rgb("#5a524c"))
      *Proof.*
      #set text(style: "normal", fill: black)
      #v(0.2em)
      #body
      #h(1fr)
      $square$
    ]
  )
  v(0.8em)
}

// ============================================================
// EXAMPLE BOX
// ============================================================

#let example(title, body) = {
  block(
    fill: rgb("#f0fdf4"),
    stroke: rgb("#16a34a"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#166534"))
      *Example: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// SOLUTION BOX
// ============================================================

#let solution(body) = {
  block(
    fill: rgb("#f5f3ff"),
    stroke: rgb("#a78bfa"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#6d28d9"))
      *Solution:*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// REMARK BOX
// ============================================================

#let remark(body) = {
  block(
    fill: rgb("#fef3c7"),
    stroke: rgb("#f59e0b"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#d97706"))
      *Remark:*
      #set text(weight: "regular", fill: black)
      #v(0.2em)
      #body
    ]
  )
  v(0.8em)
}

// ============================================================
// QUESTION FORMATTING
// ============================================================

#let question(number, title, body) = {
  v(0.5em)
  [
    #set text(weight: "bold")
    *Question #number: #title*
  ]
  body
}

// ============================================================
// ALGORITHM BLOCK
// ============================================================

#let algorithm-block(name, pseudocode) = {
  block(
    fill: rgb("#f9fafb"),
    stroke: rgb("#374151"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: rgb("#111827"))
      Algorithm: #name
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #pseudocode
    ]
  )
  v(0.8em)
}

// ============================================================
// COMPLEXITY NOTATION
// ============================================================

#let complexity(time: none, space: none) = {
  let content = ""
  if time != none {
    content += "*Time:* $O(" + str(time) + ")$"
  }
  if space != none {
    if time != none {
      content += " / "
    }
    content += "*Space:* $O(" + str(space) + ")$"
  }
  
  block(
    fill: rgb("#ecfdf5"),
    stroke: rgb("#059669"),
    inset: 0.8em,
    radius: 4pt,
    [
      #set text(size: 10pt, fill: rgb("#065f46"))
      #content
    ]
  )
  v(0.5em)
}

// ============================================================
// TABLE OF CONTENTS HELPER
// ============================================================

#let toc-entry(level, title, page) = {
  let indent = (level - 1) * 1.5em
  [#h(indent)#title #h(1fr) #page]
}

// ============================================================
// EXAM QUESTION COMPONENTS
// ============================================================

#let big_question(title, body) = {
  block(
    stroke: rgb("#ff9999"),
    inset: 1em,
    radius: 5pt,
    width: 100%,
    [
      *#title* \
      #emph(body)
    ]
  )
}

#let small_question(title, body) = {
  block(
    stroke: rgb("#ffd399"),
    inset: 1em,
    radius: 5pt,
    width: 100%,
    [
      *#title* \
      #emph(body)
    ]
  )
}

#let observation(body) = {
  block(
    width: 100%,
    inset: (left: 1em),
    stroke: (left: 2pt + gray),
    [
      *Observation* \
      #text(fill: luma(80), emph(body))
    ]
  )
}

// ============================================================
// DEFINITIONS: Global notation and terminology
// ============================================================

// Mathematical Notation
#let O = $O$
#let Theta = $Theta$
#let Omega = $Omega$
#let amortized = "amortized"
#let worst-case = "worst-case"
#let expected = "expected"

#let time-complexity(expr) = $O(#expr)$
#let space-complexity(expr) = $O(#expr)$

// Data Structure Notation
#let BST = "Binary Search Tree (BST)"
#let AVL = "AVL Tree"
#let RBT = "Red-Black Tree"
#let splay-operation = "splay operation"
#let splay = "splay"

// Complexity Terminology
#let linear = $O(n)$
#let logarithmic = $O(log n)$
#let linearithmic = $O(n log n)$
#let quadratic = $O(n^2)$
#let exponential = $O(2^n)$

// Algorithm Analysis Terms
#let amortized-bound = "amortized bound"
#let potential-method = "potential method"
#let accounting-method = "accounting method"
#let cache-aware = "cache-aware"
#let cache-oblivious = "cache-oblivious"
#let I-O-model = "I/O model"

// Hashing Terms
#let universal-hash = "universal hash family"
#let c-universal = "c-universal"
#let k-independent = "k-independent"
#let load-factor = "load factor"

// Mathematical Symbols
#let emptyset = $emptyset$
#let union(a, b) = $#a union #b$
#let intersection(a, b) = $#a sect #b$

#let sum(expr, from: "", to: "") = {
  if from == "" and to == "" {
    $sum #expr$
  } else if to == "" {
    $sum_{#from} #expr$
  } else {
    $sum_{#from}^{#to} #expr$
  }
}

#let product(expr, from: "", to: "") = {
  if from == "" and to == "" {
    $product #expr$
  } else if to == "" {
    $product_{#from} #expr$
  } else {
    $product_{#from}^{#to} #expr$
  }
}

// Theorem/Proof Conventions
#let assume-contra(stmt) = [Assume for contradiction that $#stmt$.]
#let qed = $square$

// Formatting Conventions
#let func(name) = text(weight: "bold", $"" + name + ""$)
#let var(name) = $name$
#let keyword(word) = text(weight: "bold", word)

// Course-Specific Notation
#let array-size = $n$
#let array-capacity = $c$
#let tree-height = $h$
#let tree-depth = $d$
#let node-degree = $deg$

// Page Layout Constants
#let section-spacing = 1.5em
#let subsection-spacing = 1em
#let paragraph-spacing = 0.5em
