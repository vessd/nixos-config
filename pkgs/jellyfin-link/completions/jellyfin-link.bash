_jellyfin_link() {
    local cur prev subcommand opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "movie tv" -- "$cur"))
        return 0
    fi

    subcommand="${COMP_WORDS[1]}"

    case "$prev" in
        --title|--year|--season|--shikimori-id)
            return 0
            ;;
    esac

    case "$subcommand" in
        movie)
            opts="--title --year --shikimori-id --dry-run --help"
            if [[ "$cur" != -* ]]; then
                COMPREPLY=($(compgen -f -- "$cur"))
                return 0
            fi
            ;;
        tv)
            opts="--title --season --shikimori-id --dry-run --help"
            if [[ "$cur" != -* ]]; then
                COMPREPLY=($(compgen -d -- "$cur"))
                return 0
            fi
            ;;
        *)
            return 0
            ;;
    esac

    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}
complete -F _jellyfin_link jellyfin-link
