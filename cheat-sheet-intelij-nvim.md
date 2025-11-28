# 📝 Neovim + LazyVim Cheat Sheet for IntelliJ Users

A comparison of the most important editing actions, showing:

- **IntelliJ keybinding**
- **Neovim / LazyVim keybinding**

Use this to retrain muscle memory while keeping the best of both worlds.

---

## 1. Basic Cursor Movement

| Action | IntelliJ | Neovim / LazyVim |
|-------|----------|-------------------|
| Move left/right | ← / → | `h` / `l` |
| Move up/down | ↑ / ↓ | `k` / `j` |
| Move by word | Ctrl + ← / → | `b` / `w` |
| Move to line start | Home | `0` (absolute), `^` (first non-blank) |
| Move to line end | End | `$` |
| Move to file top/bottom | Ctrl + Home / Ctrl + End | `gg` / `G` |
| Move by paragraph | Ctrl + ↑ / ↓ | `{` / `}` |
| Page up/down | PgUp / PgDn | Ctrl + `u` / Ctrl + `d` |

---

## 2. Selections (Visual Mode)

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|-------------------|
| Enter selection | Shift + arrows | `v` (char), `V` (line), `Ctrl+v` (block) |
| Select word | Ctrl + W | `viw` |
| Select line | Ctrl + L | `V` |
| Expand selection | Ctrl + W repeatedly | `<leader>v` (Treesitter incremental select) |
| Select all | Ctrl + A | `ggVG` |

---

## 3. Copy, Cut, Paste

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|-------------------|
| Copy | Ctrl + C | `y` |
| Cut | Ctrl + X | `d` |
| Paste | Ctrl + V | `p` / `P` |
| Copy line | Ctrl + C (No selection) | `yy` |
| Cut/delete line | Ctrl + X (No selection) | `dd` |
| Paste over selection | Ctrl + V | `v` → select → `p` |
| Duplicate line | Ctrl + D | `yyp` |
| Undo | Ctrl + Z | `u` |
| Redo | Ctrl + Shift + Z | `Ctrl + r` |

---

## 4. Deleting & Changing

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Delete previous word | Ctrl + Backspace | `db` |
| Delete next word | Ctrl + Delete | `dw` |
| Change word | – | `cw` |
| Change inside quotes | – | `ci"` |
| Change inside brackets | – | `ci(` |
| Delete inside quotes | – | `di"` |
| Replace one character | – | `r<char>` |
| Replace (overwrite mode) | – | `R` |

---

## 5. Searching

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Find | Ctrl + F | `/` |
| Find next | F3 | `n` |
| Find previous | Shift + F3 | `N` |
| Replace | Ctrl + R | `:%s/search/replace/g` |
| Replace with confirm | Ctrl + R | `:%s/search/replace/gc` |
| Go to line | Ctrl + G | `:line_number` or `gg`, `G` |

LazyVim bonus:

| Action | Neovim / LazyVim |
|--------|------------------|
| Search word under cursor | `*` / `#` |

---

## 6. Multi-Cursor / Multiple Selection

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Add cursor next occurrence | Alt + J | `<leader>m` |
| Add cursor previous | Alt + Shift + J | `<leader>M` |
| Add cursor to end of lines | Ctrl + Alt + Shift + J | `<leader>mA` |
| Clear all cursors | Esc | Esc |

(LazyVim includes **vim-visual-multi**.)

---

## 7. Indentation

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Indent | Tab | `>>` |
| Outdent | Shift + Tab | `<<` |
| Auto-format | Ctrl + Alt + L | `<leader>cf` |

---

## 8. File Operations

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Open file | Ctrl + Shift + N | `<leader>ff` |
| Search everywhere | Shift ×2 | `<leader>sg` |
| Recent files | Ctrl + E | `<leader>fr` |
| Toggle file tree | Alt + 1 | `<leader>e` |

---

## 9. Tabs, Splits & Windows

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Split vertically | Ctrl + `\` | `<leader>sv` |
| Split horizontally | Ctrl + Shift + `\` | `<leader>sh` |
| Next/previous tab | Alt + ← / → | `gt` / `gT` |
| Move focus | Ctrl + Tab | `<C-h>`, `<C-j>`, `<C-k>`, `<C-l>` |

---

## 10. Refactoring (LSP)

| Action | IntelliJ | Neovim / LazyVim |
|--------|----------|------------------|
| Rename symbol | Shift + F6 | `<leader>cr` |
| Refactor menu | Ctrl + Alt + Shift + T | `<leader>cA` |
| Go to definition | Ctrl + B | `gd` |
| Go to implementation | Ctrl + Alt + B | `gI` |
| Find usages | Alt + F7 | `<leader>cu` |
| Show docs | Ctrl + Q | `K` |

---

# ✔ Recommended Practice Order

1. Movement (`hjkl`, `w`, `b`, `0`, `$`, `gg`, `G`)
2. Editing (`cw`, `ciw`, `diw`, `dd`, `p`, `u`, `Ctrl+r`)
3. Searching (`/`, `n`, `N`, `*`)
4. Multi-cursor (`<leader>m`)
5. LSP (`gd`, `<leader>cr`, `<leader>cf`)
6. File navigation (`<leader>ff`, `<leader>sg`, `<leader>e`)

