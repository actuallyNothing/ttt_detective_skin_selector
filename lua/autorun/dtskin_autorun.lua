--[[

    TTT Detective Skin Selector
    Made by actuallyNothing for the Trouble in Terrorist Town gamemode
    
    contact:
    Steam: https://steamcommunity.com/id/actuallyNothing/
    GitHub: https://github.com/actuallyNothing/

--]]

DTSkin = {}

if (SERVER) then
    include("dtskin/sv_dtskin.lua")
    AddCSLuaFile("dtskin/config.lua")
    AddCSLuaFile("dtskin/cl_dtskin.lua")
else
    include("dtskin/cl_dtskin.lua")
end