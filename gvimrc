" ~/.gvimrc - |gvimrc| - additional GVim configuration

" Color scheme and font

silent! color desert
silent! color zenburn

if has("gui_gtk")
	let &guifont="Monospace 9"
	"set guifont=DejaVu\ Sans\ Mono\ 10
elseif has("gui_win32")
	let &guifont="Consolas:h9"
	"set guifont=DejaVu_Sans_Mono:h9
endif

" UI elements

set columns=90 lines=40

set guioptions+=a	" autoselect from visual mode
set guioptions+=g	" grey menu items

set guioptions-=m	" menu bar
set guioptions-=t	" tearoff menus
set guioptions-=T	" toolbar
set guioptions-=L	" left scrollbar if vsplit
set guioptions-=r	" right scrollbar
set guioptions-=R	" right scrollbar if vsplit

setl cursorline
au WinEnter * setl cursorline
au WinLeave * setl nocursorline

" Key bindings

map	<silent>	<C-Tab>		:tabnext<CR>
imap	<silent>	<C-Tab>		<Esc>:tabnext<CR>
map	<silent>	<C-S-Tab>	:tabprevious<CR>
imap	<silent>	<C-S-Tab>	<Esc>:tabprevious<CR>
map	<silent>	<C-S>		:w<CR>
imap	<silent>	<C-S>		<Esc>:w<CR>
map	<silent>	<C-Q>		:q<CR>
map	<silent>	<S-Insert>	"*p
imap	<silent>	<S-Insert>	<Esc>"*pa
map	<silent>	<C-S-C>		"+y
imap	<silent>	<C-S-C>		<Esc>"+yya
map	<silent>	<C-S-V>		"+p
imap	<silent>	<C-S-V>		<Esc>"+pa
imap			<C-BS>		<C-W>
