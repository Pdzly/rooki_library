hook.Add("ROOKI_load_prio_register", "rooki_loadutils_library", function()
    rookiutil.new("Rooki Utils", {
        {
            Autoload = true, -- Ob es automatisch CL, SH und SV erkennen soll muss natürlich genormt sein deswegen!
            Path = "rooki_library", -- Jaaa hmmm........ zur relation von lua/
            Realm = ROOKI.realms.ROOKI_CLIENT -- Ist beim Autoload "useless" 
        },
    }, {
        Active = true
    })
end)

hook.Add("ROOKI_load_prio_register", "rooki_loadutilsscp", function()
    rookiutil.new("SCP Utils", {
        {
            Autoload = true, -- Ob es automatisch CL, SH und SV erkennen soll muss natürlich genormt sein deswegen!
            Path = "scp_utils", -- Jaaa hmmm........ zur relation von lua/
            Realm = ROOKI.realms.ROOKI_CLIENT -- Ist beim Autoload "useless" 
        },
    }, {
        Active = true
    })
end)