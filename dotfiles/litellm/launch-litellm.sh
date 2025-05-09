#!/usr/bin/env bash

export ANTHROPIC_API_KEY=$(cat ~/.dotfiles/secrets/anthropic_api_key.txt)
export OPENAI_API_KEY=$(cat ~/.dotfiles/secrets/openai_api_key.txt)
export GEMINI_API_KEY=$(cat ~/.dotfiles/secrets/gemini_api_key.txt)

docker-compose up
