repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    while task.wait() do
        for _, player in pairs(Players:GetPlayers()) do
            LocalPlayer:RequestFriendship(player)
            task.wait(0.25)
        end
        task.wait(60)
    end
end)
