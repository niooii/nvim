# Neovim IDE Setup

Cool IDE setup, run nvim in project root.  

## File Explorer

- **Toggle**: `\` (backslash) to open/close file explorer
- **Features**: Automatic file following, git status indicators, expandable tree structure
- **Location**: Left sidebar, 35 characters wide

## Split/Window Management

### Creating Splits
- `<leader>%` - Split vertically
- `<leader>"` - Split horizontally 

### Window Resizing
- `Alt+←/→/↑/↓` - Resize current window
- `Alt+h/j/k/l` - Navigate between windows

### Window Operations
- `<leader>wc` - Close current window
- `<leader>wo` - Close all other windows (only keep current)

## Buffer/Tab Management

### Quick Navigation  
- `]b` - Next buffer/tab
- `[b` - Previous buffer/tab
- `Alt+1/2/3...9` - Jump to specific buffer by number

### Alternative Commands
- `<leader>bn` - Next buffer
- `<leader>bp` - Previous buffer
- `<leader>bd` - Delete buffer
- `<leader><leader>` - Fuzzy find open buffers

**Note**: Buffer line shows open files as tabs at the top. Each split window can display different buffers/tabs independently.

## File Navigation & Search

### Telescope Search
- `<leader>sf` - Search files
- `<leader>sg` - Search by grep (live search)
- `<leader>sw` - Search current word
- `<leader>sr` - Resume last search
- `<leader>s.` - Search recent files

## LSP Features (Language Support)

- `grd` - Go to definition
- `grr` - Find references
- `grn` - Rename symbol
- `gra` - Code actions
- `<leader>f` - Format buffer

## C++ Stuff

- **LSP**: clangd for completion, diagnostics, navigation
- **Debugging**: `<leader>db` (breakpoint), `<leader>dc` (continue), `<leader>dt` (toggle UI)
- **Code Outline**: `<leader>a` - Toggle aerial (symbol tree)

## Terminal

- `:term` - Open terminal in current window
- `:split | term` - Terminal in horizontal split  
- `:vsplit | term` - Terminal in vertical split
- **Exit terminal**: `Alt+Q`

## Editor

- **Tab**: Inserts 4 spaces 

## BTW

- `<leader>` is Space
- Most commands follow mnemonic patterns (e.g., `<leader>s` for search, `<leader>w` for window)
