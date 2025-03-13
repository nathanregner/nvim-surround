{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvim =
          (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
            plugins = with pkgs.vimPlugins; [
              (nvim-treesitter.withPlugins (
                plugins: with plugins; [
                  lua
                ]
              ))
              plenary-nvim
            ];
          }).overrideAttrs
            {
              dontStrip = true;
              dontFixup = true;
              postInstall = ''
                mv $out/bin/nvim $out/bin/nvim-test
              '';
            };
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            gnumake
            nvim
            stylua
          ];

          #     env.VIMRUNTIME = "${nvim}/share/nvim/runtime";
          # export LUA_PATH="./lua/?.lua;./lua/?/init.lua;$LUA_PATH"
          # nvim --headless -i NONE \
          #   --cmd "set rtp+=${vimPlugins.plenary-nvim}" \
          #   -c "PlenaryBustedDirectory tests/ {sequential = true}"

        };

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "nvim-ts-autotag";
          version = "0.0.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            nvim
          ];

          buildPhase = ''
            nvim-test --headless -c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }" |& tee $out
          '';

          dontInstall = true;
        };
      }
    );
}
