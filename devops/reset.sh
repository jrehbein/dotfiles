#!/bin/bash -eu

# Source Location Variables
CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops
REPO_CONFIG_DIR=$REPO_ROOT/.config

# Target Location Variables
CONFIG_DIR=$HOME/.config
GIT_CONFIG_DIR=$CONFIG_DIR/git


echo "Reset dotfiles and environment to original state"

. $DEVOPS_DIR/utils.sh

echo "Removing dependencies if they exist"

rm $GIT_CONFIG_DIR/.git-prompt.sh || true
rm $GIT_CONFIG_DIR/.git-completion.bash || true

echo "Removing symlinks"

remove_symlinks_of_source_file "$REPO_ROOT/.bashrc"
remove_symlinks_of_source_file "$REPO_ROOT/.inputrc"
remove_symlinks_of_source_file "$REPO_ROOT/.zshrc"
remove_symlinks_of_source_file "$REPO_CONFIG_DIR/.dircolors"
remove_symlinks_of_source_file "$REPO_CONFIG_DIR/git/config"

echo "Removing directories if they are empty"

rm -d $GIT_CONFIG_DIR || true

echo "Done Resetting! Please run 'bash -l' in the bash shell to apply changes"

