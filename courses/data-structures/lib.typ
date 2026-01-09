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
    // stroke: gray,
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "bold", fill: black)
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
    stroke: black,
    inset: 1.2em,
    // radius: 6pt,
    width: 100%,
    [
      // #set text(weight: "bold", fill: rgb("#b45309"))
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
    // stroke: (left: 2pt + gray),
    // inset: 1.2em,
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

#let observation(body) = {
  block(
    fill: rgb("#f0fdf4"),
    stroke: rgb("#16a34a"),
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    [
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #body
    ]
  )
  v(0.8em)
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
// EXAM QUESTION COMPONENTS
// ============================================================

#let big_question(title, body) = {
  block(
    stroke: rgb("#ff9999"),
    fill: rgb("#fff3f3"),
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
    fill: rgb("#fffbe6"),
    inset: 1em,
    radius: 5pt,
    width: 100%,
    [
      *#title* \
      #emph(body)
    ]
  )
}

// Page Layout Constants
#let section-spacing = 1.5em
#let subsection-spacing = 1em
#let paragraph-spacing = 0.5em
