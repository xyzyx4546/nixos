{
  programs.nvf.settings.vim.keymaps = [
    {
      mode = ["n" "v"];
      key = "j";
      action = "gj";
      silent = true;
    }
    {
      mode = ["n" "v"];
      key = "k";
      action = "gk";
      silent = true;
    }
    {
      mode = "";
      key = "<C-h>";
      action = "<CMD>bp<CR>";
      silent = true;
    }
    {
      mode = "";
      key = "<C-l>";
      action = "<CMD>bn<CR>";
      silent = true;
    }
    {
      mode = "";
      key = "<C-q>";
      action = "<CMD>bn<bar>silent!bd#<CR>";
      silent = true;
    }
    {
      mode = "";
      key = "<C-c>";
      action = "<CMD>CopilotChatToggle<CR>";
      silent = true;
    }
    {
      mode = "";
      key = "<C-o>";
      action = "<CMD>Oil --float<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "-";
      action = "<CMD>Oil<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "H";
      action = "<C-w>h";
      silent = true;
    }
    {
      mode = "n";
      key = "J";
      action = "<C-w>j";
      silent = true;
    }
    {
      mode = "n";
      key = "K";
      action = "<C-w>k";
      silent = true;
    }
    {
      mode = "n";
      key = "L";
      action = "<C-w>l";
      silent = true;
      nowait = true;
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<CMD>resize +2<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = "<CMD>resize -2<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = "<CMD>vertical resize -2<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = "<CMD>vertical resize +2<CR>";
      silent = true;
    }
    {
      mode = "n";
      key = "<A-j>";
      action = "<CMD>m .+1<CR>==";
      silent = true;
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<CMD>m .-2<CR>==";
      silent = true;
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<Esc><CMD>m .+1<CR>==gi";
      silent = true;
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<Esc><CMD>m .-2<CR>==gi";
      silent = true;
    }
    {
      mode = "v";
      key = "<";
      action = "<gv^";
      silent = true;
    }
    {
      mode = "v";
      key = ">";
      action = ">gv^";
      silent = true;
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<CR>gv=gv";
      silent = true;
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<CR>gv=gv";
      silent = true;
    }
    {
      mode = "v";
      key = "p";
      action = "\"_dP";
      silent = true;
    }
  ];
}
