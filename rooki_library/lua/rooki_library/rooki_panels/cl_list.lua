local bc = baseclass.Get( "ROOKI.Panel" )
local FRAME = {}

function FRAME:Init()
    bc.Init(self)

    self.Rows = {}
    self.Columns = {}
end

function FRAME:SetTitle(str)
    self.title:SetText(str)
    self.title:SizeToContents()
end

function FRAME:Paint(w, h)
    draw.RoundedBoxEx(3,  0, 0, w, h, Color(20, 20, 20), true, true, false, false)
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

vgui.Register("ROOKI.List", FRAME, "ROOKI.Panel")

function ROOKI:TestFrame()
    self = vgui.Create("ROOKI.Frame")
    self:Center()
    self:SetTitle("ROOKI TEST")
    self:MakePopup()
end

concommand.Add("test_rooki_list", function()
    ROOKI:TestFrame()
end)