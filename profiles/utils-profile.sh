#!/bin/bash

repeat() {
  # Infinite loop
  for (( ; ; ))
  do
    eval "$@"
    sleep 1
  done
}
