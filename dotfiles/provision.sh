#!/bin/sh

CURRENT_DIRECTORY=$(pwd)

mkdir -p ~/.config

ln -s "${CURRENT_DIRECTORY}/nvim" ~/.config/nvim
ln -s "${CURRENT_DIRECTORY}/applications" ~/.applications
