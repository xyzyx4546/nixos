---@diagnostic disable: undefined-global
-- luacheck: globals vim

local heirline = require("heirline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
	background = "#44475A",
	red = "#FF5555",
	orange = "#FFB86C",
	yellow = "#F1FA8C",
	green = "#50fa7b",
	purple = "#BD93F9",
	cyan = "#8BE9FD",
	pink = "#FF79C6",
}

vim.o.showtabline = 2
vim.o.laststatus = 3

local function create_section(opts)
	if type(opts.color) ~= "function" then
		local c = opts.color or colors.purple
		opts.color = function()
			return c
		end
	end

	return {
		init = opts.init,
		condition = opts.condition,
		update = opts.update,
		{
			provider = "",
			hl = function()
				return { fg = opts.color(), bg = nil }
			end,
		},
		{
			provider = opts.icon,
			hl = function()
				return { fg = colors.background, bg = opts.color() }
			end,
		},
		{
			provider = " ",
			hl = function()
				return { fg = colors.background, bg = opts.color() }
			end,
		},
		{
			provider = opts.content or "",
			hl = function()
				return { fg = opts.color(), bg = colors.background }
			end,
		},
		opts.child or {},
		{
			provider = "" .. (opts.is_last and "" or "  "),
			hl = { fg = colors.background, bg = nil },
		},
	}
end

local ViMode = create_section({
	update = {
		"RecordingEnter",
		"RecordingLeave",
		"ModeChanged",
	},
	icon = function()
		return vim.fn.reg_recording() == "" and "" or "󰻃"
	end,
	content = function()
		return ({
			n = "NORMAL",
			i = "INSERT",
			v = "VISUAL",
			V = "V-LINE",
			["\22"] = "V-BLOCK",
			c = "COMMAND",
			s = "SELECT",
			S = "S-LINE",
			["\19"] = "S-BLOCK",
			R = "REPLACE",
			r = "REPLACE",
			["!"] = "SHELL",
			t = "TERMINAL",
		})[vim.fn.mode()]
	end,
	color = function()
		return ({
			n = colors.purple,
			i = colors.green,
			v = colors.yellow,
			V = colors.yellow,
			["\22"] = colors.yellow,
			c = colors.pink,
			s = colors.yellow,
			S = colors.yellow,
			["\19"] = colors.yellow,
			R = colors.red,
			r = colors.red,
			["!"] = colors.purple,
			t = colors.purple,
		})[vim.fn.mode()]
	end,
})

local File = create_section({
	init = function(self)
		self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":t")
	end,
	icon = function(self)
		return require("nvim-web-devicons").get_icon(
			self.filename,
			vim.fn.fnamemodify(self.filename, ":e"),
			{ default = true }
		)
	end,
	content = function(self)
		if vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) ~= 1 then
			return vim.bo.filetype
		else
			return self.filename .. (vim.bo.modified and "  " or "")
		end
	end,
	color = colors.cyan,
})

local Diagnostics = create_section({
	condition = conditions.has_diagnostics,
	update = { "DiagnosticChanged", "BufEnter" },
	icon = "",
	child = {
		{
			condition = function()
				return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) > 0
			end,
			provider = function()
				local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				return " " .. errors
			end,
			hl = { fg = colors.red, bg = colors.background },
		},
		{
			condition = function()
				local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				return errors > 0 and (warnings > 0 or info > 0 or hints > 0)
			end,
			provider = " ",
			hl = { bg = colors.background },
		},
		{
			condition = function()
				return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) > 0
			end,
			provider = function()
				local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				return " " .. warnings
			end,
			hl = { fg = colors.yellow, bg = colors.background },
		},
		{
			condition = function()
				local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				return warnings > 0 and (info > 0 or hints > 0)
			end,
			provider = " ",
			hl = { bg = colors.background },
		},
		{
			condition = function()
				return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) > 0
			end,
			provider = function()
				local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				return " " .. info
			end,
			hl = { fg = colors.cyan, bg = colors.background },
		},
		{
			condition = function()
				local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				return info > 0 and hints > 0
			end,
			provider = " ",
			hl = { bg = colors.background },
		},
		{
			condition = function()
				return #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) > 0
			end,
			provider = function()
				local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				return " " .. hints
			end,
			hl = { fg = colors.cyan, bg = colors.background },
		},
	},
})

local Git = create_section({
	condition = conditions.is_git_repo,
	icon = "",
	child = {
		{
			provider = function()
				return "+" .. (vim.b.gitsigns_status_dict.added or 0)
			end,
			hl = { fg = colors.green, bg = colors.background },
		},
		{
			provider = function()
				return "-" .. (vim.b.gitsigns_status_dict.removed or 0)
			end,
			hl = { fg = colors.red, bg = colors.background },
		},
		{
			provider = function()
				return "~" .. (vim.b.gitsigns_status_dict.changed or 0)
			end,
			hl = { fg = colors.yellow, bg = colors.background },
		},
	},
	color = colors.orange,
})

local Lsp = create_section({
	condition = conditions.lsp_attached,
	update = { "LspAttach", "LspDetach" },
	icon = "",
	content = function()
		local names = {}
		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			table.insert(names, client.name)
		end
		return table.concat(names, ", ")
	end,
	color = colors.green,
})

local Location = create_section({
	condition = function()
		return vim.fn.filereadable(vim.api.nvim_buf_get_name(0)) == 1
	end,
	icon = function()
		local sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" }
		return sbar[math.floor((vim.api.nvim_win_get_cursor(0)[1] - 1) / vim.api.nvim_buf_line_count(0) * #sbar) + 1]
	end,
	content = function()
		return string.format("%3d:%-2d", vim.fn.line("."), vim.fn.col("."))
	end,
	color = colors.yellow,
})

local WorkDir = create_section({
	icon = "",
	content = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
	end,
	color = colors.cyan,
	is_last = true,
})

local StatusLine = {
	ViMode,
	File,
	Diagnostics,
	Git,
	{ provider = "%=" },
	Lsp,
	Location,
	WorkDir,
}

local BufferLine = utils.make_buflist({
	init = function(self)
		self.is_active = vim.fn.bufwinnr(self.bufnr) > 0
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == "l" then
				vim.api.nvim_win_set_buf(0, minwid)
			elseif button == "r" then
				local loaded_bufs = vim.tbl_filter(vim.api.nvim_buf_is_loaded, vim.api.nvim_list_bufs())
				if #loaded_bufs > 1 then
					vim.schedule(function()
						vim.api.nvim_buf_delete(minwid, { force = false })
					end)
				end
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_bufferline_callback",
	},
	{
		provider = "",
		hl = function(self)
			return { fg = self.is_active and colors.purple or colors.background }
		end,
	},
	{
		provider = function(self)
			local full_path = vim.api.nvim_buf_get_name(self.bufnr)
			local filename = vim.fn.fnamemodify(full_path, ":t")

			if filename == "" then
				return "[No Name]"
			end

			local has_duplicate = vim.iter(vim.api.nvim_list_bufs())
				:filter(function(buf)
					return vim.api.nvim_buf_is_loaded(buf) and buf ~= self.bufnr
				end)
				:map(function(buf)
					return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
				end)
				:any(function(name)
					return name == filename
				end)

			return has_duplicate and vim.fn.fnamemodify(full_path, ":h:t") .. "/" .. filename or filename
		end,
		hl = function(self)
			if self.is_active then
				return { fg = colors.background, bg = colors.purple }
			else
				return { fg = colors.purple, bg = colors.background }
			end
		end,
	},
	{
		provider = " ",
		hl = function(self)
			return { fg = self.is_active and colors.purple or colors.background }
		end,
	},
})

heirline.setup({
	statusline = StatusLine,
	tabline = BufferLine,
})
