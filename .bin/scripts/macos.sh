#!/bin/zsh

# macOS 固有の調整。sudo 不要なユーザー単位の設定だけを置く。

# com.apple.rcd: メディアキー (再生/一時停止) を押すと Music.app を起動するデーモン。
# 無効化すると再生キーがフォアグラウンドのアプリにそのまま届く。
_RCD="gui/$(id -u)/com.apple.rcd"

disable_rcd() {
    if launchctl print-disabled "gui/$(id -u)" 2>/dev/null | grep -q '"com.apple.rcd" => disabled'; then
        echo "com.apple.rcd is already disabled."
        return 0
    fi
    launchctl disable "$_RCD"
    launchctl kill SIGTERM "$_RCD" 2>/dev/null || true
    echo "Disabled com.apple.rcd (media keys no longer launch Music.app)."
}

enable_rcd() {
    launchctl enable "$_RCD"
    echo "Re-enabled com.apple.rcd."
}
