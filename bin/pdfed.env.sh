function pdf_cb {
    # (in, callback, args...)
    t="$(mktemp)"
    in="$1"
    out="${in%.pdf}_mod.pdf"
    shift

    pdftk "$in" output "$t" uncompress
    "$@" "$t"
    pdftk "$t" output "$out" compress
    echo "$out"
}

function pdf_edit {
    # (file.pdf)
    pdf_cb "$1" "${EDITOR-vim}"
}

function pdf_sed {
    # (file.pdf, 's/foo/bar/g')
    pdf_cb "$1" sed -i "$2"
}
