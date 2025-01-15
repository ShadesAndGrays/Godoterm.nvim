---@class GodotUtils
---@field cwd_has_project fun():boolean
---@field get_tscn_files fun():string[]
---@field debug fun(value:any,name:string)
---@type GodotUtils
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

---Returns all the scene files in the current working directory
---@return string[]
function M.get_tscn_files()
    local cwd = vim.uv.cwd()
    if cwd then
        local file = vim.fs.find(function (name,_)
            return name:match('.*.tscn$')
        end, {path = cwd, type='file',limit=math.huge})
        if #file == 0 then
            vim.notify("No godot scene files were present in cwd",vim.log.levels.INFO)
        end
        return file
    end
    return {}
end

M.get_tscn_files()

---Print with vim.inspect
---@param value any
---@param name string
function M.debug(value,name)
    local val = vim.inspect(value)
    vim.fn.input({prompt = name .. val})
end

return M
