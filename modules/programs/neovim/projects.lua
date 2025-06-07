local Job = require('plenary.job')
local scan = require('plenary.scandir')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local PROJECTS_DIR = os.getenv('HOME') .. '/Projects/'

local close_all_buffers = function(cmd)
  local buffers = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_get_option(bufnr, 'modified') and vim.bo[bufnr].filetype ~= 'TelescopePrompt' then
      local choice = vim.fn.confirm(
        'Buffer ' .. vim.api.nvim_buf_get_name(bufnr) .. ' has unsaved changes. Save?',
        '&Yes\n&No\n&Cancel'
      )

      if choice == 1 then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd('silent! w')
        end)
      elseif choice == 3 then
        return
      end
    end
  end

  vim.cmd(cmd)
  local current_buf = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= current_buf then
      vim.cmd('bd! ' .. bufnr)
    end
  end
end

local function get_projects()
  local projects = {}

  scan.scan_dir(PROJECTS_DIR, {
    hidden = false,
    only_dirs = true,
    depth = 1,
    on_insert = function(project)
      table.insert(projects, {
        name = project:match('([^/]+)$'),
        path = project
      })
    end,
  })

  return projects
end

local function delete_project(project, prompt_bufnr)
  vim.ui.input({ prompt = 'Type \'' .. project.name .. '\' to remove' }, function(input)
    if input then
      if input == project.name then
        vim.fn.jobstart('rm -rf ' .. project.path)
        vim.notify(project.name .. ' was properly removed.')
        actions.close(prompt_bufnr)
        vim.fn.jobstart('nohup fetch_projects.py')
      else
        vim.notify('Mismatch. Deletion cancelled.', vim.log.levels.ERROR)
      end
    end
  end)
end

local function enter_project(project)
  close_all_buffers('NvimTreeOpen')
  vim.cmd('cd ' .. project.path)
  if io.open(project.path .. '/flake.nix', 'r') then
    vim.notify('entering development environment...')
    vim.cmd('NixDevelop')
  end
end

local function add_project()
  vim.ui.input({ prompt = 'URL' }, function(input)
    if input then
      local path = PROJECTS_DIR .. (string.match(input, '.*/(.*)') or input):gsub('%.git$', '')
      local errors = {}

      vim.notify('cloning repository...', vim.log.levels.INFO)

      local clone_job = Job:new({
        command = 'gh',
        args = { 'repo', 'clone', input, path, '--', '-q' },
        on_stderr = function(_, line)
          table.insert(errors, line)
        end,
        on_exit = function(_, return_code)
          vim.schedule(function()
            if return_code == 0 then
              enter_project({ path = path })
            else
              vim.notify('failed to clone repository:\n' .. table.concat(errors, '\n'), vim.log.levels.ERROR)
            end
          end)
        end,
      })

      clone_job:start()
    end
  end)
end

local function create_project()
  vim.ui.input({ prompt = 'Name' }, function(input)
    if input then
      local path = PROJECTS_DIR .. input
      vim.fn.jobstart('mkdir ' .. path)
      vim.fn.jobstart('nohup fetch_projects.py')
      enter_project({ path = path })
    end
  end)
end

local function project_picker()
  local opts = require('telescope.themes').get_dropdown()
  pickers.new(opts, {
    prompt_title = 'Find Projects',
    finder = finders.new_table {
      results = get_projects(),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry.name,
          display = function()
            local display = ' ' .. entry.name
            local hl = { { { 0, #' ' }, 'TelescopeProjectsIcon' } }

            return display, hl
          end,
        }
      end
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      local project = nil
      actions.select_default:replace(function()
        project = action_state.get_selected_entry().value
        actions.close(prompt_bufnr)
        if project then
          enter_project(project)
        end
      end)
      map('i', '<C-n>', function() create_project() end)
      map('i', '<C-a>', function() add_project() end)
      map('i', '<C-d>', function() delete_project(action_state.get_selected_entry().value, prompt_bufnr) end)
      return true
    end,
  }):find()
end

function _PROJECTS(name)
  if name then
    local path = PROJECTS_DIR .. name
    if vim.fn.isdirectory(path) then
      enter_project({ path = path })
    else
      vim.notify('project \'' .. name .. '\' does not exist.', vim.log.levels.ERROR)
    end
  else
    project_picker()
  end
end

vim.keymap.set('n', '<leader>fp', _PROJECTS, { desc = 'Find projects [Telescope]' })
