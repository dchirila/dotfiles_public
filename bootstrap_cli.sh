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
# Args: $1 = folder/file-name
#       $2 = $CONTEXT (i.e. 'for_vim', 'for_git', etc.)
function relink_in_home
{
  DESTINATION=$HOME'/'$1
  SOURCE=$(pwd -P)/$2/$1

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

# Function to delete and (re)link files and folders to
# a custom target folder.
# Args: $1 = folder/file-name
#       $2 = $CONTEXT (i.e. 'for_vim', 'for_git', etc.)
#       $3 = host folder, inside which to relink.
function relink_in_folder
{
  HOST_FOLDER=$3
  DESTINATION=$3'/'$1 # may be file OR folder
  SOURCE=$(pwd -P)/$2/$1

  # Sanity-check: HOST_FOLDER should either be a valid FOLDER
  #               (pre-existing, or to be created).
  #               It should NOT be a FILE!
  echo -n "$2: Checking that $3 really is a valid FOLDER-name ... "
  [[ -d $3 ]] || [[ ! -f $3 ]]
  check_err

  # Preparation: Create HOST_FOLDER if it doesn't exist.
  if [[ ! -d $3 ]]; then
    echo -n "$2: Creating FOLDER $3 anew ... "
    mkdir $3
    check_err
  fi

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
# -> Get the path to the script (so that we know where the sub-dirs are)
pushd $(dirname $0) > /dev/null
DOTDIR=$(pwd -P)
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
git config --global commit.template $DOTDIR/$CONTEXT/commit_template.txt
check_err; echo
# -> ignored-files
#    (A) This version uses file defined by me
git config --global core.excludesfile $CONTEXT/my_gitignore_global
#    (B) This version uses files defined in the community GitHub-repo
URL_GITIGNORES=https://github.com/github/gitignore.git
# -> gitk
relink_in_home '.gitk' $CONTEXT


# =*= Set-up for TMUX =*=
CONTEXT="for_tmux"
# -> .tmux.conf
relink_in_home '.tmux.conf' $CONTEXT

# =*= Set-up for VIM =*=
CONTEXT="for_vim"
# -> .vim/-dir
relink_in_home '.vim' $CONTEXT
# -> .vimrc
relink_in_home '.vimrc' $CONTEXT
# -> .gvimrc
relink_in_home '.gvimrc' $CONTEXT
# -> .vim/vundle.git
if [[ ! -d $CONTEXT/.vim/vundle.git ]]; then
  echo -n "$CONTEXT: Pulling Vundle ... "
  git clone https://github.com/gmarik/vundle.git $CONTEXT/.vim/vundle.git
  check_err; echo
fi
# -> Triggering BundleInstall (Vundle)
echo -n "$CONTEXT: BundleInstall (Vundle) ... "
vim +BundleInstall +qall
check_err; echo

# =*= Set-up for Pentadactyl (Firefox plugin) =*=
CONTEXT="for_pentadactyl"
# -> .pentadactylrc
relink_in_home '.pentadactylrc' $CONTEXT

# =*= Set-up for my_cloc (estimates for lines of code) =*=
CONTEXT="for_my_cloc"
# -> Get the latest version of 'cloc' itself
echo -n "$CONTEXT: Getting latest release of 'cloc'-script ... "
wget 'http://sourceforge.net/projects/cloc/files/latest/download?source=files' \
  -O $CONTEXT/cloc &> /dev/null
check_err; echo
chmod +x $CONTEXT/cloc
# -> STORE PATHS for later (to construct a BASH-alias)
MY_CLOC_PATH=$DOTDIR/$CONTEXT/cloc
MY_CLOC_DEF_PATH=$DOTDIR/$CONTEXT/my_cloc_language_definitions.txt

# =*= Set-up for readline =*=
CONTEXT="for_readline"
# -> .inputrc
relink_in_home '.inputrc' $CONTEXT

# =*= Set-up for XMonad =*=
CONTEXT="for_xmonad"
# -> xmonad.hs
# NOTE: Since we don't want to pull the files from under a running
#       XMonad-session, we do not reset the entire ~/.xmonad-folder.
#       Instead, we only re-create that folder if it doesn't exist already,
#       and only reset the xmonad.hs-file itself.
relink_in_folder 'xmonad.hs' $CONTEXT $HOME/.xmonad

# =*= Set-up for BASH =*=
CONTEXT="for_bash"
# -> Generate 'bash_aliases' (from 'bash_aliases_template')
cat $CONTEXT/bash_aliases_template | \
  sed "s|MACRO_CLOC_DEFN_PATH|$MY_CLOC_DEF_PATH|" | \
  sed "s|MACRO_CLOC_PATH|$MY_CLOC_PATH|" > \
  $CONTEXT/bash_aliases

