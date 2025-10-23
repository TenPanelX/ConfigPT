repeat
    task.wait()
until game:IsLoaded()

getgenv().Configs = {
    ["Auto Farm"] = true,
    ["Bank Deposit"] = 100,
    ["Display UI"] = true,
    ["Disable Key"] = "G",

    ["FpsCap"] = {
        ["Enabled"] = false,
        ["FpsCap"] = 20,
    },

    ["Hop"] = {
        ["Enabled"] = true,
        ["Count Over"] = 6,
        ["Time"] = 10
    }
}
