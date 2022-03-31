ROOKI = ROOKI or {}
local ply = FindMetaTable("Player")

function ply:IsSCP()
    local job = self:getJobTable()

    return job.isSCP == true
end

function ply:GetSCP()
    local job = self:getJobTable()
    if (self:IsSCP()) then return job.SCP end

    return false
end

ROOKI.breakdoor = ROOKI.breakdoor or {}

ROOKI.breakdoor.config = {
    respawn = true,
    respawntime = 60,
    openonrespawn = false
}

local breakable_classes = {
    ["prop_door_rotating"] = true,
    ["func_door_rotating"] = true,
    ["prop_dynamic"] = true,
    ["prop_physics"] = true,
    ["func_door"] = true,
}

function ROOKI.isBreakableEntity(ent)
    return breakable_classes[ent:GetClass()]
end

local no_debris_classes = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
}

local breaked_entities = {}

function ROOKI.breakEntity(ent, velocity)
    if IsValid(ent.ROOKI_PHYS) then return false end
    if ent.ROOKI_PHYS_BASE then return false end --  avoid to break already broken entities

    if not no_debris_classes[ent:GetClass()] then
        local phys_ent = ents.Create("prop_physics")
        phys_ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        phys_ent:SetPos(ent:GetPos() + velocity:GetNormal() * 25)
        phys_ent:SetAngles(ent:GetAngles())
        phys_ent:SetModel(ent:GetModel())
        phys_ent:SetSkin(ent:GetSkin())
        phys_ent:Spawn()
        phys_ent:EmitSound(("physics/metal/metal_box_break%d.wav"):format(math.random(1, 2)))

        if velocity then
            local phys = phys_ent:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetVelocity(velocity)
            end

            util.ScreenShake(phys_ent:GetPos(), 10, velocity:Length(), 2, 500)
        end

        --  sparks effect
        if IsFirstTimePredicted() then
            local effect = EffectData()
            effect:SetOrigin(phys_ent:GetPos() + phys_ent:OBBCenter())
            effect:SetMagnitude(5)
            effect:SetScale(2.5)
            effect:SetRadius(5)
            util.Effect("Sparks", effect, true, true)
        end

        phys_ent.ROOKI_PHYS_BASE = ent
        ent.ROOKI_PHYS = phys_ent
    end

    if (ROOKI.breakdoor.config.openonrespawn) then
        ent:Fire("Open", 0)
        ent:Fire("UnLock", 0)
    end

    ent:Extinguish()
    ent:SetNoDraw(true)
    ent:SetNotSolid(true)
    breaked_entities[ent] = true

    --  auto-respawn
    if ROOKI.breakdoor.config.respawn then
        timer.Simple(ROOKI.breakdoor.config.respawntime, function()
            if IsValid(ent) then
                ROOKI.repairEntity(ent)
            end
        end)
    end

    return true
end

function ROOKI.repairEntity(ent)
    ent:SetNoDraw(false)
    ent:SetNotSolid(false)

    --  remove physics ent
    if IsValid(ent.ROOKI_PHYS) then
        ent.ROOKI_PHYS:Remove()
        ent.ROOKI_PHYS = nil
    end

    breaked_entities[ent] = nil
end

function ROOKI.breakEntitiesAtPlayerTrace(pl, break_force)
    break_force = break_force or 1
    local count = 0
    local tr = IsValid(pl) and pl:GetEyeTrace() or pl

    for i, v in ipairs(ents.FindInSphere(tr.HitPos, 32)) do
        if ROOKI.isBreakableEntity(v) and ROOKI.breakEntity(v, tr.Normal * break_force) then
            count = count + 1
        end
    end

    return count
end

hook.Add("ShouldCollide", "rooki_nocolide", function(ent1, ent2)
    if (IsValid(ent1) and ent1:IsPlayer()) then
        if ent1:GetActiveWeapon():GetNWBool("rooki_nocolide", false) then return false end
    end

    if (IsValid(ent2) and ent2:IsPlayer()) then
        if ent2:GetActiveWeapon():GetNWBool("rooki_nocolide", false) then return false end
    end
end)