# Neobuild

An extensible framework for interacting with build systems within Neovim

> WARNING: This plugin is in early development and is not ready for use.

## ✨ Features

Thoughts:

- Build targets (all, file, ...)
- Progress indicator
- Configure build
  - Build output directory (default: build)
  - Debug vs Release, etc.
- Build/Configuration summary
- Auto-discover build system based on patterns in cwd (first takes precedence)
  - I.e. poky directory (bitbake), CMakeLists.txt, Makefile, etc.
- Use vim.notify() to display info/warning/error
- Caching? Project specific settings?
- Clean build (all, directory, file)
- Cancel ongoing build

Possible adapters

- Bitbake
- CMake
- Cargo
- Conan
- Make
- Ninja
- QMake

Possible integrations

- nvim-dap

## 📦 Installation

Neobuild depends on [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).
Install it alongside Neobuild using your preferred plugin manager:

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'orjangj/neobuild'
```

[packer](https://github.com/wbthomason/packer.nvim)

```lua
use { 'orjangj/neobuild', requires = 'nvim-lua/plenary.nvim' }
```

[lazy](https://github.com/folke/lazy.nvim)

```lua
{ 'orjangj/neobuild', dependencies = 'nvim-lua/plenary.nvim' }
```

## ⚙️ Configuration

TODO

## 🚀 Usage

```lua
-- configure/initialize build system
require('neobuild').configure()
-- build
require('neobuild').build()  -- Build the default target
require('neobuild').build(vim.fn.expand('%')) -- Build the current file
-- Clean
require('neobuild').clean()
```
