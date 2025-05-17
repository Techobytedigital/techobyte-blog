#!/bin/bash

## Syntax highlighting docs:
#  https://gohugo.io/quick-reference/syntax-highlighting-styles/
## Available syntax themes:
#  https://xyproto.github.io/splash/docs/all.html

SYNTAX_OUTPUT_DIR="site/static/css"
THEME_NAME=$1
if [ -z "$THEME_NAME" ]; then
    THEME_NAME="onedark"
fi

if ! command -v hugo &> /dev/null; then
    echo "Hugo is not installed"
    exit 1
fi

if [[ ! -d "$SYNTAX_OUTPUT_DIR" ]]; then
    echo "Creating styles output directory: $SYNTAX_OUTPUT_DIR"
    mkdir -p "$SYNTAX_OUTPUT_DIR"
fi

echo "Generating styles for theme '$THEME_NAME'"
hugo gen chromastyles --style="$THEME_NAME" > ${SYNTAX_OUTPUT_DIR}/syntax.css
if [ $? -ne 0 ]; then
    echo "Failed to generate styles for theme '$THEME_NAME'"
    exit 1
fi

echo "Generated styles for theme '$THEME_NAME'"
exit 0
