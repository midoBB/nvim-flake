-- vim:fileencoding=utf-8:ft=conf:foldmethod=marker
-- Opts {{{
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
    spell = true,
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
        precedes = "<",
        space = "."
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
    sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions",
    inccommand = "split"
}

for name, value in pairs(options) do
    vim.opt[name] = value
end

vim.opt.shortmess:append("sI")
vim.opt.wildignore:append({"*.o", "*~", "*.pyc", "*pycache*", "*.lock"})

-- -- Disable builtin plugins
local disabled_built_ins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
                            "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
                            "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
                            "synmenu", "optwin", "compiler", "bugreport", "ftplugin"}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end
-- }}}
-- Colorscheme / Visuals setup {{{
pcall(vim.cmd, "colorscheme " .. "oxocarbon")
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
        }
    },
    presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false
    },
    routes = {{
        filter = {
            event = "msg_show",
            kind = "search_count"
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
    }}
})
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
        path_display = {"smart"},
        file_ignore_patterns = {".git/", "node_modules"},

        mappings = {
            i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous
            }
        }
    },

    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = false, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        },
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        }
    }

})
require('telescope').load_extension("fzf")
require('telescope').load_extension('fzy_native')
-- require('telescope').load_extension("yank_history") TODO: Add me back
-- require('telescope').load_extension("aerial") TODO: Add me back
-- }}}
-- Indentation {{{
local hl_list = {}
for i, color in pairs({'#E06C75', '#E5C07B', '#98C379', '#56B6C2', '#61AFEF', '#C678DD'}) do
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
-- Find me a place {{{
require("lspsaga").setup({
    ui = {
        winblend = 10,
        border = "rounded"
    },
    rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = false
    },
    symbol_in_winbar = {
        enable = false
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
        prefix = "●" -- Could be '■', '▎', 'x'
    },
    severity_sort = true,
    float = {
        source = "always", -- Or "if_many"
        border = "rounded",
        style = "minimal"
    }
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
