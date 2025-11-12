# Project Overview

This is a Neovim configuration based on `kickstart.nvim`. It is intended to be a starting point for a personal Neovim setup. The configuration is written in Lua and uses `lazy.nvim` for plugin management. The main configuration file is `init.lua`, with `init-quickstart.lua` being another potential entry point.

# Building and Running

This is a Neovim configuration, not a standalone application. To "run" it, you need to:

1.  **Install Neovim** (latest stable or nightly).
2.  **Install external dependencies** like `git`, a C compiler, `ripgrep`, and `fd`.
3.  **Clone this repository** into your Neovim configuration directory (e.g., `~/.config/nvim`).
4.  **Start Neovim** by running `nvim` in your terminal.

The `lazy.nvim` plugin manager will automatically handle the installation of the configured plugins when you first start Neovim.

# Development Conventions

*   **Plugin Management:** Plugins are managed using `lazy.nvim`. The core plugins are defined in `init.lua` and `init-quickstart.lua`.
*   **Customization:** Users are encouraged to add their own plugins and configurations in the `lua/custom/plugins/` directory. The `lua/custom/plugins/init.lua` file is the entry point for custom plugins.
*   **Coding Style:** The existing code follows standard Lua conventions. The `.stylua.toml` file suggests that `stylua` is used for code formatting.
*   **Pull Requests:** A pull request template exists at `.github/pull_request_template.md`.
*   **Issues:** A bug report template is at `.github/ISSUE_TEMPLATE/bug_report.md`.
*   **CI:** A GitHub Actions workflow at `.github/workflows/stylua.yml` is likely used to enforce code style.
