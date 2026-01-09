# Data Structures Course

Advanced study notes for the Data Structures course, focusing on algorithm analysis and specialized data structures.

## Topics

- Dynamic Arrays and Amortization
- Splay Trees
- (a,b)-Trees and B-Trees
- Cache-Aware and Cache-Oblivious Algorithms
- Universal Hashing and Hash Functions
- Range Trees and Geometric Data Structures
- Suffix Arrays and String Algorithms

## Resources

- **Lecture Presentations:** `sources/lectures/` directory
- **Figures:** Add screenshots and diagrams to `figs/` directory
- **Template:** See `notes/00_template.typ` for structure

## Compilation

```bash
cd courses/data-structures
typst compile main.typ data-structures.pdf
```

Or with watch mode for continuous updates:
```bash
typst watch main.typ data-structures.pdf
```

## Note Generation Process

1. Review the corresponding lecture PDF in `sources/lectures/`
2. See the root-level `NOTES_GENERATION.md` for detailed AI generation guidelines
3. Create a new `.typ` file in `notes/` using the template
4. Include 3-5 practice questions with solutions after each major section
5. Add figures from `sources/` or screenshots to `figs/` as needed
6. Uncomment the include line in `main.typ` to add the topic to the compiled document

All notes use the local `lib.typ` for consistent styling and notation.
