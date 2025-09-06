#!/usr/bin/env bash

target_dir=$(pwd)

date=$(date +%Y-%m-%d)
time=$(date +%H:%M:%S)
# Get device hostname
device_name=$(hostname)

# Change directory
if ! cd "$target_dir"; then
  echo "Error: Could not change directory to '$target_dir'"
  exit 1
fi

# Downloading the custom notification sound
mkdir -p ~/.sounds
wget -nc -O ~/.sounds/melodic.mp3 https://cdn.pixabay.com/audio/2025/06/02/audio_f91dce208a.mp3

# Pushing and logging
git add .
if [ $? -eq 0 ]; then
  git commit -m "Vault backup on $date at $time from $device_name"
  if [ $? -eq 0 ]; then
    git push
    if [ $? -eq 0 ]; then
      echo "Push completed successfully."

      # Play custom sound after commit using paplay
      paplay ~/.sounds/melodic.mp3
      # Displaying custom notification using zenity
      zenity --info --title="Vault Backup" --text="Successfully committed vault backup!\nTime: $time \nDate: $date" --width=200 --height=100
    else
      echo "Git push failed."

      zenity --info --title="Error!" --text="An error occured. Failed to push.\nRerun the script or push manually by typing 'git push'" --width=200 --height=100
    fi
  else
    echo "Commit failed."

    zenity --info --title="Error!" --text="An error occured. Failed to commit." --width=200 --height=100
  fi
else
  echo "Add failed."
fi
