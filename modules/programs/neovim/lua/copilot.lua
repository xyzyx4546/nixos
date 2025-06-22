-- TODO: Configure Copilot Chat

---@diagnostic disable: undefined-global
-- luacheck: globals vim

require("copilot").setup()

require("CopilotChat").setup({
	model = "claude-sonnet-4",
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
