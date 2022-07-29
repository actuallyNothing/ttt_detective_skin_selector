#  Detective Model Selector
A simple addon to allow players to choose the model they will spawn with when they are chosen as detectives in TTT.

## Usage

By default, the menu can be opened with the F5 key and through a tab in the TTT settings. Players can see all available models and choose whichever one they want (if they're allowed to), or reset to the default model.

The menu can also be opened with the "dtskin" concommand.

## Configuration

The config.lua file hosts the model names, paths and allowed usergroups for each one, as well as the usergroups that can open the model selector and various other settings.

**Opening the model selector without having added any models in the first place will throw an error.**

This is what the default config file looks like:

```lua
local C = {}

-- The table of models that can be chosen
  -- The key (in square brackets) is an ID for the model
  -- "name" is the name players will see in the menu
  -- "model" is the .mdl file for the model
  -- "allowedUsergroups" is a table of usergroups that can use this model. If empty, anyone can use it.
C.Models = {
    -- ["left_shark"] = {
    --     name = "Left Shark",
    --     model = "models/freeman/player/left_shark.mdl",
    --     allowedUsergroups = {
    --         ["superadmin"] = true
    --     }
    -- },

    -- ["h2o"] = {
    --     name = "H2O Delirious",
    --     model = "models/player/h2o/delirious.mdl",
    --     allowedUsergroups = {}
    -- }
}

-- Set the model colors to a detective-esque blue?
-- This only applies to models that can be colored
C.SetPlayersToBlue = true

-- The table of groups that can choose their Detective model
-- If empty, anyone can choose their Detective model
C.AllowedGroups = {
    ["superadmin"] = true,
    -- ["donator"] = true
}

-- The key that will open the menu. Set to KEY_NONE to disable
C.Key = KEY_F5

-- Show the panel as a tab in the TTT settings (F1)?
C.TTTSettingsTab = true

-- Show this tab to players that can't choose their Detective model?
C.ShowTabToUnprivilegedPlayers = true

-- The message that will be shown to players that can't choose their Detective model
C.NoAccessToPanelMsg = "You can't choose your detective model."

-- Default model for detectives that can't or haven't chosen their model
-- Set to "" for unchanged model
C.DefaultModel = ""

DTSkin.Config = C
```

## Installation
Download this repository's code as a ZIP file, and extract it inside your game or server's garrysmod/addons folder.