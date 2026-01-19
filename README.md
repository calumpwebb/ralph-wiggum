# Ralph Wiggum 🤖

An enhanced autonomous AI development loop for Claude Code, adapted from [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code).

## What is Ralph?

Ralph is an autonomous workflow system that enables Claude Code to execute development tasks in continuous loops with built-in circuit breakers, session management, and intelligent progress tracking.

## ✨ New Features in This Fork

### 🗂️ Centralized State Directory
All Ralph state files are now organized in a single `.ralph/` directory:
- Cleaner project roots (no more scattered dot files)
- Easy cleanup: `rm -rf .ralph/`
- Customizable location via `RALPH_STATE_DIR` environment variable

**Before:**
```
project/
├── .call_count
├── .last_reset
├── .claude_session_id
├── .ralph_session
├── .exit_signals
├── status.json
├── progress.json
├── logs/
└── (33+ scattered files)
```

**After:**
```
project/
├── .ralph/
│   ├── logs/
│   ├── status.json
│   ├── session
│   ├── call_count
│   └── (all state files)
├── PROMPT.md
└── @fix_plan.md
```

### 📁 In-Place Import
Import PRDs into existing projects without creating new folders:

```bash
# Traditional: creates new project folder
ralph-import my-prd.md my-project

# NEW: import into current directory
cd my-existing-project
ralph-import ../my-prd.md --current-dir
```

Features:
- Conflict detection (won't overwrite existing PROMPT.md/@fix_plan.md)
- Git-aware (skips git init if already in a repo)
- Safe and intuitive

### 📡 Realtime Streaming Output
Watch Claude's output in realtime while Ralph runs:

```bash
# Start Ralph with streaming enabled
ralph --stream

# In another terminal, watch live output
ralph-tail        # Formatted output (assistant text, results)
ralph-tail --raw  # Raw JSON stream
```

**How it works:**
- `--stream` uses Claude CLI's `stream-json` output format for realtime logging
- Logs update continuously instead of buffering until cycle completion
- `ralph-tail` parses the JSON and displays readable output

### 🎛️ Environment Configuration
Customize state directory location:

```bash
# Use custom location
export RALPH_STATE_DIR="/tmp/ralph-state"
ralph --monitor

# Or use default .ralph/
ralph --monitor
```

## 🚀 Quick Start

### Installation

```bash
# Clone this repo
git clone https://github.com/calumpwebb/ralph-wiggum.git
cd ralph-wiggum

# Run installer
./install.sh
```

### Usage

**Create a new project:**
```bash
ralph-setup my-project
cd my-project
# Edit PROMPT.md and @fix_plan.md
ralph --monitor
```

**Import from PRD:**
```bash
ralph-import requirements.md my-project
cd my-project
ralph --monitor
```

**Import into existing project:**
```bash
cd existing-project
ralph-import ../requirements.md --current-dir
ralph --monitor
```

## 📋 How It Works

1. **PROMPT.md** - Instructions for Ralph (the autonomous agent)
2. **@fix_plan.md** - Prioritized task list with checkboxes
3. **specs/** - Technical specifications and requirements
4. Ralph reads the plan, picks the most important task, implements it
5. Circuit breakers prevent infinite loops and stagnation
6. Session continuity preserves context across runs

## 🛠️ Core Components

- `ralph_loop.sh` - Main autonomous loop with rate limiting
- `ralph_import.sh` - PRD to Ralph format conversion
- `ralph_monitor.sh` - Live status dashboard
- `ralph-tail` - **NEW** Realtime log streaming viewer
- `lib/circuit_breaker.sh` - Stagnation detection
- `lib/response_analyzer.sh` - Claude response analysis
- `lib/config.sh` - Centralized configuration

## 🎯 Features

- ✅ Autonomous development loops
- ✅ Circuit breaker pattern (prevents runaway execution)
- ✅ Rate limiting (respects API limits)
- ✅ Session continuity (preserves context)
- ✅ Progress tracking and monitoring
- ✅ PRD to task conversion (via Claude)
- ✅ Centralized .ralph/ directory
- ✅ In-place import with --current-dir
- ✅ Environment variable customization
- ✅ **NEW: Realtime streaming with --stream**
- ✅ **NEW: ralph-tail log viewer**

## 🔜 More Coming Soon!

- Enhanced error recovery
- Multi-project session management
- Better progress visualization
- Integration with more development tools
- Advanced task prioritization

## 📖 Documentation

See the original [ralph-claude-code](https://github.com/frankbria/ralph-claude-code) repository for detailed documentation on the core Ralph Loop concepts.

## 🙏 Credits

This project is adapted from [frankbria/ralph-claude-code](https://github.com/frankbria/ralph-claude-code), with significant enhancements for better organization, flexibility, and usability.

## 📝 License

See LICENSE file for details.

---

**Built with ❤️ for autonomous AI development**
