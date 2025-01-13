local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
-- local conf = require('telescope.config').values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

-- local g_acts = require "godoterm.actions"
local g_acts = require "godoterm.actions"

local M = {}

---Launches a Godot action
---@param action_name string
local launch_action =  function (action_name)
    local act = g_acts.godot_actions[action_name]
    g_acts[act]()
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

    attach_mappings = function(prompt_bufnr, _)
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

---@param opts GodotConfig
function M.setup(opts)
    opts = opts or {}
    -- require('godoterm.utils').debug(opts, "config")
    require('godoterm.config').setup(opts)
    require('godoterm.commands').setup()
end

return M
