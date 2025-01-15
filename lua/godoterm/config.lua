---@class GodotConfig
---@field setup? fun(opts:Config)
---@field config? Config

---@class Config
---@field exec string
---@field cwd string

---@alias ft 'gdscript'

---@type GodotConfig
local M = {}

---@param opts Config
M.setup = function (opts)
    local cwd = vim.uv.cwd()
    if cwd == nil then
        error("Current working directory does not exist")
    end
    opts.cwd = cwd
    if opts then
        M.config = opts
    end
end

return M
