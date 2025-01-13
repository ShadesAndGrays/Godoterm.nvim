local godot_actions = {
        ["Open Editor"] = "open_editor",
        ["Close Editor"] = "close_editor",
        ["Run Project"] = "run_project",
}

local function open_editor()
    vim.api.nvim_put({ "hello godot open" }, "", false, true)
end

local function close_editor()
    vim.api.nvim_put({ "hello godot close" }, "", false, true)
end

local function run_project()
    vim.api.nvim_put({ "hello godot run" }, "", false, true)
end




---Returns a mapping of telescope values to methods
---@return <T>[]
local get_actions = function()
    return vim.tbl_keys(godot_actions)
end
