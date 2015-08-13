#!/bin/bash

# Shameless copy from https://gist.github.com/dblevins/320089#file-generic_completion-sh

_opts () {
perl -ne '
print if s/^.IP .\\fB\\-/-/ and s/\\(f(P|I|B|R)|)|".*//g;
print if s/^.IX Item .\-/-/ and s/"//g;
print if s/^.It Fl /-/;'
}

_man_generic() {
    local IFS=$'\t\n' cmd cur opts

    cur="${COMP_WORDS[COMP_CWORD]}"
    cmd=$(basename "$1")
    opts=$( for n in $(manpath | tr ':' '\n'); do \
	n="$n/man1/${cmd}.1"; \
	[ -f "$n" ] && cat "$n" | _opts; \
	[ -f "$n".gz ] && gunzip -c "$n".gz | _opts; \
	done | perl -pe 's/, | (--)/\n$1/' | sort | uniq )

    COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

_autocomplete_cmd() {
  local cmd=$1
  complete -o default -F _man_generic $cmd
}

_AUTOCOMPLETE_MAN=(ruby)
for cmd in $_AUTOCOMPLETE_MAN; do
 _autocomplete_cmd $cmd
done
