repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local url = "https://pastebin.com/raw/yXFiMPN3"

local function loadAllowedUserIds()
    local allowed = {}

    -- โหลดรายชื่อจาก pastebin
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        for line in string.gmatch(response, "[^\r\n]+") do
            local username = line:match("^%s*(.-)%s*$") -- trim
            if username and username ~= "" then
                local ok, userId = pcall(function()
                    return Players:GetUserIdFromNameAsync(username)
                end)

                if ok and userId then
                    allowed[userId] = true
                end
            end
        end
    end

    return allowed
end


task.spawn(function()
    while task.wait() do
        
        -- โหลด whitelist ใหม่ทุกครั้ง (อัพเดตตลอด)
        local allowedUserIds = loadAllowedUserIds()

        -- ส่งแอดเพื่อนเฉพาะคนที่อยู่ในลิสต์
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if allowedUserIds[player.UserId] then
                    print("Sending friend request to:", player.Name)
                    LocalPlayer:RequestFriendship(player)
                    task.wait(0.25)
                end
            end
        end

        -- รอ 60 วินาทีแล้วทำใหม่
        task.wait(60)
    end
end)
