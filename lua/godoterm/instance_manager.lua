---@class GodotInstanceManager
---@field instances? GodotInstance[] 
---@field create_instance? fun(config:GodotConfig,replace:boolean):GodotInstance function create create a running instance of godot
---@field debug? fun() check the current state of the instance manager 
---@field kill? fun(instance:GodotInstance) kills a running instance 
---@field kill_all? fun() kills all running instances 
---@field get_instances? fun(): GodotInstance[]
---@field remove? fun(idx: number) : GodotInstance removes an instance from the of instances
---@class GodotInstance
---@field pid number 
---@field handle number 
---@field time_created number


---@type GodotInstanceManager
local M = {}
M.instances = {}

function M.get_instances()
    return M.instances
end


function M.remove(idx)
    if not idx then
        return
    end
    table.remove(M.instances, idx)
    return M.instances[idx]
end

function M.kill(instance)
    if not instance then
        return
    end
    if instance.pid then -- process is currently running
        vim.uv.kill(instance.pid, vim.uv.constants.SIGTERM) -- kill it with fire
        -- instance.pid = nil -- uninitialze process
        -- instance.handle = nil
        instance = nil
    end
end

function M.kill_all()
    for _ , value in ipairs(M.instances) do
        M.kill(value)
    end
end

function M.debug()
    require("godoterm.utils").debug(M,"GodotInstanceManager")
end


---@param opts GodotConfig
---@param replace boolean
function M.create_instance(opts,replace)
    local cwd = vim.uv.cwd()
    if cwd == nil then
        error("Current working directory does not exist")
    end

    local stdin = vim.uv.new_pipe()
    local stdout = vim.uv.new_pipe()
    local stderr = vim.uv.new_pipe()
    print("stdin", stdin)
    print("stdout", stdout)
    print("stderr", stderr)

    local handle, pid = vim.uv.spawn(opts.exec, {
        args = {"--editor", cwd},
        cwd = cwd,
        stdio = {stdin, stdout, stderr},
        -- env = {} ,
        -- uid = 1000,
        -- gid = 1000,
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
            print("process closed", handle, pid)
        end)
    end)
end

return M
