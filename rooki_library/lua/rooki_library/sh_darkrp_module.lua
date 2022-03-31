ROOKI = ROOKI or {}
local ply = FindMetaTable("Player")

function ply:getJob()
    if (self.getJobTable and isfunction(self.getJobTable)) then return self:getJobTable() or {} end
    return false
end

function ply:getJobName()
    if (self.getJobTable and isfunction(self.getJobTable)) then return self:getJobTable().name or "" end
    return false
end

function ply:getCategory()
    if (self.getJobTable and isfunction(self.getJobTable)) then return self:getJobTable().name or "" end
    return false
end