MLIB = MLIB or {}

MLIB.Installed = true

MLIB.Verison = "v2.0.3"

WSG = {}

function MLIB.Print(...)
	MsgC(Color(225, 20, 30), "[MLIB - " ..MLIB.Verison.." ] ", Color(129, 225, 20), ..., "\n\r")
end

hook.Add("ROOKI_load_prio_register", "rooki_loadutils", function()
    rookiutil.new("Edge HUD Utils", {
        {
            Autoload = true, -- Ob es automatisch CL, SH und SV erkennen soll muss natürlich genormt sein deswegen!
            Path = "rooki_modules", -- Jaaa hmmm........ zur relation von lua/
            Realm = ROOKI.realms.ROOKI_CLIENT -- Ist beim Autoload "useless" 
        },
    }, {
        Active = true
    })
end)