local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")

local function waitForAnyTextChannel(timeoutSec)
    local t0 = os.clock()
    local container = TextChatService:FindFirstChild("TextChannels")
    if not container then
        local ok = pcall(function()
            container = TextChatService:WaitForChild("TextChannels", timeoutSec or 5)
        end)
        if not ok then return nil end
    end

    if TextChatService.ChatInputBarConfiguration then
        local target = TextChatService.ChatInputBarConfiguration.TargetTextChannel
        if target then return target end
    end

    local general = container:FindFirstChild("RBXGeneral")
    if general and general:IsA("TextChannel") then return general end

    for _, ch in ipairs(container:GetChildren()) do
        if ch:IsA("TextChannel") then return ch end
    end

    while os.clock() - t0 < (timeoutSec or 5) do
        local got
        local conn
        conn = container.ChildAdded:Connect(function(child)
            if child:IsA("TextChannel") then got = child end
        end)
        for _ = 1, 10 do
            if got then break end
            task.wait(0.1)
        end
        if conn then conn:Disconnect() end
        if got then return got end
    end
    return nil
end

local function sendChat(message)
    local okNew, where = pcall(function()
        local channel = waitForAnyTextChannel(5)
        if channel then
            channel:SendAsync(message)
            return "textchat"
        end
    end)
    if okNew then
        return true
    end

    local dcs = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
    local say = dcs and dcs:FindFirstChild("SayMessageRequest")
    if say then
        say:FireServer(message, "All")
        return true
    end

    StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = message,
        Color = Color3.fromRGB(200, 200, 200)
    })
    return false
end

local messageSets = {
    {
        "Hi bro"
    },
    {
        "pls give me ak"
    },
    {
        "can u help me grinding"
    },
    {
        "u griding alone right ?"
    },
    {
        "for reallll"
    },
    {
        "Bye byee!!"
    }
}

while true do
    for _, set in ipairs(messageSets) do
        for _, msg in ipairs(set) do
            sendChat(msg)
            task.wait(8)
        end
        task.wait(1) 
    end
    task.wait(60)
end
