{
  symlinkJoin,
  neovim-unwrapped,
  makeWrapper,
  runCommandLocal,
  vimPlugins,
  lib,
  pkgs,
}:
let
  packageName = "nvim";

  runtimeDeps = with pkgs; [
    stdenv.cc.cc
    luaPackages.lua-utils-nvim
    luaPackages.pathlib-nvim
    ripgrep
    fd
    universal-ctags
    nix-doc
    eslint
    taskwarrior3
    zoxide
    gh
    manix
    nixd
    nixfmt
    lua-language-server
    stylua
    cargo
    rustc
    rust-analyzer
    rustfmt
    harper
    clang-tools
    bash-language-server
    pyright
    gopls
    phpactor
    # phpPackages.psalm
    yaml-language-server
    vscode-langservers-extracted
    tailwindcss-language-server
    marksman
    python313Packages.pylatexenc
    chez
    scheme-manpages
    akkuPackages.akku
    akkuPackages.scheme-langserver
    texlab
    texliveFull
    texlivePackages.latexmk
    zathura
    lilypond
    python312Packages.python-ly
    mpv
    ffmpeg
    timidity
    fluidsynth
    soundfont-fluid
    soundfont-ydp-grand
    git
    (pkgs.aspellWithDicts (
      ds: with ds; [
        en
        en-computers
      ]
    ))
  ];

  startPlugins =
    with vimPlugins;
    [
      lz-n
      nvim-treesitter.withAllGrammars
      alpha-nvim
      which-key-nvim
      vim-tmux-navigator
      tmux-nvim
      plenary-nvim

      neorg
      neorg-telescope
      neorg-interim-ls
      image-nvim

      text-case-nvim
    ]
    ++ [ initLuaLib ];

  optPlugins = with vimPlugins; [
    telescope-nvim
    #persistence-nvim
    #wilder-nvim
    #coc-vimtex
    #trouble-nvim
    yanky-nvim
    indent-blankline-nvim
    undotree
    vim-startuptime
    fidget-nvim
    oil-nvim
    comment-nvim
    lualine-nvim
    nvim-web-devicons
    nvim-colorizer-lua
    vim-illuminate
    marks-nvim
    todo-comments-nvim
    nvim-surround
    diffview-nvim
    eyeliner-nvim
    nvim-lint
    conform-nvim
    bufferline-nvim
    wrapping-nvim
    #null-ls-nvim
    taskwarrior3
    taskwiki
    nvim-lspconfig
    lazydev-nvim
    cmp-nvim-lsp
    telescope-nvim
    telescope-fzf-native-nvim # zf fzy
    telescope-undo-nvim
    telescope-symbols-nvim
    telescope-emoji-nvim
    telescope-github-nvim
    telescope-git-conflicts-nvim
    telescope-coc-nvim
    telescope-dap-nvim
    telescope-undo-nvim
    telescope-zoxide
    plenary-nvim
    popup-nvim
    project-nvim
    telescope-media-files-nvim
    telescope-manix

    blink-cmp
    blink-cmp-dictionary
    blink-cmp-words
    blink-cmp-spell
    blink-cmp-latex
    blink-cmp-git
    blink-cmp-avante
    blink-cmp-yanky
    blink-emoji-nvim
    blink-cmp-nixpkgs-maintainers

    nvim-cmp
    luasnip
    friendly-snippets
    lspkind-nvim
    cmp-buffer
    cmp-cmdline
    cmp-cmdline-history
    cmp-nvim-lsp
    cmp-nvim-lsp-signature-help
    cmp-nvim-lua
    cmp-path
    cmp_luasnip
    cmp-dictionary
    cmp-zsh
    cmp-vimwiki-tags
    cmp-latex-symbols
    cmp-ai
    cmp-dap
    cmp-git
    cmp-calc
    cmp-emoji
    cmp-ctags
    luasnip-latex-snippets-nvim
    nvim-treesitter-textobjects
    nvim-ts-autotag # html
    nvim-ts-context-commentstring
    comment-nvim
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-dap-python
    nvim-dap-go
    gitsigns-nvim
    ChatGPT-nvim
    avante-nvim
    codecompanion-nvim
    vimwiki
    markdown-preview-nvim
    #treesitter
    nvim-treesitter-parsers.markdown
    nvim-treesitter-parsers.markdown_inline
    render-markdown-nvim
    rustaceanvim
    vimtex
    nvim-lilypond-suite
  ];

  foldPlugins = builtins.foldl' (
    acc: next: acc ++ [ next ] ++ (foldPlugins (next.dependencies or [ ]))
  ) [ ];

  #luaLib
  luaEnv = neovim-unwrapped.lua.withPackages (luaPackages: [
    luaPackages.lua-utils-nvim
    luaPackages.pathlib-nvim
  ]);
  inherit (neovim-unwrapped.lua.pkgs.luaLib) genLuaPathAbsStr genLuaCPathAbsStr;
  initLuaLib = (
    pkgs.runCommandLocal "init-plugin" { } ''
      mkdir -pv $out/plugin
      tee $out/plugin/init.lua <<EOF
      package.path = "${genLuaPathAbsStr luaEnv};" .. package.path
      package.cpath = "${genLuaCPathAbsStr luaEnv};" .. package.cpath
      EOF
    ''
  );

  startPluginsWithDeps = lib.unique (foldPlugins startPlugins);
  optPluginsWithDeps = lib.unique (foldPlugins optPlugins);

  packpath = runCommandLocal "packpath" { } ''
    mkdir -p $out/pack/${packageName}/{start,opt}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/start/${lib.getName plugin}"
    ) startPluginsWithDeps}

    ${lib.concatMapStringsSep "\n" (
      plugin: "ln -vsfT ${plugin} $out/pack/${packageName}/opt/${lib.getName plugin}"
    ) optPluginsWithDeps}

    ln -vsfT ${./config} $out/pack/${packageName}/start/config
  '';
in

symlinkJoin {
  name = "nvim";
  paths = [ neovim-unwrapped ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set LILYDICTPATH ${pkgs.vimPlugins.nvim-lilypond-suite}/lilywords \
      --add-flags '-u' \
      --add-flags 'NORC' \
      --add-flags '--cmd' \
      --add-flags "'set packpath^=${packpath} | set runtimepath^=${packpath}'" \
      --set-default NVIM_APPNAME nvim
  '';
  passthru = {
    inherit packpath;
  };
}
