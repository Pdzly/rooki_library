ROOKI = ROOKI or {}
draw = draw or {}

function ROOKI:getFontSize(fontname, txt)
    surface.SetFont(fontname)

    return {surface.GetTextSize(txt)}
end

function draw.SimpleTextShadow(text, font, x, y, color, xalign, yalign, shadowcolor, size)
    if (not shadowcolor) then
        shadowcolor = Color(0, 0, 0)
    end

    draw.SimpleText(text, font, x, y, color, xalign, yalign)
    draw.SimpleText(text, font, x + size, y + size, shadowcolor, xalign, yalign)
end