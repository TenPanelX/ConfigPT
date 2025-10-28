getgenv().MY_CONFIG = {
    PC_NAME = "PC",
    LICENSE_KEY = "LICENSE_KEY_FOR_SfjL2p0stDJp4NpV"
}

-- [!!!] แก้ไข IP ใหม่ตรงนี้ [!!!]
local WEB_API_URL = "http://117.18.126.63:3000/api/update_full_status" -- <<< IP VPS (ใหม่)

local SKILL_INDICES = {
    ["Swiper"] = 10,
    ["Shelf Stocker"] = 5,
    ["Farming"] = 7
}

local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local HttpService = game:GetService("HttpService")
local UI_upvr = require(game:GetService("ReplicatedStorage").Modules.Core.UI)

local function trim(s) return s:gsub("^%s*(.-)%s*$", "%1") end

-- [!] แก้ไข cleanCurrencyToNumber + Debug Print ภายใน
local function cleanCurrencyToNumber(amount)
    if type(amount) ~= "string" then
        -- print("[CLEAN DEBUG] Input is not a string:", amount)
        return nil
    end
    -- print("[CLEAN DEBUG] Original:", amount)

    -- Step 1: ลบทุกอย่างที่ไม่ใช่ตัวเลข (รวมถึง $, , และตัวอักษรอื่นๆ)
    -- %D คือ "non-digit character"
    local only_digits = amount:gsub("%D", "")
    -- print("[CLEAN DEBUG] After removing non-digits:", only_digits)

    -- Step 2: แปลงเป็นตัวเลข
    local final_number = tonumber(only_digits)
    -- print("[CLEAN DEBUG] Final number:", final_number)

    -- ตรวจสอบว่าแปลงสำเร็จหรือไม่
    if final_number == nil then
        -- print("[CLEAN DEBUG] ERROR: tonumber failed!")
    end

    return final_number
end


-- [!] ฟังก์ชันเดียวสำหรับรวบรวมและส่งข้อมูลทั้งหมด
local function CollectAndSendData()

    -- 1. รวบรวมข้อมูล Skill (เหมือนเดิม)
    local skillsData = {}
    local SkillsFrame = PlayerGui:FindFirstChild("Skills") and PlayerGui.Skills:FindFirstChild("SkillsHolder") and PlayerGui.Skills.SkillsHolder:FindFirstChild("SkillsScrollingFrame")
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

    -- 2. รวบรวมข้อมูลเงิน (เรียกใช้ cleanCurrencyToNumber ที่แก้ไขแล้ว)
    local Money = UI_upvr.get("HandBalanceLabel", true)
    local BankMoney = UI_upvr.get("BankBalanceLabel", true)

    -- รอ UI ให้พร้อม (สำคัญ!)
    local uiWaitTimeout = 5 -- รอสูงสุด 5 วินาที
    local waitStart = os.clock()
    repeat task.wait() until (Money and Money.ContentText and Money.ContentText ~= "") or (os.clock() - waitStart > uiWaitTimeout)
    waitStart = os.clock() -- รีเซ็ตเวลา
    repeat task.wait() until (BankMoney and BankMoney.ContentText and BankMoney.ContentText ~= "") or (os.clock() - waitStart > uiWaitTimeout)

    local rawHandText = "UI Error/Timeout"
    local rawBankText = "UI Error/Timeout"
    if Money and Money.ContentText then rawHandText = Money.ContentText end
    if BankMoney and BankMoney.ContentText then rawBankText = BankMoney.ContentText end

    -- print("[DEBUG] Raw Hand Text:", rawHandText) -- Debug หลัก
    local handAmount = cleanCurrencyToNumber(rawHandText) -- เรียกใช้ฟังก์ชันที่ปรับปรุงแล้ว
    -- print("[DEBUG] Cleaned Hand Amount:", handAmount) -- Debug หลัก

    -- print("[DEBUG] Raw Bank Text:", rawBankText) -- Debug หลัก
    local bankAmount = cleanCurrencyToNumber(rawBankText) -- เรียกใช้ฟังก์ชันที่ปรับปรุงแล้ว
    -- print("[DEBUG] Cleaned Bank Amount:", bankAmount) -- Debug หลัก


    -- 3. ตรวจสอบ Server (เหมือนเดิม)
    local serverName = "Unknown"
    if game.PlaceId == 104715542330896 then serverName = "Server 1"
    elseif game.PlaceId == 97556409405464 then serverName = "Server 2" end

    -- 4. สร้าง Payload (เหมือนเดิม)
    local dataToSend = {
        username = Player.Name,
        pc_name = getgenv().MY_CONFIG.PC_NAME,
        license_key = getgenv().MY_CONFIG.LICENSE_KEY,
        hand_money = handAmount, -- ค่าที่แปลงแล้ว (ควรจะถูกต้อง)
        bank_money = bankAmount, -- ค่าที่แปลงแล้ว (ควรจะถูกต้อง)
        skills = skillsData,
        server_name = serverName
    }

    -- 5. ส่ง Request (เหมือนเดิม)
    local jsonString = HttpService:JSONEncode(dataToSend)
    local requestOptions = { Url = WEB_API_URL, Method = "POST", Body = jsonString, Headers = { ["Content-Type"] = "application/json" } }
    local success, response = pcall(function() request(requestOptions) end)

    if success then print("[REQUEST] SUCCESS: Sent update.")
    else -- print("[REQUEST] ERROR: " .. tostring(response)) end
end

-- ลูปหลัก (เหมือนเดิม)
local lastCheckTime = 0
local checkInterval = 10
game:GetService("RunService").Stepped:Connect(function()
    local currentTime = os.clock()
    if currentTime - lastCheckTime >= checkInterval then
        CollectAndSendData()
        lastCheckTime = currentTime
    end
end)
