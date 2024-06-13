#!/bin/bash -eu

# Source Location Variables
CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)
DEVOPS_DIR=$REPO_ROOT/devops
REPO_CONFIG_DIR=$REPO_ROOT/.config

# Target Location Variables
CONFIG_DIR=$HOME/.config
GIT_CONFIG_DIR=$CONFIG_DIR/git

echo "Setting up dotfiles and environment"

. $DEVOPS_DIR/utils.sh

echo "Resetting previous dotfiles repo specific if there is any"

. $DEVOPS_DIR/reset.sh

echo "Creating directories"
mkdir -p $CONFIG_DIR
mkdir -p $GIT_CONFIG_DIR

echo "Downloading dependencies if necessary"

# Check to see if git completion scripts need to be downloaded
if ! shopt -oq posix; then
    GIT_COMPLETION_DOWNLOAD_URL=https://raw.githubusercontent.com/git/git/master/contrib/completion/
    LOCAL_GIT_CORE_COMPLETION_FOLDER=/usr/local/share/git-core/contrib/completion/

    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-prompt.sh $GIT_CONFIG_DIR/.git-prompt.sh $GIT_COMPLETION_DOWNLOAD_URL/git-prompt.sh
    download_file_if_it_does_not_exist_already  $LOCAL_GIT_CORE_COMPLETION_FOLDER/git-completion.bash $GIT_CONFIG_DIR/.git-completion.bash $GIT_COMPLETION_DOWNLOAD_URL/git-completion.bash
fi

echo "Creating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.bashrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.inputrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.zshrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_CONFIG_DIR/.dircolors" "$CONFIG_DIR"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_CONFIG_DIR/git/config" "$GIT_CONFIG_DIR"

echo "Done! Please run 'bash -l' in the bash shell to apply changes"
