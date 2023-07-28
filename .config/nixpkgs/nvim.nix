{ config, pkgs, ... }:

let
  pluginGit = owner: repo: ref: sha: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${repo}";
    version = ref;
    src = pkgs.fetchFromGitHub {
      owner = owner;
      repo = repo;
      rev = ref;
      sha256 = sha;
    };
  };

  nixpkgs_2023_02_06 = import
    (fetchTarball "https://github.com/nixos/nixpkgs/archive/2a595c9628608928c8fd9820d394c85f524a8f39.tar.gz") {};

  neovim8 = nixpkgs_2023_02_06.neovim;
  nvim-treesitter-with-plugins = nixpkgs_2023_02_06.vimPlugins.nvim-treesitter.withAllGrammars;

in
neovim8.override {
  vimAlias = true;
  configure = {
    packages.myPlugins = with pkgs.vimPlugins; {
     start = [
        (pluginGit "nvim-lualine" "lualine.nvim" "d8c392dd75778d6258da4e7c55522e94ac389732" "s4bIwha2ZWvF5jYuIfUBcT/JKK9gcMH0vms2pOO5uKs=")
        (pluginGit "Mofiqul" "dracula.nvim" "a0b129d7dea51b317fa8064f13b29f68004839c4" "snCRLw/QtKPDAkh1CXZfto2iCoyaQIx++kOEC0vy9GA=")
        # Metal syntax highlighting.
        (pluginGit "tklebanoff" "metal-vim" "6970494a5490a17033650849f0a1ad07506cef2e" "14i8q9ikp3v4q7mpid9ir1azfqfm7fbksc65cpp51424clnqcapl")
        # Add fuzzy searching (Ctrl-P to search file names, space-p to search content).
        fzf-vim
        # Maintain last location in files.
        vim-lastplace
        # Syntax highlighting for Nix files.
        vim-nix
        # Colour scheme.
        # Use :TSHighlightCapturesUnderCursor to see the syntax under cursor.
        (pluginGit "nvim-treesitter" "playground" "c481c660fa903a0e295902b1765ecfbd6e76a556" "KyLR31XfYi3aANvXBGYCAsmYEr+H9hUr8j82abPQYDQ=")
        # Tressiter syntax highlighting.
        nvim-treesitter-with-plugins
        # Code coverage
        (pluginGit "nvim-lua" "plenary.nvim" "v0.1.2" "7EsquOLB7gfN2itfGFJZYKwEXBmP0xMKEOdyyjOweHg=")
        (pluginGit "andythigpen" "nvim-coverage" "fd44fde75468ddc8d72c7a64812c6d88826a3301" "Sve4ljcXR68YIoBNW5arwa5gQCUmA6PyXxs076qKAmE=")
        # Grep plugin to improve grep UX.
        (pluginGit "dkprice" "vim-easygrep" "d0c36a77cc63c22648e792796b1815b44164653a" "0y2p5mz0d5fhg6n68lhfhl8p4mlwkb82q337c22djs4w5zyzggbc")
        # Templ highlighting.
        (pluginGit "Joe-Davidson1802" "templ.vim" "2d1ca014c360a46aade54fc9b94f065f1deb501a" "1bc3p0i3jsv7cbhrsxffnmf9j3zxzg6gz694bzb5d3jir2fysn4h")
        # Add function signatures to autocomplete.
        (pluginGit "ray-x" "lsp_signature.nvim" "e65a63858771db3f086c8d904ff5f80705fd962b" "17qxn2ldvh1gas3i55vigqsz4mm7sxfl721v7lix9xs9bqgm73n1")
        # Configure autocomplete.
        (pluginGit "hrsh7th" "nvim-cmp" "983453e32cb35533a119725883c04436d16c0120" "0649n476jd6dqd79fmywmigz19sb0s344ablwr25gr23fp46hzaz")
        # Configure autocomplete.
        (pluginGit "neovim" "nvim-lspconfig" "d3c82d2f9a6fd91ec1ffee645664d2cc57e706d9" "wDt3Fs6+hHAr4ToACR7BZRtm5FeDnGZtSsdjTxrsWE4=")
        # Snippets manager.
        (pluginGit "L3MON4D3" "LuaSnip" "e687d78fc95a7c04b0762d29cf36c789a6d94eda" "11a9b744cgr3w2nvnpq1bjblqp36klwda33r2xyhcvhzdcz0h53v")
        # Add snippets to the autocomplete.
        (pluginGit "saadparwaiz1" "cmp_luasnip" "a9de941bcbda508d0a45d28ae366bb3f08db2e36" "0mh7gimav9p6cgv4j43l034dknz8szsnmrz49b2ra04yk9ihk1zj")
        # Show diagnostic errors inline.
        (pluginGit "folke" "trouble.nvim" "929315ea5f146f1ce0e784c76c943ece6f36d786" "07nyhg5mmy1fhf6v4480wb8gq3dh7g9fz9l5ksv4v94sdp5pgzvz")
        # Go debugger.
        (pluginGit "sebdah" "vim-delve" "5c8809d9c080fd00cc82b4c31900d1bc13733571" "01nlzfwfmpvp0q09h1k1j5z82i925hrl9cg9n6gbmcdqsvdrzy55")
        # Replacement for netrw.
        (pluginGit "nvim-tree" "nvim-web-devicons" "3b1b794bc17b7ac3df3ae471f1c18f18d1a0f958" "hxujmUwNtDAXd6JCxBpvPpOzEENQSOYepS7fwmbZufs=")
        (pluginGit "nvim-tree" "nvim-tree.lua" "1837751efb5fcfc584cb0ee900f09ff911cd6c0b" "emoQbOwwZOCV4F4/vSgcfMmnJFXvxgEAxqCwZyY1zpU=")
        # \c to toggle commenting out a line.
        nerdcommenter #preservim/nerdcommenter
        # Work out tabs vs spaces etc. automatically.
        vim-sleuth #tpope/vim-sleuth
        # Change surrounding characters, e.g. cs"' to change from double to single quotes.
        vim-surround #tpope/vim-surround
        (pluginGit "klen" "nvim-test" "4e30d0772a43bd67ff299cfe201964c5bd799d73" "sha256-iUkBnJxvK71xSqbH8JLm7gwvpiNxfWlAd2+3frNEXXQ=")
        vim-visual-multi #mg979/vim-visual-multi
        (pluginGit "hrsh7th" "cmp-nvim-lsp" "59224771f91b86d1de12570b4070fe4ad7cd1eeb" "Mqkp8IH/laUx0cK7S0BjusTT+OtOOJOamZM4+93RHdU=")
        targets-vim # https://github.com/wellle/targets.vim
      ];
      opt = [ ];
    };
    customRC = "lua require('init')";
  };
}