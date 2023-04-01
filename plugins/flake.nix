{
  inputs = {
    oxocarbon = {
      url = "github:nyoom-engineering/oxocarbon.nvim";
      flake = false;
    };

    nvim-lspsaga = {
      url = "github:glepnir/lspsaga.nvim";
      flake = false;
    };

    nvim-sqls = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };

    splitjoin = {
      url = "github:bennypowers/splitjoin.nvim";
      flake = false;
    };

    hlargs = {
      url = "github:m-demare/hlargs.nvim";
      flake = false;
    };

    yanky = {
      url = "github:gbprod/yanky.nvim";
      flake = false;
    };

    cutlass = {
      url = "github:gbprod/cutlass.nvim";
      flake = false;
    };

    search-replace = {
      url = "github:roobert/search-replace.nvim";
      flake = false;
    };

    neovim-session-manager = {
      url = "github:Shatur/neovim-session-manager";
      flake = false;
    };

    tabout = {
      url = "github:abecodes/tabout.nvim";
      flake = false;
    };

    reticle = {
      url = "github:tummetott/reticle.nvim";
      flake = false;
    };

    bufferline-cycle-windowless = {
      url = "github:roobert/bufferline-cycle-windowless.nvim";
      flake = false;
    };

    incline = {
      url = "github:b0o/incline.nvim/71a03756a5f750c79a2889a80fcd8bbff7083690";
      flake = false;
    };

    persistent-breakpoints = {
      url = "github:Weissle/persistent-breakpoints.nvim";
      flake = false;
    };

    typescript-nvim = {
      url = "github:jose-elias-alvarez/typescript.nvim";
      flake = false;
    };

  };
  outputs = inputs:
    let
      missingVimPluginsInNixpkgs = pkgs: {
        oxocarbon = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "oxocarbon";
          src = inputs.oxocarbon;
        };

        nvim-lspsaga = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "lspsaga";
          src = inputs.nvim-lspsaga;
        };

        nvim-sqls = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "sqls";
          src = inputs.nvim-sqls;
        };

        splitjoin = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "splitjoin.nvim";
          src = inputs.splitjoin;
        };

        hlargs = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "hlargs.nvim";
          src = inputs.hlargs;
        };

        yanky = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "yanky.nvim";
          src = inputs.yanky;
        };

        cutlass = pkgs.vimUtils.buildVimPluginFrom2Nix{
          name = "cutlass.nvim";
          src = inputs.cutlass;
        };

        search-replace = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "search-replace.nvim";
          src = inputs.search-replace;
        };

        neovim-session-manager = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "neovim-session-manager";
          src = inputs.neovim-session-manager;
        };

        tabout = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "tabout.nvim";
          src = inputs.tabout;
        };

        reticle = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "reticle.nvim";
          src = inputs.reticle;
        };

        bufferline-cycle-windowless = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "bufferline-cycle-windowless.nvim";
          src = inputs.bufferline-cycle-windowless;
        };

        incline = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "incline.nvim";
        src = inputs.incline;
        };

        persistent-breakpoints = pkgs.vimUtils.buildVimPluginFrom2Nix {
          name = "persistent-breakpoints.nvim";
          src = inputs.persistent-breakpoints;
        };

        typescript-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
         name = "typescript.nvim";
        src = inputs.typescript-nvim;
        };

      };
    in {
      overlay = _final: prev: {
        vimPlugins = prev.vimPlugins // (missingVimPluginsInNixpkgs prev.pkgs);
      };
    };
}
