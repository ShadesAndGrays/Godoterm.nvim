local config = require("godoterm.config") ---@type GodotConfig
local utils = require("godoterm.utils") ---@type  GodotUtils

---@class GodotInstanceManager
---@field instances? GodotInstance[] 
---@field create_instance? fun():GodotInstance Creates a running instance of Godot
---@field launch_scene? fun(scene:string):GodotInstance Creates a running instance of Godot. Expects a path to a scene
---@field debug? fun() check the current state of the instance manager 
---@field kill? fun(instance:GodotInstance) kills a running instance 
---@field kill_all? fun() kills all running instances 
---@field get_instances? fun(): GodotInstance[]
---@field remove? fun(idx: number) : GodotInstance removes an instance from the of instances
---@field spawn? fun(spawn_config:SpawnConfig) : GodotInstance removes an instance from the of instances


---@class GodotInstance
---@field pid number 
---@field handle number 
---@field time_created number
---@field type? InstanceType 

---@class SpawnConfig
---@field command string
---@field path string

---@enum InstanceType
local InstanceType = {
    editor = "Editor",
    scene = "Scene"
}


---@type GodotInstanceManager
local M = {}

M.instances = {}

function M.get_instances()
    return M.instances
end


function M.remove(idx)
    if not idx then
        vim.notify("index does not exist",vim.log.levels.ERROR)
        return {}
    end
    local instance = M.instances[idx]
    table.remove(M.instances, idx)
    return instance
end

function M.kill(instance)
    if not instance then
        vim.notify("cannot kill nil instance",vim.log.levels.ERROR)
        return
    end
    if instance.pid then -- process is currently running
        vim.uv.kill(instance.pid, vim.uv.constants.SIGTERM) -- kill it with fire
        -- instance.pid = nil -- uninitialze process
        -- instance.handle = nil
        -- instance.time_created = nil
        instance = nil
    else
        vim.notify("instance is not running",vim.log.levels.ERROR)
    end
end

function M.kill_all()
    for _ , value in ipairs(M.instances) do
        M.kill(value)
    end
end

function M.debug()
    utils.debug(M,"GodotInstanceManager")
end

function M.spawn(spawn_config)

    local stdin = vim.uv.new_pipe()
    local stdout = vim.uv.new_pipe()
    local stderr = vim.uv.new_pipe()

    assert(stdin, "stdin is nil")
    assert(stdout, "stdout is nil")
    assert(stderr, "stderr is nil")

    local handle, pid = vim.uv.spawn(config.config.exec, {
        cwd = config.config.cwd,
        args = {spawn_config.command,spawn_config.path},
        stdio = {stdin, stdout, stderr},
        verbatim = true,
        detached = false,
        hide = true

    }, function(code, signal) -- on exit
        print("exit code", code)
        print("exit signal", signal)
    end)

    --- create and append instance
    local instance = { pid = pid, handle = handle, time_created = os.time()}
    table.insert(M.instances, instance)
    local idx = #M.instances


    vim.uv.read_start(stdout, function(err, data)
        assert(not err, err)
        if data then
            print("stdout chunk", stdout, data)
        else
            print("stdout end", stdout)
        end
    end)

    vim.uv.read_start(stderr, function(err, data)
        assert(not err, err)
        if data then
            print("stderr chunk", stderr, data)
        else
            print("stderr end", stderr)
        end
    end)

    vim.uv.write(stdin, "Hello World")

    vim.uv.shutdown(stdin, function()
        print("stdin shutdown", stdin)
        vim.uv.close(handle, function()
            -- for i = 1, #M.instances, 1 do
            --     if M.instances[i].pid == pid then
            --         M.kill(M.remove(i))
            --         break
            --     end
            -- end
            print("process closed", handle, pid)
        end)
    end)

    return instance
end

function M.create_instance()
    local instance = M.spawn({ command = "--editor", path = config.config.cwd})
    instance.type = InstanceType.editor
    return instance
end

function M.launch_scene(scene)
    local instance = M.spawn({ command = "", path = scene})
    instance.type = InstanceType.scene
    return instance
end

return M
