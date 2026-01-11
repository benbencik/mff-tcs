#!/usr/bin/env python3
"""
Script to validate figure references in Typst files.
Checks that all referenced images exist in the repository.
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple

def find_typst_files(root_dir: str) -> List[Path]:
    """Find all .typ files in the repository."""
    root = Path(root_dir)
    return list(root.rglob("*.typ"))

def extract_image_references(file_path: Path) -> List[Tuple[str, int]]:
    """
    Extract image references from a Typst file.
    Returns a list of (image_path, line_number) tuples.
    """
    references = []
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            
        for line_num, line in enumerate(lines, start=1):
            # Pattern 1: Direct image() calls: image("path/to/file.png")
            direct_pattern = r'image\s*\(\s*"([^"]+)"\s*[,)]'
            direct_matches = re.findall(direct_pattern, line)
            for match in direct_matches:
                references.append((match, line_num))
            
            # Pattern 2: #fig() helper function calls: #fig("filename.png")
            # The fig() function prepends "figs/" to the filename
            fig_pattern = r'#fig\s*\(\s*"([^"]+)"'
            fig_matches = re.findall(fig_pattern, line)
            for match in fig_matches:
                # If the path already starts with ../ or figs/, use as-is
                # Otherwise, prepend "figs/" as the helper function does
                if match.startswith("../") or match.startswith("figs/"):
                    references.append((match, line_num))
                else:
                    references.append((f"figs/{match}", line_num))
    
    except Exception as e:
        print(f"Warning: Could not read {file_path}: {e}")
    
    return references

def validate_figure_exists(base_path: Path, image_path: str, typst_file: Path) -> bool:
    """
    Check if a figure exists relative to the base path.
    Handles both relative and absolute paths within the repository.
    
    Special handling for the #fig() helper function:
    - Notes in courses/*/notes/ use #fig() which references figs/ from the course root
    - Need to check relative to the course directory, not the notes directory
    """
    # First, try relative to the .typ file's directory
    full_path = (base_path / image_path).resolve()
    
    if full_path.exists() and full_path.is_file():
        return True
    
    # Special case: if the .typ file is in a 'notes' subdirectory
    # and the image path starts with 'figs/', check relative to the parent (course) directory
    if 'notes' in typst_file.parts and image_path.startswith('figs/'):
        # Find the course directory (parent of notes)
        for i, part in enumerate(typst_file.parts):
            if part == 'notes':
                # Get the course directory path
                course_dir = Path(*typst_file.parts[:i])
                full_path = (course_dir / image_path).resolve()
                if full_path.exists() and full_path.is_file():
                    return True
    
    return False

def main():
    root_dir = Path.cwd()
    
    typst_files = find_typst_files(root_dir)
    
    if not typst_files:
        print("No .typ files found in repository.")
        return 0
    
    print(f"Found {len(typst_files)} .typ files to validate")
    print("-" * 60)
    
    total_references = 0
    missing_figures = []
    
    for typst_file in typst_files:
        # Get the directory containing the .typ file
        base_dir = typst_file.parent
        
        references = extract_image_references(typst_file)
        total_references += len(references)
        
        for image_path, line_num in references:
            if not validate_figure_exists(base_dir, image_path, typst_file):
                missing_figures.append({
                    'file': typst_file,
                    'line': line_num,
                    'image': image_path,
                    'base_dir': base_dir
                })
    
    print(f"Total figure references checked: {total_references}")
    print("-" * 60)
    
    if missing_figures:
        print(f"\n❌ Found {len(missing_figures)} missing figure(s):\n")
        
        for missing in missing_figures:
            # Make paths relative to repository root for cleaner output
            rel_file = missing['file'].relative_to(root_dir)
            expected_path = (missing['base_dir'] / missing['image']).resolve()
            rel_expected = expected_path.relative_to(root_dir) if expected_path.is_relative_to(root_dir) else expected_path
            
            print(f"  File: {rel_file}")
            print(f"  Line: {missing['line']}")
            print(f"  Missing: {missing['image']}")
            print(f"  Expected at: {rel_expected}")
            print()
        
        print("::error::Figure validation failed: missing figure references detected")
        return 1
    else:
        print("\n✅ All figure references are valid!")
        return 0

if __name__ == "__main__":
    sys.exit(main())
