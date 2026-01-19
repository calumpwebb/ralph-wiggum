#!/bin/bash

# Ralph Project Setup Script - Global Version
set -e

# Parse arguments
CURRENT_DIR_MODE=false
PROJECT_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --current-dir|-c)
            CURRENT_DIR_MODE=true
            shift
            ;;
        *)
            PROJECT_NAME="$1"
            shift
            ;;
    esac
done

RALPH_HOME="$HOME/.ralph"

if [[ "$CURRENT_DIR_MODE" == true ]]; then
    # Current directory mode - use directory name as project name
    PROJECT_NAME=$(basename "$PWD")

    echo "🚀 Setting up Ralph in current directory: $PROJECT_NAME"

    # Check for existing PROMPT.md or @fix_plan.md
    if [[ -f "PROMPT.md" ]]; then
        echo "❌ Error: PROMPT.md already exists in current directory."
        echo "   Remove it or use a different directory."
        exit 1
    fi

    if [[ -f "@fix_plan.md" ]]; then
        echo "❌ Error: @fix_plan.md already exists in current directory."
        echo "   Remove it or use a different directory."
        exit 1
    fi

    # Create structure in current directory
    mkdir -p {specs/stdlib,src,examples,docs/generated}

    # Copy templates from Ralph home
    cp "$RALPH_HOME/templates/PROMPT.md" .
    cp "$RALPH_HOME/templates/fix_plan.md" @fix_plan.md
    cp "$RALPH_HOME/templates/AGENT.md" @AGENT.md
    cp -r "$RALPH_HOME/templates/specs/"* specs/ 2>/dev/null || true

    # Initialize git only if not already a git repo
    if [[ ! -d ".git" ]]; then
        git init
        echo "# $PROJECT_NAME" > README.md
        git add .
        git commit -m "Initial Ralph project setup"
    else
        echo "ℹ️  Git repository already exists, skipping git init"
    fi

else
    # Traditional mode - create new directory
    PROJECT_NAME=${PROJECT_NAME:-"my-project"}

    echo "🚀 Setting up Ralph project: $PROJECT_NAME"

    # Create project directory in current location
    mkdir -p "$PROJECT_NAME"
    cd "$PROJECT_NAME"

    # Create structure
    mkdir -p {specs/stdlib,src,examples,docs/generated}

    # Copy templates from Ralph home
    cp "$RALPH_HOME/templates/PROMPT.md" .
    cp "$RALPH_HOME/templates/fix_plan.md" @fix_plan.md
    cp "$RALPH_HOME/templates/AGENT.md" @AGENT.md
    cp -r "$RALPH_HOME/templates/specs/"* specs/ 2>/dev/null || true

    # Initialize git
    git init
    echo "# $PROJECT_NAME" > README.md
    git add .
    git commit -m "Initial Ralph project setup"
fi

echo "✅ Project $PROJECT_NAME setup complete!"
echo "Next steps:"
echo "  1. Edit PROMPT.md with your project requirements"
echo "  2. Update specs/ with your project specifications"
echo "  3. Run: ralph --monitor"
echo "  4. Monitor: ralph-monitor (if running manually)"
