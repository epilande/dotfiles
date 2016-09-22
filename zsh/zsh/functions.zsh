# print available colors and their numbers
function colours() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}m colour${i}"
    if (( $i % 5 == 0 )); then
      printf "\n"
    else
      printf "\t"
    fi
  done
}

function 7zip() {
  tar cf - "$@" | 7za a -si "$@".tar.7z;
}

function 7unzip() {
  7za x -so "$@" | tar xf -;
}

# Codi
# Usage: codi [filetype]
codi() {
  local syntax="${1:-javascript}"
  vim -c \
    "let g:startify_disable_at_vimenter = 1 |\
    set bt=nofile ls=0 noru nonu nornu |\
    hi ColorColumn ctermbg=NONE |\
    hi VertSplit ctermbg=NONE |\
    hi NonText ctermfg=0 |\
    Codi $syntax"
}
