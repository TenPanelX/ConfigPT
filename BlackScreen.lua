if not game:IsLoaded() then
    game.Loaded:Wait()
end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- 1. สร้าง GUI (จอดำ)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Auto_AFK_BlackScreen"
screenGui.IgnoreGuiInset = true

-- พยายามใส่ใน CoreGui เพื่อให้บังทับทุกอย่าง
pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- สีดำสนิท
blackFrame.BorderSizePixel = 0
blackFrame.ZIndex = 99999 -- อยู่บนสุด
blackFrame.Visible = true -- **ตั้งเป็น true เพื่อให้เริ่มมาแสดงผลเลย**
blackFrame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.1, 0)
label.Position = UDim2.new(0, 0, 0.45, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.TextSize = 24
label.Text = "AFK Mode: ON (Press G to toggle)"
label.Parent = blackFrame

-- 2. กำหนดสถานะเริ่มต้นเป็น TRUE (ทำงานทันที)
local isAfk = true

-- 3. ฟังก์ชันอัปเดตสถานะ (ใช้สำหรับทั้งตอนเริ่มและตอนกดปุ่ม)
local function updateState()
    blackFrame.Visible = isAfk -- ถ้า AFK จริง ให้โชว์จอดำ
    
    -- สั่งหยุด/เปิด Rendering (ใช้ pcall ดักทั้งสองชื่อคำสั่ง)
    pcall(function()
        RunService:Set3dRenderingEnabled(not isAfk)
    end)
    pcall(function()
        RunService:Set3dRenderEnabled(not isAfk)
    end)
end

-- 4. สั่งให้ทำงานรอบแรกทันทีที่รันสคริปต์
updateState()

-- 5. ตั้งค่าปุ่มกด G
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        isAfk = not isAfk -- สลับค่า True/False
        updateState() -- อัปเดตการทำงาน
    end
end)

-- แจ้งเตือนมุมขวาล่าง
game.StarterGui:SetCore("SendNotification", {
    Title = "Auto AFK",
    Text = "Script Started! (Press G to toggle)",
    Duration = 3,
})
