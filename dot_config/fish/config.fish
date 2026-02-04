source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
#    # smth smth
end

if not set -q OPENAI_API_KEY
    set -x OPENAI_API_KEY ""
end
