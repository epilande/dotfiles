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
