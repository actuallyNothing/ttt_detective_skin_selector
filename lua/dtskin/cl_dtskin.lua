include("dtskin/config.lua")

-- Net ｡◕‿‿◕｡

local function ChooseModel(modelID)

    net.Start("DTSkin_ChooseSkin")
    net.WriteString(modelID)
    net.SendToServer()

end

net.Receive("DTSkin_SkinSet", function()

    local modelID = net.ReadString()

    if (modelID == "") then DTSkin.Skin = nil else DTSkin.Skin = modelID end

end)

-- GUI ｡◕‿‿◕｡

local clr_gray = Color(150, 150, 150)
local clr_hovered = Color(170, 170, 170)
local clr_det = Color(110, 120, 255)
local clr_disabled_background = Color(0, 0, 0, 238)

function DTSkin:Panel(parent, ttt)

    local pnl = vgui.Create("DPanel", parent)
    pnl:SetPaintBackground(false)

    if (ttt) then
        pnl:StretchToParent(0, 0, parent:GetPadding() * 2, 0)
    else
        pnl:Dock(FILL)
        pnl:InvalidateLayout(true)
    end

    local listPanel = vgui.Create("DScrollPanel", pnl)
    listPanel:SetPos(0, 0)
    listPanel:SetSize(350, 355)

    local modelPreview = vgui.Create("DModelPanel", pnl)
    modelPreview:SetPos(355, 0)
    modelPreview:SetSize(230, 330)
    modelPreview:SetModel(table.Random(DTSkin.Config.Models).model)
    modelPreview:SetCamPos(modelPreview:GetCamPos() + Vector(-12, 0, 0))
    modelPreview.LayoutEntity = function(mdl, ent)
        mdl:SetFOV(50)
        ent:SetAngles(Angle(0, RealTime() * 100,  0))
    end

    for modelID, model in pairs(DTSkin.Config.Models) do

        local panel = vgui.Create("DPanel")
        panel:SetTall(70)
        panel:Dock(TOP)
        panel:DockPadding(5, 5, 5, 5)
        panel:DockMargin(5, 5, 5, 5)

        panel.Paint = function()

            surface.SetDrawColor(DTSkin.Skin == modelID and clr_det or (panel:IsHovered() and clr_hovered or clr_gray))
            surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

            surface.SetDrawColor(color_white)
            surface.DrawOutlinedRect(0, 0, panel:GetWide(), panel:GetTall())

        end

        local modelHead = vgui.Create("DModelPanel", panel)
        modelHead:SetSize(60, 60)
        modelHead:Dock(LEFT)
        modelHead:SetModel(model.model)

        modelHead.LayoutEntity = function(_, ent)
            if (DTSkin.Skin == modelID) then
                ent:SetAngles(Angle(0, RealTime() * 100,  0))
            else
                ent:SetAngles(Angle(0, 0, 0))
            end
        end

        local modelBone = modelHead.Entity:LookupBone("ValveBiped.Bip01_Head1")
        local modelEyePos = modelBone and modelHead.Entity:GetBonePosition(modelBone) or Vector(16, -0.15, 64)
        modelEyePos:Add(Vector(0, 0, 2))
        modelHead:SetLookAt(modelEyePos)
        modelHead:SetCamPos(modelEyePos-Vector(-16, 0, 0))

        local modelName = vgui.Create("DLabel", panel)
        modelName:SetFont("ScoreboardDefaultTitle")
        modelName:SetText(model.name)
        modelName:SizeToContents()
        modelName:Dock(TOP)
        modelName:SetTextColor(color_black)

        local chooseButton = vgui.Create("DButton", panel)
        chooseButton:Dock(BOTTOM)

        chooseButton.DoClick = function()
            ChooseModel(modelID)
        end

        local chooseThink = function(this)
            if (DTSkin.Skin == modelID) then
                this:SetText("Selected")
                this:SetEnabled(false)
            else
                this:SetText("Choose")
                this:SetEnabled(true)
            end
        end

        if (not table.IsEmpty(model.allowedUsergroups)) then
            if (not model.allowedUsergroups[LocalPlayer():GetUserGroup()]) then
                local groups = table.concat(table.GetKeys(model.allowedUsergroups), ", ")

                chooseButton:SetText("You can't use this model")
                chooseButton:SetEnabled(false)

                panel:SetTooltip("Can use: " .. groups)
            else
                chooseButton.Think = chooseThink
            end
        else
            chooseButton.Think = chooseThink
        end

        local onHover = function(this)
            if (this:IsHovered()) then
                if (modelPreview:GetModel() == model.model) then return end

                modelPreview:SetModel(model.model)
            end
        end

        panel.Think = onHover

        listPanel:AddItem(panel)

    end

    local setToDefault = vgui.Create("DButton", pnl)
    setToDefault:SetText("Reset model to default")
    setToDefault:SetPos(355, 330)
    setToDefault:SetSize(225, 30)

    setToDefault.Think = function(this)
        if (not DTSkin.Skin) then
            this:SetEnabled(false)
        else
            this:SetEnabled(true)
        end
    end

    setToDefault.DoClick = function()
        ChooseModel("")
    end

    if (not DTSkin.Config.AllowedGroups[LocalPlayer():GetUserGroup()]) then

        local disabledPanel = vgui.Create("DPanel", pnl)
        disabledPanel:Dock(FILL)

        disabledPanel.Paint = function(_, w, h)

            surface.SetDrawColor(clr_disabled_background)
            surface.DrawRect(0, 0, w, h)

        end

        local disabledLabel = vgui.Create("DLabel", disabledPanel)
        disabledLabel:SetText(DTSkin.Config.NoAccessToPanelMsg)
        disabledLabel:SetFont("DermaLarge")
        disabledLabel:SetTextColor(color_white)
        disabledLabel:SizeToContents()
        disabledLabel:Dock(FILL)
        disabledLabel:SetContentAlignment(5)

    end

    if (ttt) then return pnl end

end

function DTSkin:Menu()

    DTSkin.Frame = vgui.Create("DFrame")
    local frame = DTSkin.Frame
    frame:SetSize(580, 400)
    frame:Center()
    frame:MakePopup()
    frame:SetTitle("Detective model selector")
    frame:DockMargin(5,5,5,5)

    self:Panel(frame)

end

concommand.Add("dtskin", function() DTSkin:Menu() end, nil)

-- Hooks ｡◕‿‿◕｡

hook.Add("TTTSettingsTabs", "DTSkin_TTTSettingsTabs", function(dtabs)
    if (not DTSkin.Config.TTTSettingsTab) then return end
    if (not DTSkin.Config.AllowedGroups[LocalPlayer():GetUserGroup()] and not DTSkin.Config.ShowTabToUnprivilegedPlayers) then return end

    dtabs:AddSheet("Detective Skin", DTSkin:Panel(dtabs, true), "icon16/user_suit.png")
end)

hook.Add("InitPostEntity", "DTSkin_Ready", function()

    net.Start("DTSkin_Ready")
    net.SendToServer()

end)

hook.Add("Think", "WeaponSelectionKey", function()

    if input.IsKeyDown(DTSkin.Config.Key) then

        if (DTSkin.KeyDown) then return end

        if (IsValid(DTSkin.Frame)) then
            DTSkin.Frame:Close()
        else
            DTSkin:Menu()
        end

        DTSkin.KeyDown = true

    else
        DTSkin.KeyDown = false
    end

end)

