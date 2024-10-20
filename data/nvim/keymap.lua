vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk" "<ESC>", { desc = "Exit insert mode with jk"})