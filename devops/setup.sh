#!/bin/bash -eu
CURRENT_DIR=$(cd "`dirname "$0"`" && pwd)
REPO_ROOT=$(cd "$CURRENT_DIR"/.. && pwd)

CONFIG_DIR=$HOME/.config
LOCAL_DIR=$HOME/.local

GIT_CONFIG_DIR=$CONFIG_DIR/git
SHARED_LOCAL_BASH_DIR=$LOCAL_DIR/share/bash
SHARED_LOCAL_BASH_HISTORY_FILE=$SHARED_LOCAL_BASH_DIR/history

echo "Creating directories"
mkdir -p $CONFIG_DIR
mkdir -p $GIT_CONFIG_DIR
mkdir -p $SHARED_LOCAL_BASH_DIR


echo "Creating files"
[[ -f $SHARED_LOCAL_BASH_HISTORY_FILE ]] || touch $SHARED_LOCAL_BASH_HISTORY_FILE

echo "Downloading dependencies"
wget -O $GIT_CONFIG_DIR/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
wget -O $GIT_CONFIG_DIR/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

function create_symlink_if_necessary() {
    SOURCE_FILE_PATH="$1"
    TARGET_FILE_PATH="$2"
    SOURCE_FILE_NAME=$(basename "$SOURCE_FILE_PATH")

    echo "Now setting up symlink for $SOURCE_FILE_PATH"

    if [ -L "$TARGET_FILE_PATH" ]; then
        if [ "$(readlink "$TARGET_FILE_PATH")" -ef "$SOURCE_FILE_PATH" ] ; then
           echo "Symlink already exists and points to the correct target."
           return 0
        fi

        echo "Symlink exists, but points to an incorrect location, will remove and recreate"
        rm "$TARGET_FILE_PATH"
    fi

    if [ -e "$TARGET_FILE_PATH" ] ; then
        echo "File already exists but is not a symlink. Doing nothing"
        return 0
    fi

    if [ -e "$SOURCE_FILE_PATH" ] ; then
        echo "Creating a symlink now."
        ln -s "$SOURCE_FILE_PATH" "$TARGET_FILE_PATH"
    else
        echo "File ${SOURCE_FILE_NAME} not found. Skipping symlink creation"
    fi

    return 0
}

function symlink_or_symlink_as_alt_name_as_necessary() {
    SOURCE_FILE_PATH="$1"
    TARGET_FOLDER="$2"
    SOURCE_FILE_NAME=$(basename "$SOURCE_FILE_PATH")
    TARGET_FILE_PATH="$TARGET_FOLDER/$SOURCE_FILE_NAME"

    echo "Figuring out symlink details to symlink $SOURCE_FILE_PATH into $TARGET_FOLDER"

    if [ -e "$TARGET_FILE_PATH" ] ; then
        TARGET_FILE_NAME="${SOURCE_FILE_NAME:1}"
        TARGET_FILE_NAME=".personal_${TARGET_FILE_NAME}"
        RENAMED_FILE_PATH="$TARGET_FOLDER/$TARGET_FILE_NAME"

        echo "File already exists but is not a symlink. Will symlink as ${TARGET_FILE_NAME}"

        create_symlink_if_necessary $SOURCE_FILE_PATH $RENAMED_FILE_PATH
        return 0
    fi

    create_symlink_if_necessary $SOURCE_FILE_PATH $TARGET_FILE_PATH
    return 0
}

echo "Creating symlinks"

symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.bashrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.inputrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.zshrc" "$HOME"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.config/.dircolors" "$CONFIG_DIR"
symlink_or_symlink_as_alt_name_as_necessary "$REPO_ROOT/.config/git/config" "$GIT_CONFIG_DIR"

echo ""
echo "Done!"
