"Вырубаем режим совместимости с VI:
set nocompatible

"Включаем распознавание типов файлов и типо-специфичные плагины:
filetype plugin on
filetype indent on

" Разрешить backspace через любой режим ввода
set backspace=indent,eol,start

" Хранить 50 команд в истории
set history=50

" Показывать курсор всегда
set ruler

" Неполные команды
set showcmd

" Показывать номера строк
set number

"Настройки табов для Python, согласно рекоммендациям
set shiftwidth=4
set softtabstop=4 "4 пробела в табе
set tabstop=4
set expandtab "Ставим табы пробелами
set smarttab

"Автоотступ
set autoindent

"Подсвечиваем все что можно подсвечивать
let python_highlight_all = 1

"Включаем 256 цветов в терминале, мы ведь работаем из иксов?
"Нужно во многих терминалах, например в gnome-terminal
set t_Co=256

" Формат строки состояния
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P

"Настройка omnicomletion для Python (а так же для js, html и css)
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" More suitable mapping
function SMap(key, action, ...)
    let modes = " vi"
    if (a:0 > 0)
        let modes = a:{1}
    endif
    if (match(modes, '\Ii') != -1)
        execute 'imap ' . a:key . ' <Esc>' . a:action
    endif
    if (match(modes, '\Nn') != -1)
        execute 'nmap ' . a:key . ' <Esc>' . a:action
    endif
    if (match(modes, ' ') != -1)
        execute 'map ' . a:key . ' <Esc>' . a:action
    endif
    if (match(modes, '\Vv') != -1)
        execute 'vmap ' . a:key . ' <Esc>' . a:action
    endif
endfunction

" Быстрое сохранение по F2
call SMap("<F2>", ":w<cr>")

" F11 - Tlist
call SMap("<F11>", ":TlistToggle<cr>")

" F12 to quick explorer
call SMap("<F12>", ":Explore<cr>")

"Авто комплит по табу
function TabWrapper()
  if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    "return "\<C-X>\<C-N>"
    return "\<C-X>\<C-o>\<C-p>"
  else
    return "\<C-N>"
  endif
endfunction

imap <Tab> <C-R>=TabWrapper()<CR>

set complete=""
set complete+=.
set complete+=k
set complete+=b
set completeopt-=preview
set completeopt+=longest

"Перед сохранением вырезаем пробелы на концах (только в .py файлах)
autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``

"В .py файлах включаем умные отступы после ключевых слов
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

""""Дальше мои личные настройки,
""""в принципе довольно обычные, может кому надо

"Вызываем SnippletsEmu по ctrl-j
"вместо tab по умолчанию (на табе автокомплит)
let g:snippetsEmu_key = "<C-j>"

" Копи/паст по Ctrl+C/Ctrl+V
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi

" Jump 5 lines when running out of the screen
set scrolljump=7

" Indicate jump out of the screen when 10 lines before end of the screen
set scrolloff=7

" Запуск Python скриптов по F5
imap <special><F5> <ESC>:w\|!python %<CR>
nmap <F5> :w\|!python %<CR>

colorscheme wombat256 "Цветовая схема
syntax on "Включить подсветку синтаксиса
set mousehide "Спрятать курсор мыши когда набираем текст
set mouse=a "Включить поддержку мыши
set termencoding=utf-8 "Кодировка терминала
set novisualbell "Не мигать
set t_vb= "Не пищать! (Опции 'не портить текст', к сожалению, нету)

"Вырубаем черточки на табах
set showtabline=0

"Колоночка, чтобы показывать плюсики для скрытия блоков кода:
set foldcolumn=1

"Переносим на другую строчку, разрываем строки
set wrap
set linebreak

"Вырубаем .swp и ~ (резервные) файлы
set nobackup
set noswapfile
set encoding=utf-8 " Кодировка файлов по умолчанию
set fileencodings=utf-8,cp1251,cp866,koi8-r " Возможные кодировки файлов, если файл не в unicode кодировке,

" Визуальное ограничение в 80 символов
highlight TooLongLine term=reverse ctermfg=Yellow ctermbg=Red
match TooLongLine /.\%>81v/

" Умный home
nmap <silent><Home> :call SmartHome("n")<CR>
imap <silent><Home> <C-r>=SmartHome("i")<CR>
vmap <silent><Home> <Esc>:call SmartHome("v")<CR>

" Настройки TList
let g:Tlist_Show_One_File = 1
let g:Tlist_GainFocus_On_ToggleOpen = 1

function SmartHome(mode)
let curcol = col(".")
"gravitate towards beginning for wrapped lines
if curcol > indent(".") + 2
call cursor(0, curcol - 1)
endif
if curcol == 1 || curcol > indent(".") + 1
if &wrap
normal g^
else
normal ^
endif
else
if &wrap
normal g0
else
normal 0
endif
endif
if a:mode == "v"
normal msgv`s
endif
return ""
endfunction
