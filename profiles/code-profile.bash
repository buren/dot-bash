#!/bin/bash

# "The Unofficial Bash Strict Mode" - http://redsymbol.net/articles/unofficial-bash-strict-mode/
bash_strict_mode() {
 echo "#!/bin/bash
set -euo pipefail
IFS=$'\n\t'"
}

# Modified from https://gist.github.com/namklabs/273055ef9c060af6ddc34a78910585a6
function lorem(){
  # Copy lorem ipsum to your clipboard in OS X

  # usage:

  # $ lorem <int> <htmlflag>

  # where <int> is how many paragraphs of lorem ipsum you want, each separated by 2 newlines
  # and <htmlflag> is anything, indicating you want each paragraph surrounded by <p></p>. Omit if you don't want this.

  # Explanations

  # This is our source lorem ipsum text.
  lorem='Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'

  # Here we are gathering the <int> argument.
  count=$(( $1 ))


  # The minimum is 1 lorem ipsum, so enforce that here.
  if [[ "$count" -lt 1 ]];then
    count=$(( $count + 1 ))
  fi

  # This is the variable that will hold our output.
  text=''

  # Iterate until our count is zero. Decrement each iteration.
  while [ "$count" -gt 0 ];do
    # Append the lorem ipsum again.
    text=$text$lorem

    # If this isn't the last iteration, add newlines or paragraph HTML tags.
    if [[ "$count" -gt 1 ]];then
      text=$text'\n\n'
    fi

    # Decrement our counter variable.
    count=$(( $count - 1 ))
  done

  echo -e $text
}
alias ipsum='lorem'
