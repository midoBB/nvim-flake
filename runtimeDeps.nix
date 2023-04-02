{ pkgs }:
{
  deps1 = with pkgs; [
    git
    vale # linter for prose
    proselint # ditto
    luaformatter # ditto for lua
    prisma-engines # ditto for schema.prisma files
    nil # nix lsp -- better than rnix?
    alejandra # nix formatter alternative
    statix # linter for nix
    shellcheck
    lua-language-server
    nodePackages.svelte-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"
    black
    python310Packages.python-lsp-server # todo: is specifying 310 an issue?
    nodePackages.bash-language-server
    shellcheck
    nodePackages.dockerfile-language-server-nodejs
    hadolint
    gopls
    reftools
    impl
    gotools
    delve
    golines
    golangci-lint
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier_d_slim
    nodePackages.eslint_d
    nodePackages.typescript-language-server
    nodePackages.markdownlint-cli
    deadnix
    sqls
    jq
# YAML
    nodePackages.yaml-language-server
    yamllint
  ];
  deps2 = with pkgs; [ lazygit ];
}
