local utils = require("godoterm.utils")

local M = {}

local function run_project()
    require('scratch-buffer').open()
    vim.api.nvim_put({ "hello godot run" }, "", false, true)
end

M.run_project = run_project

return M
