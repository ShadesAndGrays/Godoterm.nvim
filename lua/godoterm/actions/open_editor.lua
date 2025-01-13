local utils = require('godoterm.utils')

local M = {}

local function open_editor()
---@type GodotConfig
    local config = require('godoterm.config').config
    local instance_m = require('godoterm.instance_manager')

    if (utils.cwd_has_project()) then
        instance_m.kill() -- in case it's running kill it
        instance_m.create_instance(config)
    else
        error(vim.uv.cwd() .. " is not a godot project dir")
    end
end

M.open_editor = open_editor

return M
