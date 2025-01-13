local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
-- local conf = require('telescope.config').values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local g_acts = require "godoterm.actions"

local M = {}

---Launches a Godot action
---@param action_name string
local launch_action =  function (action_name)
    -- g_acts[action_name]()
end

local godot_action = function (opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    pickers.new(opts,{
        debunce = 100,
        prompt_title= "Godot Action",
        finder = finders.new_table {
          results = g_acts.get_actions()
        },
        sorter = require('telescope.sorters').empty(),

    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry() -- get selection
        actions.close(prompt_bufnr) -- close picker
        launch_action(selection[1])
      end)
      return true
    end,

    }):find()

end

M.open = function ()
    godot_action(require('telescope.themes').get_cursor())
end

M.setup = function (opts)
    opts = opts or {}
end

return M
