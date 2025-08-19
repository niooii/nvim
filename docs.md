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

### Diagnostics
- `<leader>d` - Show line diagnostics
- `<leader>q` - Open diagnostic quickfix list
- `<leader>sd` - Search diagnostics (Telescope)

# Lang/env/proj Support

## C++ Development

- **LSP**: clangd
- **Debugging**: `<leader>db` (breakpoint), `<leader>dc` (continue), `<leader>dt` (toggle UI)
- **Code Outline**: `<leader>a` - Toggle aerial (symbol tree)

## Haskell Development

- **LSP**: haskell-language-server
- **Build System**: Auto-detects Cabal/Stack projects
- **REPL**: `<leader>hb` - Toggle Haskell REPL
- **Build**: `<leader>hc` - Compile, `<leader>hr` - Run, `<leader>ht` - Test
- **Tools**: `<leader>hh` - Hoogle search, `<leader>he` - Evaluate all
- **Formatting**: Ormolu formatter integrated with `<leader>f`
- **Commands**: `:CabalBuild`, `:CabalRun`, `:CabalTest`, `:CabalRepl` (or Stack equivalents)

## Python Development

- **LSP**: pyright 
- **Virtual Environment**: Auto-detects uv/pip envs
- **Jupyter**: `<leader>pj` - Start Jupyter Lab
- **Environment**: `<leader>pv` - Select virtual env
- **Debug**: `<leader>pm` - Debug test method, `<leader>pc` - Debug test class
- **Docstrings**: `<leader>pd` - Generate docstring

## Workspace Auto-saved Sessions

- **Auto-save/restore**: Complete workspace state (tabs, splits, terminals) saved per directory
- `<leader>ws` - Save current workspace manually
- `<leader>wr` - Restore workspace manually  
- `<leader>wd` - Delete saved workspace
- `<leader>wl` - List/search saved workspaces

## Terminal

- `:term` - Open terminal in current window
- `:split | term` - Terminal in horizontal split  
- `:vsplit | term` - Terminal in vertical split
- **Exit terminal**: `Alt+Q`

## Editor

- **Tab**: Inserts 4 spaces (or accepts autocompletion)

## BTW

- `<leader>` is Space
- Most commands follow mnemonic patterns (e.g., `<leader>s` for search, `<leader>w` for window)
