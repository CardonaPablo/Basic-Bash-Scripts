#! /bin/bash

PIDS=()

ps -e | \
  while IFS= read -r line
  do
	ID=$(
		echo "$line" | \
			awk '{print $1}'
	)
	PIDS+=($ID)
  done

