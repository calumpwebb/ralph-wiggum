#!/bin/bash
# Ralph Configuration - Shared across all scripts
# Provides centralized state directory management and automatic migration

# State directory (can be overridden via environment)
export RALPH_STATE_DIR="${RALPH_STATE_DIR:-.ralph}"

# Initialize state directory structure
init_ralph_state_dir() {
    mkdir -p "$RALPH_STATE_DIR"/{logs,docs/generated}
}

# Automatic migration from legacy locations
migrate_legacy_state() {
    local legacy_files=(
        ".call_count:call_count"
        ".last_reset:last_reset"
        ".claude_session_id:claude_session_id"
        ".ralph_session:session"
        ".ralph_session_history:session_history"
        ".exit_signals:exit_signals"
        ".circuit_breaker_state:circuit_breaker_state"
        ".circuit_breaker_history:circuit_breaker_history"
        ".response_analysis:response_analysis"
        ".json_parse_result:json_parse_result"
        ".last_output_length:last_output_length"
        "status.json:status.json"
        "progress.json:progress.json"
    )

    local migrated=0
    for mapping in "${legacy_files[@]}"; do
        local old_file="${mapping%%:*}"
        local new_file="$RALPH_STATE_DIR/${mapping##*:}"

        if [[ -f "$old_file" && ! -f "$new_file" ]]; then
            mv "$old_file" "$new_file" 2>/dev/null && ((migrated++))
        fi
    done

    # Migrate directories
    if [[ -d "logs" && ! -d "$RALPH_STATE_DIR/logs" ]]; then
        mv logs "$RALPH_STATE_DIR/logs" 2>/dev/null && ((migrated++))
    fi

    if [[ -d "docs/generated" && ! -d "$RALPH_STATE_DIR/docs/generated" ]]; then
        mkdir -p "$RALPH_STATE_DIR/docs"
        mv docs/generated "$RALPH_STATE_DIR/docs/generated" 2>/dev/null && ((migrated++))
    fi

    [[ $migrated -gt 0 ]] && echo "✓ Migrated $migrated files to $RALPH_STATE_DIR"
}

export -f init_ralph_state_dir
export -f migrate_legacy_state
