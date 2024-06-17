#!/bin/bash -eu

function download_file_if_it_does_not_exist_already() {
  SOURCE_FILE_PATH_TO_CHECK="$1"
  TARGET_FILE_PATH="$2"
  DOWNLOAD_URL="$3"

  if [ ! -f $SOURCE_FILE_PATH_TO_CHECK ]; then
    echo "${SOURCE_FILE_PATH_TO_CHECK} was not found! Downloading dependency to ${TARGET_FILE_PATH}"
    wget -O $TARGET_FILE_PATH $DOWNLOAD_URL
  else
    echo "${SOURCE_FILE_PATH_TO_CHECK} was found! No download need."
  fi
}

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

function remove_symlinks_of_source_file() {
    SOURCE_FILE_PATH="$1"

    for FILE_FOUND in $(find -L $HOME -samefile $SOURCE_FILE_PATH)
    do
        echo "checking for symlink of $SOURCE_FILE_PATH found at $FILE_FOUND in $HOME"
        if [ "$(readlink "$FILE_FOUND")" -ef "$SOURCE_FILE_PATH" ] ; then
            echo "Removing symlink of $SOURCE_FILE_PATH found at $FILE_FOUND"
            rm $FILE_FOUND
        fi
    done
}
