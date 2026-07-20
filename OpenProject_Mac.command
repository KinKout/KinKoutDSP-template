#!/bin/bash
# OpenProject_Mac.command launcher
# double-click to open CLion with the correct CMake preset.
# Close Terminal manually


cd "$(dirname "$0")"

python3 OpenInCLion.py

if [ $? -eq 0 ]; then
    kill $PPID
fi