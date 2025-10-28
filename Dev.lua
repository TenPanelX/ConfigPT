repeat
    task.wait()
until game:IsLoaded()

task.spawn(function()
    task.wait(120)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TenPanelX/ConfigPT/refs/heads/main/ClickButton.lua"))()
end)

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TenPanelX/ConfigPT/refs/heads/main/Addfriend.lua"))()
end)

getgenv().Configs = {
    ["Auto Farm"] = true,
    ["Bank Deposit"] = 20,
    ["Display UI"] = true,
    ["Disable Key"] = "G",

    ["FpsCap"] = {
        ["Enabled"] = false,
        ["FpsCap"] = 20,
    },

    ["Hop"] = {
        ["Enabled"] = true,
        ["Count Over"] = 15,
        ["Time"] = 10
    },
    ["OBSEAO!2124S"] = true -- ตีกันเองไหม
}
