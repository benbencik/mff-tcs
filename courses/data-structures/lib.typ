// ============================================================
// GLOBAL LIBRARY: Styling, components, and definitions
// ============================================================

#import "@preview/algorithmic:1.0.7": *
#import "@preview/cetz:0.3.1"

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
    ],
  )

  set text(
    font: "New Computer Modern",
    size: 11pt,
    lang: "en",
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

#let fig(filename, width: 75%, caption: none) = {
  let img = image("figs/" + filename, width: width)
  if caption != none {
    figure(
      img,
      width: width,
      caption: caption,
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
    inset: 1.2em,
    radius: 6pt,
    width: 100%,
    breakable: false,
    [
      #set text(weight: "bold", fill: black)
      *Definition: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #emph[#body]
    ],
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
    width: 100%,
    breakable: false,
    [
      *Theorem: #title*
      #set text(weight: "regular", fill: black)
      #v(0.3em)
      #emph[#body]
    ],
  )
  v(0.8em)
}

// ============================================================
// LEMMA BOX
// ============================================================

#let lemma(title, body) = {
  block(
    width: 100%,
    [
      *Lemma: #title*
      #set text(weight: "regular", fill: black)
      #emph[#body]
    ]
  )
  v(0.8em)
}

// ============================================================
// PROOF BOX
// ============================================================

#let proof(body) = {
  block(
    stroke: (left: 2pt + gray),
    inset: 1.2em,
    width: 100%,
    [
      #set text(style: "italic", fill: rgb("#5a524c"))
      *Proof.*
      #set text(style: "normal", fill: black)
      #v(0.2em)
      #body
      #h(1fr)
      $square$
    ],
  )
  v(0.8em)
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
    ],
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
    ],
  )
}

// Page Layout Constants
#let section-spacing = 1.5em
#let subsection-spacing = 1em
#let paragraph-spacing = 0.5em
