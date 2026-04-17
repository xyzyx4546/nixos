-- TODO: Configure Copilot Chat

require("copilot").setup({
  filetypes = {
    ["*"] = false,
  },
})

require("CopilotChat").setup({
  show_help = false,
  window = {
    layout = "float",
    border = "rounded",
    width = 0.7,
    height = 0.7,
  },
  mappings = {
    submit_prompt = {
      normal = "<CR>",
      insert = "<C-CR>",
    },
    show_help = "?",
  },
})

vim.keymap.set("", "<C-c>", "<CMD>CopilotChatToggle<CR>", { silent = true })
