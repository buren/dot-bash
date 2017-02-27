#!/bin/bash

repeat() {
  # Infinite loop
  for (( ; ; ));then do
    eval "$@"
    sleep 1
  done
}
