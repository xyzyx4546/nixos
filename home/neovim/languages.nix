{
  lib,
  config,
  osConfig,
  hostName,
  ...
}: {
  programs.nvf.settings.vim = {
    languages = {
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;
      enableDAP = true;

      bash.enable = true;
      clang.enable = true;
      cmake.enable = true;
      css.enable = true;
      docker.enable = true;
      html.enable = true;
      json.enable = true;
      lua = {
        enable = true;
        extraDiagnostics.enable = false;
        format.enable = false;
      };
      make.enable = true;
      markdown = {
        enable = true;
        format.type = ["mdformat"];
        extraDiagnostics.enable = false;
        extensions.render-markdown-nvim.enable = true;
      };
      nix = {
        enable = true;
        lsp.servers = ["nixd"];
        format.type = ["alejandra"];
      };
      python = {
        enable = true;
        extraDiagnostics.enable = false;
      };
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      sql.enable = true;
      tex.enable = true;
      toml.enable = true;
      typescript.enable = true;
      xml.enable = true;
      yaml.enable = true;
    };

    lsp = {
      enable = true;
      inlayHints.enable = true;
      mappings = {
        renameSymbol = "<leader>lr";
        toggleFormatOnSave = null;
      };

      servers = {
        basedpyright.settings.basedpyright.analysis.typeCheckingMode = "basic";

        nixd = {
          root_markers = ["devenv.nix" "devenv.yaml" "flake.nix" ".git"];

          on_init = lib.generators.mkLuaInline ''
            function(client)
              local out = vim.system({ "devenv", "lsp", "--print-config" }, { cwd = client.root_dir, text = true }):wait().stdout
              local ok, cfg = pcall(vim.json.decode, out)
              if ok and cfg and cfg.nixd then
                client.settings = { nixd = cfg.nixd }
                client:notify("workspace/didChangeConfiguration", { settings = client.settings })
              end
            end
          '';

          settings.nixd.options = let
            nixos = "(builtins.getFlake \"${osConfig.programs.nh.flake}\").nixosConfigurations.${hostName}.options";
          in {
            nixos.expr = nixos;
            home_manager.expr = ''
              let u = ${nixos}.home-manager.users;
              in (u.type.substSubModules (u.type.getSubModules ++ map (d: d."${config.home.username}" or {}) u.definitions)).getSubOptions []
            '';
          };
        };

        rust-analyzer.settings.rust-analyzer.check.command = "clippy";
      };
    };

    formatter.conform-nvim.setupOpts.formatters."tex-fmt".prepend_args = ["--nowrap"];

    luaConfigRC.virtual_diagnostic =
      # lua
      ''
        vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
        vim.keymap.set('n', '<leader>tv', function()
          vim.diagnostic.config({
            virtual_lines = not vim.diagnostic.config().virtual_lines,
            virtual_text = not vim.diagnostic.config().virtual_text,
          })
        end, { desc = 'Toggle diagnostic virtual lines and virtual text' })
      '';

    debugger.nvim-dap.ui.enable = true;

    luaConfigRC.prefer_env_lsps =
      lib.mkAfter
      # lua
      ''
        do
          local function resolve(bin)
            local name = vim.fs.basename(bin)
            return vim.fn.exepath(name) ~= "" and name or bin
          end

          for _, name in ipairs(${lib.generators.toLua {} (builtins.attrNames config.programs.nvf.settings.vim.lsp.servers)}) do
            local cfg = vim.lsp.config[name]
            if cfg and type(cfg.cmd) == "table" and type(cfg.cmd[1]) == "string" and cfg.cmd[1]:match("^/nix/store/") then
              cfg.cmd[1] = resolve(cfg.cmd[1])
              vim.lsp.config(name, { cmd = cfg.cmd })
            end
          end

          for _, fmt in pairs(require("conform").formatters) do
            if type(fmt) == "table" and type(fmt.command) == "string" and fmt.command:match("^/nix/store/") then
              fmt.command = resolve(fmt.command)
            end
          end
        end
      '';
  };
}
