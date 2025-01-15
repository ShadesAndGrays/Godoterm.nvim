local utils = require('godoterm.utils') ---@type GodotUtils
local config = require('godoterm.config') ---@type GodotConfig
local instance_m = require('godoterm.instance_manager') ---@type GodotInstanceManager

local M = {}

local function open_editor()

    if (utils.cwd_has_project()) then
        instance_m.create_instance()
    else
        vim.notify(config.config.cwd .. " is not a godot project directory",vim.log.levels.ERROR)
    end
end

M.open_editor = open_editor

return M
