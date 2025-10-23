repeat
    task.wait()
until game:IsLoaded()

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
        ["Enabled"] = true,
        ["Count Over"] = 20,
        ["Time"] = 10
    },
    ["OBSEAO!2124S"] = true -- ตีกันเองไหม
}
