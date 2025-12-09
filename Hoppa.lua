if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.spawn(function()
    task.wait(10)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TenPanelX/ConfigPT/refs/heads/main/AddV2.lua"))()
end)

task.spawn(function()
    task.wait(10)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TenPanelX/ConfigPT/refs/heads/main/BlackScreen.lua"))()
end)

getgenv().HermanosDevSetting = {
    Farming = {
        Job = "Shelf Stocker", -- Shelf Stocker, Cook, Janitor, Swiper, Fishing, Farming

        -- Cook
        Skillet = "Smart Select",
        BuySkillet = false,

        -- Janitor
        PaddleMode = "Nearest", -- Smart, Nearest
        Mop = "Smart Select",
        BuyMop = false,

        -- ATM Hacking
        HackTools = "Smart Select",
        HackToolsQuantity = 5,
        
        -- Fishing
        Rod = "Smart Select",
        Bait = "Smart Select",
        BaitQuantity = 10,
        FishAmount = 10,
        AutoSellFish = false,

        -- Vehicle
        VehicleType = "Bike", -- Bike, Car
        VehicleSpeed = 52,

        -- Auto Farm
        AutoFarm = true,
        AfkChecker = true,

        -- Deposit
        CashDeposit = 200,
        AutoDeposit = true
    },

    General = {
        HideName = true,
        AntiRagdoll = true,
        AntiKill = true,
        AutoRespawn = true,
    },
}
