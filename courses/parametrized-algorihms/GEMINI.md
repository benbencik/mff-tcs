# Project: Parametrized algorithms Study Materials

This project aims to create study materials for the "Parametrized Algorithms" course taught at the Faculty of Mathematics and Physics, Charles University in Prague (MFF CUNI).

## Goal

The primary goal is to produce high-quality lecture notes in English (B2 level) for each topic covered in the course.

## Project Structure

- `main.typ`: The main Typst file that combines all chapters.
- `lib.typ`: Specifies common types of boxes and other common logic. This should be included in every file and boxes and other styles from this file should be used.
- `notes/`: This directory contains the individual chapter files in Typst format.
- `sources/`: This directory contains the source PDF presentations for each lecture.
- `main.pdf`: The compiled output of the project. This file is not versioned.
- `GEMINI.md`: This file, containing the project's documentation.
- `.gitignore`: Specifies files and directories to be ignored by git.

## Output Format

The final study materials will be written in [Typst](https://typst.app/), a modern typesetting system. Each lecture is converted into a single file, which are then included in the main document.
If you want to use images, just add links to the images, do not try to download them.

## Course Structure and Sources

- **course-contents.txt:** Contains the complete course outline with topic references. This file maps lecture topics to their source materials and academic references (PA, ND, 5M, etc.).
- **sources/ directory:** Contains three PDF files:
  - `parameterized-algorithms.pdf`: Main textbook reference (PA)
  - `Nd.pdf`: Neighborhood diversity paper reference (ND)
  - `5M.pdf`: Integer programming in parameterized complexity paper (5M)
- **Mapping topics:** Each entry in `course-contents.txt` indicates which PDF sources and sections to consult for that lecture topic.

## Scope of Work

0.  **Context:** Always read `./lib.typ` before doing other tasks. Before starting to any kind of work/changes on a lecture, first read a corresponding lecture PDF file in context and stick to it as much as possible.

1.  **Parse course contents:** Use `course-contents.txt` as a reference guide to map PDF sources in `sources/` directory to corresponding lecture topics. This file contains the course outline with references to topics and their locations.

2.  **Map sources to topics:** The `sources/` directory contains PDF presentations that should be processed in order according to the course outline. Each PDF covers specific topics listed in `course-contents.txt`.

3.  **Process each presentation:** Go through the PDF presentations in the `sources/` directory one by one, using `course-contents.txt` as a guide to understand the relationship between topics and materials.

4.  **Extract key concepts:** Identify and summarize the core algorithms, data structures, and theoretical concepts from each presentation.

5.  **Translate and simplify:** Rewrite the extracted information in clear and concise B2 level English.

6.  **Structure the content:** Organize the material in a logical way, suitable for study.

7.  **Add learning materials:** For each topic, include:
   - **Simple review questions:** 3-5 questions to test understanding of key concepts
   - **Worked examples:** Concrete examples with detailed step-by-step solutions
   - Use appropriate boxes from `lib.typ` to distinguish questions and examples from main text

8.  **Format in Typst:** Create a `.typ` file for each topic, formatting the content using Typst's syntax. Always ensure that the syntax is correct, feel free to consult official documentation.

## Text format

1. Extract examples and explanations to a corresponding boxes so they do not disturb the main text information flow.
2. Use bullet-point lists where possible, try to not use long sentences.
3. Exclude all the history related notes.
4. Each chapter should start on a new page.
5. When a greek letter or match symbols should be used, use them as a proper symbols. Use either Typst `#sym.alpha` syntax or math mode `$ alpha $`. Note that Typst syntax is different from LaTeX symbol syntax! Never use `$sym` inside math mode!
6. Use math mode when needed (denoted by $$).
7. To bold text, use a single start `*bold text*`. To create italics text, use a single underscore `_italic text_`.

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

