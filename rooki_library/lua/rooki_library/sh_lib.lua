ROOKI = ROOKI or {}

if (SERVER) then
    NOTIFY_GENERIC = 0
    NOTIFY_ERROR = 1
    NOTIFY_UNDO = 2
    NOTIFY_HINT = 3
    NOTIFY_CLEANUP = 4

    util.AddNetworkString("rooki_do_notify")
end

local ply = FindMetaTable("Player")

function ply:DoNotify(text, nochat, legacy, length, typ)
    if (not text) then return false end

    if (legacy and type(typ) ~= TYPE_NUMBER) then
        typ = NOTIFY_GENERIC
    end

    if (SERVER) then
        net.Start("rooki_do_notify")
        net.WriteString(text)
        net.WriteBool(nochat == true)
        net.WriteBool(legacy == true)
        net.WriteUInt(length or 5, 32)
        net.WriteUInt(typ or 1, 4)
        net.Send(self)
    else
        if (not nochat) then
            chat.AddText(text)
        end

        if (legacy) then
            notification.AddLegacy(text, typ, length)
        end
    end
end

net.Receive("rooki_do_notify", function()
    local txt = net.ReadString()
    local nochat = net.ReadBool()
    local legacy = net.ReadBool()
    local length = net.ReadUInt(32)
    local typ = net.ReadUInt(4)
    LocalPlayer():DoNotify(txt, nochat, legacy, length, typ)
end)

function ROOKI:ParseTimeToMinSec(time)
    local tmp = time
    local s = tmp % 60
    tmp = math.floor(tmp / 60)
    local m = tmp % 60
    tmp = math.floor(tmp / 60)

    return string.format("%02im %02is", w, d, h, m, s)
end