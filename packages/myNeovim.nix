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
  runtimeDeps = import ../runtimeDeps.nix {inherit pkgs;};
  neovimRuntimeDependencies = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies";
    paths = runtimeDeps.deps1;
  };
  neovimRuntimeDependencies2 = pkgs.symlinkJoin {
    name = "neovimRuntimeDependencies2";
    paths = runtimeDeps.deps2;
  };

  neovimaugmented = recursiveMerge [
    pkgs.neovim-unwrapped
    {buildInputs = neovimRuntimeDependencies;}
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
    runtimeInputs = [neovimRuntimeDependencies2 neovimRuntimeDependencies];
    text = ''
      ${myNeovimUnwrapped}/bin/nvim "$@"
    '';
  }
