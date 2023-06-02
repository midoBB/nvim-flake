-- # vim:fileencoding=utf-8:ft=lua:foldmethod=marker
require('impatient')
-- Helper functions {{{
function OpenQF()
    local qf_name = "quickfix"
    local qf_empty = function()
        return vim.tbl_isempty(vim.fn.getqflist())
    end
    if not qf_empty() then
        vim.cmd.copen()
        vim.cmd.wincmd("J")
    else
        print(string.format("%s is empty.", qf_name))
    end
end

function FindQF(type)
    local wininfo = vim.fn.getwininfo()
    local win_tbl = {}
    for _, win in pairs(wininfo) do
        local found = false
        if type == "l" and win["loclist"] == 1 then
            found = true
        end
        if type == "q" and win["quickfix"] == 1 and win["loclist"] == 0 then
            found = true
        end
        if found then
            table.insert(win_tbl, {
                winid = win["winid"],
                bufnr = win["bufnr"]
            })
        end
    end
    return win_tbl
end

function OpenLoclistAll()
    local wininfo = vim.fn.getwininfo()
    local qf_name = "loclist"
    local qf_empty = function(winnr)
        return vim.tbl_isempty(vim.fn.getloclist(winnr))
    end
    for _, win in pairs(wininfo) do
        if win["quickfix"] == 0 then
            if not qf_empty(win["winnr"]) then
                vim.api.nvim_set_current_win(win["winid"])
                vim.cmd.lopen()
            else
                print(string.format("%s is empty.", qf_name))
            end
        end
    end
end

function ToggleQF(type)
    local windows = FindQF(type)
    if #windows > 0 then
        for _, win in ipairs(windows) do
            vim.api.nvim_win_hide(win.winid)
        end
    else
        if type == "l" then
            OpenLoclistAll()
        else
            OpenQF()
        end
    end
end

local function map(mode, lhs, rhs, opts)
    local options = {
        noremap = true,
        silent = true
    }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- }}}
-- Opts {{{
vim.g.mapleader = " "

local options = {
    -- meta settings
    backup = false,
    belloff = "all",
    bufhidden = "wipe",
    cdhome = true,
    mouse = "",
    clipboard = "",
    completeopt = "menuone,noinsert,noselect", -- Autocomplete options
    backspace = "indent,eol,start",
    timeoutlen = 300,
    confirm = true,
    errorbells = false,
    fileencoding = "utf-8",
    icon = true,
    mousehide = true,
    swapfile = false,
    undofile = true,
    updatetime = 50,
    verbose = 0,
    visualbell = false,
    spell = false,
    -- indentation
    autoindent = true,
    breakindent = true,
    copyindent = true,
    expandtab = true,
    preserveindent = true,
    smartindent = true,
    smarttab = true,
    shiftwidth = 4,
    tabstop = 4,
    shiftround = true,
    hidden = true,
    -- visuals
    background = "dark",
    cmdheight = 1,
    cursorcolumn = false,
    cursorline = true,
    helpheight = 8,
    menuitems = 8,
    laststatus = 3,
    number = true,
    pumheight = 8,
    pumblend = 17,
    relativenumber = true,
    scrolloff = 8,
    showmode = false,
    showmatch = true,
    showcmd = true,
    colorcolumn = "80",
    sidescroll = 1,
    sidescrolloff = 8,
    signcolumn = "yes",
    splitbelow = true,
    splitright = true,
    syntax = "ON",
    termguicolors = true,
    linebreak = false,
    wrap = true,
    wrapmargin = 8,
    list = true,
    -- Setup whitespace chars
    listchars = {
        eol = "⏎",
        tab = ">·",
        trail = "~",
        extends = ">",
        precedes = "<"
    },
    fillchars = {
        vert = "█",
        horiz = "▀",
        horizup = "█",
        horizdown = "█",
        vertleft = "█",
        vertright = "█",
        verthoriz = "█"
    },
    -- code folding
    foldcolumn = "1",
    foldlevel = 99,
    foldlevelstart = 99,
    foldenable = true,
    -- search settingsop
    hlsearch = true,
    incsearch = true,
    ignorecase = true,
    smartcase = true,
    wrapscan = true,
    wildignore = "__pychache__",
    whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
    sessionoptions = "blank,buffers,curdir,winsize,winpos,localoptions",
    inccommand = "split"
}

for name, value in pairs(options) do
    vim.opt[name] = value
end

vim.opt.wildignore:append({ "*.o", "*~", "*.pyc", "*pycache*", "*.lock" })
-- -- Disable builtin plugins
local disabled_built_ins = { "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
    "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
    "synmenu", "optwin", "compiler", "bugreport", "ftplugin" }

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
-- }}}
-- Colorscheme / Visuals setup {{{
pcall(vim.cmd, "colorscheme " .. "oxocarbon")
vim.notify = require("notify")
require("colorizer").setup()
require("noice").setup({
    lsp = {
        signature = {
            enabled = false
        },
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true
        },
        progress = {
            enabled = false,
        },

        hover = {
            enabled = false,
        }
    },
    presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
    },
    messages = {
        enabled = true,              -- enables the Noice messages UI
        view = "mini",               -- default view for messages
        view_error = "mini",         -- view for errors
        view_warn = "mini",          -- view for warnings
        view_history = "messages",   -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    routes = { {
        filter = {
            event = "msg_show",
            kind = "*"
        },
        opts = {
            skip = true
        }
    }, {
        filter = {
            event = "msg_show",
            kind = "",
            find = "written"
        },
        opts = {
            skip = true
        }
    } }
})
require("dressing").setup({
    input = {
        relative = "editor"
    },
    select = {
        backend = { "telescope", "fzf", "builtin" }
    }
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
})
vim.diagnostic.config({
    underline = true,
    update_in_insert = true,
    virtual_text = {
        source = "always", -- Or "if_many"
        prefix = "●"     -- Could be '■', '▎', 'x'
    },
    severity_sort = true,
    float = {
        focused = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

local signs = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = ""
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = ""
    })
end
-- }}}
-- NvimTree {{{
require("nvim-tree").setup({
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    hijack_cursor = true,
    actions = {
        open_file = {
            quit_on_open = true
        }
    },
    update_focused_file = {
        enable = true,
        update_root = true
    },
    renderer = {
        indent_markers = {
            enable = true
        }
    }
})
-- }}}
-- Telescope {{{
require('telescope').setup({
    defaults = {
        --[[ layout_strategy = "center", ]]
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        file_ignore_patterns = { ".git/", "node_modules" },
        mappings = {
            i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = false,   -- override the file sorter
            case_mode = "smart_case"        -- or "ignore_case" or "respect_case"
        },
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        }
    }
})
require('telescope').load_extension("fzf")
require('telescope').load_extension('fzy_native')
require('telescope').load_extension("aerial")
-- }}}
-- Indentation {{{
local hl_list = {}
for i, color in pairs({ '#E06C75', '#E5C07B', '#98C379', '#56B6C2', '#61AFEF', '#C678DD' }) do
    local name = 'IndentBlanklineIndent' .. i
    vim.api.nvim_set_hl(0, name, {
        fg = color
    })
    table.insert(hl_list, name);
end

require("indent_blankline").setup({
    show_end_of_line = true,
    char_highlight_list = hl_list,
    space_char_highlight_list = hl_list,
    char = "▎",
    show_current_context = true,
    show_current_context_start = true
})

-- }}}
-- Treesitter {{{
require("nvim-treesitter")

require("nvim-treesitter.configs").setup({
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<C-backspace>"
        }
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner"
            }
        }
    },
    context_commentstring = {
        enable = true,
        -- With Comment.nvim, we don't need to run this on the autocmd.
        -- Only run it in pre-hook
        enable_autocmd = false
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil
    },
    autotag = {
        enable = true
    },
    highlight = {
        enable = true,
        disable = { "comment" }
    }
})

require("hlargs").setup()
-- }}}
-- Comments {{{

require("Comment").setup({
    mappings = {
        extra = true
    },
    pre_hook = function(ctx)
        local U = require "Comment.utils"

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring {
            key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
            location = location
        }
    end
})

-- }}}
-- Autocmds {{{
vim.api.nvim_create_augroup("bufcheck", {
    clear = true
})

-- start git messages in insert mode
vim.api.nvim_create_autocmd("FileType", {
    group = "bufcheck",
    pattern = { "gitcommit", "gitrebase" },
    command = "startinsert | 1"
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = ":%s/\\s\\+$//e"
})

-- Don't auto commenting new lines
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "set fo-=c fo-=r fo-=o"
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    command = "set shm=filnxtToOF"
})
-- Settings for filetypes:
-- Disable line length marker
vim.api.nvim_create_augroup("setLineLength", {
    clear = true
})
vim.api.nvim_create_autocmd("Filetype", {
    group = "setLineLength",
    pattern = { "text", "markdown", "html", "xhtml", "javascript", "typescript" },
    command = "setlocal cc=0"
})

-- Set indentation to 2 spaces
vim.api.nvim_create_augroup("setIndent", {
    clear = true
})
vim.api.nvim_create_autocmd("Filetype", {
    group = "setIndent",
    pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua" },
    command = "setlocal shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_augroup("General", {
    clear = true
})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "General",
    pattern = { "*.{,z,ba}sh", "*.pl", "*.py" },
    desc = "Make files executable",
    callback = function()
        vim.fn.system({ "chmod", "+x", vim.fn.expand("%") })
    end
})

-- Return to last edit position when opening files

require("nvim-lastplace").setup({
    lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
    lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
    lastplace_open_folds = true
})
require("session_manager").setup({
    autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir
})

vim.cmd([[
      augroup gitconfig
        autocmd!
        autocmd FileType gitcommit execute "normal! O" | startinsert
        autocmd FileType NeogitCommitMessage execute "normal! O" | startinsert
      augroup end
    ]])

--[[ vim.api.nvim_create_autocmd({"BufLeave"}, {
    pattern = "{}",
    callback = function()
        if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
            vim.bo.buftype = "nofile"
            vim.bo.bufhidden = "wipe"
        end
    end,
    group = "bufcheck"
}) ]]
-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qf", "help", "man", "notify", "lspinfo", "spectre_panel", "startuptime" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true
        })
    end
})

-- }}}
-- Register/Clipboard plugins {{{

require("yanky").setup({
    preserve_cursor_position = {
        enabled = true
    },
    highlight = {
        on_put = true,
        on_yank = true,
        timer = 500
    },
    system_clipboard = {
        sync_with_ring = false
    }
})

require("cutlass").setup({
    cut_key = "m",
    exclude = { "ns", "nS" }
})

-- }}}
-- Small plugins setup {{{
require("nvim-surround").setup({})
require("splitjoin").setup({})
require("nvim-autopairs").setup({})
require("smart-splits").setup({})
require("inc_rename").setup({})
require("fidget").setup({})
require("reticle").setup({})
require("aerial").setup({})
require("hlslens").setup({})
require("lsp-lens").setup({})
require("colorful-winsep").setup({})
-- }}}
-- Keymaps {{{

-- Disable arrow keys
map("", "<up>", "<nop>")
map("", "<down>", "<nop>")
map("", "<left>", "<nop>")
map("", "<right>", "<nop>")
map("", "<Space>", "<Nop>")
map("i", "<C-n>", "<Nop>")

--- Disable Recording & Ex Mode
map("", "q", "<nop>")
map("", "Q", "<nop>")
map("", "gQ", "<nop>")
map("n", "U", "<C-R>")
map("", "<C-r>", "<Nop>")

map("n", "x", '"_x')
map("n", "yw", "yiw")
map("n", "dw", '"_diw')
map("n", "cw", '"_ciw')
map("n", "cc", '"_cc')
map("v", "c", '"_c')
map("v", "p", '"_dP')
map("x", "p", '"_dP')
-- Yank ring
map("n", "p", "<Plug>(YankyPutAfter)")
map("x", "p", "<Plug>(YankyPutAfter)")
map("n", "P", "<Plug>(YankyPutBefore)")
map("x", "P", "<Plug>(YankyPutBefore)")
map("n", "gp", "<Plug>(YankyGPutAfter)", {
    desc = "Paste and move cursor after"
})
map("x", "gp", "<Plug>(YankyGPutAfter)", {
    desc = "Paste and move cursor after"
})
map("n", "gP", "<Plug>(YankyGPutBefore)", {
    desc = "Paste and move cursor after"
})
map("x", "gP", "<Plug>(YankyGPutBefore)", {
    desc = "Paste and move cursor after"
})
map("n", "y", "<Plug>(YankyYank)")
map("x", "y", "<Plug>(YankyYank)")

-- Move around splits using Ctrl + {h,j,k,l}
-- resizing splits
map("n", "<A-h>", "<cmd>lua require('smart-splits').resize_left()<cr>")
map("n", "<A-j>", "<cmd>lua require('smart-splits').resize_down()<cr>")
map("n", "<A-k>", "<cmd>lua require('smart-splits').resize_up()<cr>")
map("n", "<A-l>", "<cmd>lua require('smart-splits').resize_right()<cr>")
-- moving between splits
map("n", "<C-h>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>")
map("n", "<C-j>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>")
map("n", "<C-k>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>")
map("n", "<C-l>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>")

-- Center the screen when going down a page or up a page
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-o>", "<c-o>zz")
map("n", "<C-i>", "<c-i>zz")
map('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]])
map('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'Nzzzv')<CR><Cmd>lua require('hlslens').start()<CR>]])
map('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]])
map('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]])
map('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]])
map('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]])
map("n", "j", "gj")
map("n", "k", "gk")
-- map('n', 'J', 'V:m \'>+1<CR>gv=gv<ESC>')
-- map('n', 'K', 'V:m \'<-2<CR>gv=gv<ESC>') --Removed this because it doesn't work with LSP hover
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("x", "J", ":m '>+1<CR>gv=gv")
map("x", "K", ":m '<-2<CR>gv=gv")
map("n", ">", ">>")
map("n", "<", "<<")
map("x", ">", ">gv")
map("x", "<", "<gv")

-- buffer / window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<S-h>", "<cmd>BufferLineCycleWindowlessPrev<CR>")
map("n", "<S-l>", "<cmd>BufferLineCycleWindowlessNext<CR>")
-- Align
map("x", "aw", "<cmd>lua require('align').align_to_string(false, true, true)<cr>", {
    desc = "Align to words"
})
map("x", "as", "<cmd>lua require('align').align_to_char(1, true, true)<cr>", {
    desc = "Align to a char"
})
map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
map("n", "<C-e>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')
map("n", "<C-q>", "<cmd>AerialToggle!<CR>", { desc = "View document symbols" })
map("n", "<C-c>", "<cmd>lua ToggleQF('q')<CR>", { desc = "Toggle quickfix window" })
map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", {
    desc = "Search and Replace"
})
map("n", "gj", "<cmd>lua require('splitjoin').join()<cr>", {
    desc = "Join the object under cursor"
})
map("n", "g,", "<cmd>lua require('splitjoin').split()<cr>", {
    desc = "Split the object under cursor"
})
local whichkey = require("which-key")
local conf = {
    window = {
        border = "single",   -- none, single, double, shadow
        position = "bottom", -- bottom, top
    },
}

local opts = {
    mode = "n",     -- Normal mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

local mappings = {
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["p"] = { '"+gp', "Paste from clipboard" },
    ["y"] = { '"+y', "Copy to clipboard" },
    ["w"] = { "<cmd>update!<CR>", "Save" },
    ["<leader>q"] = { "<cmd>qa<CR>", "Quit" },
    ["q"] = { "<cmd>Bdelete<CR>", "Close the current buffer" },
    b = {
        name = "+Buffer",
        c = { "<cmd>BufDelOthers<CR>", "Close the other buffers" },
        f = { "<cmd>Telescope buffers<cr>", "Find buffer" },
    },
    d = {
        name = "+Debugging",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle breakpoint" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "Step into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "Step over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "Step out" },
        I = {
            "<cmd>lua require'dap.ui.widgets'.hover()<cr>",
            "Inspect variable under cursor",
        },
        S = {
            "<cmd>lua local w=require'dap.ui.widgets';w.centered_float(w.scopes)<cr>",
            "Show Scopes",
        },
        s = { "<cmd>lua require'dap'.continue()<cr>", "Start debugging" },
        t = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate debugging" },
        f = { "<cmd>lua require'dap'.close()<cr>", "Finish debugging" },
        j = { "<cmd>lua require'dap'.down()<cr>", "Go down in call stack" },
        k = { "<cmd>lua require'dap'.up()<cr>", "Go up in call stack" },
    },
    f = {
        name = "+Find",
        f = { "<cmd>Telescope find_files<cr>", "Find File" },
        g = { "<cmd>Telescope live_grep<cr>", "Find text" },
        p = { "<cmd>Telescope projects<CR>", "Find project" },
        r = { "<cmd>Telescope oldfiles<CR>", "Recent files" },
        b = { "<cmd>Telescope buffers<cr>", "Open Buffers" },
        c = { "<cmd>Telescope command_history<cr>", "Previous commands" },
        C = { "<cmd>Telescope commands<cr>", "Available commands" },
        h = { "<cmd>Cheatsheet<cr>", "Help Tags" },
        H = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
        j = { "<cmd>Telescope jumplist<cr>", "Jump List" },
        m = { "<cmd>Telescope marks<cr>", "Marks" },
        R = { "<cmd>Telescope registers<cr>", "Registers" },
        t = { "<cmd>Telescope live_grep<cr>", "Text" },
        T = { "<cmd>TodoTelescope<cr>", "Todos" },
    },
    s = {
        name = "+Split",
        s = { "<cmd>split<CR>", "Split hortizentally" },
        v = { "<cmd>vsplit<CR>", "Split Vertically" },
        c = { "<cmd>close<CR>", "Close Split" },
    },
    g = {
        name = "+Go to",
        f = { "<cmd>NvimTreeToggle<cr>", "file system" },
        g = { "<cmd>Neogit<CR>", "Git" },
        y = { "<cmd>YankyRingHistory<cr>", "Clipboard History" },
        i = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace issues" },
        t = { "<cmd>TodoTrouble<cr>", "Todos" },
        u = { "<cmd>UndotreeToggle<cr>", "Undo tree" },
    },
    h = {
        name = "+Git",
        n = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
        p = { "<cmd>Gitsigns prev_hunk<cr>", "Previous hunk" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
        u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo stage hunk" },
        S = { "<cmd>Gitsigns stage_buffer<cr>", "Stage buffer" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset buffer" },
        P = { "<cmd>Gitsigns preview_hunk_inline<cr>", "Preview Hunk" },
        b = { "<cmd>Gitsigns blame_line<cr>", "Git blame" },
    },
    m = {
        name = "+Harpoon",
        a = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Add File" },
        m = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Menu" },
    },
    c = {
        name = "+Coding",
        A = {
            name = "Annotate",
            f = { "<cmd>Neogen func<cr>", "Annotate function" },
            c = { "<cmd>Neogen class<cr>", "Annotate class" },
            t = { "<cmd>Neogen type<cr>", "Annotate type" },
            F = { "<cmd>Neogen file<cr>", "Annotate File" },
        },
    },
}

local vopts = {
    mode = "v",     -- Normal mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

local vmappings = {
    ["p"] = { '"+gP', "Paste from clipboard" },
    ["y"] = { '"+y', "Copy to clipboard" },
    h = {
        name = "Git Hunks",
        s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
    },
}
whichkey.setup(conf)
whichkey.register(mappings, opts)
whichkey.register(vmappings, vopts)

-- }}}
-- Code folding{{{

local _, ufo = pcall(require, "ufo")

local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = vim.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, { suffix, 'MoreMsg' })
    return newVirtText
end

-- buffer scope handler
-- will override global handler if it is existed
ufo.setup({
    fold_virt_text_handler = handler,
    provider_selector = function(_, _, _)
        return { 'treesitter', 'indent' }
    end
})
local bufnr = vim.api.nvim_get_current_buf()

ufo.setFoldVirtTextHandler(bufnr, handler)

-- }}}
-- Motion plugins {{{
require("tabout").setup({
    tabkey = "<Tab>",             -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true,            -- shift content if tab out is not possible
    act_as_shift_tab = false,     -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    default_tab = "<C-t>",        -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
    default_shift_tab = "<C-d>",  -- reverse shift default action,
    enable_backwards = true,      -- well ...
    completion = true,            -- if the tabkey is used in a completion pum
    tabouts = { {
        open = "'",
        close = "'"
    }, {
        open = '"',
        close = '"'
    }, {
        open = "`",
        close = "`"
    }, {
        open = "(",
        close = ")"
    }, {
        open = "[",
        close = "]"
    }, {
        open = "{",
        close = "}"
    }, {
        open = "<",
        close = ">"
    } },
    ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
    exclude = {} -- tabout will ignore these filetypes
})

require("leap").add_default_mappings()

require("flit").setup({
    keys = {
        f = "f",
        F = "F",
        t = "t",
        T = "T"
    },
    labeled_modes = "v",
    multiline = false,
    opts = {}
})
require("search-replace").setup({
    default_replace_single_buffer_options = "gcI",
    default_replace_multi_buffer_options = "egcI"
})
-- }}}
-- Git {{{
require("gitsigns").setup {
    signs = {
        add = {
            hl = "GitSignsAdd",
            text = "▎",
            numhl = "GitSignsAddNr",
            linehl = "GitSignsAddLn"
        },
        change = {
            hl = "GitSignsChange",
            text = "▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        },
        delete = {
            hl = "GitSignsDelete",
            text = "契",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        topdelete = {
            hl = "GitSignsDelete",
            text = "契",
            numhl = "GitSignsDeleteNr",
            linehl = "GitSignsDeleteLn"
        },
        changedelete = {
            hl = "GitSignsChange",
            text = "▎",
            numhl = "GitSignsChangeNr",
            linehl = "GitSignsChangeLn"
        }
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    watch_gitdir = {
        interval = 1000,
        follow_files = true
    },
    attach_to_untracked = true,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1
    }
}
require("neogit").setup({
    disable_commit_confirmation = true,
    disable_signs = true,
    auto_refresh = false,
    disable_builtin_notifications = true,
    integrations = {
        diffview = true
    }
})

-- }}}
-- Bufferline {{{

require("bufferline").setup({
    options = {
        offsets = { {
            filetype = "NvimTree",
            text = "",
            text_align = "left",
            padding = 1
        } },
        mode = "buffers", -- tabs or buffers
        numbers = "none",
        diagnostics = "nvim_lsp",
        separator_style = "slant" or "padded_slant",
        show_tab_indicators = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        enforce_regular_tabs = false,
        custom_filter = function(buf_number, _)
            local tab_num = 0
            for _ in pairs(vim.api.nvim_list_tabpages()) do
                tab_num = tab_num + 1
            end

            if tab_num > 1 then
                if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
                    return true
                end
            else
                return true
            end
        end,
        sort_by = function(buffer_a, buffer_b)
            local mod_a = ((vim.loop.fs_stat(buffer_a.path) or {}).mtime or {}).sec or 0
            local mod_b = ((vim.loop.fs_stat(buffer_b.path) or {}).mtime or {}).sec or 0
            return mod_a > mod_b
        end
    }
})
require("bufferline-cycle-windowless").setup({
    default_enabled = true
})
-- }}}
-- Lualine {{{
local metals_stats = function()
    local status = vim.g['metals_status']
    if status == nil then return "" else return status end
end

local function get_palette()
    return {
        rosewater = "#DC8A78",
        flamingo = "#DD7878",
        mauve = "#CBA6F7",
        pink = "#F5C2E7",
        red = "#E95678",
        maroon = "#B33076",
        peach = "#FF8700",
        yellow = "#F7BB3B",
        green = "#AFD700",
        sapphire = "#36D0E0",
        blue = "#61AFEF",
        sky = "#04A5E5",
        teal = "#B5E8E0",
        lavender = "#7287FD",
        text = "#F2F2BF",
        subtext1 = "#BAC2DE",
        subtext0 = "#A6ADC8",
        overlay2 = "#C3BAC6",
        overlay1 = "#988BA2",
        overlay0 = "#6E6B6B",
        surface2 = "#6E6C7E",
        surface1 = "#575268",
        surface0 = "#302D41",
        base = "#1D1536",
        mantle = "#1C1C19",
        crust = "#161320"
    }
end
local data = {
    kind = {
        Class = "ﴯ",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Keyword = "",
        Method = "",
        Module = "",
        Namespace = "",
        Number = "",
        Operator = "",
        Package = "",
        Property = "ﰠ",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
        -- ccls-specific icons.
        TypeAlias = "",
        Parameter = "",
        StaticMethod = "",
        Macro = ""
    },
    type = {
        Array = "",
        Boolean = "",
        Null = "ﳠ",
        Number = "",
        Object = "",
        String = ""
    },
    documents = {
        Default = "",
        File = "",
        Files = "",
        FileTree = "פּ",
        Import = "",
        Symlink = ""
    },
    git = {
        Add = " ",
        Branch = "",
        Diff = "",
        Git = "",
        Ignore = "",
        Mod = "M",
        Mod_alt = " ",
        Remove = " ",
        Rename = "",
        Repo = "",
        Unmerged = "שׂ",
        Untracked = "ﲉ",
        Unstaged = "",
        Staged = "",
        Conflict = ""
    },
    ui = {
        ArrowClosed = "",
        ArrowOpen = "",
        BigCircle = "",
        BigUnfilledCircle = "",
        BookMark = "",
        Bug = "",
        Calendar = "",
        Check = "",
        ChevronRight = "",
        Circle = "",
        Close = "",
        Close_alt = "",
        CloudDownload = "",
        Comment = "",
        CodeAction = "",
        Dashboard = "",
        Emoji = "",
        EmptyFolder = "",
        EmptyFolderOpen = "",
        File = "",
        Fire = "",
        Folder = "",
        FolderOpen = "",
        Gear = "",
        History = "",
        Incoming = "",
        Indicator = "",
        Keyboard = "",
        Left = "",
        List = "",
        Square = "",
        SymlinkFolder = "",
        Lock = "",
        Modified = "✥",
        Modified_alt = "",
        NewFile = "",
        Newspaper = "",
        Note = "",
        Outgoing = "",
        Package = "",
        Pencil = "",
        Perf = "",
        Play = "",
        Project = "",
        Right = "",
        RootFolderOpened = "",
        Search = "",
        Separator = "",
        DoubleSeparator = "",
        SignIn = "",
        SignOut = "",
        Sort = "",
        Spell = "暈",
        Symlink = "",
        Table = "",
        Telescope = ""
    },
    diagnostics = {
        Error = "",
        Warning = "",
        Information = "",
        Question = "",
        Hint = "",
        -- Holo version
        Error_alt = "",
        Warning_alt = "",
        Information_alt = "",
        Question_alt = "",
        Hint_alt = ""
    },
    misc = {
        Campass = "",
        Code = "",
        EscapeST = "✺",
        Gavel = "",
        Glass = "",
        PyEnv = "",
        Squirrel = "",
        Tag = "",
        Tree = "",
        Watch = "",
        Lego = "",
        Vbar = "│",
        Add = "+",
        Added = "",
        Ghost = "",
        ManUp = "",
        Vim = ""
    },
    cmp = {
        Copilot = "",
        Copilot_alt = "",
        nvim_lsp = "",
        nvim_lua = "",
        path = "",
        buffer = "",
        spell = "暈",
        luasnip = "",
        treesitter = ""
    },
    dap = {
        Breakpoint = "",
        BreakpointCondition = "ﳁ",
        BreakpointRejected = "",
        LogPoint = "",
        Pause = "",
        Play = "",
        RunLast = "↻",
        StepBack = "",
        StepInto = "",
        StepOut = "",
        StepOver = "",
        Stopped = "",
        Terminate = "ﱢ"
    }
}
local icons = {}

---Get a specific icon set.
---@param category "kind"|"type"|"documents"|"git"|"ui"|"diagnostics"|"misc"|"cmp"|"dap"
---@param add_space? boolean @Add trailing space after the icon.
function icons.get(category, add_space)
    if add_space then
        return setmetatable({}, {
            __index = function(_, key)
                return data[category][key] .. " "
            end
        })
    else
        return data[category]
    end
end

local colors = get_palette()
local icons = {
    diagnostics = icons.get("diagnostics", true),
    misc = icons.get("misc", true),
    ui = icons.get("ui", true)
}


local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end

local navic = require("nvim-navic")
local function get_cwd()
    local cwd = vim.fn.getcwd()
    local home = os.getenv("HOME")
    if cwd:find(home, 1, true) == 1 then
        cwd = "~" .. cwd:sub(#home + 1)
    end
    return icons.ui.RootFolderOpened .. cwd
end

local mini_sections = {
    lualine_a = { --[[ "filetype" ]] },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
}
local outline = {
    sections = mini_sections,
    filetypes = {}
}
local diffview = {
    sections = mini_sections,
    filetypes = { "DiffviewFiles" }
}

local function search_result()
    if vim.v.hlsearch == 0 then
        return ''
    end
    local last_search = vim.fn.getreg('/')
    if not last_search or last_search == '' then
        return ''
    end
    local searchcount = vim.fn.searchcount { maxcount = 9999 }
    return last_search .. '(' .. searchcount.current .. '/' .. searchcount.total .. ')'
end
local buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
end

require("lualine").setup({
    options = {
        icons_enabled = true,
        disabled_filetypes = {},
        component_separators = "|",
        section_separators = {
            left = "",
            right = ""
        }
    },
    sections = {
        lualine_a = { { "mode" } },
        lualine_b = { { 'b:gitsigns_head', icon = '' },
            {
                'diff',
                -- Is it me or the symbol for modified us really weird
                symbols = { added = data.git.Add, modified = data.git.Mod_alt, removed = data.git.Remove },
                diff_color = {
                    added = { fg = colors.green },
                    modified = { fg = colors.orange },
                    removed = { fg = colors.red },
                },
                source = diff_source
            }
        },
        lualine_c = { {
            'filename',
            cond = buffer_not_empty,
            color = { fg = colors.magenta, gui = 'bold' },
        } },
        lualine_x = { { metals_stats }, {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warning,
                info = icons.diagnostics.Information
            }
        }, { get_cwd } },
        lualine_y = { {
            "filetype",
            colored = true,
            icon_only = true
        } },
        lualine_z = { --[[ "progress", "location" ]] }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = { "quickfix", "nvim-tree", "nvim-dap-ui", "toggleterm", "fugitive", outline, diffview }
})

-- Workaround to make the global statusline look shifted over when nvim tree is
-- active
local nvim_tree_shift = {
    function()
        return string.rep(" ", vim.api.nvim_win_get_width(require("nvim-tree.view").get_winnr()) - 1)
    end,
    cond = require("nvim-tree.view").is_visible,
    color = "BufferInactive"
}

require("lualine").setup({
    sections = {
        lualine_a = { nvim_tree_shift, "mode" }
    }
})

-- }}}
-- Trouble {{{
require("trouble").setup {
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    auto_jump = { "lsp_definitions" },
    auto_fold = true,
    use_diagnostic_signs = true
}
require("todo-comments").setup {
    signs = true
}
-- }}}
-- Incline {{{

local function get_diagnostic_label(props)
    local icons = {
        Error = "",
        Warn = "",
        Info = "",
        Hint = ""
    }

    local label = {}
    for severity, icon in pairs(icons) do
        local n = #vim.diagnostic.get(props.buf, {
            severity = vim.diagnostic.severity[string.upper(severity)]
        })
        if n > 0 then
            local fg = "#" ..
                string.format("%06x",
                    vim.api.nvim_get_hl_by_name("DiagnosticSign" .. severity, true)["foreground"])
            table.insert(label, {
                icon .. " " .. n .. " ",
                guifg = fg
            })
        end
    end
    return label
end

local function get_git_diff(props)
    local icons = {
        removed = "",
        changed = "",
        added = ""
    }
    local labels = {}
    local signs = vim.api.nvim_buf_get_var(props.buf, "gitsigns_status_dict")
    -- local signs = vim.b.gitsigns_status_dict
    for name, icon in pairs(icons) do
        if tonumber(signs[name]) and signs[name] > 0 then
            table.insert(labels, {
                icon .. " " .. signs[name] .. " ",
                group = "Diff" .. name
            })
        end
    end
    if #labels > 0 then
        table.insert(labels, { "| " })
    end
    return labels
end

require("incline").setup({
    debounce_threshold = {
        falling = 500,
        rising = 250
    },
    hide = {
        only_win = true
    },
    render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":t")
        local diagnostics = get_diagnostic_label(props)
        local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"
        local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

        local buffer = { { get_git_diff(props) }, {
            filetype_icon,
            guifg = color
        }, { " " }, {
            filename,
            gui = modified
        } }

        if #diagnostics > 0 then
            table.insert(diagnostics, {
                "| ",
                guifg = "grey"
            })
        end
        for _, buffer_ in ipairs(buffer) do
            table.insert(diagnostics, buffer_)
        end
        return diagnostics
    end
})

-- }}}
-- LSP {{{
require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
require("barbecue").setup()
local glance = require('glance')
glance.setup({
    hooks = {
        before_open = function(results, open, jump, method)
            local uri = vim.uri_from_bufnr(0)
            if #results == 1 then
                local target_uri = results[1].uri or results[1].targetUri

                if target_uri == uri then
                    jump(results[1])
                else
                    open(results)
                end
            else
                open(results)
            end
        end,
    },
})
local function attached(client, bufnr)
    require("lsp_signature").on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded",
        },
    }, bufnr)
    require("illuminate").on_attach(client)

    if client.supports_method("textDocument/codeLens") then
        require("virtualtypes").on_attach()
    end
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group   = vim.api.nvim_create_augroup("SharedLspFormatting", { clear = true }),
            pattern = "*",
            command = "lua vim.lsp.buf.format({async=false})",
        })
    end
    client.server_capabilities.document_formatting = true
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
    if client.name == "tsserver" or client.name == "jsonls" or client.name ==
        "nil" or client.name == "eslint" or client.name == "html" or
        client.name == "cssls" or client.name == "tailwindcss" then
        -- Most of these are being turned off because prettier handles the use case better
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    else
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
        require("lsp-format").on_attach(client)
    end
    if client.server_capabilities.semanticTokensProvider and vim.lsp.semantic_tokens then
        for _, clientI in ipairs(vim.lsp.get_active_clients()) do
            if clientI.server_capabilities.semanticTokensProvider then
                vim.lsp.semantic_tokens[vim.b.semantic_tokens_enabled and "start" or "stop"](bufnr or 0, clientI.id)
            end
        end
    end
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

    map("n", "gd", "<cmd>Glance definitions<CR>", { desc = "Find symbol" })
    map("n", "gp", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "Peek symbol" })
    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
    map("n", "gr", "<cmd>Glance references<CR>", { desc = "Go to References" })
    map("n", "gt", "<cmd>Glance type_definitions<CR>", { desc = "Go to type definition" })
    map("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "See Line diagnostics" })
    map("n", "<leader>ca", "<cmd>CodeActionMenu<CR>", { desc = "Show Code actions" })
    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show hover documentation" })
    map("i", "<C-p>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", { desc = "Show signature help" })
    map("n", "<C-p>", "<cmd>lua require('lsp_signature').toggle_float_win()<CR>", { desc = "Show signature help" })
    map("n", "<C-S-q>", "<cmd>Telescope aerial<CR>", { desc = "Search document symbols" })
    map("n", "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", { desc = "Run codelens" })
    map("n", "(d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', { desc = "Go to next error" })
    map("n", ")d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', { desc = "Go to previous error" })
    map("n", "<leader>=", "<cmd>lua vim.lsp.buf.format({async=false})<CR>", { desc = "Format current file" })
    map("n", "gI", "<cmd>Telescope lsp_implementations<CR>", { desc = "Go to Implementation" })
    vim.keymap.set("n", "<leader>cr", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true, desc = "Rename" })
end

-- LSP stuff - minimal with defaults for now
local null_ls = require("null-ls")

local null_helpers = require("null-ls.helpers")
local null_methods = require("null-ls.methods")
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local codeactions = null_ls.builtins.code_actions

local function fix_imports()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end
require("lsp-format").setup {}

null_ls.setup {
    debug = false,
    sources = {
        -- formatting.lua_format,
        formatting.black,
        formatting.alejandra, -- for nix
        formatting.prismaFmt, -- for node prisma db orm

        null_helpers.make_builtin({
            method = null_methods.internal.FORMATTING,
            filetypes = { "sql" },
            generator_opts = {
                to_stdin = true,
                ignore_stderr = true,
                suppress_errors = true,
                command = "sqlfluff",
                args = {
                    "fix",
                    "-",
                },
            },
            factory = null_helpers.formatter_factory,
        }),

        null_ls.builtins.diagnostics.sqlfluff.with({
            command = "sqlfluff",
        }),
        formatting.prettier.with {

            -- extra_args = {
            --     "--use-tabs", "--single-quote", "--jsx-single-quote"
            -- },
            -- Disable markdown because formatting on save conflicts in weird ways
            -- with the taskwiki (roam-task) stuff.
            filetypes = {
                "javascript", "javascriptreact", "typescript",
                "typescriptreact", "vue", "scss", "less", "html", "css",
                "json", "jsonc", "yaml", "graphql", "handlebars", "svelte"
            },
            disabled_filetypes = { "markdown" }
        }, diagnostics.eslint_d.with {
        args = {
            "-f", "json", "--stdin", "--stdin-filename", "$FILENAME"
        }
    }, diagnostics.vale, diagnostics.hadolint,
        codeactions.eslint_d, codeactions.statix, -- for nix
        diagnostics.statix,                       -- for nix
        null_ls.builtins.hover.dictionary, codeactions.shellcheck,
        diagnostics.shellcheck,
        diagnostics.ktlint,
        formatting.ktlint
        -- removed formatting.rustfmt since rust_analyzer seems to do the same thing
    },
    on_attach = attached
}
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = vim.tbl_extend('keep', vim.lsp.protocol
    .make_client_capabilities(),
    cmp_nvim_lsp.default_capabilities());

lspconfig.tsserver.setup { capabilities = capabilities, on_attach = attached }
lspconfig.lua_ls.setup {
    on_attach = attached,
    capabilities = capabilities,
    filetypes = { "lua" },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim', "string", "require" }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                --[[ library = vim.api.nvim_get_runtime_file("", true), ]]
                --[[ checkThirdParty = false ]]
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
            completion = { enable = true, callSnippet = "Replace" }
        }
    }
}
lspconfig.svelte.setup { on_attach = attached, capabilities = capabilities }
lspconfig.tailwindcss.setup {
    on_attach = attached,
    capabilities = capabilities,
    settings = {
        files = { exclude = { "**/.git/**", "**/node_modules/**", "**/*.md" } }
    }
}
-- nil_ls is a nix lsp
lspconfig.nil_ls.setup { on_attach = attached, capabilities = capabilities }

lspconfig.sqls.setup {
    on_attach = function(client, bufnum)
        client.server_capabilities.execute_command = true
        attached(client, bufnum)
        require 'sqls'.setup {}
    end,
    cmd = { "sqls", "-config", string.format("%s/.sqls-config.yml", vim.fn.getcwd()) }
}

lspconfig.hls.setup {
    capabilities = capabilities,
    on_attach = attached,
    root_dir = lspconfig.util.root_pattern("hie.yaml", "stack.yaml", ".cabal", "cabal.project", "package.yaml"),
}
lspconfig.elixirls.setup { cmd = { "elixir-ls" }, on_attach = attached, capabilities = capabilities }
lspconfig.prismals.setup { on_attach = attached, capabilities = capabilities }
lspconfig.dockerls.setup { on_attach = attached, capabilities = capabilities }
lspconfig.kotlin_language_server.setup { on_attach = attached, capabilities = capabilities }
lspconfig.docker_compose_language_service.setup { on_attach = attached, capabilities = capabilities }
lspconfig.cssls.setup {
    on_attach = attached,
    capabilities = capabilities,
    settings = { css = { lint = { unknownAtRules = "ignore" } } }
}
lspconfig.eslint.setup { on_attach = attached, capabilities = capabilities }
lspconfig.html.setup { on_attach = attached, capabilities = capabilities }
lspconfig.bashls.setup { on_attach = attached, capabilities = capabilities }
lspconfig.pylsp.setup { on_attach = attached, capabilities = capabilities } -- for python
lspconfig.jsonls.setup {
    on_attach = attached,
    settings = {
        json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true }
        }
    },
    setup = {
        commands = {
            Format = {
                function()
                    vim.lsp.buf.range_formatting({}, { 0, 0 },
                        { vim.fn.line "$", 0 })
                end
            }
        }
    },
    capabilities = capabilities
}
lspconfig.gopls.setup({
    on_attach = function(clientgo, bufnrgo)
        attached(clientgo, bufnrgo)
        require("lsp-inlayhints").setup({
            inlay_hints = { type_hints = { prefix = "=> " } },
        })
        require("lsp-inlayhints").on_attach(clientgo, bufnrgo)
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("FixGoImports", { clear = true }),
            pattern = "*.go",
            callback = function()
                fix_imports()
            end,
        })
    end,
    settings = {
        gopls = {
            analyses = {
                assign = true,
                atomic = true,
                bools = true,
                composites = true,
                copylocks = true,
                deepequalerrors = true,
                embed = true,
                erroras = true,
                fieldalignment = true,
                httpresponse = true,
                ifaceassert = true,
                loopclosure = true,
                nilfunc = true,
                nilness = true,
                nonewvars = true,
                printf = true,
                shadow = true,
                shift = true,
                unusedparams = true,
                unusedvariable = true,
                unusedwrite = true,
                useany = true,
            },
            experimentalPostfixCompletions = true,
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true,
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
        },
    },
})

-- }}}
-- Completions {{{

local _, cmp = pcall(require, "cmp")

local _, ls = pcall(require, "luasnip")

local _, lspkind = pcall(require, "lspkind")
vim.keymap.set({ "i", "s" }, "<c-l>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-h>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

require("luasnip/loaders/from_vscode").lazy_load()
local border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format({
            mode = "symbol",       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
                vim_item.menu = ({
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                    nvim_lsp = "[LSP]",
                    rg = "[rg]",
                })[entry.source.name]
                return vim_item
            end,
        }),
    },
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ["<C-j>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-k>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping({
            i = function()
                if cmp.visible() then
                    cmp.abort()
                else
                    cmp.complete()
                end
            end,
            c = function()
                if cmp.visible() then
                    cmp.close()
                else
                    cmp.complete()
                end
            end,
        }),
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer",  keyword_length = 3 },
        { name = "rg",      keyword_length = 3 },
        { name = "nvim_lua" },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    window = {
        completion = {
            border = border,
            scrollbar = "┃",
        },
        documentation = {
            border = border,
            scrollbar = "┃",
        },
    },
    experimental = {
        ghost_text = false,
        native_menu = false,
    },
})
-- }}}
--- Scala {{{
-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "scala", "sbt" },
    callback = function()
        local metals_config = require("metals").bare_config()
        metals_config.init_options.statusBarProvider = "on"
        metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
        -- Debug settings if you're using nvim-dap
        metals_config.on_attach = function(client, bufnumber)
            attached(client, bufnumber)
            map('n', '<leader>cmc', '<cmd>lua require("metals").commands()<CR>', { desc = "Metals Commands" })
            require("metals").setup_dap()
        end
        metals_config.settings = {
            showImplicitArguments = true,
            showImplicitConversionsAndClasses = true,
            showInferredType = true,
            excludedPackages = {
                "akka.actor.typed.javadsl",
                "com.github.swagger.akka.javadsl"
            }
        }
        metals_config.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = {
                    prefix = '',
                }
            }
        )
        require("metals").initialize_or_attach(metals_config)
    end,
    group = nvim_metals_group,
})
--- }}}
--- GoLang {{{
local golang_group = vim.api.nvim_create_augroup("go.nvim", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "go" },
    callback = function()
        require("go").setup()
        local default_options = { silent = true }
        whichkey.register({
            c = {
                name = "Coding",
                a = { "<cmd>GoCodeAction<cr>", "Code action" },
                e = { "<cmd>GoIfErr<cr>", "Add if err" },
                h = {
                    name = "Helper",
                    a = { "<cmd>GoAddTag<cr>", "Add tags to struct" },
                    r = { "<cmd>GoRMTag<cr>", "Remove tags to struct" },
                    c = { "<cmd>GoCoverage<cr>", "Test coverage" },
                    g = { "<cmd>lua require('go.comment').gen()<cr>", "Generate comment" },
                    v = { "<cmd>GoVet<cr>", "Go vet" },
                    t = { "<cmd>GoModTidy<cr>", "Go mod tidy" },
                    i = { "<cmd>GoModInit<cr>", "Go mod init" },
                },
                l = { "<cmd>GoLint<cr>", "Run linter" },
                o = { "<cmd>GoPkgOutline<cr>", "Outline" },
                r = { "<cmd>GoRun<cr>", "Run" },
                s = { "<cmd>GoFillStruct<cr>", "Autofill struct" },
                t = {
                    name = "Tests",
                    r = { "<cmd>GoTest<cr>", "Run tests" },
                    a = { "<cmd>GoAlt!<cr>", "Open alt file" },
                    s = { "<cmd>GoAltS!<cr>", "Open alt file in split" },
                    v = { "<cmd>GoAltV!<cr>", "Open alt file in vertical split" },
                    u = { "<cmd>GoTestFunc<cr>", "Run test for current func" },
                    f = { "<cmd>GoTestFile<cr>", "Run test for current file" },
                    g = { "<cmd>GoAddAllTest<cr>", "Generate tests for current file" },
                },
                x = {
                    name = "Code Lens",
                    l = { "<cmd>GoCodeLenAct<cr>", "Toggle Lens" },
                    a = { "<cmd>GoCodeAction<cr>", "Code Action" },
                },
            },
        }, { prefix = "<leader>", mode = "n", default_options })
        whichkey.register({
            c = {
                -- name = "Coding",
                j = { "<cmd>'<,'>GoJson2Struct<cr>", "Json to struct" },
            },
        }, { prefix = "<leader>", mode = "v", default_options })
    end,
    group = golang_group,
})
--- }}}
--- DAP {{{

local status_dap, dap = pcall(require, "dap")
local status_ui, dapui = pcall(require, "dapui")
if not status_dap or not status_ui then
    return
end
local dap_breakpoint = {
    breakpoint = {
        text = "",
        texthl = "LspDiagnosticsSignError",
        linehl = "",
        numhl = "",
    },
    rejected = {
        text = "",
        texthl = "LspDiagnosticsSignHint",
        linehl = "",
        numhl = "",
    },
    stopped = {
        text = "",
        texthl = "LspDiagnosticsSignInformation",
        linehl = "DiagnosticUnderlineInfo",
        numhl = "LspDiagnosticsSignInformation",
    },
}

vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)
local status_dap_virtual_text, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if status_dap_virtual_text then
    dap_virtual_text.setup({
        commented = true,
    })
end

dapui.setup {
    expand_lines = true,
    icons = { expanded = "", collapsed = "", circular = "" },
    mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
    },
    layouts = {
        {
            elements = {
                { id = "scopes",      size = 0.33 },
                { id = "breakpoints", size = 0.17 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 0.33,
            position = "right",
        },
        {
            elements = {
                { id = "repl",    size = 0.45 },
                { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
        },
    },
    floating = {
        max_height = 0.9,
        max_width = 0.5,             -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
            close = { "q", "<Esc>" },
        },
    },
} -- use default
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dap.configurations.scala = {
    {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
            runType = "runOrTestFile",
            --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
        },
    },
    {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
            runType = "testTarget",
        },
    },
}
--- }}}
--- Haskell {{{

local nvim_hask_group = vim.api.nvim_create_augroup("nvim-hask", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "hs" },
    callback = function()
        local ht = require('haskell-tools')
        local def_opts = { noremap = true, silent = true, }
        ht.start_or_attach {
            hls = {
                on_attach = function(client, bufnrhl)
                    attached(client, bufnrhl)
                    local hlopts = vim.tbl_extend('keep', def_opts, { buffer = bufnrhl, })
                    vim.keymap.set('n', '<space>ca', vim.lsp.codelens.run, hlopts)
                    vim.keymap.set('n', '<space>cs', ht.hoogle.hoogle_signature, hlopts)
                end,
            },
        }
    end,
    group = nvim_hask_group,
})
---}}}
