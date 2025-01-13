---@class GodotConfig
---@field exec string

---@alias ft 'gdscript'

local M = {}

---@type GodotConfig
M.config = nil

---comment
---@param opts GodotConfig
M.setup = function (opts)
    if opts then
        M.config = opts
    end
end

return M
