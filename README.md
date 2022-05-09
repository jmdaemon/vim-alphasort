# Vim-Alphasort

Alphabetizes program import statements

I could not find a general purpose Vim Script available that would sort
program import statements so I wrote one myself.

## Install

### Vim-Plug

To install with `vim-plug`, put this in your `.vimrc` file:

```vimscript
Plug 'jmdaemon/vim-alphasort'
```

Then you can use `vim-alphasort` in your `.vimrc` as follows:

```vimscript
vnoremap <F5> :SortImports<CR>
```

## Usage

To alphabetize your program imports:

1. Select your imports in visual mode
2. Hit `F5` or your equivalent keymap defined above.
