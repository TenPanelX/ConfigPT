-- Private Script Block Spin
print("KaitunUI Checking, Install...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

local WAIT_TIME = 200

local function checkFrameVisible()
    local core = game:GetService("CoreGui")
    local screenGui = core:FindFirstChild("ScreenGui")
    if not screenGui then return false end
    local main = screenGui:FindFirstChild("Main")
    if not main then return false end
    return main.Visible == true
end

while true do
    task.wait(WAIT_TIME)
    if checkFrameVisible() then
        warn("Main UI Visible = true")
    else
        warn("Main UI not found or not visible, rejoining...")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end
