#!/usr/bin/env bash
# brightness.sh — ustaw jasność na obu monitorach przez DDC/CI (ddcutil)
# użycie: ./brightness.sh 60
# (0-100)

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Użycie: $0 <0-100>"
  exit 1
fi

B="$1"
if ! [[ "$B" =~ ^[0-9]+$ ]] || (( B < 0 || B > 100 )); then
  echo "Błąd: podaj wartość 0-100"
  exit 1
fi

if ! command -v ddcutil >/dev/null 2>&1; then
  echo "Brak ddcutil. Zainstaluj: sudo apt install ddcutil"
  exit 1
fi

# znajdź wykryte monitory (numery display)
mapfile -t DISPLAYS < <(ddcutil detect 2>/dev/null | awk '/Display [0-9]+/ {print $2}')

if (( ${#DISPLAYS[@]} == 0 )); then
  echo "Nie wykryto monitorów przez DDC/CI. Sprawdź DDC/CI w OSD monitora."
  exit 1
fi

# ustaw jasność na max 2 pierwszych monitorach
for d in "${DISPLAYS[@]:0:2}"; do
  ddcutil --display "$d" setvcp 10 "$B" >/dev/null
done

echo "Ustawiono jasność $B na monitorach: ${DISPLAYS[*]:0:2}"

