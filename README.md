# Master's Studies Notes

Comprehensive notes repository for master's studies, structured by course and topic.

## Structure

```
lib.typ                       # Global styling and definitions
typst.toml                    # Typst project configuration

courses/
├── data-structures/
│   ├── README.md             # Course overview
│   ├── main.typ              # Main compilable file
│   ├── lib.typ               # Local copy of global library
│   ├── notes/                # Individual topic files
│   │   ├── 00_template.typ   # Template for new topics
│   │   ├── amortized_analysis.typ
│   │   ├── splay_trees.typ
│   │   └── ... (other topics)
│   ├── sources/              # Source materials (PDFs, readings)
│   ├── figs/                 # Figures and screenshots
│   └── data-structures.pdf   # Compiled output
```

## Compilation

For any course, compile using Typst from within the course directory:

```bash
cd courses/[course-name]
typst compile main.typ [course-name].pdf
```

Or with watch mode for continuous updates:
```bash
typst watch main.typ [course-name].pdf
```

## Note Structure

Each topic includes:
- **Definition/Concepts**: Core definitions and key concepts
- **Theory**: Theorems, lemmas, proofs
- **Examples**: Worked examples with explanations
- **Questions & Answers**: 3-5 medium-difficulty questions per section with solutions

## Adding a New Course

1. Create `courses/[course-name]/` directory with subdirectories for `notes/`, `sources/`, and `figs/`
2. Copy `lib.typ` from an existing course (or from root)
3. Create `main.typ` as the entry point (imports from `lib.typ`)
4. Create topic files in `notes/`
5. Add course README describing scope and topics

All courses share the global `lib.typ` file that each course maintains a local copy of for simpler relative imports.
