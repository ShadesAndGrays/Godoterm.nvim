local utils = require("godoterm.utils") ---@type GodotUtils
local instance_m = require("godoterm.instance_manager")---@type GodotInstanceManager

local M = {}

local function run_project()

   if not utils.cwd_has_project() then
        vim.notify("There current working directory is not a valid godot project",vim.log.levels.ERROR)
   end
    local scenes = utils.get_tscn_files()
    if #scenes < 1 then
        vim.notify("There are no scenes present in this project",vim.log.levels.INFO)
    elseif #scenes == 1 then
        instance_m.launch_scene(scenes[1])
    else
        vim.ui.select(scenes, {
            prompt = 'Which scene would you like to open',
            format_item = function (item)
                return string.match(item, '[~,_,%-,0-z]*.tscn$')
            end
        }, function (value,_)
            vim.notify("lauching ".. value,vim.log.levels.INFO)
            instance_m.launch_scene(value)
        end)
    end
end

M.run_project = run_project

return M
