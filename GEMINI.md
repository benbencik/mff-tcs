# GEMINI.md — Unified Writing & Workflow Guide

This is the single authoritative instruction file for working in this repository.

## 1) Repository purpose

This repository contains course-organized study notes written in Typst.

Goals:
- Produce clear, correct, exam-oriented notes in English (B2-level clarity).
- Keep notation and visual style consistent across courses.
- Keep source material traceable (lecture PDFs, syllabi, and course outlines).

## 2) Directory structure

```text
shared/
  lib.typ                       # Shared macros/styles used by all courses
  template/course-template/     # Copyable starter for new courses

courses/<course>/
  main.typ                      # Course entry file
  notes/*.typ                   # Chapter/topic files
  figs/                         # Course-local figures only
  sources/                      # Course source PDFs/materials
  course-contents.txt           # Topic/source mapping for that course
```

Rules:
- Do not create root-level `figs/`; figures stay in each course's `figs/`.
- Use shared macros from `shared/lib.typ`.
- Keep course-specific behavior in `main.typ`.

## 3) Typst import/include conventions

- In `main.typ`:
  - `#import "../../shared/lib.typ": *`
- In `courses/<course>/notes/*.typ`:
  - `#import "../../../shared/lib.typ": *`
- Include chapters from `main.typ` with `#include "notes/<file>.typ"`.

## 4) How to write notes

For each lecture/topic:
1. Read relevant files in `sources/` and `course-contents.txt` first.
2. Extract core definitions, theorems, lemmas, algorithms, and proof ideas.
3. Rephrase into concise study notes; avoid historical digressions.
4. Add reinforcement material:
   - 3–5 review questions per major section.
   - Worked examples where helpful.
5. Keep chapter order aligned with lecture order: lecture *n* should map to chapter *n* in notes whenever feasible.

Style/content rules:
- Do not create new `exam_question` items unless they are explicitly part of the predefined exam set for that course.
- Prefer short paragraphs and bullet points for readability.
- Each chapter should start on a new page (done via chapter flow in `main.typ`).
- Use shared macros for structured content:
  - `#definition(title)[body]`
  - `#theorem(title)[body]`
  - `#lemma(title)[body]`
  - `#proof[body]`
  - `#question(...)` for AI-generated control/review questions
  - `#exam_question(...)` for fixed, predetermined exam questions only
  - `#example(...)`

## 5) Figures and assets

- Put figures only in `courses/<course>/figs/`.
- In note files, reference figures explicitly, e.g.:
  - `#fig("../figs/my-figure.png")`
- Do not move figures into shared/global asset folders.

## 6) Typst usage essentials

Typst is not LaTeX:
- Do not use backslash-prefixed LaTeX commands.
- Use Typst math mode with `$...$`.
- For symbols, use Typst syntax (e.g., `#sym.alpha`) or proper math expressions.

Common syntax:
- Bold: `*bold*`
- Italic: `_italic_`
- Inline math: `$x^2$`
- Block math: `$ x^2 + y^2 = z^2 $`

Math notes:
- Use plain variables in math (`$T$`, `$n$`, `$P$`).
- Use grouped subscripts/superscripts for multi-char labels (`$h_(new)$`).
- Use strings in math mode with quotes (`$"text"$`).

## 7) Build and verification workflow

From repository root:

```bash
typst compile --root . courses/<course>/main.typ
```

From inside a course directory:

```bash
cd courses/<course>
typst compile --root ../.. main.typ
typst watch --root ../.. main.typ
```

Before finishing significant edits:
- Compile the affected course.
- If shared lib changed, compile all courses.

## 8) Quality checklist

- Typst syntax is valid (document compiles).
- Shared macros are used consistently.
- Figure paths are course-local and correct.
- Content matches source materials.
- Notes are clear and exam-focused.
