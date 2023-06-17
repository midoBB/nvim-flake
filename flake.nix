{
  description = "My own Neovim flake";
  inputs = {
    oxocarbon = {
      url = "github:nyoom-engineering/oxocarbon.nvim";
      flake = false;
    };
    align = {
      url = "github:Vonr/align.nvim";
      flake = false;
    };
    textcase = {
      url = "github:johmsalas/text-case.nvim";
      flake = false;
    };
    barbacue-nvim = {
      url = "github:utilyre/barbecue.nvim?rev=ec237dfcab297a973f4f7146d4527b1f6aae8d74";
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
    windowsep = {
      url = "github:nvim-zh/colorful-winsep.nvim";
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
    virtual-types = {
      url = "github:jubnzv/virtual-types.nvim";
      flake = false;
    };
    lsplens = {
      url = "github:VidocqH/lsp-lens.nvim";
      flake = false;
    };
    resession = {
      url = "github:stevearc/resession.nvim";
      flake = false;
    };
  };
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
    oxocarbon,
    barbacue-nvim,
    virtual-types,
    lsplens,
    resession,
    windowsep,
    textcase,
    splitjoin,
    hlargs,
    yanky,
    cutlass,
    search-replace,
    neovim-session-manager,
    tabout,
    reticle,
    bufferline-cycle-windowless,
    incline,
    persistent-breakpoints,
    typescript-nvim,
    align,
  }: let
    missingVimPluginsInNixpkgs = pkgs: {
      oxocarbon = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "oxocarbon";
        src = oxocarbon;
      };
      align = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "align.nvim";
        src = align;
      };
      barbecue = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "barbacue";
        src = barbacue-nvim;
      };
      virtual-types = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "virtualtypes";
        src = virtual-types;
      };
      lsplens = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "lsplens";
        src = lsplens;
      };
      resession = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "resession";
        src = resession;
      };

      window = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "windowsep";
        src = windowsep;
      };

      textcase = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "taxt-case.nvim";
        src = textcase;
      };

      hlargs = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "hlargs.nvim";
        src = hlargs;
      };

      yanky = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "yanky.nvim";
        src = yanky;
      };

      cutlass = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "cutlass.nvim";
        src = cutlass;
      };

      search-replace = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "search-replace.nvim";
        src = search-replace;
      };

      neovim-session-manager = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "neovim-session-manager";
        src = neovim-session-manager;
      };

      tabout = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "tabout.nvim";
        src = tabout;
      };

      reticle = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "reticle.nvim";
        src = reticle;
      };

      bufferline-cycle-windowless = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "bufferline-cycle-windowless.nvim";
        src = bufferline-cycle-windowless;
      };

      incline = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "incline.nvim";
        src = incline;
      };

      persistent-breakpoints = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "persistent-breakpoints.nvim";
        src = persistent-breakpoints;
      };

      typescript-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = "typescript.nvim";
        src = typescript-nvim;
      };
    };
    vim-plugins-overlay = _final: prev: {
      vimPlugins = prev.vimPlugins // (missingVimPluginsInNixpkgs prev.pkgs);
    };
    overlayFlakeInputs = prev: final: {
      inherit (nixpkgs.packages.neovim.x86_64-linux) neovim;
    };

    overlayMyNeovim = prev: final: {
      myNeovim = import ./packages/myNeovim.nix {pkgs = final;};
    };

    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = [vim-plugins-overlay overlayFlakeInputs overlayMyNeovim];
    };
  in {
    packages.x86_64-linux.default = pkgs.myNeovim;
    apps.x86_64-linux.default = {
      type = "app";
      program = "${pkgs.myNeovim}/bin/nvim";
    };
    devShell.x86_64-linux =
      pkgs.mkShell {buildInputs = [self.packages.x86_64-linux.default pkgs.myNeovim];};
  };
}
