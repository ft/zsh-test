# Make sure this is called from zsh's source root directory:
function is-zsh-source-root () {
    test -f README || return 1
    test -f .preconfig || return 1
    test -d Completion || return 1
    return 0
}

if ! is-zsh-source-root; then
    printf 'Only use this setup from zsh'\''s root source directory!\n'
    printf 'Exiting...\n'
    exit 1
fi

typeset REPLY

function name-from-mdd () {
    local mdd="${1:r}.mdd"
    local line
    if ! test -f "$mdd"; then
        printf 'Missing mdd file: %s\n' "$mdd"
        return 1
    fi
    REPLY=''
    while IFS= read -r line; do
        case "$line" in
        name=*) REPLY="${line#name=}"
                return 0
                ;;
        esac
    done < "$mdd"
    printf 'Could not extract name from %s\n' "$mdd"
    return 1
}

# Prepare a local module directory:
if ! test -d _modules_; then
    mkdir -p _modules_ || exit 1
fi

for mod in "$PWD"/Src/**/*.so; do
    name-from-mdd "$mod" || exit 1
    dest="_modules_/${REPLY}.so"
    test -h "$dest" && continue
    mkdir -p "${dest:h}" || exit 1
    ln -s "$mod" "$dest" || exit 1
done

# Setup the shell's load paths for functions and modules:
fpath=( "$PWD"/Completion
        "$PWD"/Completion/**/*(/)
        "$PWD"/Functions/**/*(/) )
module_path=( "$PWD"/_modules_ )

# Here's a plain prompt:
PS1='zsh%% '

# Clean up the environment again:
unset mod dest REPLY
unfunction is-zsh-source-root
unfunction name-from-mdd
