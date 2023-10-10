{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    packages =
      builtins.mapAttrs (_system: pkgs: let
        pkg = pkgs.mkYarnPackage {
          src = ./.;
        };
      in {
        default = pkg;
        mjml-worker = pkg;
      })
      nixpkgs.legacyPackages;

    checks =
      builtins.mapAttrs (system: pkgs: {
        default = pkgs.runCommand "check-mjml-worker" {} ''
          if ${self.packages.${system}.mjml-worker}/bin/mjml-worker <<<"qed"; then
            echo "Expected mjml-worker to fail on invalid JSON" >&2
            exit 1
          fi

          ${self.packages.${system}.mjml-worker}/bin/mjml-worker <<<'{"ref": "abc", "mjml": "Hello, World!"}' >$out
        '';
      })
      nixpkgs.legacyPackages;
  };
}
