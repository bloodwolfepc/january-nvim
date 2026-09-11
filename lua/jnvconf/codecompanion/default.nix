{ pkgs, ... }:
{
  install = {
    optPlugins = {
      always = with pkgs.vimPlugins; [
        codecompanion-nvim
        codecompanion-history-nvim
        codecompanion-spinner-nvim
        vectorcode-nvim
        mcphub-nvim
      ];
    };
    runtimeDeps = {
      always = with pkgs; [
        vectorcode
        github-mcp-server
      ];
    };
  };
}
