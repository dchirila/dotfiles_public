# File: bootstrap_cli.sh
# Purpose: Bootstrap my usual command-line tools.

#!/bin/bash

# Function to simplify error-reporting.
# NOTE: Call this after each "milestone"!
function check_err
{
	if [ $? -gt 0 ]; then
		echo "FAIL!"
		exit 1
	else
		echo "OK"
	fi
}

# =*= Global Variables for bootstrap_cli.sh-script =*=
VOID='/dev/null'
# -> Get the path to the script (so that we know where the sub-dirs are)
pushd `dirname $0` > /dev/null
DOTDIR=`pwd -P`
popd > /dev/null
echo "Script is in folder: $DOTDIR"

# =*= Change to DOTDIR, to make things easier =*=
cd $DOTDIR

# =*= Set-up for GIT =*=
FOR_GIT=$DOTDIR/for_git
# - general settings
echo -n "GIT: applying general settings ... "
git config --global user.name "Dragos B. Chirila"
git config --global user.email "dchirila@gmail.com"
git config --global core.editor vim
git config --global color.ui true
git config --global alias.unstage "reset HEAD"
# -> for cross-platform development
#    (Windows users should set "core.autocrlf true")
git config --global core.autocrlf input
# -> commit-message template
git config --global commit.template $FOR_GIT/commit_template.txt
check_err
# -> ignored-files
#    (A) This version uses file defined by me
git config --global core.excludesfile $FOR_GIT/my_gitignore_global
#    (B) This version uses files defined in the community GitHub-repo
URL_GITIGNORES=https://github.com/github/gitignore.git

