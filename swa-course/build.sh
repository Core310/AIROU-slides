#!/bin/bash
# Assembles the course from parts.
# Run from the course directory: bash build.sh
set -e
cat _base.html modules/*.html _footer.html > swa.html
echo "Built swa.html — open it in your browser."
