local augroup = vim.api.nvim_create_augroup("Godoterm", { clear = true })

local create_user_command = vim.api.nvim_create_user_command

local M = {}


function M.setup()

    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        group = augroup,
        pattern = {"*.gdscript","*.gd"},
        callback = function(ev)
            -- require('scratch-buffer').open()
            -- vim.api.nvim_put({'Hello to gdscript',string.format('event fired: %s', vim.inspect(ev))},"",true,true)
            vim.notify('Valid gdscript file',vim.log.levels.INFO)
        end
    })


vim.api.nvim_create_autocmd({'QuitPre'}, {
    group = augroup,
callback = function ()
    require('godoterm.instance_manager').kill_all()
end})


    create_user_command(
    "GTInstanceDebug",
    require('godoterm.instance_manager').debug,
    {desc="Check the current state of the instance manager"}
    )

    create_user_command(
    "GTRun",
    require('godoterm.actions.run_project').run_project,
    {desc="run the godot project in the current directory"}
    )

    create_user_command(
    "GTOpen",
    require('godoterm.actions.open_editor').open_editor,
    {desc="open the editor for the current project"}
    )

    create_user_command(
    "GTClose",
    require('godoterm.actions.close_editor').close_editor,
    {desc="close the editors"}
    )

    create_user_command(
    "GTCloseAll",
    require('godoterm.actions.close_editor').close_all,
    {desc="close all editors"}
    )
end

return M
