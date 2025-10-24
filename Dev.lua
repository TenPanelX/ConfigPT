repeat
    task.wait()
until game:IsLoaded()

task.spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TenPanelX/ConfigPT/refs/heads/main/Addfriend.lua"))()
end)

getgenv().Configs = {
    ["Auto Farm"] = true,
    ["Bank Deposit"] = 10,
    ["Display UI"] = true,
    ["Disable Key"] = "G",

    ["FpsCap"] = {
        ["Enabled"] = false,
        ["FpsCap"] = 20,
    },

    ["Hop"] = {
        ["Enabled"] = false,
        ["Count Over"] = 20,
        ["Time"] = 10
    },
    ["OBSEAO!2124S"] = true -- ตีกันเองไหม
}
