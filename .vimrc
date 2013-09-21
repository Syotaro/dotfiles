" --------------------------------------------------------------------------------------------------------
" - * File: .vimrc
" - * Author: itchyny
" - * Last Change: 21-Sep-2013.
" --------------------------------------------------------------------------------------------------------

" INITIALIZE {{{
" --------------------------------------------------------------------------------------------------------
set nocompatible
filetype off
scriptencoding utf-8
set encoding=utf-8
if !executable(&shell) | set shell=sh | endif
let s:isunix = has('unix')
let s:iswin = has('win16') || has('win32') || has('win64')
let s:iscygwin = has('win32unix')
let s:ismac = !s:iswin && !s:iscygwin && (has('mac') || has('macunix') || has('guimacvim') || system('uname') =~? '^darwin')
let s:nosudo = $SUDO_USER == ''
augroup ESC
  autocmd!
augroup END
augroup SetLocal
  autocmd!
augroup END
function! s:safeexecute(s, ...)
  if a:0
    let check = a:1
  else
    let check = a:s
  endif
  if exists(check)
    try
      silent execute a:s
    catch
      try
        silent execute 'call '.a:s
      catch
      endtry
    endtry
  endif
endfunction
function! CompleteNothing(...)
  return []
endfunction
" }}}

" Bundles 
let $VIM = expand('~/.vim')
let $BUNDLE = $VIM.'/bundle'
let s:neobundle_dir = $BUNDLE.'/neobundle.vim'
if !isdirectory(s:neobundle_dir)

" neobundle {{{
" --------------------------------------------------------------------------------------------------------
  if executable('git')
    echo 'Initializing neobundle'
    execute '!mkdir -p '.$BUNDLE
       \.' && git clone https://github.com/Shougo/neobundle.vim '.$BUNDLE.'/neobundle.vim'
       \.' && git clone https://github.com/Shougo/unite.vim '.$BUNDLE.'/unite.vim'
       \.' && git clone https://github.com/Shougo/vimproc '.$BUNDLE.'/vimproc'
    if s:ismac
      if executable('llvm-gcc')
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_mac.mak'
      elseif executable('gcc')
        execute '!cd '.$BUNDLE.'/vimproc && '
              \.'gcc -O3 -W -Wall -Wno-unused -bundle -fPIC -arch x86_64 -arch '
              \.'i386 -o autoload/vimproc_mac.so autoload/proc.c -lutil'
      else
        echo 'gcc not found!'
      endif
    elseif s:iswin
      echo 'access https://github.com/Shougo/vimproc/downloads to get dll'
    else
      if executable('gcc')
        execute '!cd '.$BUNDLE.'/vimproc && make -f make_unix.mak'
      else
        echo 'gcc not found!'
      endif
    endif
  else
    echo 'git not found! Sorry, this .vimrc cannot be completely used without git.'
  endif
else
if has('vim_starting')
  execute 'set runtimepath+='.expand(s:neobundle_dir)
endif
call neobundle#rc(expand($BUNDLE))
NeoBundleFetch 'Shougo/neobundle.vim'
  " nnoremap <silent> <S-b><S-b> :<C-u>NeoBundleUpdate<CR>
  nnoremap <silent> <S-b><S-b> :<C-u>Unite neobundle/update<CR>
" }}}


" Complement {{{
" --------------------------------------------------------------------------------------------------------
if s:nosudo
if has('lua') && v:version > 703
NeoBundle 'Shougo/neocomplete.vim'
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_smart_case = 1
  " let g:neocomplete#enable_cursor_hold_i = 1
  let g:neocomplete#max_list = 1000
  let g:neocomplete#skip_auto_completion_time = "0.50"
  let g:neocomplete#enable_auto_close_preview = 1
  let g:neocomplete#auto_completion_start_length = 1
  let g:neocomplete#max_keyword_width = 50
  if !exists('g:neocomplete#force_omni_input_patterns')
      let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#force_omni_input_patterns.c =
              \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.cpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objc =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objcpp =
              \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  function! s:cancel_popup(key)
    return a:key . neocomplete#cancel_popup()
  endfunction
  function! s:cancel_popup_reverse(key)
    return neocomplete#cancel_popup() . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . neocomplete#cancel_popup()
  endfunction
else
endif
NeoBundle 'Shougo/neosnippet'
  let g:neosnippet#snippets_directory = expand($VIM.'/snippets')
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable() <Bar><Bar> neosnippet#jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)"
    \: "\<TAB>"
NeoBundle 'ujihisa/neco-look'
  " --| Requirement: look commnad
else
  function! s:cancel_popup(key)
    return a:key . (pumvisible() ? "\<C-e>" : '')
  endfunction
  function! s:cancel_popup_reverse(key)
    return (pumvisible() ? "\<C-e>" : '') . a:key
  endfunction
  function! s:goback_insert(key)
    return "gi" . a:key . (pumvisible() ? "\<C-e>" : '')
  endfunction
endif
" }}}

" Unite ( "," ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = ","
if s:nosudo
NeoBundle 'Shougo/unite.vim'
  let g:unite_enable_start_insert = 1
  let g:unite_cursor_line_highlight = 'CursorLine'
  let g:unite_source_file_mru_limit = 1000
  let g:unite_force_overwrite_statusline = 0
  if executable('ag')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
    \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
    \  '''.hg'' --ignore ''.svn'' --ignore ''.git'''
    let g:unite_source_grep_recursive_opt = ''
  else
    let g:unite_source_grep_command = 'grep'
    let g:unite_source_grep_default_opts = '-iHn'
  endif
  if s:ismac && has('multi_byte')
    let g:unite_marked_icon = '✓'
  else
    let g:unite_marked_icon = 'v'
  endif
  let g:unite_candidate_icon = '-'
  " nnoremap <C-u> :Unite<SPACE>
  nnoremap <silent><C-p> :Unite buffer -buffer-name=buffer<CR>
  nnoremap <silent><C-n> :Unite file/new directory/new -buffer-name=file/new,directory/new<CR>
  nnoremap <silent><S-k> :Unite output:message -buffer-name=output<CR>
  nnoremap <silent><C-o> :execute 'Unite file:'.<SID>change_directory().' file/new -buffer-name=file'<CR>
  nnoremap <silent><C-z> :Unite file_mru -buffer-name=file_mru<CR>
  nnoremap <silent><S-l> :Unite line -buffer-name=line<CR>
  augroup Unite
    autocmd!
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
    autocmd FileType unite nnoremap <silent> <buffer> <expr> <C-k> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <expr> <C-k> unite#do_action('vsplit')
    autocmd FileType unite inoremap <silent> <buffer> <C-z> <Nop>
    autocmd FileType unite inoremap <silent> <buffer> <C-o> <Nop>
    autocmd FileType unite nmap <buffer> <C-a> <Plug>(unite_insert_enter)
    autocmd FileType unite nmap <buffer> OA <Plug>(unite_rotate_previous_source)
    autocmd FileType unite nnoremap <buffer> OB <Down>
    autocmd FileType unite nmap <buffer> <Bs> <Plug>(unite_exit)
  augroup END
  autocmd ESC FileType unite nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
  let s:startfiletypes = '.*\.\(exe\|png\|gif\|jpg\|jpeg\|bmp\|eps\|pdf\|mp3\|mp4\|avi\|mkv\|tiff\)$'
  let s:auto_open = {
        \ 'description' : 'edit or open files',
        \ 'is_selectable' : 1,
        \ }
  function! s:auto_open.func(candidates)
    try
      for candidate in a:candidates
        if candidate.word =~? s:startfiletypes
          call unite#take_action('start', candidate)
        else
          call unite#take_action('open', candidate)
        endif
      endfor
    catch
    endtry
  endfunction
  let s:eject = {
        \ 'description': 'eject',
        \ 'is_selectable': 0,
        \ }
  function! s:eject.func(candidate)
    try
      let c = 'sudo ' . (executable('eject') ? 'eject' : s:ismac ? 'diskutil umount' : '')
            \ . ' "' . a:candidate.action__path . '"'
      if strlen(c)
        let s:eject.path = a:candidate.action__path
        let s:eject.count = 0
        exe 'VimShellInteractive --split="split | resize 20" ' . c
      endif
    catch
    endtry
  endfunction
  let bundle = neobundle#get('unite.vim')
  function! bundle.hooks.on_post_source(bundle)
    if exists('*unite#custom_source')
      call unite#custom_source('file', 'ignore_pattern'
            \, '.*\.\(o\|exe\|dll\|bak\|sw[po]\|hi\|fff\|aux\|toc\|bbl\|blg\|DS_Store\)$')
    endif
    if exists('*unite#custom_action')
      call unite#custom_action('file', 'auto_open', s:auto_open)
    endif
    if exists('*unite#custom_default_action')
      call unite#custom_default_action('file', 'auto_open')
    endif
    if exists('*unite#custom_default_action')
      call unite#custom_action('file', 'eject', s:eject)
    endif
    if exists('*unite#custom_source')
      call unite#custom_source('haddock,hoogle', 'max_candidates', 20)
    endif
  endfunction
NeoBundleLazy 'Shougo/unite-build', {'autoload': {'unite_sources': ['build']}}
  nnoremap <silent><F5> :<C-u>Unite build -buffer-name=build<CR>
NeoBundleLazy 'unite-colorscheme', {'autoload': {'unite_sources': ['colorscheme']}}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload': {'unite_sources': ['highlight']}}
NeoBundleLazy 'ujihisa/vim-ref'
if executable('hoogle')
NeoBundleLazy 'eagletmt/unite-haddock', {'autoload': {'unite_sources': ['hoogle']}}
  nnoremap <Leader>h :<C-u>Unite hoogle -buffer-name=hoogle<CR>
  " --| Requirement: hoogle
  " --|   $ cabal install hoogle
  " --|   $ hoogle data
endif
NeoBundleLazy 'h1mesuke/unite-outline', {'autoload': {'unite_sources': ['outline']}}
NeoBundleLazy 'ujihisa/unite-haskellimport', {'autoload': {'unite_sources': ['haskellimport']}}
endif
" }}}

" QuickRun / Filer / Outer world of Vim ( "\\" ) {{{
" --------------------------------------------------------------------------------------------------------
let mapleader = "\\"
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
  \     'windows' : 'echo "Sorry, cannot update vimproc binary file in Windows."',
  \     'cygwin' : 'make -f make_cygwin.mak',
  \     'mac' : 'make -f make_mac.mak',
  \     'unix' : 'make -f make_unix.mak',
  \   },
  \ }
NeoBundle 'thinca/vim-quickrun'
  let g:quickrun_config = {'_': {'runner': 'vimproc', 'runner/vimproc/updatetime': 60, 'split': 'vertical', 'into': 1}}
  let s:quickrun_command_list = map(split(
        \ 'quickrun;cat,javascript;node,roy;roy,qcl;qcl,haskell;runhaskell,bf;bf', ','), 'split(v:val, ";")')
  for [ft, exe] in s:quickrun_command_list
    execute printf('if executable("%s") | let g:quickrun_config.%s = {"command":"%s"} | endif', exe, ft, exe)
  endfor
  if executable('pandoc')
    let g:quickrun_config.markdown = {'type' : 'markdown/pandoc', 'outputter': 'browser', 'cmdopt': '-s'}
  endif
  if executable('autolatex')
    let g:quickrun_config.tex = {'command' : 'autolatex'}
  elseif executable('platex')
    let g:quickrun_config.tex = {'command' : 'platex'}
  endif
  if executable('man')
    let g:quickrun_config.nroff = {'command': 'man',
          \ 'args': " -P cat | tr '\b' '\1' | sed -e 's/.\1//g'", 'filetype': 'man'}
  endif
  if executable('autognuplot')
    let g:quickrun_config.gnuplot = {'command' : 'autognuplot'}
  elseif executable('gnuplot')
    let g:quickrun_config.gnuplot = {'command' : 'gnuplot'}
  endif
  let g:quickrun_config.objc = {'command': 'cc',
        \ 'exec': ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
        \ 'tempfile': '{tempname()}.m'}
  if executable('scad3.exe')
    let g:quickrun_config.spice = {'command': 'scad3.exe', 'exec': ['%c -b %s:t'] }
  endif
  if executable('abcm2ps')
    let g:quickrun_config.abc = {'command': 'abcm2ps',
          \ 'exec': ['%c %s -O %s:p:r.ps', 'ps2pdf %s:p:r.ps', 'open %s:p:r.pdf']}
    if executable('abc2midi')
      call extend(g:quickrun_config.abc.exec, ['abc2midi %s -o %s:p:r.mid', 'open %s:p:r.mid'])
    endif
  endif
  nnoremap <Leader>r :<C-u>QuickRun<CR>
  nnoremap <Leader><Leader>r :<C-u>QuickRun >file:temp.dat<CR>
  nnoremap <Leader>e :<C-u>QuickRun <i <CR>
  nnoremap <Leader>o :<C-u>QuickRun <i >file:output<CR>
  autocmd ESC FileType quickrun nnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
  autocmd ESC FileType quickrun vnoremap <silent> <buffer> <ESC><ESC> <ESC>:q!<CR>
if s:nosudo
NeoBundle 'Shougo/vimfiler'
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = 'TIME'
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_force_overwrite_statusline = 0
  if s:iswin || !has('multi_byte')
    let g:vimfiler_tree_leaf_icon = '|'
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  else
    let g:vimfiler_tree_leaf_icon = ' '
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
  endif
  let g:vimfiler_file_icon = '-'
  if s:ismac && has('multi_byte')
    let g:vimfiler_readonly_file_icon = '✗'
    let g:vimfiler_marked_file_icon = '✓'
  else
    let g:vimfiler_readonly_file_icon = 'x'
    let g:vimfiler_marked_file_icon = 'v'
  endif
  nnoremap <silent> <Leader>f :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> <Leader><Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent> @<Leader> :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  nnoremap <silent>@@ :<C-u>VimFilerBufferDir -status -buffer-name=vimfiler -auto-cd<CR>
  " nnoremap <silent> s :<C-u>execute 'VimShellCreate '.<SID>current_directory_auto()<CR>
  nnoremap <silent> s :<C-u>VimShellBufferDir<CR>
  let g:vimfiler_execute_file_list = {}
  for ft in split('pdf,png,jpg,jpeg,gif,bmp,ico,ppt,html', ',')
    let g:vimfiler_execute_file_list[ft] = 'open'
  endfor
  function! s:changetime()
    let marked_files = vimfiler#get_marked_filenames()
    if !empty(marked_files)
      return
    endif
    let file = vimfiler#get_file()
    if empty(file)
      return
    endif
    let filepath = file.action__path
    let vimfiler_current_dir = get(unite#get_context(), 'vimfiler__current_directory', '')
    if vimfiler_current_dir == ''
      let vimfiler_current_dir = getcwd()
    endif
    let current_dir = getcwd()
    if system('stat -l . > /dev/null 2>&1; echo $?') =~ '^0'
      let atime = system('stat -lt "%Y/%m/%d %H:%M" "'.filepath
            \."\" | awk {'print $6\" \"$7'} | tr -d '\\n'")
    else
      let atime = system('stat --printf "%y" "'.filepath."\" | sed -e 's/\\..*//'")
    endif
    let atime = substitute(atime, '-', '/', 'g')
    try
      lcd `=vimfiler_current_dir`
      let newtime = input(printf('New time: %s -> ', atime))
      redraw
      if newtime == ''
        let newtime = atime
      endif
      let newtime = substitute(newtime, '\d\@<!\(\d\)$', '0\1', '')
      let newtime = substitute(newtime, '\d\@<!\(\d\)\d\@!', '0\1', 'g')
      let newtime = substitute(newtime, '[ -]', '', 'g')
      if newtime =~? '^\d\+/\d\+/\d\+$' || len(newtime) <= 8
        let newtime .= '0000'
      endif
      let newtime = substitute(newtime, '\(\d\+:\d\+\):\(\d\+\)$', '\1.\2', '')
      let newtime = substitute(newtime, '[/:]', '', 'g')
      call system('touch -at '.newtime.' -mt '.newtime.' "'.filepath.'"')
    finally
      lcd `=current_dir`
    endtry
  endfunction
  augroup Vimfiler
    autocmd!
    autocmd FileType vimfiler nunmap <buffer> <C-l>
    autocmd FileType vimfiler nunmap <buffer> \
    autocmd FileType vimfiler nnoremap <buffer> <C-l> <ESC><C-w>l
    autocmd FileType vimfiler nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
    autocmd FileType vimfiler nmap <buffer> O <Plug>(vimfiler_sync_with_another_vimfiler)
    autocmd FileType vimfiler nmap <buffer><expr> e
          \ vimfiler#smart_cursor_map("\<Plug>(vimfiler_cd_file)", "\<Plug>(vimfiler_edit_file)")
    " autocmd FileType vimfiler nnoremap <buffer><expr> t <SID>changetime()
    autocmd FileType vimfiler if filereadable("Icon\r") | silent call delete("Icon\r") | endif
  augroup END
NeoBundle 'itchyny/vimfiler-preview', {'type': 'nosync'}
  let g:vimfiler_preview_action = 'auto_preview'
  let bundle = neobundle#get('vimfiler-preview')
  function! bundle.hooks.on_post_source(bundle)
    if exists('*unite#custom_action')
      call unite#custom_action('file', 'auto_preview', g:vimfiler_preview)
    endif
  endfunction
NeoBundle 'Shougo/vinarise'
endif
NeoBundleLazy 'eagletmt/ghci-vim', {'autoload': {'filetypes': ['haskell']}}
  augroup Ghci
    autocmd!
    autocmd FileType haskell nnoremap <buffer> <Leader>l <expr> call s:safeexecute(':GhciLoad')
    autocmd FileType haskell nnoremap <buffer> <Leader>i <expr> call s:safeexecute(':GhciInfo')
    autocmd FileType haskell nnoremap <buffer> <Leader>t <expr> call s:safeexecute(':GhciType')
  augroup END
NeoBundleLazy 'tyru/open-browser.vim', {'autoload' : {'mappings' : ['<Plug>(openbrowser-']}}
  nmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  vmap <silent> <Leader>b <Plug>(openbrowser-smart-search)
  nmap <silent> <Leader>s <Plug>(openbrowser-search)
NeoBundle 'mattn/webapi-vim'
NeoBundleLazy 'mattn/googletasks-vim', {'autoload': {'commands': [{'name': 'GoogleTasks', 'complete': 'customlist,CompleteNothing'}]}}
" }}}


" Edit
    " NeoBundle 'Shougo/vimfiler'
  " NeoBundle 'Shougo/vimshell.git'
" ---------------------------------------------
    NeoBundle 'Changed'
    NeoBundle 'Gundo'                                   " undo履歴を追える
    " NeoBundle 'SQLUtilities'
    NeoBundle 'VOoM'                                    " Vim Outliner of Markers
    " NeoBundle 'bash-support.vim'
    NeoBundle 'joonty/vdebug.git'
    NeoBundle 'itchyny/lightline.vim'
    " NeoBundle 'sandeepcr529/Buffet.vim'
    NeoBundle 'git://github.com/itspriddle/vim-marked.git'
    NeoBundle 'git://github.com/jimsei/winresizer.git'
    NeoBundle 'git://github.com/tpope/vim-surround.git' " テキストを括弧で囲む／削除する
    NeoBundle 'h1mesuke/vim-alignta.git'                " 整形プラグイン Alignのマルチバイト対応版
    NeoBundle 'kwbdi.vim'                               " keep Window on Buffer Delete
    " NeoBundle 'kien/ctrlp.vim'
    " NeoBundle 'mattn/livestyle-vim'
    NeoBundle 'molokai'
    NeoBundle 'tell-k/vim-browsereload-mac'
    NeoBundle 'tomtom/tcomment_vim'                     " コメント処理 \c<Space>
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'tyru/vim-altercmd'
    NeoBundle 'yuratomo/w3m.vim.git'
  " NeoBundle 'Auto-Pairs'
  " NeoBundle 'Indent-Guides'
  " NeoBundle 'Quich-Filter'
  " NeoBundle 'YankRing.vim'                            " YankRing.vim : ヤンクの履歴を管理し、順々に参照、出力できるようにする
  " NeoBundle 'css_color.vim'
  " NeoBundle 'eregex.vim'
  " NeoBundle 'git://github.com/thinca/vim-showtime.git'
  " NeoBundle 'grep.vim'
  NeoBundle 'kana/vim-fakeclip'                " tmuxでyankやpasteの時にOS clipboardを使う
  " NeoBundle 'kannokanno/previm'                       " markdown preview
  " NeoBundle 'mattn/benchvimrc-vim'
  " NeoBundle 'minibufexpl.vim'
  " NeoBundle 'rhysd/clever-f.vim.git'
  " NeoBundle 'spolu/dwm.vim.git'  " Window Manager
  " NeoBundle 'vimtaku/vim-mlh.git'        " ローマ字で文字を入力したあと /<Space> で文字を変換することができる
  " NeoBundle 'xmledit'
  " NeoBundle 'yoppi/fluentd.vim.git'
  " NeoBundle 'thinca/vim-quickrun'
" Syntax------------------------------------------
    " NeoBundle 'JavaScript-syntax'
    " NeoBundle 'jQuery'
  " NeoBundle 'joker1007/vim-markdown-quote-syntax'
  " NeoBundle 'Markdown-syntax'
  " NeoBundle 'kchmck/vim-coffee-script'
  " NeoBundle 'nginx.vim'
" reference--------------------------------------
  " NeoBundle 'thinca/vim-ref'
  " NeoBundle 'taichouchou2/vim-ref-ri'
  " NeoBundle 'taq/vim-rspec'
" Chef -----------------------------------------
  " NeoBundle 'MarcWeber/vim-addon-mw-utils'
  " NeoBundle 'tomtom/tlib_vim'
  " NeoBundle 'garbas/vim-snipmate'
  " NeoBundle 'vadv/vim-chef'
" Rails & Ruby ---------------------------------
  " NeoBundle 'dbext.vim'    " rails.vimと合わせてインストールしておくと，database.ymlの設定を自動で読み込んでvimから直接SQLが打てる
  " NeoBundle 'ujihisa/unite-rake'
  " NeoBundle 'basyura/unite-rails'
  " NeoBundle 'ruby.vim'
  " NeoBundle 'taichouchou2/vim-rails'
  " NeoBundle 'romanvbabenko/rails.vim'
  " NeoBundle 'tpope/vim-endwise.git'
  " NeoBundle 'ruby-matchit'
  " NeoBundle 'rhysd/unite-ruby-require.vim.git'
" PHP ------------------------------------------
    NeoBundle 'taku-o/vim-ethna-switch'
    NeoBundle 'watanabe0621/aoi-jump.vim'
    NeoBundle 'watanabe0621/SmartyJump'
    NeoBundle 'jktgr/smarty.vim'
    NeoBundle 'jktgr/phpfolding.vim'
    NeoBundle 'bpearson/vim-phpcs'
    " NeoBundle 'jktgr/vim-json'
    " NeoBundle 'jktgr/phpcomplete.vim'
 
" 他のvimpluginから必要にされるもの-----------
    NeoBundle 'mattn/gist-vim'
  " NeoBundle 'cecutil'
    NeoBundle 'L9'
  " NeoBundle 'tyru/open-browser.vim'



" Syntax {{{
" --------------------------------------------------------------------------------------------------------
if has('multi_byte')
NeoBundleLazy 'scrooloose/syntastic', {'autoload': {'filetypes': ['c', 'cpp'], 'functions': ['SyntasticStatuslineFlag']}}
  let g:syntastic_mode_map = { 'mode': 'passive' }
  let g:syntastic_echo_current_error = 0
  let g:syntastic_enable_highlighting = 0
  augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp call s:syntastic()
  augroup END
  function! s:syntastic()
    if exists(':SyntasticCheck') | exec 'SyntasticCheck' | endif
    if exists('*lightline#update') | call lightline#update() | endif
  endfunction
endif
NeoBundleLazy 'mattn/emmet-vim', {'autoload': {'filetypes': ['html']}}
  let g:user_zen_settings = { 'html' : { 'indentation' : '  ' }, }
NeoBundleLazy 'itspriddle/vim-javascript-indent', {'autoload': {'filetypes': ['javascript']}}
NeoBundleLazy 'JSON.vim', {'autoload': {'filetypes': ['json']}}
NeoBundleLazy 'html5.vim', {'autoload': {'filetypes': ['html']}}
" NeoBundleLazy 'wavded/vim-stylus', {'autoload': {'filetypes': ['stylus']}}
" NeoBundleLazy 'groenewege/vim-less', {'autoload': {'filetypes': ['less']}}
" NeoBundleLazy 'less.vim', {'autoload': {'filetypes': ['less']}}
NeoBundleLazy 'syntaxm4.vim', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'vim-scripts/jade.vim', {'autoload': {'filetypes': ['jade']}}
NeoBundleLazy 'vim-coffee-script', {'autoload': {'filetypes': ['coffee']}}
" NeoBundleLazy 'rest.vim', {'autoload': {'filetypes': ['rest']}}
" NeoBundleLazy 'vim-scripts/indenthaskell.vim', {'autoload': {'filetypes': ['haskell']}}
  let hs_highlight_boolean = 1
  let hs_highlight_types = 1
  let hs_highlight_more_types = 1
NeoBundleLazy 'tpope/vim-markdown', {'autoload': {'filetypes': ['m4']}}
NeoBundleLazy 'syngan/vim-vimlint', { 'depends' : 'ynkdir/vim-vimlparser', 'autoload' : { 'functions' : 'vimlint#vimlint'}}
" }}}




filetype plugin indent on     " Required!





endif
" }}} Bundles

"-------------------------------------------------------------------------------
" [Basic]
"-------------------------------------------------------------------------------
" エンコーディング設定

  syntax   on                                                          " Syntax有効
  set ambiwidth=double                                                 " Ambiguous width文字表記不具合の是正（iTerm2でDouble-WidthCharactersのチェックONにしないと意味なし)
  set autoindent
  set autoread                                                         " 他で書き換えられたら自動で読み直す
  set backspace=indent,eol,start                                       " バックスペースでなんでも消せるように
  set browsedir=buffer                                                 " ファイル保存の初期ディレクトリをバッファファイル位置に設定
  " set clipboard+=unnamed                                               " OSのクリップボードを使用する
  set clipboard=unnamed,unnamedplus
  " set clipboard+=autoselect                                            " 選択した瞬間、clipboardに入れる
  set expandtab                                                        " タブを入力した際に自動でホワイトスペースに展開
  set ffs=unix,dos,mac                                                 " 改行コードをUnix系に変更：ffs(fileformats)にunix,dos,macを指定する
  set foldmethod=marker                                                " マーカー文字列による折り畳み(folding)機能有効化
  set formatoptions=lmoq                                               " テキスト整形オプション，マルチバイト系を追加
  set hidden                                                           " 編集中でも他のファイルを開けるようにする
  set hlsearch                                                         " 文字列を検索したときに、マッチしたところをハイライト
  set ignorecase                                                       " 小文字の検索でも大文字も見つかるようにする
  set incsearch                                                        " インクリメンタルサーチを行う
  set lazyredraw                                                       " コマンド実行中は再描画しない
  set list                                                             " 不可視文字表示
  set listchars=tab:▸\ ,trail:_,extends:>,precedes:<,nbsp:%            " 不可視文字の表示形式
  set nobackup                                                         " バックアップ取らない
  set noswapfile                                                       " スワップファイル作らない
  set nowrap                                                           " 折り返ししない
  set nowrapscan                                                       " (no)検索をファイルの末尾まで検索したら、ファイルの先頭へループする
  set scrolloff=5                                                      " スクロール時の余白確保
  set shiftwidth=2                                                     " >> 等のコマンドや自動インデントの際に使う1レベル分のインデント量
  set showcmd                                                          " コマンドをステータス行に表示
  set smartcase                                                        " 大文字も含めた検索の場合はその通りに検索する
  set softtabstop=4                                                    " タブを入力した際にタブ文字の代わりに挿入されるホワイトスペースの量
  set tabstop=4
  set updatetime=300
  set ttyfast                                                          " 高速ターミナル接続を行う
  set vb t_vb=                                                         " ビープをならさない
  set whichwrap=b,s,h,l,<,>,[,]                                        " カーソルを行頭、行末で止まらないようにする
" let mapleader = ","                                                  " キーマップリーダー
" set imdisable                                                        " insertモードを抜けるとIMEオフ
" set iminsert=0 imsearch=0                                            " insertモードを抜けるとIMEオフ
" set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" set noimcmdline                                                      " insertモードを抜けるとIMEオフ
" set nolinebreak                                                      " 勝手に改行するのをやめる
  set nrformats=octal                                        " <C-a> <C-x> で英字も増減させる
" set textwidth=0                                                      " 一行に長い文章を書いていても自動折り返しをしない
" set undofile                                                         " アンドゥの履歴をファイルに保存し、Vim を一度終了したとしてもアンドゥやリドゥを行えるようにする
" setlocal tabstop=2                                                   " タブ文字の幅を設定できます。デフォルトは8

"-------------------------------------------------------------------------------
" [Apperance]
"-------------------------------------------------------------------------------

  " ターミナルタイプによるカラー設定
  if &term =~ "xterm-256color" || "screen-256color"
    " 256色
    set t_Co=256
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
    set t_Co=16
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  elseif &term =~ "xterm-color"
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif

  colorscheme molokai
  " カーソル行をハイライト
" set cursorline
" autocmd WinEnter,BufRead * set cursorline
" highlight CursorLine ctermbg=black guibg=black

  " 行頭のTAB文字を可視化
  highlight TabString ctermbg=red guibg=red
  au BufWinEnter * let w:m2 = matchadd("TabString", '^\t+')
  au WinEnter * let w:m2 = matchadd("TabString", '^\t+')

  " 全角スペースの表示
  highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
  au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
  au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')

  " 行末のスペースハイライト
  highlight WhitespaceEOL ctermbg=red guibg=red
  match WhitespaceEOL /\s\+$/
  autocmd WinEnter * match WhitespaceEOL /\s\+$/


"-------------------------------------------------------------------------------
" [Autocmd]
"-------------------------------------------------------------------------------

  autocmd BufRead *.txt set filetype=markdown                                                          " .txtファイルを、Markdown Syntax Hilightで開く
  autocmd BufRead *.md  set filetype=markdown                                                          " .txtファイルを、Markdown Syntax Hilightで開く
  autocmd BufRead *.sql set filetype=mysql                                                             " .sqlは、すなわちmysql
" autocmd FileType * setlocal formatoptions-=r                                                         " # の行で改行したときなどに #  をつけないように
" autocmd FileType * setlocal formatoptions-=o                                                         " # の行で改行したときなどに #  をつけないように
" autocmd BufEnter * execute ":lcd " . expand("%:p:h")                                                 " ファイルを開くたびに、そのファイルのディレクトリに移動する
" au BufEnter * execute 'lcd ' fnameescape(expand('%:p:h'))
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif     " 前回終了したカーソル行に移動
  autocmd BufRead *.txt set tw=0                                                                       " *.txtや*.md なファイルを編集するときに長い行で勝手に改行が入ってしまうのを無効に

" autocmd FileType markdown set com=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,b:-                         " markdownで、list行で改行した時に、次に行で自動的にlist文字が入る
" autocmd FileType markdown set formatoptions=tcroqln                                                  " markdownで、list行で改行した時に、次に行で自動的にlist文字が入る
  autocmd BufEnter * if &filetype == "" | setlocal ft=markdown | endif

  autocmd FileType ruby,eruby set filetype=ruby.eruby.chef                                             " Enable syntax for chef files some like this:

  autocmd FileType php,ctp | set shiftwidth=4
" autocmd FileType php,ctp :set dictionary=~/.vim/dict/php.dict | set shiftwidth=4
"-------------------------------------------------------------------------------
" [Command]
"-------------------------------------------------------------------------------

  command! Ev        edit   $MYVIMRC                                   " Ev/Rvでvimrcの編集と反映
  command! Rv        source $MYVIMRC                                   " Ev/Rvでvimrcの編集と反映
" command! Nginx     set ft=nginx                                      " ft(FileType)Nginx

"-------------------------------------------------------------------------------
" [Keybind]
"-------------------------------------------------------------------------------

" [Vimfiler]
  " CurrentBufferFile List
  nnoremap <silent> <Space>b  : <C-u>VimFilerBufferDir -split -no-quit -simple -winwidth=30<CR>
  " CurrentDirFileList
  nnoremap <silent> <Space>f  : <C-u>VimFiler          -split -no-quit -simple -winwidth=30<CR>
  " VimfilerExplorer
  nnoremap <silent> <Space>e  : <C-u>VimFilerExplorer  -split -no-quit -simple -winwidth=30 <CR>

" [Unite]
  nnoremap <silent> <Space>/         : <C-u>Unite line                   -direction=rightbelow -buffer-name=search -start-insert -no-quit <CR>
  nnoremap <silent> <Space>u  : <C-u>Unite file_mru file bookmark -direction=rightbelow<CR>
  nnoremap <silent> <Space>o  : <C-u>Unite outline                -direction=rightbelow -no-quit <CR>
  nnoremap <silent> <Space>l  : <C-u>Unite buffer_tab             -direction=rightbelow<CR>


  " nnoremap <silent> <Space>uo       : <C-u>Unite -no-quit -vertical -winwidth=15 outline<CR>
  " nnoremap <silent> <Space>rm         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/model<CR>
  " nnoremap <silent> <Space>rc         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/controller<CR>
  " nnoremap <silent> <Space>rv         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/view<CR>

  " nnoremap <silent> <C-f>          : <C-u>Unite buffer file_mru bookmark file<CR>
  " inoremap <silent> <C-f> <ESC>    : <C-u>Unite buffer file_mru bookmark file<CR>
  " nnoremap <silent> <C-b>          : <C-u>Unite -no-quit -vertical -winwidth=30 outline<CR>
  " inoremap <silent> <C-b> <ESC>    : <C-u>Unite -no-quit -vertical -winwidth=30 outline<CR>
  " nnoremap <silent> <C-r>m         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/model<CR>
  " inoremap <silent> <C-r>m <ESC>   : <C-u>Unite -no-quit -vertical -winwidth=50 rails/model<CR>
  " nnoremap <silent> <C-r>c         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/controller<CR>
  " inoremap <silent> <C-r>c <ESC>   : <C-u>Unite -no-quit -vertical -winwidth=50 rails/controller<CR>
  " nnoremap <silent> <C-r>v         : <C-u>Unite -no-quit -vertical -winwidth=50 rails/view<CR>
  " inoremap <silent> <C-r>v <ESC>   : <C-u>Unite -no-quit -vertical -winwidth=50 rails/view<CR>
  "
" [Voom]

  nnoremap <silent> <Space>v       : <C-u>Voom markdown<CR>

" [Other]

  " vimからQuickLookで開く
  " map <Leader>v :write<cr>:sil !/usr/bin/qlmanage -p % > /dev/null &<cr>:redraw!<cr>
  " 1,0,9で行頭、行末へ
  " 行末、行の最初への移動のキーマップ設定
  :map! <C-e> <Esc>$
  :map <C-e> <Esc>$
  " 9で行末へ
  noremap 1 ^
  noremap 9 $
  " 「Ctrl+C」の2回押しでハイライト消去
  nmap <C-c><C-c> ;nohlsearch<CR><ESC>
  " us key
  noremap  ; :
  " 挿入モードにならずに改行できる
  noremap <CR> o<ESC>
  " タブ移動を直感的に
  noremap gh gT
  " タブ移動を直感的に
  noremap gl gt
  " insertモードを抜けるとIMEオフ
  ""inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
  " Ctrl + c とEscの動作を完全に一致させる
  inoremap <C-c> <ESC>

  " 現在のバッファを閉じます
  noremap  <silent><Space>k    :bd<CR>
  " ファイル保存(バッファ変更時のみ)
  nnoremap <silent><Space>s    :<C-u>update<CR>

  nmap <C-l> >>
  nmap <C-h> <<

  " map <C-a> <Esc>^
  " map! <C-b> <Esc>h
  " map! <C-f> <Esc>l
  " map <C-b> <Esc>h
  " map <C-f> <Esc>l

   " C-j, C-kで1行スクロール
  noremap <C-j> <C-e>
  noremap <C-k> <C-y>
    " インサートモードでもhjklで移動（Ctrl押すけどね）
  " imap <C-j> <Down>
  " imap <C-k> <Up>
  " imap <C-h> <Left>
  " imap <C-l> <Right>

    " 最後に編集された位置に移動
  " nnoremap gb '[
  " nnoremap gp ']

    " 対応する括弧に移動
  " nnoremap ( %
  " nnoremap ) %

    " 最後に変更されたテキストを選択する
" nnoremap gc  " nnoremap gc  `[v`]
" nnoremap gc  " vnoremap gc <C-u>normal gc<Enter>
" nnoremap gc  " onoremap gc <C-u>normal gc<Enter>

  " paste yanked string vertically。<C-v> 時に<C-p> でvertical に paste
    vnoremap <C-p> I<C-r>"<ESC><ESC>

  " visualモードで置き換えたい文字を選択した後、「p」で0のレジスターを使用する(visualモードで選択したあとに、ヤンクした文字をペーストするとその置き換えた文字がヤンクされてしまい2回目同じようにしようとすると、前回置き換えた文字がペーストされてしまうので）
    vnoremap <silent> p "0p<CR>

  " qでウインドウを閉じて Qでマクロ
    nnoremap q :<C-u>q<CR>
    nnoremap Q q

"-------------------------------------------------------------------------------
" [Source]
"-------------------------------------------------------------------------------

  " Vundle Plugin に関する設定を読み込む
  source ~/.vimrc.plugins_setting

"-------------------------------------------------------------------------------
" [Function]
"-------------------------------------------------------------------------------

" augroup BUFWRITE_POSTDELETE                                " 内容が空のファイルを保存したら自動で削除する(*.mkdのみ)
"   au!
"   autocmd BufWritePost *.md call BufWritePostDelete()
" augroup END
" function! BufWritePostDelete()
"   let crlen = 0
"   if &binary == 0
"     let crlen = &ff=='dos' ? 2 : 1
"   endif
"   if getfsize(expand('%:p')) <= crlen
"     call delete(expand('%:p'))
"   endif
" endfunction
" 

"------------------------------------------------
" CSVのハイライト表示
" @see http://www.vim.org/tips/tip.php?tip_id=667
"------------------------------------------------
" csv の特定のカラムをハイライト (put in .vimrc)
" 使い方↓↓
" :Csv 5                            : 5番めのカラムをハイライト
" function! CSVH(x)
"   execute 'match Keyword /^\([^,]*,\)\{'.a:x.'}\zs[^,]*/'
"   execute 'normal ^'.a:x.'f,'
" endfunction
" command! -nargs=1 Csv :call CSVH(<args>)
" 
" 

"let g:ref_use_vimproc=1
"let g:ref_refe_version=2
"nmap ,rr :<C-u>Ref refe<Space>
"



  " カッコやクオートなどを入力した際に左に自動で移動します
  inoremap {} {}<Left>
  inoremap [] []<Left>
  inoremap () ()<Left>
  inoremap "" ""<Left>
  inoremap '' ''<Left>
  inoremap <> <>


" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" Shift + 矢印でウィンドウサイズを変更
" nnoremap <S-Left>  <C-w><<CR>
" nnoremap <S-Right> <C-w>><CR>
" nnoremap <S-Up>    <C-w>-<CR>
" nnoremap <S-Down>  <C-w>+<CR>






" PHPCSのスタイルを設定
let Vimphpcs_Standard='PSR2'

" PHPの名前空間を保管する設定
"inoremap <Leader>e <C-O>:call PhpExpandClass()<CR>
"noremap <Leader>e :call PhpExpandClass()<CR>



" マウスモード有効
set mouse=a

" xtermとscreen対応
set ttymouse=xterm2



inoremap <C-d> $
inoremap <C-a> @
inoremap <C-j> _
inoremap <C-k> ()

" phpfolding
augroup vimrc
  autocmd FileType phpunit EnableFastPHPFolds
augroup END



" Enable omni completation {{{
augroup Omnifunc
  autocmd!
  " autocmd FileType c          setlocal omnifunc=ccomplete#Complete
  " autocmd FileType css        setlocal omnifunc=csscomplete#CompleteCSS
  " autocmd FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType php        setlocal omnifunc=phpcomplete#CompletePHP
  " autocmd FileType python     setlocal omnifunc=pythoncomplete#Complete
  " autocmd FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
  " autocmd FileType haskell    setlocal omnifunc=necoghc#omnifunc
augroup END
setlocal omnifunc=syntaxcomplete#Complete
" }}}
"


" move within insert mode
imap <expr><C-o> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
inoremap <expr> <Up> <SID>cancel_popup("\<Up>")
inoremap <expr> <Down> <SID>cancel_popup("\<Down>")
inoremap <expr> <Left> <SID>cancel_popup("\<Left>")
inoremap <expr> <Right> <SID>cancel_popup("\<Right>")
