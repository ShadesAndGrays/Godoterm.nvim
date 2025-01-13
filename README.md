Control Godot from neovim

## Usage 
```lua
        config = function ()
            local godoterm = require("godoterm")
            godoterm.setup({
                exec = "/path/to/godot/exe"
            })

            Kmap("n","<leader>G",godoterm.open,{desc="Godot Actions"})
        end
```
### Commands
    GTRun,
    GTOpen,
    GTClose,
    GTCloseAll,
