local  open_editor = require("godoterm.actions.open_editor")
local  close_editor = require("godoterm.actions.close_editor")
local  run_project = require("godoterm.actions.run_project")
M = {}

M.godot_actions = {
        ["Open Editor"] = "open_editor",
        ["Close Editor"] = "close_editor",
        ["Run Project"] = "run_project",
}





M['open_editor'] = open_editor.open_editor
M['close_editor'] = close_editor.close_editor
M['run_project'] = run_project.run_project


M.open_editor = open_editor.open_editor
M.close_editor = close_editor.close_editor
M.run_project = run_project.run_project

---Returns a mapping of telescope values to methods
---@return <T>[]
M.get_actions = function()
    return vim.tbl_keys(M.godot_actions)
end

return M
