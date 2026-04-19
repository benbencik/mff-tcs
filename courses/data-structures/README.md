# Data Structures 1: Lecture Notes

This repository advanced study notes for the Data Structures 1 course (NTIN066) from the Faculty of Mathematics and Physics, Charles University in Prague, for the academic year 2025/2026. These notes were created by AI, reviewed, and edited by a human, serving as supplementary learning material. They may not be an exact representation of the course content, and some parts might be omitted. Feel free to fix any mistakes and improve the text.

## Topics

- Dynamic Arrays and Amortization
- Splay Trees
- (a,b)-Trees and B-Trees
- Cache-Aware and Cache-Oblivious Algorithms
- Universal Hashing and Hash Functions
- Range Trees and Geometric Data Structures
- Suffix Arrays and String Algorithms

## Typst

Typst is very user friendly. Like if markdown and latex had a baby. They have good docs and it is fast. Compile as follows:

```bash
cd courses/data-structures
typst compile --root ../.. main.typ data-structures.pdf
```

Or with watch mode for continuous updates:
```bash
typst watch --root ../.. main.typ data-structures.pdf
```

All notes use the shared `shared/lib.typ` for consistent styling and notation.
