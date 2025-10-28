-- [!] ตาราง Config
-- [!] สิ้นสุด Config

-- [!!!] แก้ไข IP ใหม่ตรงนี้ [!!!]
local WEB_API_URL = "http://117.18.126.63:3000/api/update_full_status" -- <<< IP VPS (ใหม่)

local SKILL_INDICES = {
    ["Swiper"] = 10,
    ["Shelf Stocker"] = 5,
    ["Farming"] = 7
}

-- 🧩 ป้องกันไม่ให้สคริปต์นี้รันซ้ำ (สำคัญ!)
if getgenv()._CollectAndSendConnection then
    getgenv()._CollectAndSendConnection:Disconnect()
    -- print("[INFO] Disconnected old RunService connection.")
end

if getgenv()._IsCollecting then
    warn("[WARN] Script already running, skipping re-run.")
    return
end
getgenv()._IsCollecting = true

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local UI_upvr = require(game:GetService("ReplicatedStorage").Modules.Core.UI)
local RunService = game:GetService("RunService")

local function trim(s)
    return s:gsub("^%s*(.-)%s*$", "%1")
end

-- [!] แปลงข้อความเงินเป็นตัวเลข
local function cleanCurrencyToNumber(amount)
    if type(amount) ~= "string" then return nil end
    local only_digits = amount:gsub("%D", "")
    return tonumber(only_digits)
end

-- [!] ป้องกันการส่งซ้ำ
local isSending = false

-- [!] ฟังก์ชันรวบรวม + ส่งข้อมูล
local function CollectAndSendData()
    if isSending then return end
    isSending = true

    local skillsData = {}
    local SkillsFrame = PlayerGui:FindFirstChild("Skills")
        and PlayerGui.Skills:FindFirstChild("SkillsHolder")
        and PlayerGui.Skills.SkillsHolder:FindFirstChild("SkillsScrollingFrame")

    if SkillsFrame then
        for skillKey, skillIndex in pairs(SKILL_INDICES) do
            local SkillItem = SkillsFrame:GetChildren()[skillIndex]
            local SkillTextObject = SkillItem and SkillItem:FindFirstChild("SkillTitle")
            if SkillTextObject and SkillTextObject:IsA("TextLabel") then
                local rawText = SkillTextObject.Text
                local skillName, skillLevelString = rawText:match("([^:]+):%s*(%d+)")
                local skillLevel = tonumber(skillLevelString)
                if skillLevel then skillsData[trim(skillName)] = skillLevel end
            end
        end
    end

    local Money = UI_upvr.get("HandBalanceLabel", true)
    local BankMoney = UI_upvr.get("BankBalanceLabel", true)

    local uiWaitTimeout = 5
    local waitStart = os.clock()
    repeat task.wait() until (Money and Money.ContentText and Money.ContentText ~= "") or (os.clock() - waitStart > uiWaitTimeout)
    waitStart = os.clock()
    repeat task.wait() until (BankMoney and BankMoney.ContentText and BankMoney.ContentText ~= "") or (os.clock() - waitStart > uiWaitTimeout)

    local rawHandText = (Money and Money.ContentText) or "UI Error/Timeout"
    local rawBankText = (BankMoney and BankMoney.ContentText) or "UI Error/Timeout"

    local handAmount = cleanCurrencyToNumber(rawHandText)
    local bankAmount = cleanCurrencyToNumber(rawBankText)

    local serverName = "Unknown"
    if game.PlaceId == 104715542330896 then
        serverName = "Server 1"
    elseif game.PlaceId == 97556409405464 then
        serverName = "Server 2"
    end

    local dataToSend = {
        username = Player.Name,
        pc_name = getgenv().MY_CONFIG.PC_NAME,
        license_key = getgenv().MY_CONFIG.LICENSE_KEY,
        hand_money = handAmount,
        bank_money = bankAmount,
        skills = skillsData,
        server_name = serverName
    }

    local jsonString = HttpService:JSONEncode(dataToSend)
    local requestOptions = {
        Url = WEB_API_URL,
        Method = "POST",
        Body = jsonString,
        Headers = { ["Content-Type"] = "application/json" }
    }

    local success, response = pcall(function()
        request(requestOptions)
    end)

    if success then
        -- print("[REQUEST] SUCCESS: Sent update.")
    else
        -- warn("[REQUEST] ERROR: " .. tostring(response))
    end

    isSending = false
end

-- [!] ลูปหลักแบบป้องกันซ้ำ
local lastCheckTime = 0
local checkInterval = 5

getgenv()._CollectAndSendConnection = RunService.Stepped:Connect(function()
    local currentTime = os.clock()
    if currentTime - lastCheckTime >= checkInterval then
        CollectAndSendData()
        lastCheckTime = currentTime
    end
end)

print("[✅ SCRIPT ACTIVE] Data sender running every " .. checkInterval .. "s")
