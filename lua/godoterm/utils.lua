local M = {}

---Returns true if the current working directory has a godot project file project.godot
---@return boolean
 function M.cwd_has_project()
    local cwd = vim.uv.cwd()
    if cwd then
        local project_file = vim.fs.find("project.godot",{path = cwd})
        return #project_file > 0
    end
    return false
end

---Print with vim.inspect
---@param value any
---@param name string
function M.debug(value,name)
    local val = vim.inspect(value)
    vim.fn.input({prompt = name .. val})
end

return M
