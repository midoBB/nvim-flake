{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim = {
      url = "github:neovim/neovim/stable?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-plugins = { url = "path:./plugins"; };
  };
  outputs = { self, nixpkgs, neovim, vim-plugins }:
    let

      overlayFlakeInputs = prev: final: {
        neovim = neovim.packages.x86_64-linux.neovim;
      };

      overlayMyNeovim = prev: final: {
        myNeovim = import ./packages/myNeovim.nix { pkgs = final; };
      };

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ vim-plugins.overlay overlayFlakeInputs overlayMyNeovim ];
      };

    in {
      packages.x86_64-linux.default = pkgs.myNeovim;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${pkgs.myNeovim}/bin/nvim";
      };
    };
}
