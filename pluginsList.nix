{pkgs}:
with pkgs.vimPlugins; [
  impatient-nvim
  # General Deps
  nui-nvim
  plenary-nvim
  popup-nvim
  dressing-nvim
  promise-async
  nvim-notify
  noice-nvim
  # Fuzzy Finder
  telescope-nvim # da best popup fuzzy finder
  telescope-fzy-native-nvim # with fzy gives better results
  telescope-fzf-native-nvim
  # File Tree
  nvim-tree-lua
  #Bufferline
  scope-nvim
  bufferline-cycle-windowless
  bufferline-nvim
  nvim-bufdel
  bufdelete-nvim
  incline
  # Appearance
  oxocarbon
  bufferline-nvim
  indent-blankline-nvim
  lualine-nvim
  nvim-colorizer-lua
  nvim-web-devicons
  nvim-bqf
  smart-splits-nvim
  reticle
  which-key-nvim
  window
  trouble-nvim
  todo-comments-nvim
  undotree
  zen-mode-nvim
  # DAP
  nvim-dap
  nvim-dap-python
  nvim-dap-ui
  nvim-dap-virtual-text
  # Git
  gitsigns-nvim
  neogit
  diffview-nvim
  #Sessions
  vim-sleuth
  vim-rooter
  neovim-session-manager
  #Text maniupulation
  nvim-surround
  comment-nvim
  leap-nvim
  flit-nvim
  align
  textcase
  tabout # Tab out of the parantheses and quotes
  vim-repeat
  # Progrmming: Treesitter
  nvim-treesitter.withAllGrammars
  nvim-treesitter-textobjects
  nvim-ts-context-commentstring
  nvim-treesitter-context
  nvim-ts-rainbow2
  nvim-ts-autotag
  hlargs
  nvim_context_vt
  nvim-autopairs
  #Code folding
  nvim-ufo
  #Misc
  vim-visual-multi # As the name suggests multi cursor support in vim
  vim-illuminate # Highlight the word under the cursor
  harpoon # Quickly change between most used files
  align
  #Registers (Copy and Paste)
  yanky
  cutlass
  #Search
  nvim-hlslens
  vim-cool
  search-replace
  nvim-lastplace
  # Programming: LSP
  fidget-nvim
  lsp_signature-nvim
  lspkind-nvim
  null-ls-nvim
  nvim-lspconfig
  lsp-format-nvim
  nvim-navic
  glance-nvim
  nvim-lightbulb
  nvim-code-action-menu
  virtual-types
  lsplens
  aerial-nvim
  barbecue
  inc-rename-nvim
  # Programming : Language support
  #SQL
  #Typescript
  typescript-nvim
  SchemaStore-nvim # json schemas
  #Golang
  nvim-dap-go
  go-nvim
  # Programming: Database support
  vim-dadbod
  vim-dadbod-ui
  # Programming : Scala
  nvim-metals
  # Programming : Haskell
  haskell-tools-nvim
  # Programming: Autocompletion setup
  nvim-cmp
  cmp-buffer
  cmp-calc
  cmp-nvim-lsp
  cmp-nvim-lua
  cmp-path
  cmp-rg
  cmp-treesitter
  cmp_luasnip
  luasnip
  friendly-snippets
]
