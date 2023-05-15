{pkgs}: let
  recursiveMerge = attrList: let
    f = attrPath:
      builtins.zipAttrsWith (n: values:
        if pkgs.lib.tail values == []
        then pkgs.lib.head values
        else if pkgs.lib.all pkgs.lib.isList values
        then pkgs.lib.unique (pkgs.lib.concatLists values)
        else if pkgs.lib.all pkgs.lib.isAttrs values
        then f (attrPath ++ [n]) values
        else pkgs.lib.last values);
  in
    f [] attrList;
  customRC = import ../config {inherit pkgs;};
  plugins = import ../pluginsList.nix {inherit pkgs;};

  neovimaugmented = recursiveMerge [
    pkgs.neovim-unwrapped
  ];
  myNeovimUnwrapped = pkgs.wrapNeovim neovimaugmented {
    configure = {
      inherit customRC;
      packages.all.start = plugins;
    };
  };
in
  pkgs.writeShellApplication {
    name = "nvim";
    text = ''
      ${myNeovimUnwrapped}/bin/nvim "$@"
    '';
  }
