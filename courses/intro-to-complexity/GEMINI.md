# Project: Parametrized algorithms Study Materials

This project aims to create study materials for the "Parametrized Algorithms" course taught at the Faculty of Mathematics and Physics, Charles University in Prague (MFF CUNI).

## Goal

The primary goal is to produce high-quality lecture notes in English (B2 level) for each topic covered in the course.

## Project Structure

- `main.typ`: The main Typst file that combines all chapters.
- `lib.typ`: Specifies common types of boxes and other common logic. This should be included in every file and boxes and other styles from this file should be used.
- `notes/`: This directory contains the individual chapter files in Typst format, organized in logical groups:
  - `01_turing_machines.typ` — Turing machines, RAM, decidability
  - `02_computability.typ` — Decidable and semi-decidable languages, Rice's theorem
  - `03_space_hierarchy.typ` — Space complexity classes and Savitch's theorem
  - `04_time_hierarchy.typ` — Time complexity classes and hierarchy theorems
  - `05_np_completeness.typ` — NP class, Cook-Levin theorem, NP-completeness
  - `06_reductions.typ` — SAT to Vertex Cover and other polynomial reductions
  - `07_fpt_algorithms.typ` — FPT class, kernelization, parameterized algorithms
  - `08_counting_complexity.typ` — #P class and counting problems
  - `09_complementary_classes.typ` — co-NP and complementary complexity classes
  - `10_advanced_topics.typ` — Pseudorandom generators, one-way functions, fine-grained complexity
- `sources/`: This directory contains the source PDF presentations for each lecture.
- `main.pdf`: The compiled output of the project. This file is not versioned.
- `GEMINI.md`: This file, containing the project's documentation.
- `.gitignore`: Specifies files and directories to be ignored by git.

## Output Format

The final study materials will be written in [Typst](https://typst.app/), a modern typesetting system. Each lecture is converted into a single file, which are then included in the main document.
If you want to use images, just add links to the images, do not try to download them.

## Course Structure and Sources

- **course-contents.txt:** Contains the complete course outline with topic references.
- **sources/ directory:** Contains three PDF files:
  
## Notes Organization

Notes should be grouped into 10 logical thematic chapters, each covering related exam questions and concepts:

1. **Turing Machines and Computation Models** (`01_turing_machines.typ`)
   - Turing machine definition and computation
   - Universal Turing machine
   - RAM model and equivalence with Turing machines
   - Covers: B1, B2

2. **Computability and Decidability** (`02_computability.typ`)
   - Decidable and partially decidable languages
   - Closure properties and Post's theorem
   - Enumerators
   - Rice's theorem with proof
   - Covers: A1, B3

3. **Space Complexity** (`03_space_hierarchy.typ`)
   - Space complexity classes and definitions
   - Savitch's theorem
   - Deterministic space hierarchy
   - Covers: A2, A3, B4, B5

4. **Time Complexity** (`04_time_hierarchy.typ`)
   - Time complexity classes and definitions
   - Deterministic time hierarchy
   - Covers: A4, B4, B5

5. **NP and NP-Completeness** (`05_np_completeness.typ`)
   - Two definitions of NP and their equivalence
   - Cook-Levin theorem (NP-completeness of SAT)
   - NP-hardness and NP-completeness
   - Covers: A5, B6

6. **Polynomial-Time Reductions** (`06_reductions.typ`)
   - Polynomial-time reduction and NP-completeness implications
   - 3-SAT to Vertex Cover reduction
   - Other classic reductions
   - Covers: B7

7. **Parameterized Complexity and FPT** (`07_fpt_algorithms.typ`)
   - FPT class definition
   - Kernels and kernelization
   - Vertex Cover kernelization
   - Bounded search tree algorithms for Vertex Cover
   - Covers: B8, B9

8. **Counting Complexity** (`08_counting_complexity.typ`)
   - #P class definition
   - #P-completeness
   - Counting cycles in graphs
   - Covers: B10

9. **Complementary Classes and co-NP** (`09_complementary_classes.typ`)
   - co-NP definition and properties
   - co-NP-completeness
   - Covers: B11

10. **Advanced Topics** (`10_advanced_topics.typ`)
    - Pseudorandom generators
    - One-way functions
    - Connections to cryptography (symmetric encryption, bit-commitment)
    - Fine-grained complexity reductions (SETH, OV, regex matching)
    - Covers: B12, B13

Each chapter file should be included in `main.typ` with a page break between chapters.

This project must provide comprehensive answers to all exam questions from `exam_questions.pdf`. Questions are divided into two groups:

### Group A (Theoretical Foundations)
- **(A1)** Rice's Theorem with proof via $m$-reducibility
- **(A2)** Savitch's Theorem
- **(A3)** Deterministic Space Hierarchy
- **(A4)** Deterministic Time Hierarchy
- **(A5)** Cook-Levin Theorem (NP-completeness of SAT)

### Group B (Complexity Classes and Related Topics)
- **(B1)** Universal Turing Machine and undecidability of the universal language
- **(B2)** RAM and equivalence with Turing machines
- **(B3)** Properties of decidable and partially decidable languages (closure properties, Post's theorem, enumerators)
- **(B4)** Definition of basic complexity classes and proof of $NTIME(f(n)) subseteq SPACE(f(n))$
- **(B5)** Definition of basic complexity classes and proof of space-time relationship theorem
- **(B6)** Two definitions of NP class and their equivalence
- **(B7)** Polynomial reduction from 3-SAT to Vertex Cover
- **(B8)** Definition of FPT class and kernels, and kernelization of Vertex Cover
- **(B9)** Definition of FPT and parameterized algorithm for Vertex Cover via bounded search tree
- **(B10)** #P class and #P-completeness, hardness of counting cycles in a graph
- **(B11)** co-NP class and co-NP-completeness
- **(B12)** Pseudorandom generators, one-way functions and their connection to cryptography
- **(B13)** Example of fine-grained reduction (SETH to OV or OV to regex matching)

## Scope of Work

0.  **Context:** Always read `./lib.typ` before doing other tasks. Before starting any kind of work/changes on a lecture, first read the corresponding lecture PDF file in context and stick to it as much as possible.

1.  **Parse course contents:** Use `course-contents.txt` as a reference guide to map PDF sources in `sources/` directory to corresponding lecture topics. This file contains the course outline with references to topics and their locations.

2.  **Map sources to topics:** The `sources/` directory contains PDF presentations that should be processed in order according to the course outline. Each PDF covers specific topics listed in `course-contents.txt`.

3.  **Process each presentation:** Go through the PDF presentations in the `sources/` directory one by one, using `course-contents.txt` as a guide to understand the relationship between topics and materials.

4.  **Extract key concepts:** Identify and summarize the core algorithms, data structures, and theoretical concepts from each presentation.

5.  **Translate and simplify:** Rewrite the extracted information in clear and concise B2 level English.

6.  **Structure the content:** Organize the material in a logical way, suitable for study and exam preparation.

7.  **Include all definitions and lemmas:** For each topic covered by exam questions:
   - Extract and define all necessary concepts using the `definition()` macro from `lib.typ`
   - Include all lemmas referenced in proofs using the `lemma()` macro from `lib.typ`
   - Ensure definitions and lemmas are complete and self-contained

8.  **Add proofs for exam questions:** For all exam questions marked as requiring proofs (Group A and selected Group B items):
   - Use the `proof()` macro from `lib.typ` to format proofs
   - Proofs do **not** need to be exact rewrites of lecture material; alternative correct proofs are acceptable
   - Ensure proofs capture the **main idea** and all essential steps
   - Proofs should be clear and understandable for exam preparation

9.  **Add learning materials:** For each topic, include:
   - **Simple review questions:** 3-5 questions to test understanding of key concepts
   - **Worked examples:** Concrete examples with detailed step-by-step solutions
   - Use appropriate boxes from `lib.typ` to distinguish questions and examples from main text

10. **Format in Typst:** Create a `.typ` file for each topic, formatting the content using Typst's syntax. Always ensure that the syntax is correct, feel free to consult official documentation.

## Text Format and Styling

1. **Use `lib.typ` styling macros for all structured content:**
   - Definitions: Use `#definition(title)[body]` macro
   - Theorems: Use `#theorem(title)[body]` macro
   - Lemmas: Use `#lemma(title)[body]` macro
   - Proofs: Use `#proof[body]` macro
   - Examples and questions: Use appropriate question/example boxes from `lib.typ`

2. Extract examples and explanations to corresponding boxes so they do not disturb the main text information flow.

3. Use bullet-point lists where possible, try to avoid long sentences.

4. Exclude all history-related notes.

5. Each chapter should start on a new page.

6. When Greek letters or math symbols should be used, use them as proper symbols:
   - Use Typst `#sym.alpha` syntax for symbols
   - Use math mode `$alpha$` for math expressions
   - Note that Typst syntax is **different from LaTeX symbol syntax**!
   - Never use `$sym` inside math mode!

7. Use math mode when needed (denoted by `$$`).

8. To bold text, use a single asterisk `*bold text*`. To create italic text, use a single underscore `_italic text_`.

## Questions and Examples

Each chapter should include learning reinforcement materials:

### Questions
- Include 3-5 review questions at the end of each major topic section
- Questions should test understanding of core concepts and algorithms
- Use the question box from `lib.typ` to clearly separate questions from main text
- Questions should be of moderate difficulty, suitable for B2 level students

### Examples and Worked Solutions
- Provide concrete examples demonstrating the application of algorithms and concepts
- Include step-by-step worked solutions showing the process or algorithm execution
- Use the example box from `lib.typ` to distinguish examples from main content
- Examples should illustrate both typical use cases and edge cases where relevant

## How Typst works

Important: NEVER EVER USE LaTeX expressions prefixed by backslash!!!
In Typst, backslashes are only used for escaping, not for expressions nor symbols!!!

Dollars `$` that do not start the math mode should be prefixed by slash.
Strings in math mode are enclosed in quotes. When quotes are supposed to be used in the math mode,
they need to be enclosed in string and escaped.

### Math Mode Variables and Subscripts

-   Variables in math mode should be directly written, e.g., `$T$`, `$n$`, `$P$`. Do NOT wrap them in backticks (e.g., `\`$T\`` or `\`$n\``), as backticks are for literal code.
-   Multi-character subscripts or superscripts in math mode should be enclosed in parentheses, e.g., `$h_(new)$`, `$T^(text)$`.
-   Literal strings within math mode must be enclosed in double quotes, e.g., `$"substring"$.

## Versioning

After every significant change, a new git commit should be created and pushed. The `lectures/` directory and `*.pdf` files should not be versioned.

