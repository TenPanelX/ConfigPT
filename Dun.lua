-- New5
local Debug = true

--LPH_NO_UPVALUES = function(...) return ... end
--LPH_NO_VIRTUALIZE = function(...) return ... end

repeat task.wait() until game:IsLoaded()
task.wait(2)

local ProjectName = "DungeonLeveling"
local UILibraryName = "Dungeon Leveling"

local UiName = "WindUI"
_G.BreakAllFunction = false

for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do 
	if v:IsA("ScreenGui") and v.Name == UiName then 
		v:Destroy()
		_G.BreakAllFunction = true
	end 
end 

task.wait(1)
_G.BreakAllFunction = false 


local _Blank = function() end
local Debug_Log = function(...) if Debug then print(...) end end 

local game = game
local Collection = {}; Collection.__index = Collection
local function getService(service)
	return game:GetService(service); -- create service return stuff
end
local Services = setmetatable({}, {
	__index = function(_, k) 
		return getService(k)
	end
})

---------------------------------------------- [ Exploits Variables ] ----------------------------------------------

_sethiddenproperty = sethiddenproperty or set_hidden_property or set_hidden_prop
_gethiddenproperty = gethiddenproperty or get_hidden_property or get_hidden_prop
_setsimulationradius = setsimulationradius or set_simulation_radius
_clone_function_ = clonefunction or clone_function or function(...) return ... end

_queue_on_teleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
_http_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
_getcustomasset = (syn and getsynasset) or getcustomasset
local IsWave = getexecutorname and getexecutorname():find("Wave")

--------------------------- [[ Services ]] ---------------------------

local JobId = tostring(game.JobId)
local PlaceId = tonumber(game.PlaceId);
local TweenService = Services.TweenService
local VirtualUser = Services.VirtualUser
local UserInputService = Services.UserInputService
local ReplicatedStorage = Services.ReplicatedStorage
local CoreGui = Services.CoreGui
local TeleportService = Services.TeleportService
local Lighting = Services.Lighting
local HttpService = Services.HttpService
local PathfindingService = Services.PathfindingService
local RunService = Services.RunService
local CollectionService = Services.CollectionService
local Teams = Services.Teams
local GuiService = Services.GuiService
local Players = Services.Players
local CurrentCamera = workspace.CurrentCamera
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local Camera = workspace:FindFirstChildOfClass("Camera")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Mobile = false

local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local Signals_List = {'Activated'}
local IsLoaded = false

local Version = "1"
local filename = "Deity_Hub_Next_Generations/SaveSettings/" .. ProjectName.."/" .. tostring(game.Players.LocalPlayer.Name) ..".json"

print("[Deity Hub] "..ProjectName.." Loaded")
print("[Deity Hub] White List Loaded")

local FunctionTask = {}

getgenv().SaveSettings = SaveSettings or {}

function Collection:Load()
	if readfile and writefile and isfile and isfolder then
		if not isfolder("Deity_Hub_Next_Generations") then
			makefolder("Deity_Hub_Next_Generations")
		end
		if not isfolder("Deity_Hub_Next_Generations/SaveSettings") then
			makefolder("Deity_Hub_Next_Generations/SaveSettings")
		end
		if not isfolder("Deity_Hub_Next_Generations/SaveSettings/" .. ProjectName) then
			makefolder("Deity_Hub_Next_Generations/SaveSettings/" .. ProjectName)
		end
		if not isfile(filename) then
			writefile(filename, HttpService:JSONEncode(SaveSettings))
		else
			local fileContent = readfile(filename)
			-- print("File content:", fileContent) -- Debugging print

			local success, Decode = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)

			if not success then
				warn("Failed to parse JSON. Check the content of the file:", filename)
				return false -- Early exit if JSON is invalid
			end

			for i, v in pairs(Decode) do
				SaveSettings[i] = v
			end
			for i,v in pairs(SaveSettings) do 
				SaveSettings[i] = v
			end 
		end
	else
		warn("[Deity Hub] Failed to load script... (Please Contact Admins)")
		return false
	end
end

function Collection:Save()
	if readfile and writefile and isfile then
		if not isfile(filename) then
			Collection:Load()
		else
			local fileContent = readfile(filename)
			-- print("File content before saving:", fileContent) -- Debugging print

			local success, Decode = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)

			if not success then
				warn("Failed to parse JSON while saving. Check the content of the file:", filename)
				return false -- Early exit if JSON is invalid
			end

			local Array = {}
			for i, v in pairs(SaveSettings) do
				Array[i] = v
			end
			writefile(filename, HttpService:JSONEncode(Array))
		end
	else
		warn("[Deity Hub] Failed to save")
		return false
	end
end

Collection:Load()

function Collection:GetRoot(Character)
	local Root
	xpcall(function()
		if Character and Character:FindFirstChild("HumanoidRootPart") then
			Root = Character.HumanoidRootPart
		end
	end,Debug_Log)
	return Root
end
function Collection:GetHum(Character)
	local Humanoid
	xpcall(function()
		if Character and Character:FindFirstChild("Humanoid") then
			Humanoid = Character.Humanoid
		end
	end,Debug_Log)
	return Humanoid
end
function Collection:Log(...)
	if Debug then
		print("[Deity Hub]:",...)
	end
end
function Collection:Comma(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function Collection:GetSelfDistance(Object)
	local _Magnitude = 9999
	xpcall(function()
		local Position = (typeof(Object) == "CFrame") and Object.Position or Object
		local RootPart = Collection:GetRoot(LocalPlayer.Character)
		_Magnitude = (RootPart.Position - Position).Magnitude
	end,Debug_Log)
	return _Magnitude
end

function Collection:TeleportCFrame(_CFrame)
	xpcall(function()
		local Current_CFrame = typeof(_CFrame) == "Vector3" and CFrame.new(_CFrame) or _CFrame
		local RootPart = Collection:GetRoot(LocalPlayer.Character)

		if Current_CFrame and RootPart then
			RootPart.CFrame = Current_CFrame
		end
	end,Debug_Log)
end
function Collection:LookAt(_Position)
	xpcall(function()
		local RootPart = Collection:GetRoot(LocalPlayer.Character)
		RootPart.CFrame = CFrame.lookAt(RootPart.Position, _Position)
	end,Debug_Log)
end
function Collection:GetObjectDistance(Position_1,Position_2)
	return (Position_1 - Position_2).Magnitude
end
function Collection:fireclickbutton(button)
	-- if game:GetService("GuiService").SelectedObject ~= nil then 
	-- 	game:GetService("GuiService").SelectedObject = nil
	-- end 
	if not button then return end 
	xpcall(function()
		local UserInputService = game:GetService("UserInputService")
		local GuiService = game:GetService("GuiService")
		local playerGui = game:GetService("Players").LocalPlayer.PlayerGui

		local VisibleUI = playerGui:FindFirstChild("") or Instance.new("Frame")
		VisibleUI.Name = "_"
		VisibleUI.BackgroundTransparency = 1
		VisibleUI.Parent = playerGui
		playerGui.SelectionImageObject = VisibleUI
		GuiService.SelectedObject = button
		VirtualInputManager:SendKeyEvent(true, 'Return', false, game)
		VirtualInputManager:SendKeyEvent(false, 'Return', false, game)
	end, Debug_Log)
end

function Collection:Keyboard(Key,Holding)
	spawn(function()
		xpcall(function()
			if Holding == nil then
				Holding = 0 
			end
			VirtualInputManager:SendKeyEvent(true,Key,false,Collection:GetRoot(LocalPlayer.Character))
			wait(Holding)
			VirtualInputManager:SendKeyEvent(false,Key,false,Collection:GetRoot(LocalPlayer.Character)) 
		end,Debug_Log)
	end)
end

function Collection:fireproximityprompt(Obj, Amount, Skip)
	spawn(function()
		xpcall(function()
			if Obj.ClassName == "ProximityPrompt" then 
				Obj.RequiresLineOfSight = false
				Amount = Amount or 1
				local PromptTime = Obj.HoldDuration
				if Skip then 
					Obj.HoldDuration = 0
				end
				for i = 1, Amount do 
					Obj:InputHoldBegin()
					if not Skip then 
						wait(Obj.HoldDuration)
					end
					Obj:InputHoldEnd()
				end
				Obj.HoldDuration = PromptTime
			else 
				error("userdata<ProximityPrompt> expected")
			end
		end,Debug_Log)
	end)
end
function Collection:New(Object,Property)
	local Object_ = Instance.new(Object)
	for i,v in pairs(Property) do
		Object_[i] = v
	end
	return Object_
end
local function CountTable(t)
	local count, key = 0
	repeat
		key = next(t, key)
		if key ~= nil then
			count = count + 1
		end
	until key == nil
	return count
end
local PrintTable
local function ParseObject(object, spacing, scope, checkedTables)
	local objectType = type(object)
	if objectType == "string" then
		return spacing .. string.format("%q", object)
	elseif objectType == "nil" then
		return spacing .. "nil"
	elseif objectType == "table" then
		if checkedTables[object] then
			return spacing .. tostring(object) .. " [recursive table]"
		else
			checkedTables[object] = true
			return spacing .. PrintTable(object, scope + 1, checkedTables)
		end
	elseif objectType == "userdata" then
		if typeof(object) == "userdata" then
			return spacing .. "userdata"
		else
			return spacing .. tostring(object)
		end
	else -- userdata, function, boolean, thread, number
		return spacing .. tostring(object)
	end
end
function PrintTable(t, scope, checkedTables)
	local mt = getrawmetatable(t)
	local backup = {}
	if mt and mt ~= t then
		for i, v in pairs(mt) do
			rawset(backup, i, v)
			rawset(mt, i, nil)
		end
	end

	checkedTables = checkedTables or {}
	scope = scope or 1
	local result = (checkedTables and "{" or "") .. "\n"
	local spacing = string.rep("\t", scope)
	local function parse(index, value)
		result = result .. ParseObject(index, spacing, scope, checkedTables) .. " -: " .. ParseObject(value, "", scope, checkedTables) .. "\n"
	end

	if CountTable(t) ~= #t then
		table.foreach(t, parse) -- I'm very aware this is a deprecated function
	else
		for index = 1, select("#", unpack(t)) do
			parse(index, t[index])
		end
	end

	if mt and mt ~= t then
		for i, _ in pairs(backup) do
			rawset(mt, i, rawget(backup, i))
		end
	end

	return result .. string.sub(spacing, 1, #spacing - 1) .. (checkedTables and "}" or "")
end

-- local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/A1phes/DeityHub/refs/heads/main/UI/WindUI"))()

local Window = WindUI:CreateWindow({
	Title = "Deity Hub | "..UILibraryName,
	Icon = "door-open",
	Author = "https://deityhub.pro/",
	Folder = "Deity_Hub",
	Size = UDim2.fromOffset(580, 460),
	-- KeySystem = {
	--     Key = { "1234", "5678" },
	--     Note = "The Key is '1234' or '5678",
	--     URL = "https://github.com/Footagesus/WindUI",
	--     SaveKey = true,
	-- },
	Transparent = true,
	Theme = "Dark",
	SideBarWidth = 200,
	HasOutline = false,
})


--- About UI ---

function Collection:AddToggle(Path,Title,Default)
	-- Configuration = {
	--  Title = "Enable Feature",
	--  Default = true,
	--  Callback = function(state) print("Feature enabled: " .. tostring(state)) end
	-- }
	local value 
	if _G.Configs and _G.Configs[Title] then 
		value = _G.Configs[Title]
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if SaveSettings[Title] then 
			value = SaveSettings[Title]
		else 
			value = Default
		end 

	end 

	local Toggles_ = Path:Toggle(
		{
			Title = Title,
			Value = value,
			Callback = function(state) 
				if state == true and Title == "Reduce CPU" then 
					for i,v in pairs(game.Workspace:GetDescendants()) do 
						if v:IsA("ParticleEmitter") then 
							v:Destroy()
						end 
					end 
					task.spawn(function()
						for i,v in pairs(game.Workspace:GetDescendants()) do 
							if v:IsA("ParticleEmitter") then 
								v:Destroy()
							end 
						end 
						UserSettings():GetService("UserGameSettings").MasterVolume = 0
						UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

						function Collection:TextureLow()
							-- ApLocalPlayer changes to the existing environment
							local g = game
							local w = g.Workspace
							local l = g:GetService"Lighting"
							local t = w:WaitForChild"Terrain"

							t.WaterWaveSize = 0
							t.WaterWaveSpeed = 0
							t.WaterReflectance = 0
							t.WaterTransparency = 1
							l.GlobalShadows = false
							-- Function to change object properties
							function change(v)
								pcall(function()
									if v.Material ~= Enum.Material.SmoothPlastic then
										pcall(function() v.Reflectance = 0 end)
										pcall(function() v.Material = Enum.Material.SmoothPlastic end)
										pcall(function() v.TopSurface = Enum.SurfaceType.SmoothNoOutlines end)
									end
								end)
							end

							-- ApLocalPlayer changes to new objects added to the game
							game.DescendantAdded:Connect(function(v)
								pcall(function()
									if v:IsA"Part" then change(v)
									elseif v:IsA"MeshPart" then change(v)
									elseif v:IsA"TrussPart" then change(v)
									elseif v:IsA"UnionOperation" then change(v)
									elseif v:IsA"CornerWedgePart" then change(v)
									elseif v:IsA"WedgePart" then change(v) end
								end)
							end)

							-- ApLocalPlayer changes to all existing descendants
							for i, v in pairs(game:GetDescendants()) do
								pcall(function()
									if v:IsA"Part" then change(v)
									elseif v:IsA"MeshPart" then change(v)
									elseif v:IsA"TrussPart" then change(v)
									elseif v:IsA"UnionOperation" then change(v)
									elseif v:IsA"CornerWedgePart" then change(v)
									elseif v:IsA"WedgePart" then change(v) end
								end)
							end
						end

						Collection:TextureLow()

						while true do
							if Library.Unloaded or Collection.UnLoaded or Collection.BreakLoop then break end
							pcall(function()
								for _, obj in pairs(game.Players:GetDescendants()) do
									if obj:IsA("ParticleEmitter") then

										-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
										obj.Enabled = false
										obj.Rate = 0
										obj.Lifetime = NumberRange.new(0)
										obj.Speed = NumberRange.new(0)
										obj.Rotation = NumberRange.new(0)
										obj.Size = NumberSequence.new(0)
										obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
										-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
										--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
									end
									task.wait(0)
								end
								for _, obj in pairs(workspace:GetDescendants()) do
									if obj:IsA("ParticleEmitter") then

										-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
										obj.Enabled = false
										obj.Rate = 0
										obj.Lifetime = NumberRange.new(0)
										obj.Speed = NumberRange.new(0)
										obj.Rotation = NumberRange.new(0)
										obj.Size = NumberSequence.new(0)
										obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
										-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
										--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
									end
									task.wait(0)
								end
							end)
							task.wait(0)
						end
					end)
				end 
				SaveSettings[Title] = state
				Collection:Save()
			end
		}
	)

	return Toggles_
end

function Collection:AddDropdown(Path,Title,Values,Default,Multi)
	-- Configuration = {
	--   Title = "Select an Option",
	--   Values = { "Option 1", "Option 2", "Option 3" },
	--   Value = "Option 1",
	--   Callback = function(option) print("Selected: " .. option) end
	-- }
	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 

	local Dropdown_ = Path:Dropdown(
		{
			Title = Title,
			Values = Values,
			Value = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
			Multi = Multi,
			Callback = function(option) 
				SaveSettings[Title] = option
				Collection:Save()
			end
		}
	)


	Collection:Save()
	--Dropdown:Refresh(Value) -- {"Options 1","Options 2"}
	return Dropdown_
end
function Collection:AddInput(Path,Title,Default,Placeholder)
	-- Configuration = {
	--     Title = "Item Count",
	--     Default = "1",
	--     Placeholder = "Enter the number of item count u need",
	--     Callback = function(input) 
	-- 		if not tonumber(input) then 
	-- 			Collection:Notify("Only Number Type")
	-- 		else 
	-- 			SaveSettings["Item Count"] = tonumber(input)
	-- 			Collection:Save()
	-- 		end 
	-- 	end
	-- }
	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 
	local Input = Path:Input(
		{
			Title = Title,
			Value = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
			PlaceholderText = Placeholder,
			Callback = function(input) 
				SaveSettings[Title] = input
				Collection:Save() 
			end
		}
	)

	Collection:Save()
	--Dropdown:Refresh(Value) -- {"Options 1","Options 2"}
	return Input
end
function Collection:AddSlider(Path,Title,Min,Max,Default)
	if _G.Configs and _G.Configs[Title] then
		SaveSettings[Title] = _G.Configs[Title]
	else 
		if not SaveSettings[Title] then 
			SaveSettings[Title] = Default
			Collection:Save()
		end 
	end 
	Path:Slider({
		Title = Title,
		Value = {
			Min = Min,
			Max = Max,
			Default = _G.Configs and _G.Configs[Title] or SaveSettings[Title] or Default,
		},
		Callback = function(value) 
			SaveSettings[Title] = value
			Collection:Save()  
		end
	})

	Collection:Save()
	--Dropdown:Refresh(Value) -- {"Options 1","Options 2"}
	return Input
end
----------------
-- Script generated by SimpleSpy - credits to exx#9394

local Main = Window:Tab({ Title = "Main", Icon = "toggle-left" })
local Visuals = Window:Tab({ Title = "Visuals", Icon = "app-window-mac" })
local Configs = Window:Tab({ Title = "Configs", Icon = "brain" })
Window:Divider()
local WindowTab = Window:Tab({ Title = "Window and File Configuration", Icon = "settings" })
local CreateThemeTab = Window:Tab({ Title = "Create Theme", Icon = "palette" })

Main:Section({ Title = "Auto Farm" })

Collection:AddToggle(Main,"Auto Farm",false)
Collection:AddDropdown(Main,"Dungeons",{"Orc Lands","The Crypt","Frosty Hills","The Swamps"},"Orc Lands",false)
Collection:AddDropdown(Main,"Mode",{"Easy","Medium","Hard"},"Easy",false)
Collection:AddToggle(Main,"Invasions",false)

Collection:AddToggle(Main,"Use Modify",false)
Collection:AddDropdown(Main,"Modify",{"NoPotions","ReduceMaxHPBy70","NoCampfires","NoMana","EliteEnemiesOnly","NoChests","Mobs2xHP","ReduceDamageBy50","Damage2x"},{},true)



Main:Section({ Title = "Party" })

Collection:AddToggle(Main,"Auto Party",false)
function getplrlist()
	local plarlist = {}
	for i,v in pairs(game.Players:GetChildren()) do
		if v.Name ~= LocalPlayer.Name then 
			table.insert(plarlist,v.Name)
		end
	end
	return plarlist
end

local SelectedPlayer = Collection:AddDropdown(Main,"Player Name",getplrlist(),{},true)
local PlayerAddedConnection = game.Players.ChildAdded:Connect(function()
	pcall(function()
		SelectedPlayer:Refresh(getplrlist())
	end)
end)
local PlayerRemoveConnection = game.Players.ChildRemoved:Connect(function()
	pcall(function()
		SelectedPlayer:Refresh(getplrlist())
	end)
end)
--Collection:AddDropdown(Main,"Position",{"Above","Below","Behide"},"Above",false)

Main:Section({ Title = "Auto Farm Settings" })

Collection:AddToggle(Main,"Full Auto Farm Level",false)
Collection:AddSlider(Main,"Farm Distance",1,20,5)
Collection:AddSlider(Main,"Hp Regen Percent",1,100,55)
Collection:AddSlider(Main,"MP Regen Percent",1,100,55)
Main:Section({ Title = "Skill Settings" })

task.wait(3)

local SkillTable = {}
for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HotBar.Info.Skills:GetChildren()) do 
	if v:IsA("TextButton") then 
		table.insert(SkillTable,v.Name)
	end 
end 
Collection:AddToggle(Main,"Auto Use Skills",false)

Collection:AddDropdown(Main,"Skills",SkillTable,{},true)

Collection:AddToggle(Main,"Auto Use Class Skill",false)

Visuals:Section({ Title = "Players" })

Visuals:Button({
	Title = "Identify All",
	Desc = "If you click this button, it will automatics identify all item u have.",
	Callback = function() 
		Collection:TeleportCFrame(CFrame.new(-476.339874, 4.99999952, 152.953506, -0.950386584, -1.66751875e-08, -0.311071277, -1.45295553e-08, 1, -9.21490617e-09, 0.311071277, -4.23799618e-09, -0.950386584))
		task.wait(.1)
		if game:GetService("Players").LocalPlayer.PlayerGui.InteractionZones.Blacksmith.IdentifyFrame.Selected.Action.ConfirmButton.Visible == false then 
			for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.InteractionZones.Blacksmith.IdentifyFrame.Items.Frame.Items:GetChildren()) do 
				if v:IsA("ImageButton") then 
					firesignal(v.Activated)
					break 
				end 
			end 
		end 
		task.wait(.1)
		firesignal(game:GetService("Players").LocalPlayer.PlayerGui.InteractionZones.Blacksmith.IdentifyFrame.Selected.Action.IdentifyAll.Activated)
	end,
})

Visuals:Button({
	Title = "Teleport To Merchant",
	Desc = "If you click this button, it will automatics teleport u to merchant.",
	Callback = function() 
		Collection:TeleportCFrame(CFrame.new(-536.070007, 4.99999952, 65.754509, -0.927255094, -1.9636607e-08, 0.374430269, -3.01867473e-08, 1, -2.23117897e-08, -0.374430269, -3.19915543e-08, -0.927255094))
	end,
})

Visuals:Section({ Title = "Visuals" })

Collection:AddToggle(Visuals,"Reduce CPU",false)
Collection:AddToggle(Visuals,"Protect Name",false)


if _G.Configs and _G.Configs["Reduce CPU"] then
	task.spawn(function()
		for i,v in pairs(game.Workspace:GetDescendants()) do 
			if v:IsA("ParticleEmitter") then 
				v:Destroy()
			end 
		end 
		UserSettings():GetService("UserGameSettings").MasterVolume = 0
		UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

		function Collection:TextureLow()
			-- ApLocalPlayer changes to the existing environment
			local g = game
			local w = g.Workspace
			local l = g:GetService"Lighting"
			local t = w:WaitForChild"Terrain"

			t.WaterWaveSize = 0
			t.WaterWaveSpeed = 0
			t.WaterReflectance = 0
			t.WaterTransparency = 1
			l.GlobalShadows = false
			-- Function to change object properties
			function change(v)
				pcall(function()
					if v.Material ~= Enum.Material.SmoothPlastic then
						pcall(function() v.Reflectance = 0 end)
						pcall(function() v.Material = Enum.Material.SmoothPlastic end)
						pcall(function() v.TopSurface = Enum.SurfaceType.SmoothNoOutlines end)
					end
				end)
			end

			-- ApLocalPlayer changes to new objects added to the game
			game.DescendantAdded:Connect(function(v)
				pcall(function()
					if v:IsA"Part" then change(v)
					elseif v:IsA"MeshPart" then change(v)
					elseif v:IsA"TrussPart" then change(v)
					elseif v:IsA"UnionOperation" then change(v)
					elseif v:IsA"CornerWedgePart" then change(v)
					elseif v:IsA"WedgePart" then change(v) end
				end)
			end)

			-- ApLocalPlayer changes to all existing descendants
			for i, v in pairs(game:GetDescendants()) do
				pcall(function()
					if v:IsA"Part" then change(v)
					elseif v:IsA"MeshPart" then change(v)
					elseif v:IsA"TrussPart" then change(v)
					elseif v:IsA"UnionOperation" then change(v)
					elseif v:IsA"CornerWedgePart" then change(v)
					elseif v:IsA"WedgePart" then change(v) end
				end)
			end
		end

		Collection:TextureLow()

		while true do
			if Library.Unloaded or Collection.UnLoaded or Collection.BreakLoop then break end
			pcall(function()
				for _, obj in pairs(game.Players:GetDescendants()) do
					if obj:IsA("ParticleEmitter") then

						-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
						obj.Enabled = false
						obj.Rate = 0
						obj.Lifetime = NumberRange.new(0)
						obj.Speed = NumberRange.new(0)
						obj.Rotation = NumberRange.new(0)
						obj.Size = NumberSequence.new(0)
						obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
						-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
						--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
					end
					task.wait(0)
				end
				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("ParticleEmitter") then

						-- ตั้งค่าคุณสมบัติต่างๆ ของ ParticleEmitter เป็น 0
						obj.Enabled = false
						obj.Rate = 0
						obj.Lifetime = NumberRange.new(0)
						obj.Speed = NumberRange.new(0)
						obj.Rotation = NumberRange.new(0)
						obj.Size = NumberSequence.new(0)
						obj.Transparency = NumberSequence.new(1)  -- ทำให้โปร่งใสเต็มที่ (ไม่มองเห็น)
						-- สามารถเพิ่มคุณสมบัติอื่นๆ ตามความจำเป็น
						--print(obj:GetFullName() .. " has been set to zero.")  -- พิมพ์เส้นทางของอ็อบเจค
					end
					task.wait(0)
				end
			end)
			task.wait(0)
		end
	end)
end

Visuals:Section({ Title = "Game" })

Collection:AddToggle(Visuals,"Fps Lock",false)

Collection:AddInput(Visuals,"Fps Cap",240,"Enter Fps Number")

Collection:AddToggle(Visuals,"White Screen",false)

Visuals:Button({
	Title = "Rejoin Server",
	Desc = "If you click this button, You will rejoin the server.",
	Callback = function() 
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
	end,
})

Visuals:Button({
	Title = "Hop Server",
	Desc = "If you click this button, You will hop the server.",
	Callback = function() 
		local PlaceID = game.PlaceId
		local AllIDs = {}
		local foundAnything = ""
		local actualHour = os.date("!*t").hour
		local Deleted = false
		local File = pcall(function()
			AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
		end)
		if not File then
			table.insert(AllIDs, actualHour)
			writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
		end
		function TPReturner()
			local Site;
			if foundAnything == "" then
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
			else
				Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
			end
			local ID = ""
			if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
				foundAnything = Site.nextPageCursor
			end
			local num = 0;
			for i,v in pairs(Site.data) do
				local Possible = true
				ID = tostring(v.id)
				if tonumber(v.maxPlayers) > tonumber(v.playing) then
					for _,Existing in pairs(AllIDs) do
						if num ~= 0 then
							if ID == tostring(Existing) then
								Possible = false
							end
						else
							if tonumber(actualHour) ~= tonumber(Existing) then
								local delFile = pcall(function()
									delfile("NotSameServers.json")
									AllIDs = {}
									table.insert(AllIDs, actualHour)
								end)
							end
						end
						num = num + 1
					end
					if Possible == true then
						table.insert(AllIDs, ID)
						wait()
						pcall(function()
							writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
							wait()
							game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
						end)
						wait(4)
					end
				end
			end
		end

		function Teleport()
			while wait() do
				pcall(function()
					TPReturner()
					if foundAnything ~= "" then
						TPReturner()
					end
				end)
			end
		end

		-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
		Teleport()
	end,
})


Configs:Button({
	Title = "Generate Configs",
	Desc = "Before clicking, the script will generate your current function to configs.",
	Callback = function() 
		_G.Configs = {}
		local String = [[_G.Configs = {
]]

		for key, value in pairs(SaveSettings) do
			_G.Configs[key] = value
			local text = ('    ["%s"] = '):format(key)
			local value_text = ""
			local value_type = type(value)
			if value_type == "boolean" then
				value_text = tostring(value) .. ",\n"
			elseif value_type == "table" then
				value_text = "{\n       "
				for k, v in pairs(value) do
					value_text = value_text .. ('"%s",\n        '):format(tostring(v))
				end
				value_text:sub(1, -2)
				value_text = value_text .. "},\n"
			else
				value_text = ('"%s",\n'):format(tostring(value))
			end

			String = String .. text .. value_text
			task.wait()
		end

		String = String .. "}"

		setclipboard(String)
	end,
})

local LobbyPlace = 112315720097464 

function Collection:CheckMagnitude(pos)
	return (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - pos).Magnitude 
end 

function Collection:AutoEquipWeapon()
	if LocalPlayer.Character:GetAttribute("IsEquipped") == false then 
		local args = {
			[1] = "Equip/UnEquip"
		}

		game:GetService("ReplicatedStorage").Events.WeaponsEvent:FireServer(unpack(args))
		task.wait(.1)
	end 
end
function Collection:getNearestEnemy()
	local closest
	local shortestDistance = math.huge

	for _, obj in pairs(workspace.Characters:GetChildren()) do
		if obj ~= LocalPlayer.Character and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") and obj.Humanoid.Health > 0 and not game.Players:FindFirstChild(obj.Name) and not game.Players:FindFirstChild(tostring(obj.Name)) then
			local dist = (obj.HumanoidRootPart.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if dist < shortestDistance then
				closest = obj
				shortestDistance = dist
			end
		elseif obj ~= LocalPlayer.Character and not obj:FindFirstChild("HumanoidRootPart") and not game.Players:FindFirstChild(obj.Name) and not game.Players:FindFirstChild(tostring(obj.Name)) then 
			local dist = (obj:GetModelCFrame().Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude
			if dist < shortestDistance then
				closest = obj
				shortestDistance = dist
			end
		end
	end

	return closest
end


function Collection:Attack(pos)
	if (LocalPlayer.Character:GetAttribute("Class") == "Ranger" or LocalPlayer.Character:GetAttribute("Class") == "Wizard") and pos then 
		local args = {
			[1] = "Attack",
			[2] = pos,
		}
	
		game:GetService("ReplicatedStorage").Events.Combat:FireServer(unpack(args))
	else 
		local args = {
			[1] = "Attack"
		}
	
		game:GetService("ReplicatedStorage").Events.Combat:FireServer(unpack(args))
	end 
end 

local Part_Proprerties = {Name = "Deity-Tween",Anchored = true,Transparency = 1,CanCollide = false}
local RoomCheck = nil
function Collection:TeleportTo(Object)
	 --Collection:TeleportCFrame(Object)  r
	pcall(function()
		local room = RoomCheck
		if room and room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️" then 
			LocalPlayer.Character:PivotTo(Object * CFrame.new(0,-2,0))
		else 
			local distance = (LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position - Object.Position).Magnitude
			local Linear = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity
			LocalPlayer.Character:FindFirstChild("HumanoidRootPart").AssemblyLinearVelocity = Linear * Vector3.new(1, 0, 1, 0)
			if distance >= 500 then 
				local Position = (typeof(Object) == "CFrame") and Object.Position or Object
				local HumanoidRootPart = Collection:GetRoot(LocalPlayer.Character)
				local Always_Distancing =  Collection:GetSelfDistance(Position)
				local InBetween_Part = Workspace:FindFirstChild("Deity-Tween") or Instance.new("Part",workspace)
				for Proprerty,Value in pairs(Part_Proprerties) do InBetween_Part[Proprerty] = Value end
				local DistanceFromPart = Collection:GetSelfDistance(InBetween_Part.Position)
				local Max_Distance = 100
				local Max_Speed = 1000
				if Always_Distancing <= Max_Distance then
					return Collection:TeleportCFrame(Position)  
				end
				if Always_Distancing > 1000 then 
					Max_Speed = 1000
				end
			
				if DistanceFromPart >= 150 then
					InBetween_Part.CFrame = HumanoidRootPart.CFrame
				end
			
				TweenService:Create(InBetween_Part, TweenInfo.new(Always_Distancing / Max_Speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Position)}):Play()
				Collection:TeleportCFrame(InBetween_Part.CFrame)
			else 
				LocalPlayer.Character:PivotTo(Object * CFrame.new(0,-2,0))
			end 
		end 
	end)
end
local FindChest = true
function Collection:CollectChest(room)
	if room ~= nil then 
		RoomCheck = room
		if RoomCheck then 
			if RoomCheck:FindFirstChild("Chest") then 
				local chest = RoomCheck:FindFirstChild("Chest")
				if chest:FindFirstChild("ProximityPrompt") and not chest:FindFirstChild("ForceField") and chest:GetAttribute("Collected") == nil then 
					FindChest = true 
					Collection:TeleportTo(chest:GetModelCFrame())
					if chest.ModelStreamingMode ~= "Persistent" then 
						chest.ModelStreamingMode = "Persistent"
					end 
					task.wait()
					if chest and chest:FindFirstChild("ProximityPrompt") and not chest:FindFirstChild("ForceField") then 
						Collection:TeleportTo(chest:GetModelCFrame())
						task.wait(.5)
						fireproximityprompt(chest.ProximityPrompt)
						chest:SetAttribute("Collected",true)
						FindChest = false
					end 
				end 
			end 
		end 
	else 
		for i,v in pairs(game.Workspace.Tower:GetDescendants()) do 
			if v.Name == "Chest" and v:FindFirstChild("ProximityPrompt") and not v:FindFirstChild("ForceField") and v:GetAttribute("Collected") == nil then 
				Collection:TeleportTo(v:GetModelCFrame())
				FindChest = true 
				task.wait(.5)
				if v.ModelStreamingMode ~= "Persistent" then 
					v.ModelStreamingMode = "Persistent"
				end 
				if v and v:FindFirstChild("ProximityPrompt") and not v:FindFirstChild("ForceField") then 
					Collection:TeleportTo(v:GetModelCFrame())
					task.wait(.5)
					fireproximityprompt(v.ProximityPrompt)
					task.wait(v.ProximityPrompt.HoldDuration)
					v:SetAttribute("Collected",true)
					FindChest = false
				end 
			end
		end 
	end 
end 
local findresult = false
function Collection:Dice(room)
	if room ~= nil and room:FindFirstChild("Dice") then 
		if not findresult then 
			Collection:TeleportTo(room:FindFirstChild("Dice"):FindFirstChild("Dice").CFrame)
			task.wait(1)
			fireproximityprompt(room:FindFirstChild("Dice"):FindFirstChild("Dice").ProximityPrompt)
			task.wait(2)
			findresult = true 
			for i,v in pairs(room:FindFirstChild("Dice"):GetChildren()) do 
				if v.Name ~= "Dice" then 
					if not v:FindFirstChild("ForceField") then 
						if v:FindFirstChild("Result") then 
							Collection:TeleportTo(v:FindFirstChild("Result"):FindFirstChild("PrimaryPart").CFrame)
							task.wait(1)
							fireproximityprompt(v:FindFirstChild("Result").ProximityPrompt)
							task.wait(1)
							break
						end 
						if v:FindFirstChild("Skull") then 
							TeleportService:Teleport(LobbyPlace, LocalPlayer)
							task.wait(2)
							--break
						end 
					end 
				end 
			end 
		end 
	end 
end 
local OldPos = nil
local DontHeal = false
function Collection:KillEnemyHandle(nearestEnemy,MPPercent)
	nearestEnemy = Collection:getNearestEnemy()
	if nearestEnemy and nearestEnemy:FindFirstChild("HumanoidRootPart") then 
		print("FindRootPart")
		OldPos = nearestEnemy:FindFirstChild("HumanoidRootPart").CFrame
		if SaveSettings["Auto Use Class Skill"] then
			for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HotBar.Info.ClassSkill:GetChildren()) do 
				if v:IsA("TextButton") and MPPercent >= 25 then 
					Collection:fireclickbutton(v)
					task.wait()
				end 
			end 
		end  
		if SaveSettings["Auto Use Skills"] then 
			if SaveSettings["Skills"] then 
				for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.HotBar.Info.Skills:GetChildren()) do 
					if table.find(SaveSettings["Skills"],tostring(v.Name)) and v:IsA("TextButton") then 
						if  MPPercent >= 25 then 
							Collection:fireclickbutton(v)
							task.wait()
						end 
					end 
				end 
			end 
		end 
		if nearestEnemy.ModelStreamingMode ~= "Persistent" then 
			nearestEnemy.ModelStreamingMode = "Persistent"
		end 
		if nearestEnemy:GetAttribute("IsSkillUsing") and nearestEnemy:GetAttribute("IsSkillUsing") == true and nearestEnemy:GetAttribute("IsBoss") == true then 
			if nearestEnemy:GetAttribute("IsBoss") == true then 
				Collection:TeleportCFrame(nearestEnemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, SaveSettings["Farm Distance"] + 5, 0))
			else 
				Collection:TeleportTo(nearestEnemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, SaveSettings["Farm Distance"] + 5, 0))
			end 
			
			local args = {
				[1] = "HP"
			}

			game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))

			Collection:CollectChest(room)

			local args = {
				[1] = "MP"
			}

			game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
		else 
			if nearestEnemy:GetAttribute("IsBoss") == true then 
				Collection:TeleportCFrame(nearestEnemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, SaveSettings["Farm Distance"] + 5, 0))
			else 
				Collection:TeleportTo(nearestEnemy:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, SaveSettings["Farm Distance"]))
			end 
		end 
		Collection:Attack(nearestEnemy:FindFirstChild("HumanoidRootPart").Position)

	else 
		local Mp = LocalPlayer.Character:GetAttribute("MP")
		local MaxMp = LocalPlayer.Character:GetAttribute("MaxMP")
		local MPPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
		if OldPos then 
			print("Teleport To Old Pls")
			Collection:TeleportTo(OldPos)
		else 
			--print("Teleport To Portal")
			if room ~= nil then 
				Collection:TeleportPortal(room)
			else 
				nearestEnemy = Collection:getNearestEnemy()
				if nearestEnemy then 
					--print("FindNearestEnemy")
					Collection:TeleportCFrame(nearestEnemy:GetModelCFrame())
					
				else 
					print("Don't Find")
					Collection:CollectChest(room)
					Collection:ExitDungeon(room)
				end 
			end 
		end 
	end 
end 

function Collection:ExitDungeon(room)
	if room ~= nil and room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️" then 
			Collection:CollectChest(room)
			nearestEnemy = Collection:getNearestEnemy()
			Collection:CollectChest(room)
			if FindChest == false and not nearestEnemy then 
			print("FINDCHEST FALSE")
			task.wait(1)
			Collection:TeleportTo(room.ExitPortal.CFrame * CFrame.new(0,10,0))
			task.wait(1.5)
			fireproximityprompt(room.ExitPortal.ProximityPrompt)
			task.wait(1)
			if game:GetService("Players").LocalPlayer.PlayerGui.ScreenInfo.GameResult.Visible == true then 
				Collection:fireclickbutton(game:GetService("Players").LocalPlayer.PlayerGui.ScreenInfo.GameResult.Buttons.ConfirmButton)
			end 
		end 
	end 
end 
local justteleport = false
local oldportalpos = nil
function Collection:TeleportPortal(room)
	if room ~= nil then 
		Collection:Dice(room)
		Collection:CollectChest(room)
	
		local portal = room:FindFirstChild("Out") and room:FindFirstChild("Out"):FindFirstChild("Portal")
		if portal and not justteleport then
			local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local hrp = character:WaitForChild("HumanoidRootPart")
	
			local oldPos = hrp.Position
			local startTime = tick()
	
			Collection:TeleportTo(portal.CFrame )
	
			local timeout = .5
			repeat
				task.wait(0.1)
			until (hrp.Position - oldPos).Magnitude > 5 or tick() - startTime > timeout or not SaveSettings["Auto Farm"]
			task.wait(.1)
			if (hrp.Position - oldPos).Magnitude <= 5 then
				warn("Teleport failed or took too long. Retrying...")
				Collection:TeleportTo(portal.CFrame * CFrame.new(0, 0, 5))
				task.wait(.1)
				Collection:TeleportTo(portal.CFrame)
				task.wait(.1)
			end
		end
	end 
end 

local modifications = {
	"NoPotions",
	"ReduceMaxHPBy70",
	"NoCampfires",
	"NoMana",
	"EliteEnemiesOnly",
	"NoChests",
	"Mobs2xHP",
	"ReduceDamageBy50",
	"Damage2x"
}

local args2 = {}

for _, mod in ipairs(modifications) do
	if table.find(SaveSettings["Modify"], mod) and SaveSettings["Use Modify"] then
		args2[mod] = true
	end
end

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
					if nearestEnemy:GetAttribute("IsBoss") == true or room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️" then 
						if room.ModelStreamingMode ~= "Persistent" then 
							room.ModelStreamingMode = "Persistent"
						end 
						local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
						local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
						local mpPercent = math.floor((tonumber(Mp) / tonumber(MaxMp)) * 100)
						Collection:TeleportCFrame(workspace.Tower.StartRoom.Campfire.Hitbox.CFrame)
						
						--LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = StartCampPos
						-- print("Recovery")
						local args = {
							[1] = "HP"
						}
		
						game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
	
	
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
							Collection:TeleportCFrame(workspace.Tower.StartRoom.Campfire.Hitbox.CFrame)
							--LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = workspace.Tower.StartRoom.Campfire:GetModelCFrame()
							print("Recovery")
							local args = {
								[1] = "HP"
							}
		
							game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
	
							local args = {
								[1] = "MP"
							}
		
							game:GetService("ReplicatedStorage").Events.UsePotion:FireServer(unpack(args))
							justteleport = true 
	
							task.wait()
						until nearestEnemy:GetAttribute("IsBoss") == true or ( room:FindFirstChild("Floor") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum") and room:FindFirstChild("Floor"):FindFirstChild("SurfaceGui"):FindFirstChild("RoomNum").Text == "☠️") or (LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health >= LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MaxHealth and tonumber(LocalPlayer.Character:GetAttribute("MP")) >= tonumber(LocalPlayer.Character:GetAttribute("MaxMP"))) 
							or _G.BreakAllFunction 
							or not SaveSettings["Auto Farm"]					
							justteleport = false 
							Collection:CollectChest(room)
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
								if Collection:CheckMagnitude(room:GetModelCFrame().Position) <= 500 then
									if room.Name == "StartRoom" then 
										if room.ModelStreamingMode ~= "Persistent" then 
											room.ModelStreamingMode = "Persistent"
										end 
										Collection:TeleportPortal(room)
									end 
									if StartCampPos == nil and tower:FindFirstChild("StartRoom"):FindFirstChild("Campfire"):FindFirstChild("Hitbox") then 
										StartCampPos = workspace.Tower.StartRoom.Campfire.Hitbox.CFrame * CFrame.new(0,3,0)
										
									else 
										StartCampPos = workspace.Tower.StartRoom.Campfire:GetModelCFrame() * CFrame.new(0,3,0)
									end 
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
		if game.PlaceId ~= LobbyPlace then
			task.wait()
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
		task.wait()
		if _G.BreakAllFunction then
			break
		end
        if game.PlaceId ~= LobbyPlace then
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
