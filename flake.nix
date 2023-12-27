{
  description = "Override hook example";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    out = system: let
      pkgs = nixpkgs.legacyPackages."${system}";
      empty_hook = pkgs.runCommand "empty-hook" {} "mkdir -p $out";
      overlay_1 = final: prev: {
        sphinxHook = empty_hook;
        pythonPackages = prev.pythonPackages // {sphinxHook = empty_hook;};
        python3Packages = prev.python3Packages // {sphinxHook = empty_hook;};
        python38Packages = prev.python38Packages // {sphinxHook = empty_hook;};
      };
      nixpkgs_2 = pkgs.extend overlay_1;
    in
      nixpkgs_2.python38Packages.wrapt;
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems out;
    defaultPackage = self.packages;
  };
}
