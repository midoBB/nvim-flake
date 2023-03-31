{ pkgs }:
{
  deps1 = with pkgs; [
    git
    nodePackages.typescript-language-server
  ];
  deps2 = with pkgs; [ lazygit ];
}
