#!/bin/bash

# Dispatch to the platform-specific setup script
case "$(uname -s)" in
Darwin) exec "$(dirname "$0")/setup-macos.sh" "$@" ;;
Linux) exec "$(dirname "$0")/setup-linux.sh" "$@" ;;
*)
  echo "❌ Unsupported OS: $(uname -s)"
  exit 1
  ;;
esac
