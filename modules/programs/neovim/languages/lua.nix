{
  programs.nvf.settings.vim = {
    lsp.servers.lua-language-server.settings.Lua.diagnostics.globals = ["vim"];

    languages.lua = {
      enable = true;
      extraDiagnostics.enable = false;
      format.enable = false;
    };
  };
}
