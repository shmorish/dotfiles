#!/bin/zsh

install_claude_code() {
    command -v claude >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "Claude Code is already installed: $(claude --version)"
        return 0
    fi
    curl -fsSL https://claude.ai/install.sh | bash
}
