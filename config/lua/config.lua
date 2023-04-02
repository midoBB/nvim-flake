--jjjjjjjjjjjjjjjj # vim:fileencoding=utf-8:ft=lua:foldmethod=marker
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
function map(mode, lhs, rhs, opts)
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
    sessionoptions = "blank,buffers,curdir,winsize,winpos,localoptions",
    inccommand = "split"
}

for name, value in pairs(options) do
    vim.opt[name] = value
end

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
        }
    },
    presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true
    },
  messages = {
    enabled = true, -- enables the Noice messages UI
    view = "mini", -- default view for messages
    view_error = "mini", -- view for errors
    view_warn = "mini", -- view for warnings
    view_history = "messages", -- view for :messages
    view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
  },
    routes = {{
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
    }}
})
require("dressing").setup({
    input = {
        relative = "editor"
    },
    select = {
        backend = {"telescope", "fzf", "builtin"}
    }
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
require('telescope').load_extension("aerial")
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
        disable = {"comment"}
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
    pattern = {"gitcommit", "gitrebase"},
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
    pattern = {"text", "markdown", "html", "xhtml", "javascript", "typescript"},
    command = "setlocal cc=0"
})

-- Set indentation to 2 spaces
vim.api.nvim_create_augroup("setIndent", {
    clear = true
})
vim.api.nvim_create_autocmd("Filetype", {
    group = "setIndent",
    pattern = {"xml", "html", "xhtml", "css", "scss", "javascript", "typescript", "yaml", "lua"},
    command = "setlocal shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_augroup("General", {
    clear = true
})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = "General",
    pattern = {"*.{,z,ba}sh", "*.pl", "*.py"},
    desc = "Make files executable",
    callback = function()
        vim.fn.system({"chmod", "+x", vim.fn.expand("%")})
    end
})

-- Return to last edit position when opening files

require("nvim-lastplace").setup({
    lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
    lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
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
    pattern = {"qf", "help", "man", "notify", "lspinfo", "spectre_panel", "startuptime"},
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
    exclude = {"ns", "nS"}
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
map("n", "<C-q>", "<cmd>AerialToggle!<CR>", {
    desc = "View document symbols"
})
vim.keymap.set("n", "<C-c>", function()
    ToggleQF("q")
end, {
    desc = "Toggle quickfix window"
})
map("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", {
    desc = "Search and Replace"
})
map("n", "gj", "<cmd>lua require('splitjoin').join()<cr>", {
    desc = "Join the object under cursor"
})
map("n", "g,", "<cmd>lua require('splitjoin').split()<cr>", {
    desc = "Split the object under cursor"
})
whichkey = require("which-key")
local conf = {
	window = {
		border = "single", -- none, single, double, shadow
		position = "bottom", -- bottom, top
	},
}

local opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local mappings = {
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["p"] = { '"+gp', "Paste from clipboard" },
	["y"] = { '"+y', "Copy to clipboard" },
	["w"] = { "<cmd>update!<CR>", "Save" },
	["<leader>q"] = { "<cmd>qa<CR>", "Quit" },
	["q"] = { "<cmd>BufDel<CR>", "Close the current buffer" },
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
	mode = "v", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
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
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

-- buffer scope handler
-- will override global handler if it is existed
ufo.setup({
    fold_virt_text_handler = handler,
    provider_selector = function(_, _, _)
        return {'treesitter', 'indent'}
    end
})
local bufnr = vim.api.nvim_get_current_buf()

ufo.setFoldVirtTextHandler(bufnr, handler)

-- }}}
-- Motion plugins {{{
require("tabout").setup({
    tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
    backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
    act_as_tab = true, -- shift content if tab out is not possible
    act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
    default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
    default_shift_tab = "<C-d>", -- reverse shift default action,
    enable_backwards = true, -- well ...
    completion = true, -- if the tabkey is used in a completion pum
    tabouts = {{
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
    }},
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
        offsets = {{
            filetype = "NvimTree",
            text = "",
            text_align = "left",
            padding = 1
        }},
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
        Add = "",
        Branch = "",
        Diff = "",
        Git = "",
        Ignore = "",
        Mod = "M",
        Mod_alt = "",
        Remove = "",
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

local _cache = {
    context = "",
    bufnr = -1
}
local function lspsaga_symbols()
    local exclude = {
        ["terminal"] = true,
        ["toggleterm"] = true,
        ["prompt"] = true,
        ["NvimTree"] = true,
        ["help"] = true
    }
    if vim.api.nvim_win_get_config(0).zindex or exclude[vim.bo.filetype] then
        return "" -- Excluded filetypes
    else
        local currbuf = vim.api.nvim_get_current_buf()
        local ok, lspsaga = pcall(require, "lspsaga.symbolwinbar")
        if ok and lspsaga:get_winbar() ~= nil then
            _cache.context = lspsaga:get_winbar()
            _cache.bufnr = currbuf
        elseif _cache.bufnr ~= currbuf then
            _cache.context = "" -- Reset [invalid] cache (usually from another buffer)
        end

        return _cache.context
    end
end

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

local function get_cwd()
    local cwd = vim.fn.getcwd()
    local home = os.getenv("HOME")
    if cwd:find(home, 1, true) == 1 then
        cwd = "~" .. cwd:sub(#home + 1)
    end
    return icons.ui.RootFolderOpened .. cwd
end

local mini_sections = {
    lualine_a = {"filetype"},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
}
local outline = {
    sections = mini_sections,
    filetypes = {"lspsagaoutline"}
}
local diffview = {
    sections = mini_sections,
    filetypes = {"DiffviewFiles"}
}

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
        lualine_a = {{"mode"}},
        lualine_b = {{"branch"}},
        lualine_c = {lspsaga_symbols},
        lualine_x = {{
            "diagnostics",
            sources = {"nvim_diagnostic"},
            symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warning,
                info = icons.diagnostics.Information
            }
        }, {get_cwd}},
        lualine_y = {{
            "filetype",
            colored = true,
            icon_only = true
        }, {"encoding"}, {
            "fileformat",
            icons_enabled = true,
            symbols = {
                unix = "LF",
                dos = "CRLF",
                mac = "CR"
            }
        }},
        lualine_z = {"progress", "location"}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"filename"},
        lualine_x = {"location"},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {"quickfix", "nvim-tree", "nvim-dap-ui", "toggleterm", "fugitive", outline, diffview}
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
        lualine_a = {nvim_tree_shift, "mode"}
    }
})

-- }}}
-- Trouble {{{
require("trouble").setup {
    mode = "workspace_diagnostics",
    fold_open = "",
    fold_closed = "",
    auto_jump = {"lsp_definitions"},
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
        table.insert(labels, {"| "})
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

        local buffer = {{get_git_diff(props)}, {
            filetype_icon,
            guifg = color
        }, {" "}, {
            filename,
            gui = modified
        }}

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
