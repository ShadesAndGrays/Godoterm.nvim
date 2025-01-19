local M = {}

M.open = function ()
    -- godot_action(require('telescope.themes').get_cursor())
end

---@param opts Config
function M.setup(opts)
    opts = opts or {}
    -- require('godoterm.utils').debug(opts, "config in inti")
    require('godoterm.config').setup(opts)
    require('godoterm.commands').setup()
end

return M
