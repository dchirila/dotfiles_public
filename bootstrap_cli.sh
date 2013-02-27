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
# -> general settings
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

# =*= Set-up for TMUX =*=
FOR_TMUX=$DOTDIR/for_tmux
if [ -f $HOME/.tmux.conf ]; then
	echo -n "TMUX: removing existing .tmux.conf ... "
	rm $HOME/.tmux.conf
	check_err
fi
echo -n "TMUX: linking new .tmux.conf ... "
ln -sf $FOR_TMUX/.tmux.conf $HOME/.tmux.conf
check_err

# =*= Set-up for VIM =*=
FOR_VIM=$DOTDIR/for_vim
# -> .vim/-dir
if [ -d $HOME/.vim ]; then
	echo -n "VIM: removing existing .vim-folder ... "
	rm -rf $HOME/.vim
	check_err
fi
echo -n "VIM: linking new .vim-folder ... "
ln -sf $FOR_VIM/.vim $HOME/.vim
check_err
# -> .vimrc
if [ -f $HOME/.vimrc ]; then
	echo -n "VIM: removing existing .vimrc ... "
	rm $HOME/.vimrc
	check_err
fi
echo -n "VIM: linking new .vimrc ... "
ln -sf $FOR_VIM/.vim/.vimrc $HOME/.vimrc
check_err
# -> .gvimrc
if [ -f $HOME/.gvimrc ]; then
	echo -n "VIM: removing existing .gvimrc ... "
	rm $HOME/.vimrc
	check_err
fi
echo -n "VIM: linking new .gvimrc ... "
ln -sf $FOR_VIM/.vim/.gvimrc $HOME/.gvimrc
check_err
# -> Triggering BundleInstall (Vundle)
echo -n "VIM: BundleInstall (Vundle) ... "
vim +BundleInstall +qall
check_err

