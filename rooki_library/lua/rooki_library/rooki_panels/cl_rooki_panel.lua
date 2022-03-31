local FRAME = {}

function FRAME:Init()
    self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
    self.cwidth = 5
    self.csize = 15
    self.corners = false
end

function FRAME:PerformLayout(w, h)
end

function FRAME:PaintOver(w, h)
    if (self.corners == true) then
        surface.SetDrawColor(255, 255, 255)
        ROOKI.DrawEdges(0, 0, w, h, self.csize, self.cwidth)
    elseif (type(self.corners) == "table") then
        surface.SetDrawColor(255, 255, 255)
        ROOKI.DrawEdges(0, 0, w, h, self.csize, self.cwidth, self.corners)
    end
end

function FRAME:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20))
    self:PaintOver(w, h)
end

function FRAME:SetCorners(lt, rt, lb, rb)
    if (type(lt) == "boolean" and rt == nil and rb == nil and lb == nil) then
        self.corners = lt == true
    else
        if (type(rt) == "boolean" or type(lt) == "boolean" or type(rb) == "boolean" or type(lb) == "boolean") then
            self.corners = {
                lt = lt == true,
                rt = rt == true,
                lb = lb == true,
                rb = rb == true,
            }
        end
    end

    return self.corners
end

function FRAME:SetCornerWidth(width)
    self.cwidth = width or 1

    return self.cwidth
end

function FRAME:SetCornerSize(size)
    self.csize = size or 1

    return self.csize
end

vgui.Register("ROOKI.Panel", FRAME, "EditablePanel")

function ROOKI:TestPanel()
    self = vgui.Create("ROOKI.Panel")
    self:Center()
    self:MakePopup()
end

concommand.Add("test_rooki_panel", function()
    ROOKI:TestPanel()
end)