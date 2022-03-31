local FRAME = {}

function FRAME:Init()
    self.topbar = vgui.Create("Panel", self)
    self.topbar:Dock(TOP)

    self.topbar.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(3, 0, 0, w, h, ROOKI.GetColor("bgdark", Color(0, 0, 0)), true, true, false, false)
    end

    self.title = vgui.Create("DLabel", self.topbar)
    self.title:Dock(LEFT)
    self.title:DockMargin(15, 5, 0, 0)
    self.title:SetFont(imgui.xFont("!Roboto@" .. ScrW() * 0.025))
    self.title:SetTextColor(Color(255, 0, 0))
    self.closeBtn = vgui.Create("DButton", self.topbar)
    self.closeBtn:Dock(RIGHT)
    self.closeBtn:DockMargin(0, 12, 0, 0)
    self.closeBtn:SetText("")
    self.closeBtn.CloseButton = Color(195, 195, 195)
    self.closeBtn.Alpha = 0

    self.closeBtn.DoClick = function(pnl)
        self:Remove()
    end

    self.closeBtn.Paint = function(pnl, w, h)
        local txts = ROOKI:getFontSize( imgui.xFont("!Roboto@" .. self.topbar:GetTall() - 15), "X")
        draw.RoundedBox(5, 0, 0, txts[2] - 10, txts[2] - 10, Color(30, 30, 30))

        if self.closeBtn:IsHovered() then
            draw.RoundedBox(5, 0, 0, txts[2] - 10,txts[2] - 10, Color(18, 18, 18))
        end

        draw.DrawText("X", imgui.xFont("!Roboto@" .. self.topbar:GetTall() - 15), w / 2 - 10, -5, Color(245, 0, 0), TEXT_ALIGN_CENTER)
    end

    self.panel = vgui.Create("ROOKI.Panel", self)
    self.panel:Dock(FILL)
    self:SetSize(ScrW() * 0.5, ScrH() * 0.5)
end

function FRAME:SetTitle(str)
    self.title:SetText(str)
    self.title:SizeToContents()
end

function FRAME:PerformLayout(w, h)
    self.topbar:SetTall(ScrH() * 0.05)
    self.closeBtn:SetWide(self.topbar:GetTall() - 10)
    self.closeBtn:SetTall(self.topbar:GetTall() - 10)
    self.title:SetWide(self.topbar:GetWide())
end

function FRAME:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(20, 20, 20), true, true, false, false)
end

function FRAME:SetCorners(lt, rt, lb, rb)
    self.panel:SetCorners(lt, rt, lb, rb)

    return self.panel.corners
end

function FRAME:SetCornerWidth(width)
    self.panel:SetCornerWidth(width)

    return self.panel.cwidth
end

function FRAME:SetCornerSize(size)
    self.panel:SetCornerSize(size)

    return self.panel.csize
end

function FRAME:ShowCloseButton(show)
    self.closeBtn:SetVisible(show)
end

vgui.Register("ROOKI.Frame", FRAME, "EditablePanel")

function ROOKI:TestFrame()
    self = vgui.Create("ROOKI.Frame")
    self:Center()
    self:SetTitle("ROOKI TEST")
    self:SetCorners(true)
    self:MakePopup()
end

concommand.Add("test_rooki_frame", function()
    ROOKI:TestFrame()
end)