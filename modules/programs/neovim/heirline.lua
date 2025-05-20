local heirline = require("heirline")
local utils = require("heirline.utils")
local colors = require("dracula").colors()

vim.o.showtabline = 2
vim.o.laststatus = 3

local ViMode = {
	static = {
		mode_colors = {
			n = colors.purple,
			i = colors.green,
			v = colors.yellow,
			V = colors.yellow,
			["\22"] = colors.yellow,
			c = colors.cyan,
			s = colors.yellow,
			S = colors.yellow,
			["\19"] = colors.yellow,
			R = colors.red,
			r = colors.red,
			["!"] = colors.purple,
			t = colors.purple,
		},
		mode_names = {
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
		},
	},
	init = function(self)
		self.mode = vim.fn.mode()
	end,
	update = "ModeChanged",
	{
		provider = "",
		hl = function(self)
			return { fg = self.mode_colors[self.mode], bg = nil }
		end,
	},
	{
		provider = function(self)
			return self.mode_names[self.mode]
		end,
		hl = function(self)
			return { fg = colors.black, bg = self.mode_colors[self.mode], bold = true }
		end,
	},
	{
		provider = "  ",
		hl = function(self)
			return { fg = self.mode_colors[self.mode], bg = nil }
		end,
	},
}

local FileName = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	{
		init = function(self)
			local extension = vim.fn.fnamemodify(self.filename, ":e")
			self.icon, self.icon_color =
				require("nvim-web-devicons").get_icon_color(self.filename, extension, { default = true })
		end,
		provider = function(self)
			return self.icon and (self.icon .. " ")
		end,
		hl = function(self)
			return { fg = self.icon_color }
		end,
	},
	{
		provider = function(self)
			local filename = vim.fn.fnamemodify(self.filename, ":t")
			filename = filename == "" and "[No Name]" or filename
			local modified = vim.bo.modified and "    " or "  "
			return filename .. modified
		end,
		hl = { fg = colors.purple },
	},
}

local Diagnostics = {
	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
	end,
	update = { "DiagnosticChanged", "BufEnter" },
	{
		provider = function(self)
			if self.errors > 0 then
				return " " .. self.errors .. " "
			end
		end,
		hl = { fg = colors.red },
	},
	{
		provider = function(self)
			if self.warnings > 0 then
				return " " .. self.warnings .. " "
			end
		end,
		hl = { fg = colors.yellow },
	},
	{
		provider = function(self)
			if self.info > 0 then
				return " " .. self.info .. " "
			end
		end,
		hl = { fg = colors.cyan },
	},
	{
		provider = function(self)
			if self.hints > 0 then
				return " " .. self.hints .. " "
			end
		end,
		hl = { fg = colors.cyan },
	},
}

local FileType = {
	provider = function()
		return vim.bo.filetype
	end,
	hl = { fg = colors.purple },
}

local Location = {
	{
		provider = "  ",
		hl = { fg = colors.purple, bg = nil },
	},
	{
		provider = function()
			local line = vim.fn.line(".")
			local col = vim.fn.col(".")
			return string.format("%3d:%-2d", line, col)
		end,
		hl = { fg = colors.black, bg = colors.purple },
	},
	{
		provider = "",
		hl = { fg = colors.purple, bg = nil },
	},
}

local StatusLine = {
	ViMode,
	FileName,
	Diagnostics,
	{ provider = "%=" },
	FileType,
	Location,
}

local Buffer = {
	init = function(self)
		self.filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":t")
		if self.filename == "" then
			self.filename = "[No Name]"
		end
		self.is_active = vim.fn.bufwinnr(self.bufnr) > 0
	end,
	{
		provider = function(self)
			return self.is_active and "" or " "
		end,
		hl = { fg = colors.purple },
	},
	{
		provider = function(self)
			return self.filename
		end,
		hl = function(self)
			if self.is_active then
				return { fg = colors.black, bg = colors.purple }
			else
				return { fg = colors.purple, bg = nil }
			end
		end,
	},
	{
		provider = function(self)
			return self.is_active and " " or "  "
		end,
		hl = { fg = colors.purple },
	},
}

local BufferLine = utils.make_buflist(Buffer)

heirline.setup({
	statusline = StatusLine,
	tabline = BufferLine,
})
