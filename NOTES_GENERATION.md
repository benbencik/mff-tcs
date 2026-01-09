# AI-Assisted Notes Generation Guide

## Overview

This guide instructs AI agents on how to generate consistent, high-quality study notes from source materials.

## Pre-Generation Checklist

Before starting work on any topic:

1. **Read Course Context**: 
   - Study `definitions.typ` to understand notation and available styles
   - Review `lib.typ` to understand available Typst components

2. **Review Source Material**:
   - Examine the corresponding lecture PDF in `sources/lectures/`
   - Take note of the structure, examples, and emphasis in the original material
   - Identify the key learning objectives

3. **Check Existing Content**:
   - Review previously generated notes for style consistency
   - Note how examples and proofs are formatted
   - Understand the expected depth and level of detail

## Content Generation Workflow

### Phase 1: Content Extraction
- Identify core definitions, concepts, and theorems from the PDF
- Note important algorithms and data structures
- Extract or remember key examples and counterexamples
- Understand the problem motivation and use cases

### Phase 2: Content Organization
Structure the topic as follows:

```typst
= Topic Title

== Introduction/Overview
[Brief context and motivation]

== Definitions
#definition("Concept Name", [definition text])

== Key Concepts
- Concept 1: explanation
- Concept 2: explanation

== Theorems & Analysis
#theorem("Theorem Name", [statement])
#proof([proof content])

== Examples
#example("Example 1: Description", [
  Step-by-step walkthrough with clear explanation
])

== Practice Questions & Solutions

=== Question 1: [Title]
[Question text - medium difficulty]

#solution[
  [Answer with detailed explanation]
]

=== Question 2: [Title]
[Question text]

#solution[
  [Answer with explanation]
]

[Continue for 3-5 questions total per section]
```

### Phase 3: Content Standards

**Language & Clarity**:
- Write in clear, B2-level English
- Use simple, direct language where possible
- Explain intuition before formal definitions

**Mathematical Notation**:
- Use consistent notation from `definitions.typ`
- Define notation when first introduced in a topic
- Use proper Typst math syntax with `$...$` for inline and `$$...$$` for display

**Examples**:
- Provide concrete, worked examples
- Show step-by-step computations
- Include intuitive explanations of why things work
- Use diagrams/figures where helpful (reference from `figs/`)

**Questions**:
- Create 3-5 questions per major section
- Vary difficulty: 1-2 straightforward, 2-3 medium, 1-2 challenging
- Questions should test understanding, not just memorization
- Avoid questions identical to course materials; create original variations

**Solutions**:
- Provide complete, step-by-step solutions
- Explain the reasoning, not just the answer
- For proofs: show key lemmas and why each step follows
- For algorithms: trace through an example execution

### Phase 4: Typst Syntax

**Always Use These Components**:
```typst
#definition("Title", [content])        // For definitions
#theorem("Title", [content])           // For theorems
#lemma("Title", [content])             // For lemmas
#proof([proof content])                // For proofs
#example("Title", [content])           // For worked examples
#solution[content]                     // For question solutions
```

**Important Rules**:
- All syntax must be valid Typst
- Test compilation before considering content complete
- Ensure all references to `figs/` files exist
- Use consistent heading levels (= for sections, == for subsections, === for subsubsections)

## Quality Checklist

Before finalizing any topic:

- [ ] All definitions are clear and mathematically precise
- [ ] All theorems have proofs or references
- [ ] Examples are worked through completely
- [ ] Questions are original and varied in difficulty
- [ ] Solutions are detailed and explain reasoning
- [ ] Typst syntax is valid and consistent
- [ ] Notation matches `definitions.typ`
- [ ] Content aligns with source PDF emphasis
- [ ] Formulas are properly formatted
- [ ] No orphaned references to missing figures

## Example Section Template

```typst
== Topic Subsection

#definition("Key Concept", [
  A clear mathematical or conceptual definition that explains what the term means.
])

#theorem("Important Result", [
  The main theorem or result that shows something important about this concept.
])

#proof([
  Step 1: Establish the base case.
  
  Step 2: Show the inductive step.
  
  Step 3: Conclude by induction.
])

=== Example: Concrete Application

#example("Simple Case", [
  Consider $n = 5$. We want to demonstrate the concept.
  
  Step 1: Set up the initial state.
  
  Step 2: Apply the operation.
  
  Step 3: Observe the result.
  
  Therefore, the result is: [answer]
])

=== Practice & Assessment

*Question 1: Basic Understanding*
#blockquote[
  Define the key concept and explain one property.
]

#solution[
  The concept is... because... The property means that...
]

*Question 2: Application*
#blockquote[
  Given a scenario, apply the concept to solve a problem.
]

#solution[
  We can solve this by... Step by step: ... Therefore, the answer is...
]

[Continue with 1-3 more questions]
```

## Notes

- Always prioritize clarity and pedagogy over brevity
- When in doubt, add more explanation
- Examples should be runnable through mentally step-by-step
- Solutions should be good enough that a student learns from reading them
- Consistency across all notes is important for the reader's experience
