ROOKI = ROOKI or {}
ROOKI.debug = true

ROOKI.realms = {
    ROOKI_CLIENT = 1,
    ROOKI_SHARED = 2,
    ROOKI_SERVER = 3
}

module("rookiutil", package.seeall)
local mt = {}
local methods = {}
mt.__index = methods
mt.modules = {}

local emptymodule = {
    Name = "Empty",
    Dirs = {
        {
            Autoload = true, -- Ob es automatisch CL, SH und SV erkennen soll muss natürlich genormt sein deswegen!
            Path = "ROOKI_testmodule", -- Jaaa hmmm........ zur relation von lua/
            Realm = ROOKI.realms.ROOKI_CLIENT -- Ist beim Autoload "useless" 
            
        }
    },
    Opts = {
        Active = true,
        NoConfig = false,
    }
}

local function rooki_print(text, level)
    if (not level) then
        level = 1
    end

    if (ROOKI.debug and level and level > 1) then
        print("ROOKI - Loader Debug | " .. text)
    elseif (not level or level == 1) then
        print("ROOKI - Loader | " .. text)
    elseif (not level or level < 1) then
        print(text)
    end
end

local function AddFile(File, dir, realm)
    local fileSide = string.lower(string.Left(File, 3))

    if (not realm) then
        if SERVER and fileSide == "sv_" then
            rooki_print(File .. " wird geladen....", 2)
            include(dir .. File)
        elseif fileSide == "sh_" then
            rooki_print(File .. " wird geladen....", 2)

            if SERVER then
                AddCSLuaFile(dir .. File)
            end

            include(dir .. File)
        elseif fileSide == "cl_" then
            rooki_print(File .. " wird geladen....", 2)

            if SERVER then
                AddCSLuaFile(dir .. File)
            elseif CLIENT then
                include(dir .. File)
            end
        end
    elseif (realm) then
        if SERVER and realm == ROOKI.realms.ROOKI_SERVER then
            rooki_print(File .. " wird geladen....", 2)
            include(dir .. File)
        elseif realm == ROOKI.realms.ROOKI_SHARED then
            rooki_print(File .. " wird geladen....", 2)

            if SERVER then
                AddCSLuaFile(dir .. File)
            end

            include(dir .. File)
        elseif realm == ROOKI.realms.ROOKI_CLIENT then
            rooki_print(File .. " wird geladen....", 2)

            if SERVER then
                AddCSLuaFile(dir .. File)
            elseif CLIENT then
                include(dir .. File)
            end
        end
    end
end

function LoadDir(dir, realm, opts)
    dir = dir .. "/"
    local File, Directory = file.Find(dir .. "*", "LUA")
    if (opts and not opts.Active) then return false, "Das Modul ist nicht Aktiv!" end
    rooki_print(dir .. " wird geladen....", 2)

    if (not realm) then
        if (opts and not opts.NoConfig) then
            for k, v in ipairs(File) do
                local d = string.find(v, "_config_")

                if string.EndsWith(v, ".lua") and d ~= nil then
                    AddFile(v, dir)
                    table.remove(File, k)
                end
            end
        end

        for k, v in ipairs(File) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir)
            end
        end

        for k, v in ipairs(Directory) do
            LoadDir(dir .. v, realm, opts)
        end
    elseif (realm) then
        if (opts and not opts.noconfig) then
            for k, v in ipairs(File) do
                local d = string.find(v, "_config_")

                if string.EndsWith(v, ".lua") and d ~= nil then
                    AddFile(v, dir, realm)
                    table.remove(File, k)
                end
            end
        end

        for k, v in ipairs(File) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir, realm)
            end
        end

        for k, v in ipairs(Directory) do
            LoadDir(dir .. v, realm)
        end
    end

    rooki_print(dir .. " wurde geladen....", 2)

    return true
end

function new(name, dir, opts)
    if (not name) then return false end

    if (not opts) then
        opts = {
            Active = true,
        }
    end

    local data = table.Inherit({
        Active = opts.Active or true,
        Name = name,
        Dirs = dir,
        Opts = opts
    }, emptymodule)

    table.insert(mt.modules, data)
    setmetatable(data, mt)
    rooki_print(data.Name .. " wurde registriert")

    return obj
end

function getall()
    return mt.modules
end

function mt:__tostring()
    return "Name: " .. self.Name
end

function mt:Deactivate()
    self.Active = false

    return true
end

function mt:Activate()
    self.Active = true

    return true
end

function mt:Remove()
    self.modules[self.Name] = nil
    self = nil

    return true
end

function StartLoading()
    rooki_print("Debug: " .. tostring(ROOKI.debug), 2)

    for _, v1 in ipairs(rookiutil.getall()) do
        rooki_print(v1.Name .. " wird geladen....")

        for k, v in ipairs(v1.Dirs) do
            if (v.Autoload) then
                local res, er = LoadDir(v.Path, nil, v.Opts)

                if (not res) then
                    rooki_print("Hinweis:" .. er)
                end
            else
                local res, er = LoadDir(v.Path, v.Realm, v.Opts)

                if (not res) then
                    rooki_print("Hinweis:" .. er)
                end
            end
        end

        rooki_print(v1.Name .. " wurde geladen!")
    end

    hook.Run("rooki_finished_loading")
end

hook.Add("PreGamemodeLoaded", "ROOKI_loader_register_start", function()
    hook.Run("ROOKI_load_prio_register")
    hook.Run("ROOKI_load_register")
    rooki_print("Module wurden registriert")
end)

hook.Add("Initialize", "ROOKI_loader_start", StartLoading)