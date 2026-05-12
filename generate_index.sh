#!/bin/bash

# Configuration
OUTPUT_FILE="index.html"
EXCLUDE_PATTERNS=("index.html" "*/libs/*" "*/trash/*" "_*" "*/node_modules/*" "*/modules/*" "*/briefs/*")

# Start generating index.html
cat <<EOF > "$OUTPUT_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AIROU Slides Index</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            background-color: #f8f9fa;
        }
        h1 {
            border-bottom: 2px solid #007bff;
            padding-bottom: 0.5rem;
            color: #007bff;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            background: white;
            margin-bottom: 0.5rem;
            padding: 0.75rem 1rem;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            transition: transform 0.1s ease;
        }
        li:hover {
            transform: translateX(5px);
            background-color: #e9ecef;
        }
        a {
            text-decoration: none;
            color: #333;
            display: block;
            font-weight: 500;
        }
        .path {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 0.2rem;
        }
    </style>
</head>
<body>
    <h1>Project Pages Index</h1>
    <ul>
EOF

# Find HTML files and append to list
# We use -not -path to exclude directory patterns and -not -name to exclude file patterns
FIND_CMD="find . -name '*.html' -not -name '_*'"
for pattern in "${EXCLUDE_PATTERNS[@]}"; do
    if [[ $pattern == *"/"* ]]; then
        FIND_CMD+=" -not -path '$pattern'"
    else
        FIND_CMD+=" -not -name '$pattern'"
    fi
done

eval "$FIND_CMD" | sort | while read -r file; do
    # Remove leading ./
    clean_path="${file#./}"
    # Get filename for display
    filename=$(basename "$clean_path")
    # Get directory for context
    dirname=$(dirname "$clean_path")
    
    echo "        <li><a href=\"$clean_path\">$filename</a><div class=\"path\">$dirname</div></li>" >> "$OUTPUT_FILE"
done

cat <<EOF >> "$OUTPUT_FILE"
    </ul>
    <footer style="margin-top: 3rem; font-size: 0.8rem; color: #adb5bd;">
        Last updated: $(date)
    </footer>
</body>
</html>
EOF

chmod +x generate_index.sh
echo "Successfully generated $OUTPUT_FILE"
