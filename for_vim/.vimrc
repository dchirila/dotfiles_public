"______________________________________________________________________"
" Dragos Chirila's Vim Configuration                                   "
" Vundle is used for plugin-management; also, I included a lot of tips "
" from the Internet, which worked for me.                              "
"----------------------------------------------------------------------"

"_______________________"
" START: Vundle Section "
"-----------------------"
    set nocompatible
    filetype off              " required! (for Vundle)
    set rtp+=~/.vim/vundle.git/
    call vundle#rc()

    " START: Bundles I need

        " START: Bundles I need :: Original REPOS on GitHub "

            Bundle 'mileszs/ack.vim.git'
            Bundle 'sjl/gundo.vim.git'
            Bundle 'scrooloose/nerdtree.git'
            Bundle 'scrooloose/nerdcommenter.git'
            Bundle 'tpope/vim-fugitive.git'
            Bundle 'tpope/vim-git.git'
            Bundle 'tpope/vim-markdown.git'
            Bundle 'tpope/vim-repeat.git'
            Bundle 'tpope/vim-surround.git'
            Bundle 'tpope/vim-vividchalk.git'
            Bundle 'tsaleh/vim-tmux.git'
            Bundle 'Shougo/neocomplcache.git'
            Bundle 'gerw/vim-latex-suite.git'
            Bundle 'vim-jp/cpp-vim.git'
            "Bundle 'Rip-Rip/clang_complete.git'
            "Bundle 'quark-zju/vim-cpp-auto-include.git'
            "" Plugin below is for GitHub Gists (useful for code-exchange).
            " Bundle 'vim-scripts/Gist.vim.git'
            Bundle 'vim-scripts/bufkill.vim.git'
            Bundle 'vim-scripts/DoxygenToolkit.vim.git'
            Bundle 'vim-scripts/TaskList.vim.git'
            Bundle 'vim-scripts/AutoTag.git'
            Bundle 'vim-scripts/Boost-Build-v2-BBv2-syntax.git'
            "Bundle 'vim-scripts/OmniCppComplete.git'
            Bundle 'vim-scripts/Cpp11-Syntax-Support.git'
            "Bundle 'vim-scripts/c.vim.git'
            Bundle 'Lokaltog/vim-easymotion'
            Bundle 'Lokaltog/vim-powerline'
            "" Plugin below is for HTML-CSS editing.
            "Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}

        " END: Bundles I need :: Original REPOS on GitHub "

        " START: Bundles I need :: Vim-scripts REPOS "

            Bundle 'L9'
            Bundle 'FuzzyFinder'

        " END: Bundles I need :: Vim-scripts REPOS "

    " END: Bundles I need

    filetype plugin indent on " required! (for Vundle)
"_____________________"
" END: Vundle Section "
"---------------------"

"__________________"
" START: Functions "
"------------------"

    " Function to remove trailing spaces after text on a line.
    function! <SID>StripTrailingWhitespaces()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " Do the business:
        %s/\s\+$//e
        " Clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction

    function! HighlightAllOfWord(onoff)
        if a:onoff == 1
            :augroup highlight_all
            :au!
            :au CursorMoved * silent! exe printf('match Search /\<%s\>/', expand('<cword>'))
            :augroup END
        else
            :au! highlight_all
            match none /\<%s\>/
        endif
    endfunction

"________________"
" END: Functions "
"----------------"

"___________________________________"
" START: Filetype-dependent settings"
"-----------------------------------"
if has("autocmd")
    let g:load_doxygen_syntax=1

    " Syntax-highlighting for tmux.conf
    au BufRead,BufNewFile */.tmux.conf set filetype=tmux

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

    " C++: Customizations based on HOUSE-STYLE (variable)
    autocmd BufEnter,BufNewFile,BufRead *.{cc,cxx,cpp,h,hh,hpp,hxx} set matchpairs+=<:> " Add angle-brackets to matched-items (for C++ templates)
    autocmd BufEnter,BufNewFile,BufRead *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal sts=4 sw=4 expandtab
    "autocmd BufEnter,BufNewFile,BufRead *.{cc,cxx,cpp,h,hh,hpp,hxx} set formatprg=uncrustify\ -c\ /home/dchirila/Desktop/CPP_CodingStandard/call_Uncrustify_production1.cfg\ -l\ CPP\ --no-backup\ 2>/dev/null

    " Treat .tex files as pdflatex
    autocmd BufNewFile,BufRead *.tex setfiletype latex

    " Haskell
    autocmd FileType hs setlocal ts=4 sts=4 sw=4 expandtab    " config whitespace
    "autocmd BufEnter *.hs compiler ghc " configure compiler
    let g:haddock_browser = "/usr/bin/firefox" " set-up browser for haskell_doc.vim

    " Git commit message
    " To me, it doesn't make sense to enable C-style indenting (esp for braces)
    " in the commit-messages, so I disable that.
    autocmd BufRead,BufNewFile {COMMIT_EDITMSG} setl nocindent

    " Treat .plt and .gnuplot files as GnuPlot
    autocmd BufNewFile,BufRead *.plt,.gnuplot setfiletype gnuplot

    " Treat .asy files as Asymptote
    autocmd BufNewFile,BufRead *.asy setfiletype asy

    " Fortran stuff
    let fortran_free_source=1
    let fortran_do_enddo=1
    let fortran_more_precise=1
    let fortran_have_tabs=1

    "" Treat .f90 and .f03 files as Fortran
    "autocmd BufNewFile,BufRead *.f90 set filetype=fortran
    "autocmd BufNewFile,BufRead *.f03 set filetype=fortran

    " START: Filetype-dependent COMPILER-settings
        " NOTE: Enables :make to compile, or validate, certain filetypes
        " (use :cn & :cp to jump between errors)
        au FileType xml,xslt compiler xmllint
        au FileType html compiler tidy
    " END: Filetype-dependent COMPILER-settings
endif
"_________________________________"
" END: Filetype-dependent settings"
"---------------------------------"

"__________________________________________________________"
" START: General VIM-settings (both CLI- and GUI-versions) "
"----------------------------------------------------------"
    " set the colorscheme
    colorscheme desert " GOOD OPTIONS desert/delek/koehler

    " Source the VIMRC-file after saving it
    if has("autocmd")
      autocmd! bufwritepost .vimrc source $MYVIMRC " platform-independent
    endif

    " Issue warning if we have same file open in another editor.
    autocmd FileChangedShell *
        \ echohl WarningMsg |
        \ echo "Seems like another program is editing the same file!" |
        \ echohl None

    " Some key-bindings to enhance Vim Help Navigation:
    " Usage: hit Enter to activate links, and Ctrl-[ to go back.
    au FileType help nmap <buffer> <Return> <C-]>
    au FileType help nmap <buffer> <C-[> <C-O>

    " Let Vim know about our preferred NIX-SHELL.
    if has("unix")
        set shell=bash
    endif

    " START: Fix some of vi's problems
        map Y y$
        " prevents inserting two spaces after punctuation on a join 
        set nojoinspaces
    " END: Fix some of vi's problems

    " START: Settings for text-wrapping
        set textwidth=80
        set wm=2 " enables text-wrapping
    " END: Settings for text-wrapping

    " Allow backspacing over indent, eol, and the start of an insert
    set backspace=2

    " START: Make sure filetype-detection is enabled
        filetype on
        filetype plugin on
    " END: Make sure filetype-detection is enabled

    " START: Enable Omni-completion
        set ofu=syntaxcomplete#Complete
        if has("autocmd")
            au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
        endif
    " END: Enable Omni-completion

    " START: Get rid of the bells
        set t_vb=^[...
        set noerrorbells
        set novisualbell
    " END: Get rid of the bells

    " Show line-numbers
    set nu

    " Show the current mode
    set showmode

    " Set working directory to the current file 
    autocmd BufEnter * lcd %:p:h

    " tell VIM to always put a status line in, even if there is only one window
    set laststatus=2

    " Enable StripTrailingWhitespace for certain filetypes (when file is saved)
    if has("autocmd")
      autocmd BufWritePre *.py,*.cpp,*.h,*.hpp,*.inl,*.f90,*.sh :call <SID>StripTrailingWhitespaces()
    endif

    " Let the error-messages persist for longer, instead of dissapearing
    " after one second at startup.
    set debug=msg

    " Disable encryption (:X)
    set key=

    " Keep some stuff in the history
    set history=100

    " This is the timeout used while waiting for user input on a multi-keyed macro
    " or while just sitting and waiting for another key to be pressed measured
    " in milliseconds.
    "
    " i.e. for the ",d" command, there is a "timeoutlen" wait period between the
    "      "," key and the "d" key.  If the "d" key isn't pressed before the
    "      timeout expires, one of two things happens: The "," command is executed
    "      if there is one (which there isn't) or the command aborts.
    set timeoutlen=500

    " START: Make the line numbers look nice...
        " can also try: white+dark/lightgreen
        hi LineNr guifg=darkgray guibg=lightgray
        hi LineNr ctermfg=darkgray ctermbg=lightgray
    " END: Make the line numbers look nice...

    " START: X11 Integration
        " Basically, we disable a lot of things here, to avoid annoying
        " behavior.
        " NOTE: May want to look at these more closely in  the future, in case
        " there is also something we DO want.
        set mouse=a
        set selectmode=mouse
        " Disable automatic X11 clipboard-crossover.
        set clipboard=
        " Hide the mouse pointer while typing
        set mousehide
    " END: X11 Integration

    " START: Performance Tweaks
        " Will NOT redraw the screen while running macros.
        set lazyredraw
        " Improved re-drawing for newer computers
        set ttyfast
        " Don't show the current command in the lower-right corner.
        " NOTE: This may be particularly important for OSX, when lazyredraw is
        " also set (combination slows things down).
        set showcmd
        " Disable syntax-highlighting for lines that are just too long
        " (otherwise, things slow-down in that case).
        set synmaxcol=2048
    " END: Performance Tweaks

    " Don't complain when creating HIDDEN BUFFERS (i.e. wanting to navigate away
    " from a buffer before changes have been saved)
    set hidden

    " START: TABs-related settings

        " Vim manual reccomends to leave this at 8, and adjust
        "other params instead to enforce our preferences.

        "set tabstop=8

        " We choose tabstops to be 4 spaces
        set shiftwidth=4
        set softtabstop=4
        " Replace TABs with SPACES (good for normal code).
        " NOTE: Some programming-languages rely on TABs, so we have to disable
        " this in specific cases.
        set expandtab
    " END: TABs-related settings

    " Make DIFF-mode ignore whitespace.
    set diffopt+=iwhite

    " START: INDENTING settings
        " Enable automatic-indentation as-you-type
        filetype indent on
        " Indentation for C/C++
        set cinoptions=>s,e0,n0,f0,{s,}0,^0,:s,=s,l1,b0,gs,t0,+2s,i0,c3,(0,W2s
        set cindent

        " ??
        "set autoindent

        " Helps with backspacing because of 'expandtab'-option
        set smarttab
        " Rounds indent to a multiple of 'shiftwidth'
        set shiftround
    " END: INDENTING settings

    " START: SYNTAX-HIGHLIGHTING settings
        " Enable...
        syntax on
        " Flashes matching brackets or parentheses
        set showmatch
        " (Alternatively): Disable highlighting of matched parens
        "let g:loaded_matchparen=1
    " END: SYNTAX-HIGHLIGHTING settings

    " START: Search settings 
        " set the search scan to wrap lines
        set wrapscan
        " automatically begins searching as you type
        set incsearch
        " ignores case when pattern matching
        set ignorecase
        " ignores ignorecase when pattern contains uppercase characters
        set smartcase
        " highlights search results
        set hlsearch
        " Searches the current directory, as well as subdirectories when commands
        " like :find, :grep, etc. are issued.
        set path=.,**
    " END: Search settings 

    " START: Folding settings
        " Disable folding by default
        "set nofoldenable
        " RECOMMENDED for code-COLLABORATION
        "set foldmethod=indent
        set foldmethod=syntax
        " Start worrying if more fold-nesting is necessary
        set foldnestmax=10
        " Creates a small left-hand gutter for displaying fold info
        set foldcolumn=4
    " END: Folding settings

    " START: COMMAND-LINE COMPLETION
        " Make the command-line completion better
        set wildmenu
        " Same as default except that I remove the 'u' option
        set complete=.,w,b,t
        " When completing by tag, show the whole tag, not just the function name
        set showfulltag
    " END: COMMAND-LINE COMPLETION

    " START: VIEW settings
        " Automatically save and re-load view (folding)
        au BufWinLeave *.* mkview
        au BufWinEnter *.* silent loadview
    " END: VIEW settings

    " Disable paste mode when leaving Insert Mode
    au InsertLeave * set nopaste 

    " START: Config Powerline plugin
        let g:Powerline_symbols='fancy'
    " END: Config Powerline plugin

    " Need this on Debian/Ubuntu for Ack-plugin to work
    let g:ackprg="ack-grep -H --nocolor --nogroup --column"
"________________________________________________________"
" END: General VIM-settings (both CLI- and GUI-versions) "
"--------------------------------------------------------"

"_________________________"
" START: Keyboard Mapping "
"-------------------------"
    " Set the system-default lead for mappings to the ","-character.
    let mapleader = ","

    " START: Bindings for faster switching of buffers
        map <C-N> :bnext<CR> " map CTRL-N to "next buffer"
        map <C-P> :bprevious<CR> " map CTRL-P to "previous buffer"
    " END: Bindings for faster switching of buffers

    " START: Bindings for shifting lines UP/DOWN
        " NOTE: They are NOT enabled because they don't behave nicely at the beginning
        " and end of the file.
        "map - ddp     " DOWN
        "map _ ddkP    " UP
    " END: Bindings for shifting lines UP/DOWN

    " Make the current file executable
    nmap ,x :w<cr>:!chmod 755 %<cr>:e<cr>

    " - Shortcut to add new blank line without entering insert mode
    noremap <CR> :put_<CR>

    " - A shortcut to show the numbered register contents
    map <F2> :reg "0123456789-*+:/<CR>

    " - useful so auto-indenting doesn't mess up code when pasting
    set pastetoggle=<F5>

    " Launch the Gundo plugin
    nnoremap <F6> :GundoToggle<CR>

    " - Use ctrl-L to unhighlight search results in normal mode
    nmap <silent> <C-L> :silent noh<CR>

    " - Keyboard mapping for quickly editing $MYVIMRC
    nmap <leader>v :tabedit $MYVIMRC<CR>

    " - Spacebar toggles a fold, zi toggles all folding, zM closes all folds
    noremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>

    " Search the current file for the word under the cursor and display matches
    nmap <silent> ,gw :vimgrep /<C-r><C-w>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

    " Search the current file for the WORD under the cursor and display matches
    nmap <silent> ,gW :vimgrep /<C-r><C-a>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:nohls<CR>

    " Swap two words
    nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'

    " Underline the current line with '='
    nmap <silent> ,u= :t.\|s/./=/g\|:nohls<cr>
    nmap <silent> ,u- :t.\|s/./-/g\|:nohls<cr>

    " Shrink the current window to fit the number of lines in the buffer.  Useful
    " for those buffers that are only a few lines
    nmap <silent> ,sw :execute ":resize " . line('$')<cr>

    " Use the bufkill plugin to eliminate a buffer but keep the window layout
    nmap ,bd :BD<cr>

    " Clear the text using a motion / text object and then move the character to the
    " next word
    nmap <silent> ,C :set opfunc=ClearText<CR>g@
    vmap <silent> ,C :<C-U>call ClearText(visual(), 1)<CR>

    " - highlighting word under the cursor
    nmap ,ha :call HighlightAllOfWord(1)<cr>
    nmap ,hA :call HighlightAllOfWord(0)<cr>

    " Mapping for Alternate-plugin (to quickly switch between *.hpp & *.cpp
    " files in C++).
    map ,a :A<CR>
"_______________________"
" END: Keyboard Mapping "
"-----------------------"

"_________________________________"
" START: PLUGIN-specific settings "
"---------------------------------"
    " START: VIM-CPP-AUTO-INCLUDE 
        "autocmd BufWritePre /home/dchirila/Desktop/Sandbox/**.cpp :ruby CppAutoInclude::process
    " END: VIM-CPP-AUTO-INCLUDE 

    " START: NERD Tree Plugin Settings
        " Toggle the NERD Tree on an off with F7
        nmap <F7> :NERDTreeToggle<CR>

        " Close the NERD Tree with Shift-F7
        nmap <S-F7> :NERDTreeClose<CR>

        " Show the bookmarks table on startup
        let NERDTreeShowBookmarks=1

        " Don't display these kinds of files
        let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
                        \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
                        \ '\.embed\.manifest$', '\.embed\.manifest.res$',
                        \ '\.intermediate\.manifest$', '^mt.dep$' ]
    " END: NERD Tree Plugin Settings

    " START: Vim-Latex
        " Disable FOLDING for TeX-files
        let Tex_FoldedSections=""
        let Tex_FoldedEnvironments=""
        let Tex_FoldedMisc=""
        " IMPORTANT: grep will sometimes skip displaying the file name if you
        " search in a singe file. This will confuse Latex-Suite. Set your grep
        " program to always generate a file-name.
        set grepprg=grep\ -nH\ $*

        " OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
        " 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
        " The following changes the default filetype back to 'tex':
        let g:tex_flavor='pdflatex'
        let g:Tex_GotoError=0
        " this is mostly a matter of taste. but LaTeX looks good with just a bit
        " of indentation.
        set sw=2
        " TIP: if you write your \label's as \label{fig:something}, then if you
        " type in \ref{fig: and press <C-n> you will automatically cycle through
        " all the figure labels. Very useful!
        set iskeyword+=:
        " Re-mapping to allow easy compilation of TEX documents using
        map <Tab>l <Leader>ll
        map <Tab>v <Leader>lv
        "let g:Tex_ViewRule_pdf = 'open -a Preview'  " MAC-specific
        "let g:Tex_FormatDependency_pdf = 'pdf'
        ""let g:Tex_CompileRule_pdf = 'dvips $*.dvi; ps2pdf14 $*.ps; xpdf -remote 127.0.0.1 -reload -raise'
        ""let g:Tex_CompileRule_pdf = 'dvips $*.dvi; ps2pdf14 $*.ps'
        ""let g:Tex_ViewRule_pdf = 'xpdf -remote 127.0.0.1'
        "let g:Tex_DefaultTargetFormat = 'pdf'
        "let g:Tex_UsePython=0 " Use LatexSuite without Python support
        "" Set the warning messages to ignore.
        "let g:Tex_IgnoredWarnings =
        "\"Underfull\n".
        "\"Overfull\n".
        "\"specifier changed to\n".
        "\"You have requested\n".
        "\"Missing number, treated as zero.\n".
        "\"There were undefined references\n".
        "\"Citation %.%# undefined\n".
        "\'LaTeX Font Warning:'"
        "" " This number N says that latex-suite should ignore the first N of the
        "" above.
        "let g:Tex_IgnoreLevel = 8
        let g:Tex_DefaultTargetFormat = 'pdf'

        "let g:Tex_CompileRule_dvi = 'latex --interaction=nonstopmode $*'
        "let g:Tex_CompileRule_ps = 'dvips -Pwww -o $*.ps $*.dvi'
        "let g:Tex_CompileRule_pspdf = 'ps2pdf $*.ps'
        "let g:Tex_CompileRule_dvipdf = 'dvipdfm $*.dvi'
        "let g:Tex_CompileRule_pdf = 'pdflatex --interaction=nonstopmode $*'

        "let g:Tex_ViewRule_dvi = 'okular'
        "let g:Tex_ViewRule_ps = 'okular'
        "let g:Tex_ViewRule_pdf = 'okular'

        "let g:Tex_FormatDependency_ps  = 'dvi,ps'
        "let g:Tex_FormatDependency_pspdf = 'dvi,ps,pspdf'
        "let g:Tex_FormatDependency_dvipdf = 'dvi,dvipdf'

        let g:Tex_IgnoredWarnings ='
                    \"Underfull\n".
                    \"Overfull\n".
                    \"specifier changed to\n".
                    \"You have requested\n".
                    \"Missing number, treated as zero.\n".
                    \"There were undefined references\n".
                    \"Citation %.%# undefined\n".
                    \"\oval, \circle, or \line size unavailable\n"' 
    " END: Vim-Latex
"_______________________________"
" END: PLUGIN-specific settings "
"-------------------------------"

"__________________________________"
" START: Fix common miss-spellings "
"----------------------------------"
    iab teh       the
    iab Teh       The
    iab taht      that
    iab Taht      That
    iab alos      also
    iab Alos      Also
    iab aslo      also
    iab Aslo      Also
    iab acnobla   acknowledge
    iab Acnobla   Acknowledge
    iab becuase   because
    iab Becuase   Because
    iab bianry    binary
    iab Bianry    Binary
    iab bianries  binaries
    iab Bianries  Binaries
    iab charcter  character
    iab Charcter  Character
    iab charcters characters
    iab Charcters Characters
    iab exmaple   example
    iab Exmaple   Example
    iab exmaples  examples
    iab Exmaples  Examples
    iab neibla    neighborhood
    iab Neibla    Neighborhood
    iab shoudl    should
    iab Shoudl    Should
    iab seperate  separate
    iab Seperate  Separate
"________________________________"
" END: Fix common miss-spellings "
"--------------------------------"
