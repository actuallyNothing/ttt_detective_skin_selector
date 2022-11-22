
--[[

    TTT Detective Skin Selector configuration

--]]

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

-- The key that will open the menu. Set to nil to disable
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