ROOKI = ROOKI or {}
ROOKI.themes = {}
ROOKI.activeTheme = {}

ROOKI.defaultTheme = {
    gray = Color(58, 58, 58),
    white = Color(250, 250, 250),
    black = Color(31, 31, 31),
    bgdark = Color(44, 44, 44),
    bggray = Color(58, 58, 58),
    bglight = Color(211, 211, 211),
    btn_accept = Color(38, 255, 0),
    btn_decline = Color(255, 0, 0),
    btn = Color(90, 90, 90),
}

function ROOKI.AddTheme(themeopts)
    if (not themeopts) then return false end
end

function ROOKI.GetTheme()
    return table.Merge(ROOKI.activeTheme, ROOKI.defaultTheme)
end

function ROOKI.GetColor(name, fallback)
    if (not fallback) then
        fallback = ROOKI.defaultTheme["black"]
    end

    return table.Merge(ROOKI.activeTheme, ROOKI.defaultTheme)[name] or fallback
end