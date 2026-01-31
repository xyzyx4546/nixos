---@diagnostic disable: undefined-global
-- luacheck: globals vim PROJECTS

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local PROJECTS_DIR = vim.uv.os_homedir() .. "/Projects/"

local function get_projects()
  local projects = {}

  for name, typ in vim.fs.dir(PROJECTS_DIR, { depth = 1 }) do
    if typ == "directory" then
      table.insert(projects, { name = name, path = PROJECTS_DIR .. name })
    end
  end

  return projects
end

local function enter_project(path)
  vim.schedule(function()
    local modified = vim.iter(vim.fn.getbufinfo({ bufmodified = 1 }))
      :filter(function(info) return info.name ~= "" end)
      :map(function(info) return info.name end)
      :totable()

    if #modified > 0 then
      local msg = "Unsaved buffers:\n• " .. table.concat(modified, "\n• ")
      local choice = vim.fn.confirm(msg, "&Save all\n&Discard all\n&Cancel", 1)

      if choice == 1 then
        vim.cmd("wall")
      elseif choice ~= 2 then
        return
      end
    end

    vim.cmd("silent! %bd! | %bd!")
    vim.fn.chdir(path)
  end)
end

local function add_project()
  vim.ui.input({ prompt = "URL" }, function(input)
    if input then
      local path = PROJECTS_DIR .. (string.match(input, ".*/(.*)") or input):gsub("%.git$", "")

      vim.notify("Cloning repository...", vim.log.levels.INFO)

      vim.system({ "gh", "repo", "clone", input, path, "--", "--quiet" }, function(obj)
        if obj.code == 0 then
          enter_project(path)
        else
          vim.notify(obj.stderr, vim.log.levels.ERROR)
        end
      end)
    end
  end)
end

local function create_project()
  vim.ui.input({ prompt = "Name" }, function(input)
    if input and input ~= "" then
      local path = PROJECTS_DIR .. input
      vim.fn.mkdir(path, "p")
      enter_project(path)
    end
  end)
end

local function delete_project(project, prompt_bufnr)
  local choice = vim.fn.confirm("Delete project '" .. project.name .. "'?", "&Yes\n&No", 2)

  if choice ~= 1 then
    vim.notify("Deletion cancelled.")
  end

  if vim.fn.getcwd():find(vim.fn.fnamemodify(project.path, ":p")) == 1 then
    vim.fn.chdir("~")
  end

  if vim.fn.delete(project.path, "rf") == 0 then
    vim.notify(project.name .. " removed.")
  else
    vim.notify("Failed to delete '" .. project.name .. "'.", vim.log.levels.ERROR)
  end

  actions.close(prompt_bufnr)
end

local function project_picker()
  local opts = require("telescope.themes").get_dropdown()

  pickers.new(opts, {
    prompt_title = "Find Projects",
    finder = finders.new_table({
      results = get_projects(),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry.name,
          display = function()
            local display = " " .. entry.name
            local hl = { { { 0, #" " }, "TelescopeProjectsIcon" } }
            return display, hl
          end,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selected = action_state.get_selected_entry()
        if selected then
          enter_project(selected.value.path)
        end
      end)

      map("i", "<C-n>", create_project)
      map("i", "<C-a>", add_project)
      map("i", "<C-d>", function() delete_project(action_state.get_selected_entry().value, prompt_bufnr) end)

      return true
    end,
  }):find()
end

function PROJECTS(name)
  if name then
    local path = PROJECTS_DIR .. name
    if vim.fn.isdirectory(path) then
      enter_project(path)
    else
      vim.notify("Project '" .. name .. "' does not exist.", vim.log.levels.ERROR)
    end
  else
    project_picker()
  end
end

vim.keymap.set("n", "<leader>fp", PROJECTS, { desc = "Find projects [Telescope]" })
