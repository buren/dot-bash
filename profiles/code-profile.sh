# "The Unofficial Bash Strict Mode" - http://redsymbol.net/articles/unofficial-bash-strict-mode/
bash_strict_mode() {
 echo "#!/bin/bash
set -euo pipefail
IFS=$'\n\t'"
}
