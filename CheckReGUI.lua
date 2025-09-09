local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")

local WAIT_TIME = 90

local function checkWindowVisible()
    local reGui = game:GetService("CoreGui"):FindFirstChild("ReGui")
    if not reGui then return false end
    local windows = reGui:FindFirstChild("Windows")
    if not windows then return false end
    local window = windows:FindFirstChild("Window")
    if not window then return false end
    return window.Visible == true
end

local elapsed = 0
local interval = 1

while not checkWindowVisible() and elapsed < WAIT_TIME do
    warn(string.format("Rejoin in %d Sec", WAIT_TIME - elapsed))
    wait(interval)
    elapsed = elapsed + interval
end

if not checkWindowVisible() then
    warn("Rejoining...")
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end
