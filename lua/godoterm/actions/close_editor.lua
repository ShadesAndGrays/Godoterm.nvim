local utils = require("godoterm.utils")
---@type GodotInstanceManager
local instance_m = require("godoterm.instance_manager")
local M = {}

local function close_editor()
    ---@type GodotInstance[]
    local editors = instance_m.get_instances()
    if #editors < 1 then
        vim.notify("There are no instances running",vim.log.levels.INFO)
    elseif #editors == 1 then
        instance_m.kill(instance_m.remove(1))
    else
        vim.ui.select(editors, {
            prompt = 'Which editor would you like to close',
            format_item = function (item)
                local fmt = string.format("%s (%d) created %d sec ago", item.type, item.pid,os.time()-item.time_created)
                return fmt
            end
        }, function (_,idx)
            instance_m.kill(instance_m.remove(idx))
        end)
    end

end

local function close_all()
    instance_m.kill_all()
end

M.close_editor = close_editor
M.close_all = close_all

return M
