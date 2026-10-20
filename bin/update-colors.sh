#!/usr/bin/env bash

JSON_FILE="/home/rem/.config/fastfetch/ryoku-colors.json"
CONFIG_FILE="$HOME/.config/mpv/script-opts/uosc.conf"

# Sprawdzenie czy plik Ryoku istnieje
if [ ! -f "$JSON_FILE" ]; then
    echo "Błąd: Nie znaleziono pliku z kolorami Ryoku ($JSON_FILE)."
    exit 1
fi

# Funkcja zamieniająca format "R;G;B" z Ryoku na format "RRGGBB" HEX dla UOSC
rgb_to_hex() {
    local r g b
    IFS=';' read -r r g b <<< "$1"
    printf "%02x%02x%02x" "$r" "$g" "$b"
}

# Wyciąganie kolorów przez 'jq' i natychmiastowa konwersja na HEX
FG=$(rgb_to_hex "$(jq -r '.keys' "$JSON_FILE")")
FG_TEXT=$(rgb_to_hex "$(jq -r '.title' "$JSON_FILE")")
BG=$(rgb_to_hex "$(jq -r '.rule' "$JSON_FILE")")
BG_TEXT=$(rgb_to_hex "$(jq -r '.muted' "$JSON_FILE")")
SUCCESS=$(rgb_to_hex "$(jq -r '.percent.green' "$JSON_FILE")")
ERROR=$(rgb_to_hex "$(jq -r '.percent.red' "$JSON_FILE")")

# Złożenie nowej konfiguracji (curtain używa tego samego koloru tła co BG)
NEW_COLORS="color=foreground=$FG,foreground_text=$FG_TEXT,background=$BG,background_text=$BG_TEXT,curtain=$BG,success=$SUCCESS,error=$ERROR"

# Aktualizacja pliku konfiguracyjnego MPV
if grep -q "^color=" "$CONFIG_FILE"; then
    sed -i "s/^color=.*/$NEW_COLORS/" "$CONFIG_FILE"
else
    echo "$NEW_COLORS" >> "$CONFIG_FILE"
fi

echo "Sukces! Kolory UOSC zsynchronizowane z obecnym motywem Ryoku."