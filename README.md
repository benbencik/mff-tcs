# Master's Studies Notes

Comprehensive notes repository for master's studies, structured by course and topic.

## Structure

```
courses/
├── course 1/
│   ├── README.md             # Course overview
│   ├── main.typ              # Main compilable file
│   ├── lib.typ               # Local copy of global library
│   ├── notes/                # Individual topic files
│   │   ├── 00_note.typ       # Template for new topics
│   │   ├── 01_note.typ
│   │   └── ... (other topics)
│   ├── figs/                 # Figures and screenshots
│   └── main.pdf              # Compiled output
├── course 2/
│ ...

```

## Compilation

For any course, compile using Typst from within the course directory:

```bash
cd courses/[course-name]
typst compile main.typ
```

Or with watch mode for continuous updates:
```bash
typst watch main.typ
```