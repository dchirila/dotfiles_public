# File: bootstrap_cli.sh
# Purpose: Bootstrap my usual command-line tools.

#!/bin/bash

# Function to simplify error-reporting.
# Args: None
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

# Function to delete and (re)link files and folders to
# $HOME-folder.
# Args: $1 = directory/file-name
#       $1 = $CONTEXT (i.e. 'for_vim', 'for_git', etc.)
function relink_to_home
{
  DESTINATION=$HOME'/'$1
  SOURCE=$(pwd)/$2/$1

  # Stage 1: Cleanup
  if [[ -d $DESTINATION ]]; then
    echo -n "$2: removing existing FOLDER $DESTINATION ... "
    rm -rf $DESTINATION
    check_err
  elif [[ -f $DESTINATION ]]; then
    echo -n "$2: removing existing FILE $DESTINATION ... "
    rm -rf $DESTINATION
    check_err
  fi
  # Stage 2: Re-link
  echo -n "$2: (re)linking $SOURCE -> $DESTINATION ... "
  ln -sf $SOURCE $DESTINATION
  check_err; echo
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
CONTEXT="for_git"
# -> general settings
echo -n "$CONTEXT: applying general settings ... "
git config --global user.name "Dragos B. Chirila"
git config --global user.email "dchirila@gmail.com"
git config --global core.editor vim
git config --global color.ui true
git config --global alias.unstage "reset HEAD"
# -> for cross-platform development
#    (Windows users should set "core.autocrlf true")
git config --global core.autocrlf input
# -> commit-message template
git config --global commit.template $CONTEXT/commit_template.txt
check_err; echo
# -> ignored-files
#    (A) This version uses file defined by me
git config --global core.excludesfile $CONTEXT/my_gitignore_global
#    (B) This version uses files defined in the community GitHub-repo
URL_GITIGNORES=https://github.com/github/gitignore.git
# -> gitk
relink_to_home '.gitk' $CONTEXT


## =*= Set-up for TMUX =*=
CONTEXT="for_tmux"
# -> .tmux.conf
relink_to_home '.tmux.conf' $CONTEXT

# =*= Set-up for VIM =*=
CONTEXT="for_vim"
# -> .vim/-dir
relink_to_home '.vim' $CONTEXT
# -> .vimrc
relink_to_home '.vimrc' $CONTEXT
# -> .gvimrc
relink_to_home '.gvimrc' $CONTEXT
# -> Pull submodules
echo -n "$CONTEXT: Pulling Vundle ... "
git clone git@github.com:gmarik/vundle.git $CONTEXT/.vim/vundle.git
check_err; echo
# -> Triggering BundleInstall (Vundle)
echo -n "$CONTEXT: BundleInstall (Vundle) ... "
vim +BundleInstall +qall
check_err; echo

