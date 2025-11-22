-- version 0.2
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local url = "https://pastebin.com/raw/yXFiMPN3"

-- โหลดรายชื่อ username จาก Pastebin
local function loadAllowedNames()
    local list = {}

    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success and response then
        for line in string.gmatch(response, "[^\r\n]+") do
            local name = line:match("^%s*(.-)%s*$")
            if name ~= "" then
                list[name] = true
            end
        end
    end

    return list
end


task.spawn(function()
    while true do
        local allowedNames = loadAllowedNames()

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                -- อยู่ในลิสต์?
                if allowedNames[player.Name] then

                    -- ถ้าเป็นเพื่อนอยู่แล้ว → ข้าม
                    if LocalPlayer:IsFriendsWith(player.UserId) then
                        print("[FriendRequest] Skip (already friends):", player.Name)
                    else
                        print("[FriendRequest] Sending to:", player.Name)
                        pcall(function()
                            LocalPlayer:RequestFriendship(player)
                        end)
                        task.wait(0.25)
                    end

                end
            end
        end

        print("AddedV2")
        task.wait(30)
    end
end)
