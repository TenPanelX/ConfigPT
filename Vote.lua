    local LocalPlayer = game.Players.LocalPlayer;
    local PlayerGui = LocalPlayer.PlayerGui;
    local GuiService = game:GetService('GuiService');
    local CFrameCheck = CFrame.new(-13083.48828125, 601.469970703125, -443.3150634765625)

    while task.wait(0.03) do 
        local result,Error = pcall(function()
            if PlayerGui.MainUI.Frames.Voting.Visible then 
                if LocalPlayer:DistanceFromCharacter(CFrameCheck.Position) <= 500 then 
                    local args = {
                        [1] = "Medium"
                    }
                    
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.VotingService.RF.Vote:InvokeServer(unpack(args))
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_knit@1.7.0").knit.Services.VotingService.RF.Start:InvokeServer()
                end;
            end;
        end)
    end;
