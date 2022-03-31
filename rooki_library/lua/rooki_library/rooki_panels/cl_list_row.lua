local bc = baseclass.Get( "ROOKI.Panel" )
local FRAME = {}

function FRAME:Init()
    bc.Init(self)

    self.Rows = {}
    self.Columns = {}
end


function FRAME:SetCorners(lt, rt, lb, rb)
    bc.SetCorners(self, lt, rt, lb, rb)

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

vgui.Register("ROOKI.ListRow", FRAME, "ROOKI.Panel")

function ROOKI:TestFrame()
    self = vgui.Create("ROOKI.Frame")
    self:Center()
    self:SetTitle("ROOKI TEST")
    self:MakePopup()
end

concommand.Add("test_rooki_listrow", function()
    ROOKI:TestFrame()
end)