local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

local WAIT_TIME = 200

local function checkFrameVisible()
    local core = game:GetService("CoreGui")
    local gui = core:FindFirstChild("RobloxGui")
    if not gui then return false end
    local windUI = gui:FindFirstChild("WindUI")
    if not windUI then return false end
    local window = windUI:FindFirstChild("Window")
    if not window then return false end
    local frame = window:FindFirstChild("Frame")
    if not frame then return false end
    return frame.Visible == true
end

while true do
    task.wait(WAIT_TIME)
    if checkFrameVisible() then
        warn("WindUI Visible = true")
    else
        warn("WindUI not found or not visible, rejoining...")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end
