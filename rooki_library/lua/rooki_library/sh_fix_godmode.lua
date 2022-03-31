if CLIENT then
    local meta = FindMetaTable("Player")

    function meta:HasGodMode()
        return self:GetNWBool("HasGodMode")
    end
end

if SERVER then
    local meta = FindMetaTable("Player")
    meta.DefaultGodEnable = meta.DefaultGodEnable or meta.GodEnable
    meta.DefaultGodDisable = meta.DefaultGodDisable or meta.GodDisable

    function meta:GodEnable()
        self:SetNWBool("HasGodMode", true)
        self:DefaultGodEnable()
    end

    function meta:GodDisable()
        self:SetNWBool("HasGodMode", false)
        self:DefaultGodDisable()
    end
end