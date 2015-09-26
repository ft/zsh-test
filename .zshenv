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

# Prepare a local module directory:
root="$PWD"
if ! test -d _modules_; then
    mkdir -p _modules_/zsh || exit 1
fi

cd _modules_/zsh || exit 1
for mod in "${root}"/Src/**/*.so; do
    test -h "${mod:t}" && continue
    ln -s "$mod" "${mod:t}" || exit 1
done
cd "$root" || exit 1

# Setup the shell's load paths for functions and modules:
fpath=( "${root}/Completion" )
module_path=( "${root}/_modules_" )

# Here's a plain prompt:
PS1='zsh%% '

# Clean up the environment again:
unset root mod
unfunction is-zsh-source-root
