ROOKI.customsave = {
    ["CLASS"] = function(ent, dataifspawning) end,
    ["spawned_weapon"] = function(ent, data, issaving)
        if (issaving) then
            local temp = {}
            temp.Name = weapons.Get(ent:GetNetworkVars()["WeaponClass"]).PrintName

            return temp
        end
    end
}

function ROOKI.GetEntTable(ent, conf)
    if (not conf) then
        conf = {}
    end

    if not ent or not ent:IsValid() then return false end
    local content = {}
    content.Class = ent:GetClass()
    content.Angle = ent:GetAngles()
    content.Model = conf.model or ent:GetModel()
    content.Skin = ent:GetSkin()
    --content.Mins, content.Maxs = ent:GetCollisionBounds()
    content.ColGroup = ent:GetCollisionGroup()
    content.Name = conf.alias or ent.GetName and ent:GetName() or ent.GetPrintName and ent:GetPrintName() or ""
    content.ModelScale = ent:GetModelScale()
    content.Color = ent:GetColor()
    content.Material = ent:GetMaterial()
    content.Solid = ent:GetSolid()
    content.RenderMode = ent:GetRenderMode()
    content.IsWeapon = ent:IsWeapon() or ent.IsTFAWeapon

    if (ent.CPPIGetOwner and isfunction(ent.CPPIGetOwner)) then
        content.Owner = ent:CPPIGetOwner() or false
    end

    if (content.IsWeapon) then
        if (ent.Ammo1 and ent.GetAmmoCount) then
            content.AmmoPrimary = ent:Ammo1()
            content.AmmoPrimaryType = ent:GetPrimaryAmmoType()
        end

        if (ent.Ammo2 and ent.GetAmmoCount) then
            content.AmmoSecondary = ent:Ammo2()
            content.AmmoSecondaryType = ent:GetSecondaryAmmoType()
        end
    end

    if ROOKI.customsave[ent:GetClass()] ~= nil and isfunction(ROOKI.customsave[ent:GetClass()]) then
        local othercontent = ROOKI.customsave[ent:GetClass()](ent, content, true)
        if not othercontent then return false end

        if othercontent ~= nil and istable(othercontent) then
            table.Merge(content, othercontent)
        end
    end

    if (ent.GetNetworkVars) then
        content.DT = ent:GetNetworkVars()
    end

    local sm = ent:GetMaterials()

    if (sm and istable(sm)) then
        for k, v in pairs(sm) do
            if (ent:GetSubMaterial(k)) then
                content.SubMat = content.SubMat or {}
                content.SubMat[k] = ent:GetSubMaterial(k - 1)
            end
        end
    end

    local bg = ent:GetBodyGroups()

    if (bg) then
        for k, v in pairs(bg) do
            if (ent:GetBodygroup(v.id) > 0) then
                content.BodyG = content.BodyG or {}
                content.BodyG[v.id] = ent:GetBodygroup(v.id)
            end
        end
    end

    if ent:GetPhysicsObject() and ent:GetPhysicsObject():IsValid() then
        content.Frozen = not ent:GetPhysicsObject():IsMoveable()
    end

    if content.Class == "prop_dynamic" then
        content.Class = "prop_physics"
    end
    --content.Table = PermaProps.UselessContent( ent:GetTable() )

    return content
end

function ROOKI.EntityFromTable(data)
    if not data or not istable(data) then return false end

    if data.Class == "prop_physics" and data.Frozen then
        data.Class = "prop_dynamic" -- Can reduce lags
    end

    local ent = ents.Create(data.Class)
    if not ent then return false end

    if not ent:IsVehicle() then
        if not ent:IsValid() then return false end
    end

    ent:SetAngles(data.Angle or Angle(0, 0, 0))
    ent:SetModel(data.Model or "models/props_lab/box01b.mdl")
    ent:SetSkin(data.Skin or 0)
    --ent:SetCollisionBounds( ( data.Mins or 0 ), ( data.Maxs or 0 ) )
    ent:SetCollisionGroup(data.ColGroup or 0)
    ent:SetName(data.Name or "")
    ent:SetModelScale(data.ModelScale or 1)
    ent:SetMaterial(data.Material or "")
    ent:SetSolid(data.Solid or 6)

    if (ent.CPPISetOwner and isfunction(ent.CPPISetOwner) and data.Owner and IsValid(data.Owner)) then
        ent:CPPISetOwner(data.Owner)
    end

    if (data.IsWeapon) then
        function ent:Equip(newown)
            if (data.AmmoPrimary) then
                local newmun = newown:GetAmmo()[self:GetPrimaryAmmoType()] or 0
                newown:SetAmmo(newmun + data.AmmoPrimary, self:GetPrimaryAmmoType())
            end

            if (data.AmmoSecondary) then
                local newmun = newown:GetAmmo()[self:GetSecondaryAmmoType()] or 0
                newown:SetAmmo(newmun + data.AmmoSecondary, self:GetSecondaryAmmoType())
            end
        end

        function ent:EquipAmmo(newown)
            if (data.AmmoPrimary) then
                local newmun = newown:GetAmmo()[self:GetPrimaryAmmoType()] or 0
                newown:SetAmmo(newmun + data.AmmoPrimary, self:GetPrimaryAmmoType())
            end

            if (data.AmmoSecondary) then
                local newmun = newown:GetAmmo()[self:GetSecondaryAmmoType()] or 0
                newown:SetAmmo(newmun + data.AmmoSecondary, self:GetSecondaryAmmoType())
            end
        end
    end

    if ROOKI.customsave[data.Class] ~= nil and isfunction(ROOKI.customsave[data.Class]) then
        ROOKI.customsave[data.Class](ent, data.Other)
        ent:Spawn()
    else
        ent:Spawn()
    end

    ent:SetRenderMode(data.RenderMode or RENDERMODE_NORMAL)
    ent:SetColor(data.Color or Color(255, 255, 255, 255))

    -- OLD DATA
    if data.EntityMods ~= nil and istable(data.EntityMods) then
        if data.EntityMods.material then
            ent:SetMaterial(data.EntityMods.material["MaterialOverride"] or "")
        end

        if data.EntityMods.colour then
            ent:SetColor(data.EntityMods.colour.Color or Color(255, 255, 255, 255))
        end
    end

    if data.DT then
        for k, v in pairs(data.DT) do
            if (data.DT[k] == nil) then continue end
            if not isfunction(ent["Set" .. k]) then continue end
            ent["Set" .. k](ent, data.DT[k])
        end
    end

    if data.BodyG then
        for k, v in pairs(data.BodyG) do
            ent:SetBodygroup(k, v)
        end
    end

    if data.SubMat then
        for k, v in pairs(data.SubMat) do
            if type(k) ~= "number" or type(v) ~= "string" then continue end
            ent:SetSubMaterial(k - 1, v)
        end
    end

    if data.Frozen ~= nil then
        local phys = ent:GetPhysicsObject()

        if phys and phys:IsValid() then
            phys:EnableMotion(not data.Frozen)
        end
    end

    function ent:CanTool(ply, trace, tool)
        if trace and IsValid(trace.Entity) and trace.Entity.PermaProps then
            if tool == "permaprops" then return true end

            return PermaProps.HasPermission(ply, "Tool")
        end
    end

    return ent
end

local distance, step, area = 600, 30, Vector(16, 16, 64)
local north_vec, east_vec, up_vec = Vector(0, 0, 0), Vector(0, 0, 0), Vector(0, 0, 0)

function ROOKI:is_empty(vector, ignore)
    local point = util.PointContents(vector)
    local a = point ~= CONTENTS_SOLID and point ~= CONTENTS_MOVEABLE and point ~= CONTENTS_LADDER and point ~= CONTENTS_PLAYERCLIP and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end
    local ents_found = ents.FindInSphere(vector, 35)

    for i = 1, #ents_found do
        local v = ents_found[i]
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and v ~= ignore then return false end
    end

    return true
end

function ROOKI:find_empty_pos(pos, ignore)
    if ROOKI:is_empty(pos, ignore) and ROOKI:is_empty(pos + area, ignore) then return pos end

    for j = step, distance, step do
        for i = -1, 1, 2 do
            local k = j * i
            -- North/South
            north_vec.x = k
            if ROOKI:is_empty(pos + north_vec, ignore) and ROOKI:is_empty(pos + north_vec + area, ignore) then return pos + north_vec end
            -- East/West
            east_vec.y = k
            if ROOKI:is_empty(pos + east_vec, ignore) and ROOKI:is_empty(pos + east_vec + area, ignore) then return pos + east_vec end
            -- Up/Down
            up_vec.z = k
            if ROOKI:is_empty(pos + up_vec, ignore) and ROOKI:is_empty(pos + up_vec + area, ignore) then return pos + up_vec end
        end
    end

    return pos
end

hook.Add("onDarkRPWeaponDropped", "rooki_fix_drop", function(ply, ent)
    if (ent.CPPISetOwner and isfunction(ent.CPPISetOwner) and IsValid(ply)) then
        ent:CPPISetOwner(ply)
    end
end)