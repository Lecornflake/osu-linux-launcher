#!/bin/bash

# This is an launcher for osu-lazer on linux.
# Its main feature is an automatic update detection directly from github.
# I made it to avoid relying on repo maintainers who might be late or inactive.

# If AppImageLauncher is installed on your device. You might encounter issues with unwanted prompts.
# "export APPIMAGELAUNCHER_DISABLE=1" will fix the issue (note that this will get rid of popups for all AppImages)
# I might add options to change the AppImage location.

# The script will download an Appimage and put it in your osu-lazer directory (the one containing skins, songs,...).
# The osu! folder path used here is the path that should be used by the osu! framework : https://github.com/ppy/osu-framework/blob/master/osu.Framework/Platform/Linux/LinuxGameHost.cs
if [[ -z "$XDG_DATA_HOME" ]]; then
    OSUDIR="$HOME/.local/share/osu"
else
    OSUDIR="$XDG_DATA_HOME/osu"
fi

if [ ! -d "$OSUDIR" ]; then
    echo "The osu $OSUDIR directory does not exist ($OSUDIR) !"
    read -rp "This might be your first install on this computer. Do you want to create this directory and try downloading osu! ?
WARNING : This is untested [y/N]" ANSWER
    # There is a chance doing this might be broken. Proceed with caution.
    if [[ $ANSWER == "Y" || $ANSWER == "y" ]]; then
        mkdir -p "$OSUDIR"
        echo "The osu! AppImage and the osu! assets will be located in $OSUDIR (if everything goes fine)"
    else
        exit 1
    fi
fi

# This script relies on a text file made to register the version of the game (I'd like to change this)
LOCAL_VERSION=$([ -f "$OSUDIR/osu-version" ] && cat "$OSUDIR/osu-version")
# Fetches laest available version using github API.
REMOTE_VERSION=$(curl -s https://api.github.com/repos/ppy/osu/releases/latest | jq '.["tag_name"]' | tr -d '"')

# if curl fails (no internet for exemple), don't try to update
if [[ "$LOCAL_VERSION" != "$REMOTE_VERSION" ]] && [[ -n "$REMOTE_VERSION" ]]; then

    read -rp "A new update is available (version $REMOTE_VERSION) ! Update now ? [Y/n]" ANSWER
	if [[ $ANSWER == "Y" || $ANSWER == "y" || $ANSWER == "" ]]; then
        if [ -n "$LOCAL_VERSION" ]; then
            echo "Upgrading from $LOCAL_VERSION to $REMOTE_VERSION..."
        else
            echo "Downloading latest osu! release : $REMOTE_VERSION"
        fi

        # Creating a temp directory for safety. If an issue were to happen with wget, We don't want it to break a working AppImage.
        # wget -N or something similar might do the trick, but until I know better, a temp directory will do.
        mkdir "$OSUDIR/temp"
        if wget -P "$OSUDIR/temp" "https://github.com/ppy/osu/releases/latest/download/osu.AppImage"; then
            [ -f "$OSUDIR/osu.AppImage" ] && rm "$OSUDIR/osu.AppImage"
            mv "$OSUDIR/temp/osu.AppImage" "$OSUDIR"
            chmod u+x "$OSUDIR/osu.AppImage"
            [ -f "$OSUDIR/osu-version" ] || touch "$OSUDIR/osu-version"
            echo "$REMOTE_VERSION" > "$OSUDIR/osu-version"
            LOCAL_VERSION=$REMOTE_VERSION
        else
            echo "An error occured..."
            exit 1
        fi
        rm -r "$OSUDIR/temp"

    else
	    echo "OK ! We'll update another time !"
    fi
fi

if [ -f "$OSUDIR/osu.AppImage" ]; then
    echo "launching osu! (version $LOCAL_VERSION)" && exec "$OSUDIR/osu.AppImage" &
else
    echo "No $OSUDIR/osu.AppImage has been found..."
    [ -f "$OSUDIR/osu-version" ] && rm "$OSUDIR/osu-version"
fi