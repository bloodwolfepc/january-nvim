{ pkgs, ... }:
{
  install = {
    runtimeDeps = {
      always = with pkgs; [
        lilypond
        zathura
        mpv
        ffmpeg
        timidity
        fluidsynth
        soundfont-fluid
        soundfont-ydp-grand
      ];
    };
    optPlugins = {
      always = with pkgs.vimPlugins; [
        nvim-lilypond-suite
      ];
    };
  };
}
