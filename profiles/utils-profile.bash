#!/bin/bash

repeat() {
  # Infinite loop
  while true;do
    eval "$@"
    sleep 1
  done
}
