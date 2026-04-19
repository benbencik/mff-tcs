# TCS Master's Notes

Comprehensive Typst-based notes repository for master's studies, organized by course and topic.

![cover image](tcs-garden.png)

## Structure

```
shared/
├── lib.typ                    # Single shared Typst library (all courses)
├── template/
│   └── course-template/       # Copyable starter template for new courses
courses/
├── course 1/
│   ├── README.md             # Course overview
│   ├── main.typ              # Main compilable file
│   ├── notes/                # Individual topic files
│   │   ├── 00_note.typ       # Template for new topics
│   │   ├── 01_note.typ
│   │   └── ... (other topics)
│   ├── figs/                 # Course-local figures only
│   └── main.pdf              # Compiled output
├── course 2/
│ ...

```

## Unified instructions (`GEMINI.md`)

There is exactly one instruction file at repository root:

- `GEMINI.md` — canonical guidance for:
  - note-writing workflow,
  - directory responsibilities,
  - source usage,
  - Typst syntax/style conventions,
  - build and verification rules.

Per-course `GEMINI.md` files are intentionally removed to avoid divergence.

## Compilation and validation

### Compile a single course (from repo root)

```bash
typst compile --root . courses/data-structures/main.typ
typst compile --root . courses/intro-to-complexity/main.typ
typst compile --root . courses/parametrized-algorihms/main.typ
typst compile --root . courses/info-theory/main.typ
```

### Compile a single course (from inside that course directory)

```bash
cd courses/[course-name]
typst compile --root ../.. main.typ
```

### Watch mode (continuous rebuild)

```bash
typst watch --root ../.. main.typ
```

### Verify all courses after shared changes

```bash
typst compile --root . courses/data-structures/main.typ
typst compile --root . courses/intro-to-complexity/main.typ
typst compile --root . courses/parametrized-algorihms/main.typ
typst compile --root . courses/info-theory/main.typ
```

If all commands succeed, the shared setup is consistent.
