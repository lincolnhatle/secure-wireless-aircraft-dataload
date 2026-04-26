#!/bin/bash

# ARINC 615A Tool Suite Setup Script for Debian 13
# This script installs system dependencies and clones project-specific libraries.

set -e

echo "### Step 1: Installing System Dependencies via APT"
# Requirements derived from README: Boost, libxml++, spdlog, and optional Qt 6
sudo apt update
sudo apt install \
		git \
    cmake \
    build-essential \
    libboost-all-dev \
    libxml++2.6-dev \
    libspdlog-dev \
    qt6-base-dev \
    qt6-declarative-dev

echo "### Step 2: Cloning First-Level Git Dependencies"
# Creating a directory for the custom Thomas Vogt libraries
DEPS_DIR="/home/data-loader/Documents/deps"
mkdir -p "$DEPS_DIR"
cd "$DEPS_DIR"

REPOS=(
    "https://git.thomas-vogt.de/thomas-vogt/arinc_615a" #technically not a first level dependency but screw you
    "https://git.thomas-vogt.de/thomas-vogt/helper"
    "https://git.thomas-vogt.de/thomas-vogt/qt_icon_resources"
    "https://git.thomas-vogt.de/thomas-vogt/arinc_645"
    "https://git.thomas-vogt.de/thomas-vogt/arinc_665"
    "https://git.thomas-vogt.de/thomas-vogt/tftp"
    "https://git.thomas-vogt.de/thomas-vogt/commands"
)

for repo in "${REPOS[@]}"; do
    repo_name=$(basename "$repo")
    if [ -d "$repo_name" ]; then
        echo "--> $repo_name already exists, updating..."
        git -C "$repo_name" pull
    else
        echo "--> Cloning $repo_name..."
        git clone "$repo"
    fi
done

echo "### Step 3: Build Environment Ready"
echo "All first-level dependencies are now present in: $(pwd)"
echo "You can now use CMake Presets to build the project."
