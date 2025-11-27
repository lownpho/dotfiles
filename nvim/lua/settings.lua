local o = vim.opt

o.mouse = "a" -- Enable mouse support

o.relativenumber = true
o.number = true
o.cursorline = true

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.showmode = false 
o.signcolumn = "yes" -- Always show the sign column

o.breakindent = true -- Indent wrapped lines

o.undofile = true

-- Search: case insensitive unless uppercase letters are used
o.ignorecase = true
o.smartcase = true

o.updatetime = 250 -- Faster completion
o.timeoutlen = 300 -- Time to wait for a mapped sequence to complete

-- Splits (not that I use them much...)
o.splitright = true
o.splitbelow = true
o.inccommand = "split" -- Show live substitutions in a split window

-- Show whitespace characters
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣"}

o.scrolloff = 10

o.winborder = "rounded"

-- Scheduling what could increase startup time
vim.schedule(function()
    o.clipboard = "unnamedplus" -- Use the system clipboard
end)

