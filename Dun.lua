
local StartCampPos = nil
local OldPlayerPos = nil
function handleRoom(room)
		local nearestEnemy = Collection:getNearestEnemy()
		local healthPercent = math.floor((LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health / LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth) * 100)
		local Mp = LocalPlayer.Character:GetAttribute("MP")
		local MaxMp = LocalPlayer.Character:GetAttribute("MaxMP")
		local MPPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
		RoomCheck = room
		Collection:CollectChest(room)
		if nearestEnemy then
			Collection:AutoEquipWeapon()
			justteleport = false 
			nearestEnemy = Collection:getNearestEnemy()
			OldPlayerPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
			print("StartRepeat")
			repeat
				task.wait()
				if LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then 
					TeleportService:Teleport(LobbyPlace, LocalPlayer)
					task.wait(2)
				end 
				healthPercent = math.floor((LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health / LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth) * 100)
				Mp = LocalPlayer.Character:GetAttribute("MP")
				MaxMp = LocalPlayer.Character:GetAttribute("MaxMP")
				MPPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
				Collection:CollectChest(room)
				if LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then 
					LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
				end 
				if not DontHeal and (healthPercent <= SaveSettings["Hp Regen Percent"] or MPPercent <= SaveSettings["MP Regen Percent"])  then
					if room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️" then 
						if room.ModelStreamingMode ~= "Persistent" then 
							room.ModelStreamingMode = "Persistent"
						end 
						local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
						local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
						local mpPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
						--Collection:TeleportTo(StartCampPos)
						LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = StartCampPos
						-- print("Recovery")
						local args = {
							[1] = "HP"
						}
		
						game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
	
						Collection:CollectChest(room)
	
						local args = {
							[1] = "MP"
						}
		
						game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
						justteleport = true 
	
						task.wait()
					else 
						repeat task.wait()
							local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
							local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
							local mpPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
							--Collection:TeleportTo(StartCampPos)
							LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = StartCampPos
							print("Recovery")
							local args = {
								[1] = "HP"
							}
		
							game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
	
							Collection:CollectChest(room)
	
							local args = {
								[1] = "MP"
							}
		
							game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
							justteleport = true 
	
							task.wait()
						until ( room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️") or (LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health >= LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth and tonumber(LocalPlayer.Character:GetAttribute("MP")) >= tonumber(LocalPlayer.Character:GetAttribute("MaxMP"))) 
							or _G.BreakAllFunction 
							or not SaveSettings["Auto Farm"]					
							justteleport = false 
					end 
						
				else
					if nearestEnemy then
						Collection:KillEnemyHandle(nearestEnemy,MPPercent)
					elseif not nearestEnemy and (healthPercent >= SaveSettings["Hp Regen Percent"] or MPPercent >= SaveSettings["MP Regen Percent"]) then
						--nearestEnemy = Collection:getNearestEnemy()
						print("Teleport%")
						if nearestEnemy then 
							Collection:TeleportTo(nearestEnemy:GetModelCFrame(),room)
						else 
							Collection:CollectChest(room)
							if OldPos then 
								Collection:TeleportTo(OldPos)
								nearestEnemy = Collection:getNearestEnemy()
								Collection:KillEnemyHandle(nearestEnemy,MPPercent)
							else 
								Collection:TeleportPortal(room)
							end 
							Collection:ExitDungeon(room)
						end 
						
					end
				end
			until (nearestEnemy and nearestEnemy:FindFirstChild("Humanoid") and nearestEnemy:FindFirstChild("Humanoid").Health <= 0) or not SaveSettings["Auto Farm"] or _G.BreakAllFunction
			print("EndLoop")
			OldPlayerPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
			Collection:CollectChest(room)
			Collection:ExitDungeon(room)
			if LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then 
				TeleportService:Teleport(LobbyPlace, LocalPlayer)
				task.wait(2)
			end 
			if OldPos and justteleport then 
			
				Collection:TeleportTo(OldPos)
				justteleport = false
				task.wait(.5)
			end 
			nearestEnemy = Collection:getNearestEnemy()
		elseif not nearestEnemy and (healthPercent >= SaveSettings["Hp Regen Percent"] or MPPercent >= SaveSettings["MP Regen Percent"]) then
			nearestEnemy = Collection:getNearestEnemy()
			Collection:CollectChest(room)
			if OldPos and justteleport then 
			
				Collection:TeleportTo(OldPos)
				justteleport = false
				task.wait(.5)
			end 

			if room.Name == "StartRoom" then 
				if workspace:FindFirstChild("TELEPORT") and justteleport == false then
					Collection:TeleportTo(workspace.TELEPORT.CFrame)
					task.wait(1)
				end
			else 
				Collection:CollectChest(room)
				Collection:ExitDungeon(room)
				Collection:TeleportPortal(room)
			end 
			
		end 
end



FunctionTask["Auto Farm"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end

		local success, err = pcall(function()
			if SaveSettings["Auto Farm"] then
				print("Loop and Loop")
				if game.PlaceId == LobbyPlace then
					if not SaveSettings["Auto Party"] then
						if SaveSettings["Full Auto Farm Level"] then 
							local level = tonumber(game:GetService("Players").LocalPlayer.leaderstats.Level)
							local DungeonType = ""
							local Mode = ""
							if level >= 1 and level < 5 then 
								DungeonType = "Orc Lands" 
								Mode = "Easy"
							elseif level >= 5 and level < 8 then 
								DungeonType = "Orc Lands" 
								Mode = "Medium"
							elseif level >= 8 and level < 10 then 
								DungeonType = "Orc Lands" 
								Mode = "Hard"
							elseif level >= 10 and level < 14 then 
								DungeonType = "The Crypt" 
								Mode = "Easy"
							elseif level >= 14 and level < 17 then 
								DungeonType = "The Crypt" 
								Mode = "Medium"
							elseif level >= 17 and level < 20 then 
								DungeonType = "The Crypt" 
								Mode = "Hard"
							elseif level >= 20 and level < 24 then 
								DungeonType = "Frosty Hills" 
								Mode = "Easy"
							elseif level >= 24 and level < 27 then 
								DungeonType = "Frosty Hills" 
								Mode = "Medium"
							elseif level >= 27 and level < 30 then 
								DungeonType = "Frosty Hills" 
								Mode = "Hard"
							elseif level >= 30 and level < 34 then 
								DungeonType = "The Swamps" 
								Mode = "Easy"
							elseif level >= 34 and level < 37 then 
								DungeonType = "The Swamps" 
								Mode = "Medium"
							elseif level >= 37 and level < 37 then 
								DungeonType = "The Swamps" 
								Mode = "Hard"
							end 
							if SaveSettings["Use Modify"] then 
								local args = {
									[1] = {
										["Location"] = tostring(DungeonType),
										["GroupType"] = "Private",
										["Difficult"] = tostring(Mode),
										["Invasions"] = SaveSettings["Invasions"]
									},
									[2] = next(args2) and args2 or {}
								}
								game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
							else 
								local args = {
									[1] = {
										["Location"] = tostring(DungeonType),
										["GroupType"] = "Private",
										["Difficult"] = tostring(Mode),
										["Invasions"] = SaveSettings["Invasions"]
									},
									[2] = {}
								}
								game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
							end 
						else 
							if SaveSettings["Use Modify"] then 
								local args = {
									[1] = {
										["Location"] = tostring(SaveSettings["Dungeons"]),
										["GroupType"] = "Private",
										["Difficult"] = tostring(SaveSettings["Mode"]),
										["Invasions"] = SaveSettings["Invasions"]
									},
									[2] = next(args2) and args2 or {}
								}
								game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
							else 
								local args = {
									[1] = {
										["Location"] = tostring(SaveSettings["Dungeons"]),
										["GroupType"] = "Private",
										["Difficult"] = tostring(SaveSettings["Mode"]),
										["Invasions"] = SaveSettings["Invasions"]
									},
									[2] = {}
								}
								game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
							end 
						end 
						
						task.wait(2)
						game:GetService("ReplicatedStorage").Events.StartDungeonGroup:FireServer()
					end 
				else
					-- if SaveSettings["Dungeons"] == "Orc Lands" then 

					-- else 
					if LocalPlayer.Character:FindFirstChild("Humanoid").Health <= 0 then 
						TeleportService:Teleport(LobbyPlace, LocalPlayer)
						task.wait(2)
					end 
					if LocalPlayer.Character:FindFirstChild("Humanoid").Sit == true then 
						LocalPlayer.Character:FindFirstChild("Humanoid").Sit = false
					end 
					if workspace:FindFirstChild("Tower") then
						local tower = workspace:FindFirstChild("Tower")
						local rooms = {}

						for _, room in ipairs(workspace.Tower:GetChildren()) do
							if room:IsA("Model") then
								rooms[room.Name] = room
							end
						end
						
						for roomName, room in pairs(rooms) do
							if room then
								if Collection:CheckMagnitude(room:GetModelCFrame().Position) <= 300 then
									if StartCampPos == nil and tower:FindFirstChild("StartRoom"):FindFirstChild("Campfire"):FindFirstChild("Hitbox") then 
										StartCampPos = workspace.Tower.StartRoom.Campfire.Hitbox.CFrame * CFrame.new(0,3,0)
									else 
										StartCampPos = workspace.Tower.StartRoom.Campfire:GetModelCFrame() * CFrame.new(0,3,0)
									end 
									Collection:CollectChest(room)
									handleRoom(room)
								end
							end
						end

					end
					--end 
					
				end

			end
		end)

		task.wait()

		if err and Debug then
			warn("[Auto Farm] Caught Error: ", err)
		end
	end
end
local count = 0
local inpartycount = 0
local findframe = false
local DontLeave = false
spawn(function()
	while task.wait() do 
		if _G.BreakAllFunction then
			break
		end
		if SaveSettings["Auto Party"] and game.PlaceId == LobbyPlace then 
			if DontLeave == true then 
				task.wait(10)
				DontLeave = false
				task.wait(2)
			end 
		end 
	end 
end )
FunctionTask["Auto Party"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Auto Party"] and game.PlaceId == LobbyPlace then
				count = #SaveSettings["Player Name"] 
				inpartycount = 0 
				
				if LocalPlayer.PlayerGui.InteractionZones.DungeonMasterFind.Dungeons.Items:FindFirstChild("DungeonFindGroupExample") then 
					for i,v in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonMasterFind.Dungeons.Items:GetChildren()) do 
						if v.Name == "DungeonFindGroupExample" then 
							local dungeonexam = v
							local labelText = dungeonexam.Location.Bar.Info.Label.Text
							local nameOnly = string.match(labelText, "^(.-)%s%[") or labelText
							nameOnly = nameOnly:match("^%s*(.-)%s*$")
					
							local isCreating = LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Visible
							local dungeonGroupItems = LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items
							local foundInGroup = dungeonGroupItems:FindFirstChild(nameOnly)
					
							if isCreating and not table.find(SaveSettings["Player Name"],tostring(nameOnly)) then
								if not foundInGroup then
									DontLeave = true
								else
									DontLeave = false
								end
							else 
								DontLeave = false
							end
					
							if table.find(SaveSettings["Player Name"], tostring(nameOnly)) and tostring(nameOnly) ~= tostring(LocalPlayer.Name) then
								findframe = true
								if LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Visible == true and table.find(SaveSettings["Player Name"], tostring(nameOnly)) and DontLeave == false then 
									firesignal(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Actions.Leave.Activated)
									task.wait(0.1)
									if LocalPlayer.PlayerGui.ScreenInfo.Invites:FindFirstChild("DungeonInvite") then 
										for i,DungeonInvite in pairs(LocalPlayer.PlayerGui.ScreenInfo.Invites:GetChildren()) do 
											if DungeonInvite.Name == "DungeonInvite" then 
												local dungeoninvite = DungeonInvite
												local Label = dungeoninvite.Bar.Info.Label.Text
												local FindName = string.match(Label, "^(.-)%s%[") or Label
												FindName = FindName:match("^%s*(.-)%s*$")
												if FindName == nameOnly then 
													firesignal(dungeoninvite.Accept.Activated)
													task.wait(0.1)
												else 
													firesignal(dungeoninvite.Close.Activated)
													task.wait(0.1)
												end 
											end 
										end 
									end 
								else 
									if LocalPlayer.PlayerGui.ScreenInfo.Invites:FindFirstChild("DungeonInvite") then 
										for i,DungeonInvite in pairs(LocalPlayer.PlayerGui.ScreenInfo.Invites:GetChildren()) do 
											if DungeonInvite.Name == "DungeonInvite" then 
												local dungeoninvite = DungeonInvite
												local Label = dungeoninvite.Bar.Info.Label.Text
												local FindName = string.match(Label, "^(.-)%s%[") or Label
												FindName = FindName:match("^%s*(.-)%s*$")
												if FindName == nameOnly then 
													firesignal(dungeoninvite.Accept.Activated)
													task.wait(0.2)
												else 
													firesignal(dungeoninvite.Close.Activated)
													task.wait(0.2)
												end 
											end 
										end 
									end 
								end 
							else
								findframe = false
					
								if LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Visible == false and LocalPlayer.PlayerGui.InteractionZones.DungeonGroupOpen.Visible == false then 
									local args = {
										[1] = {
											["Location"] = tostring(SaveSettings["Dungeons"]),
											["GroupType"] = "Public",
											["Difficult"] = tostring(SaveSettings["Mode"]),
											["Invasions"] = SaveSettings["Invasions"]
										},
										[2] = next(args2) and args2 or {}
									}
									game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
									task.wait(1)
								else 
									for i,Players in pairs(game.Players:GetChildren()) do 
										if table.find(SaveSettings["Player Name"], Players.Name) and not LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:FindFirstChild(Players.Name) then 
											local args = {
												[1] = Players
											}
											game:GetService("ReplicatedStorage").Events.SendInvitePlayerToDungeonGroup:InvokeServer(unpack(args))
											task.wait(0.2)
										else 
											for i,v in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:GetChildren()) do 
												if v:IsA("Frame") and not table.find(SaveSettings["Player Name"], v.Name) and v.Name ~= LocalPlayer.Name then 
													firesignal(v.Kick.Activated)
													task.wait()
												end 
											end 
											inpartycount = 0 
											for i,InParty in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:GetChildren()) do 
												if table.find(SaveSettings["Player Name"], tostring(InParty.Name)) and InParty:IsA("Frame") and tostring(InParty.Name) ~= LocalPlayer.Name then 
													inpartycount += 1
													task.wait()
												end 
											end 
											if inpartycount >= count and count ~= 0 then 
												firesignal(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Actions.Start.Activated)
												task.wait(.1)
											end 
										end 
									end
								end 
							end
						end 
					end
					
				else 
					if findframe == false then 
						if LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Visible == false and game:GetService("Players").LocalPlayer.PlayerGui.InteractionZones.DungeonGroupOpen.Visible == false then 
							local args = {
								[1] = {
									["Location"] = tostring(SaveSettings["Dungeons"]),
									["GroupType"] = "Public",
									["Difficult"] = tostring(SaveSettings["Mode"]),
									["Invasions"] = SaveSettings["Invasions"]
								},
								[2] = next(args2) and args2 or {}
							}
							game:GetService("ReplicatedStorage").Events.CreateDungeonGroup:FireServer(unpack(args))
							task.wait(1)
						else 
							for i,Players in pairs(game.Players:GetChildren()) do 
								if table.find(SaveSettings["Player Name"],Players.Name) and not LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:FindFirstChild(Players.Name) then 
									local args = {
										[1] = Players
									}
	
									game:GetService("ReplicatedStorage").Events.SendInvitePlayerToDungeonGroup:InvokeServer(unpack(args))
									for i,v in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:GetChildren()) do 
										if v:IsA("Frame") and not table.find(SaveSettings["Player Name"],v.Name) and v.Name ~= LocalPlayer.Name then 
											firesignal(v.Kick.Activated)
											task.wait()
										end 
									end 
									task.wait(.5)
								else 
									for i,v in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:GetChildren()) do 
										if v:IsA("Frame") and not table.find(SaveSettings["Player Name"],v.Name) and v.Name ~= LocalPlayer.Name then 
											firesignal(v.Kick.Activated)
											task.wait()
										end 
									end 
									inpartycount = 0 
									for i,InParty in pairs(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Group.Items:GetChildren()) do 
										if table.find(SaveSettings["Player Name"],InParty.Name) and v:IsA("Frame") and InParty.Name ~= LocalPlayer.Name then 
											inpartycount += 1
											task.wait()
										end 
									end 
									if inpartycount >= count and count ~= 0 then 
										firesignal(LocalPlayer.PlayerGui.InteractionZones.DungeonGroup.Actions.Start.Activated)
										task.wait(.1)
									end 
								end 
							end
						end 
					end 
				end 
			
			end
		end)
		task.wait()
		if Err and Debug then
			warn("[Auto Party] Caught Error: ",Err)
		end
	end
end
FunctionTask["Protect Name"] = function()
	while true do
		if _G.BreakAllFunction then
			break
		end
		local Succ,Err = pcall(function()
			if SaveSettings["Protect Name"] then
				if game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text ~= "Protected By Deity Hub" then 
					game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = "Protected By Deity Hub"
				end
			else 

				if game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text == "Protected By Deity Hub" then 
					game:GetService("CoreGui").RoactAppExperimentProvider.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..game.Players.LocalPlayer.UserId].ChildrenFrame.NameFrame.BGFrame.OverlayFrame.PlayerName.PlayerName.Text = LocalPlayer.DisplayName
				end
			end
		end)
		task.wait()
		if Err and Debug then
			warn("[Protect Name] Caught Error: ",Err)
		end
	end
end

coroutine.wrap(function()
	while RunService.Stepped:wait() do
		local LogError = false
		if _G.BreakAllFunction then 
			break
		end

		local Success , err = pcall(function()


			local Humanoid = Collection:GetHum(LocalPlayer.Character) 
			local Root = Collection:GetRoot(LocalPlayer.Character)

			if SaveSettings["White Screen"]  then 
				game:GetService("RunService"):Set3dRenderingEnabled(false)
			else 
				game:GetService("RunService"):Set3dRenderingEnabled(true)
			end
			if SaveSettings["Fps Lock"] and tonumber(SaveSettings["Fps Cap"]) then 
				pcall(setfpscap, tonumber(SaveSettings["Fps Cap"]))
				pcall(set_fps_cap, tonumber(SaveSettings["Fps Cap"]))
			else 
				pcall(setfpscap, 240)
				pcall(set_fps_cap, 240)
			end
			if SaveSettings["Auto Farm"] then
                local Humanoid = Collection:GetHum(LocalPlayer.Character) 
                local Root = Collection:GetRoot(LocalPlayer.Character)
                if false then
                    if Humanoid then
                        setfflag("HumanoidParallelRemoveNoPhysics", "False")
                        setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
                        Humanoid:ChangeState(11)
                    end
                else
                    for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                            v.CanCollide = false
                        end
                    end
                end
				if not Root:FindFirstChild("KRNLONAIR") then
					local KRNLONAIR = Instance.new("BodyVelocity")
					KRNLONAIR.Name = "KRNLONAIR"
					KRNLONAIR.MaxForce = Vector3.new(100000, 100000, 100000)
					KRNLONAIR.Velocity = Vector3.zero
					KRNLONAIR.Parent = Root
				end
            elseif Collection:GetRoot(LocalPlayer.Character):FindFirstChild("KRNLONAIR") then
                Collection:GetRoot(LocalPlayer.Character)["KRNLONAIR"]:Destroy()
            end
            if sethiddenproperty then
                _sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            end
		end)
		if err and LogError then
			warn("CAUGHT ERROR! : " .. err)
		end 
	end
end)()

-- Bypass --  
local AdService = game:GetService("AdService")
for _ , Child in next, AdService:GetChildren() do
    if Child:IsA("RemoteEvent") then
        local Name = Child.Name
        local Swap = Instance.new("UnreliableRemoteEvent")
        Swap.Name = Name
        Swap.Parent = AdService
        Child:Destroy()
    end
end
local plr = game:GetService("Players").LocalPlayer;

local old;
old = hookmetamethod(game, "__index", function(self, key)
   if not checkcaller() and key == "PlatformStand" and self.ClassName == "Humanoid" and self.Parent and plr.Character and self.Parent == plr.Character then 
       return false
   end
   return old(self, key)
end)

game.DescendantAdded:Connect(function(d)
   if d.ClassName:find("Body") and plr.Character and d:IsDescendantOf(plr.Character) then
       
       local old_idx;
       local old_nc;
       
       old_idx = hookmetamethod(d, "__index", newcclosure(function(self, ...) 
           if not checkcaller() and self == d then
               local s,e = pcall(old_idx, self, ...)
               
               if not s then
                   return error(e)
               end
               return
           end
           return old_idx(self, ...)
       end))
       
       old_nc = hookmetamethod(d, "__namecall", newcclosure(function(self, ...)
           if not checkcaller() and self == d then
               local s,e = pcall(old_nc, self, ...)
               
               if not s then
                   return error(e)
               end
               return
           end
           return old_nc(self, ...)
       end))
   end
end)


for TaskName, TaskFunction in pairs(FunctionTask) do
	coroutine.wrap(function()
		repeat
			task.wait(1)
		until SaveSettings[TaskName] == true or (type(SaveSettings[TaskName]) == "table" and #SaveSettings[TaskName] > 0)

		print("Starting Task:", TaskName)  -- Debugging print
		TaskFunction()
	end)()
end

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
	vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


-- Configuration

local HttpService = game:GetService("HttpService")

local folderPath = "WindUI"
makefolder(folderPath)

local function SaveFile(fileName, data)
	local filePath = folderPath .. "/" .. fileName .. ".json"
	local jsonData = HttpService:JSONEncode(data)
	writefile(filePath, jsonData)
end

local function LoadFile(fileName)
	local filePath = folderPath .. "/" .. fileName .. ".json"
	if isfile(filePath) then
		local jsonData = readfile(filePath)
		return HttpService:JSONDecode(jsonData)
	end
end

local function ListFiles()
	local files = {}
	for _, file in ipairs(listfiles(folderPath)) do
		local fileName = file:match("([^/]+)%.json$")
		if fileName then
			table.insert(files, fileName)
		end
	end
	return files
end

WindowTab:Section({ Title = "Window" })

local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
	table.insert(themeValues, name)
end

local themeDropdown = WindowTab:Dropdown({
	Title = "Select Theme",
	Multi = false,
	AllowNone = false,
	Value = nil,
	Values = themeValues,
	Callback = function(theme)
		WindUI:SetTheme(theme)
	end
})
themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = WindowTab:Toggle({
	Title = "Toggle Window Transparency",
	Callback = function(e)
		Window:ToggleTransparency(e)
	end,
	Value = WindUI:GetTransparency()
})

WindowTab:Section({ Title = "Save" })

local fileNameInput = ""
WindowTab:Input({
	Title = "Write File Name",
	PlaceholderText = "Enter file name",
	Callback = function(text)
		fileNameInput = text
	end
})

WindowTab:Button({
	Title = "Save File",
	Callback = function()
		if fileNameInput ~= "" then
			SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
		end
	end
})

WindowTab:Section({ Title = "Load" })

local filesDropdown
local files = ListFiles()

filesDropdown = WindowTab:Dropdown({
	Title = "Select File",
	Multi = false,
	AllowNone = true,
	Values = files,
	Callback = function(selectedFile)
		fileNameInput = selectedFile
	end
})

WindowTab:Button({
	Title = "Load File",
	Callback = function()
		if fileNameInput ~= "" then
			local data = LoadFile(fileNameInput)
			if data then
				WindUI:Notify({
					Title = "File Loaded",
					Content = "Loaded data: " .. HttpService:JSONEncode(data),
					Duration = 5,
				})
				if data.Transparent then 
					Window:ToggleTransparency(data.Transparent)
					ToggleTransparency:SetValue(data.Transparent)
				end
				if data.Theme then WindUI:SetTheme(data.Theme) end
			end
		end
	end
})

WindowTab:Button({
	Title = "Overwrite File",
	Callback = function()
		if fileNameInput ~= "" then
			SaveFile(fileNameInput, { Transparent = WindUI:GetTransparency(), Theme = WindUI:GetCurrentTheme() })
		end
	end
})

WindowTab:Button({
	Title = "Refresh List",
	Callback = function()
		filesDropdown:Refresh(ListFiles())
	end
})

local currentThemeName = WindUI:GetCurrentTheme()
local themes = WindUI:GetThemes()

local ThemeAccent = themes[currentThemeName].Accent
local ThemeOutline = themes[currentThemeName].Outline
local ThemeText = themes[currentThemeName].Text
local ThemePlaceholderText = themes[currentThemeName].PlaceholderText

function updateTheme()
	WindUI:AddTheme({
		Name = currentThemeName,
		Accent = ThemeAccent,
		Outline = ThemeOutline,
		Text = ThemeText,
		PlaceholderText = ThemePlaceholderText
	})
	WindUI:SetTheme(currentThemeName)
end

local CreateInput = CreateThemeTab:Input({
	Title = "Theme Name",
	Value = currentThemeName,
	Callback = function(name)
		currentThemeName = name
	end
})

CreateThemeTab:Colorpicker({
	Title = "Background Color",
	Default = Color3.fromHex(ThemeAccent),
	Callback = function(color)
		ThemeAccent = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Outline Color",
	Default = Color3.fromHex(ThemeOutline),
	Callback = function(color)
		ThemeOutline = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Text Color",
	Default = Color3.fromHex(ThemeText),
	Callback = function(color)
		ThemeText = color:ToHex()
	end
})

CreateThemeTab:Colorpicker({
	Title = "Placeholder Text Color",
	Default = Color3.fromHex(ThemePlaceholderText),
	Callback = function(color)
		ThemePlaceholderText = color:ToHex()
	end
})

CreateThemeTab:Button({
	Title = "Update Theme",
	Callback = function()
		updateTheme()
	end
})

if _G.Deity_Toggle then
	_G.Deity_Toggle:Destroy()
	_G.Deity_Toggle = nil
end

local UserInputService = game:GetService("UserInputService")

if game.CoreGui:FindFirstChild("DeityToggle") then game.CoreGui["DeityToggle"]:Destroy() end

local DeityToggle = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local ImageLabel = Instance.new("ImageLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

DeityToggle.Name = "DeityToggle"
DeityToggle.Parent = game.CoreGui
DeityToggle.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = DeityToggle
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.485, 0, 0.046683047, 0)
ImageButton.Size = UDim2.new(0.0362654328, 0, 0.0577395596, 0)
ImageButton.AutoButtonColor = false

UICorner.Parent = ImageButton

ImageLabel.Parent = ImageButton
ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.BackgroundTransparency = 1.000
ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ImageLabel.BorderSizePixel = 0
ImageLabel.Position = UDim2.new(0, 0, 0.0500000007, 0)
ImageLabel.Size = UDim2.new(0.957446814, 0, 0.957446814, 0)
ImageLabel.Image = "rbxassetid://109816771524527"

UIAspectRatioConstraint.Parent = ImageLabel
UIAspectRatioConstraint.AspectRatio = 1.010

UIAspectRatioConstraint_2.Parent = ImageButton
UIAspectRatioConstraint_2.AspectRatio = 1.010

local dragging = false
local dragStart
local startPos

ImageButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = ImageButton.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		ImageButton.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
local Debounce = true
ImageButton.Activated:Connect(function()
	if Debounce then
		Debounce = false
		Window:Close()
	else 
		Debounce = true
		Window:Open()
	end
end)
-- New
