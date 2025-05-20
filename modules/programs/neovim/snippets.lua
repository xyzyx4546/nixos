local luasnip = require('luasnip')
local s = luasnip.snippet
local t = luasnip.text_node
local i = luasnip.insert_node

luasnip.add_snippets("nix", {
  s("devShell", {
    t({
      '{',
      '  inputs = {',
      '    nixpkgs.url = "github:nixos/nixpkgs/nixos-' }), i(1, 'version'), t({ '";',
      '  };',
      '',
      '  outputs = {nixpkgs, ...}: let',
      '    system = "x86_64-linux";',
      '    pkgs = import nixpkgs {',
      '      inherit system;',
      '    };',
      '  in {',
      '    devShells.${system}.default = pkgs.mkShell {',
      '      buildInputs = with pkgs; [',
      '        ' }), i(0), t({ '',
      '      ];',
      '    };',
      '  };',
      '}'
    }),
  }),
})
