function '?'
    set q (string join " " $argv)
    if test -z "$q"
        echo "usage: ? <query>"
        return 1
    end

    if not type -q ddgr
        echo "ddgr not found. Install: sudo apt install ddgr jq (or: brew install ddgr jq)"
        return 1
    end

    ddgr -n 10 --json --noua "$q" 2>/dev/null | jq -r '.[] | "\(.title)\t\(.url)"' \
    | while read -l title url
        printf '\e]8;;%s\a%s\e]8;;\a\n' "$url" "$title"
        printf '  %s\n\n' "$url"
    end
end

