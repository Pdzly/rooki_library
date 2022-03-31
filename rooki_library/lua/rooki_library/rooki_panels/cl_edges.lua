function ROOKI.DrawEdges(x, y, width, height, edgeSize, edgeWidth, edgedata)
    if (not edgedata) then
        edgedata = {
            rt = true,
            lt = true,
            rb = true,
            lb = true,
        }
    end

    if (not edgeSize) then
        edgeSize = 1
    end

    if (not edgeWidth) then
        edgeWidth = 1
    end

    --Draw the upper left corner.
    if (not edgedata or edgedata.lt) then
        surface.SetDrawColor(217, 217, 217)
        surface.DrawRect(x, y, edgeSize, edgeWidth)
        surface.DrawRect(x, y + edgeWidth, edgeWidth, edgeSize - edgeWidth)
    end

    local XRight = x + width

    --Draw the upper right corner.
    if (not edgedata or edgedata.rt) then
        surface.SetDrawColor(217, 217, 217)
        surface.DrawRect(XRight - edgeSize, y, edgeSize, edgeWidth)
        surface.DrawRect(XRight - edgeWidth, y + edgeWidth, edgeWidth, edgeSize - edgeWidth)
    end

    local YBottom = y + height

    --Draw the lower right corner.
    if (not edgedata or edgedata.rb) then
        surface.SetDrawColor(217, 217, 217)
        surface.DrawRect(XRight - edgeSize, YBottom - edgeWidth, edgeSize, edgeWidth)
        surface.DrawRect(XRight - edgeWidth, YBottom - edgeSize, edgeWidth, edgeSize - edgeWidth)
    end

    --Draw the lower left corner.
    if (not edgedata or edgedata.lb) then
        surface.SetDrawColor(217, 217, 217)
        surface.DrawRect(x, YBottom - edgeWidth, edgeSize, edgeWidth)
        surface.DrawRect(x, YBottom - edgeSize, edgeWidth, edgeSize - edgeWidth)
    end
end

function ROOKI.DrawBG(x, y, w, h)
    surface.SetDrawColor(Color(50, 50, 50, 200))
    surface.DrawRect(x, y, w, h)
    surface.SetDrawColor(Color(255, 255, 255, 50))
    surface.DrawOutlinedRect(x, y, w, h)
    surface.SetDrawColor(Color(255, 255, 255, 120))
    surface.DrawOutlinedRect(x, y, w, h)
end