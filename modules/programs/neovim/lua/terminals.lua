---@diagnostic disable: undefined-global
-- luacheck: globals vim

local Terminal = require("toggleterm.terminal").Terminal

local terminals = {
	{ cmd = "lazygit", key = "l" },
	{ cmd = "gh-dash", key = "g" },
	{ cmd = "btop", key = "t" },
}

for _, term in ipairs(terminals) do
	vim.keymap.set("n", "<leader>t" .. term.key, function()
		Terminal:new({ cmd = term.cmd, hidden = true }):toggle()
	end, { desc = "Open " .. term.cmd .. " [toggleterm]" })
end
