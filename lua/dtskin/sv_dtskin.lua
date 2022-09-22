include("dtskin/config.lua")
util.AddNetworkString("DTSkin_ChooseSkin")
util.AddNetworkString("DTSkin_Ready")
util.AddNetworkString("DTSkin_SkinSet")

-- Net ｡◕‿‿◕｡

local det_blue = Vector(15 / 255, 15 / 255, 215 / 255)

net.Receive("DTSkin_ChooseSkin", function(len, ply)

    if (ply.DTSkinNextRequest and (CurTime() < ply.DTSkinNextRequest)) then return end

    ply.DTSkinNextRequest = CurTime() + 1

    if (not table.IsEmpty(DTSkin.Config.AllowedGroups) and not DTSkin.Config.AllowedGroups[ply:GetUserGroup()]) then return end

    local modelID = net.ReadString()

    if (modelID == "") then
        if (not ply.DTSkin) then return end
    else
        if (modelID == ply.DTSkin) then return end
        if (not table.IsEmpty(DTSkin.Config.Models[modelID].allowedUsergroups) and not DTSkin.Config.Models[modelID].allowedUsergroups[ply:GetUserGroup()]) then return end
        if (not DTSkin.Config.Models[modelID]) then return end
    end

    local cookieID = "DTSkin_" .. ply:SteamID()

    if (modelID == "") then
        cookie.Delete(cookieID)
        ply.DTSkin = nil
    else
        cookie.Set("DTSkin_" .. ply:SteamID(), modelID)
        ply.DTSkin = modelID
    end

    net.Start("DTSkin_SkinSet")
    net.WriteString(modelID)
    net.Send(ply)

end)

-- Meta ｡◕‿‿◕｡

local meta = FindMetaTable("Player")

function meta:SetAppropiateDetectiveModel()
    if (not self:IsActiveDetective()) then return end

    if (self.DTSkin) then
        self:SetModel(DTSkin.Config.Models[self.DTSkin].model)
    elseif (DTSkin.Config.DefaultModel ~= "") then
        self:SetModel(DTSkin.Config.DefaultModel)
    end

    if (DTSkin.Config.SetPlayersToBlue) then
        self:SetPlayerColor(det_blue)
    end
end

-- Hooks ｡◕‿‿◕｡

hook.Add("TTTBeginRound", "DTSkin_SetDetectiveModel", function()

    for _, v in ipairs(player.GetAll()) do
        v:SetAppropiateDetectiveModel()
    end

end)

hook.Add("PlayerSpawn", "DTSkin_PlayerSpawn", function(ply)

    timer.Simple(0, function()
        ply:SetAppropiateDetectiveModel()
    end)

end)

net.Receive("DTSkin_Ready", function(len, ply)

    if (ply.DTSkinReady) then return end

    local sid = ply:SteamID()
    local cookieID = "DTSkin_" .. sid
    local modelID = cookie.GetString(cookieID)

    if (not modelID) then

        modelID = DTSkin.Config.DefaultModel
        cookie.Delete(cookieID)

    end

    ply.DTSkin = modelID

    net.Start("DTSkin_SkinSet")
    net.WriteString(modelID)
    net.Send(ply)

    ply.DTSkinReady = true

end)