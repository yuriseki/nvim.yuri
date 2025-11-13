# Learning NVIM

## Useful commands

- Reload the configuration without exiting `nvim`: `:so` - It do not work with Lazy.vim
TODO: Find a way to make it work


### Navigation commands

- Half of a page navigation: Up: `<ctrl> u`, Down `<ctrl> + d`
- Jump to a line: type line number and then `gg`
- Center page in the cursor line: `zz`

## Inspiring repositories

- Full newovim from Scratch 2025
    - https://www.youtube.com/watch?v=KYDG3AHgYEs&t=247s
    - https://github.com/hendrikmi/neovim-kickstart-config


## LSP

To install a new LSP serve, execute `:LspInstall` with a file using the language.

Ex: To install the Python LSP, execute that command with the `test.py` file opened.
