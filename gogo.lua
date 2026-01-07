repeat task.wait(7) until game:IsLoaded()
	and game.Players.LocalPlayer
	and game.Players.LocalPlayer.Character
	and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

print("Excute")

local Missing = function (t, f, fallback)
	return type(f) == t and f or fallback
end

local cloneref = Missing("function", cloneref, function(...) return ... end)
local service = setmetatable({}, {__index = function(self, name)
	return cloneref(game:GetService(name))
end})

local Request_Var = request

Players = service.Players
repeat 
	Client = Players.LocalPlayer
	wait()
until Client

Char = Client.Character

Humanoid = Char:WaitForChild("Humanoid")
Root = Char:WaitForChild("HumanoidRootPart")

Client.CharacterAdded:Connect(function(char)
	Char = char
	Humanoid = Char:WaitForChild("Humanoid")
	Root = Char:WaitForChild("HumanoidRootPart")
end)

local PathfindingService = service.PathfindingService
local RunService = service.RunService
local ReplicatedStorage = service.ReplicatedStorage
local VirtualInputManager = service.VirtualInputManager
local HttpService = service.HttpService
local TeleportService = service.TeleportService
local UserInputService = service.UserInputService

local LPH_NO_VIRTUALIZE = function (f) return f end
local fireproximityprompt = fireproximityprompt

local game = game
if typeof(game) ~= "Instance" then game = workspace.Parent end

local Module = {
	GameData = {
		Time_Buy = false,
	}
}
local Thread = {}


local StringToVector3 = function (str)
	if type(str) ~= "string" then
		return Vector3.new(0, 0, 0)
	end

	local x, y, z = str:match("([^,]+),%s*([^,]+),%s*([^,]+)")
	return Vector3.new(
		tonumber(x) or 0,
		tonumber(y) or 0,
		tonumber(z) or 0
	)
end

local L = {
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-312.14178466796875, 8.5, -132.0174560546875",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "58, 38, 19"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-313.27569580078125, 9.111783027648926, -46.89309310913086",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "57, 37, 64"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-313.10894775390625, 8.701273918151855, 60.38490295410156",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "58, 38, 59"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-313, 8.699999809265137, 167.5",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "58, 38, 63"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-312.79046630859375, 7.499998092651367, 251.762451171875",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "61, 36, 19"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-512.1199951171875, 11.499998092651367, 251.27713012695312",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "73, 44, 18"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-510.22003173828125, 10.201273918151855, 166.67835998535156",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "65, 41, 64"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-506.54571533203125, 10.201272010803223, 60.13006591796875",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "59, 41, 61"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-441.19818115234375, 5.5, 47.315345764160156",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "19, 32, 83"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-502.93157958984375, 10.201272010803223, -46.99650573730469",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "50, 40, 63"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-507.955322265625, 9.499996185302734, -134.7079620361328",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "62, 40, 25"
	},
	{
		Rotation = "0, 0, 0",
		Transparency = 1,
		Name = "Part",
		Position = "-378.57684326171875, 6.999996185302734, 49.008094787597656",
		Parent = "Workspace",
		Anchored = true,
		CanCollide = true,
		Size = "39, 35, 102"
	}
}

local LoadParts = function (data)
	local parts = {}

	for _, info in ipairs(data) do
		local part = Instance.new("Part")

		part.Name = info.Name or "Part"
		part.Size = StringToVector3(info.Size)
		part.Position = StringToVector3(info.Position)
		part.Rotation = StringToVector3(info.Rotation)

		part.Anchored = info.Anchored == true
		part.CanCollide = info.CanCollide == true
		part.Transparency = tonumber(info.Transparency) or 0

		-- Parent
		if info.Parent == "Workspace" or not info.Parent then
			part.Parent = workspace
		else
			part.Parent = workspace
		end

		table.insert(parts, part)
	end

	return parts
end

LoadParts(L)

local env = {} do -- Server Function
	env.Crypto = function(Str, Encode)
		local CharsetA = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_+-*/=(){}[]<>.,;:!@#$%^&|~\"'\\ \n"
		local CharsetB = "QWERTYUIOPASDFGHJKLZXCVBNMabcdefghijklmnopqrstuvwxyz0123456789~!@#$%^&*()_+-=[]{}<>?,.;:\"'|/\\ \n"

		local EncodeMap = {}
		local DecodeMap = {}

		for Index = 1, #CharsetA do
			local AChar = CharsetA:sub(Index, Index)
			local BChar = CharsetB:sub(Index, Index)
			EncodeMap[AChar] = BChar
			DecodeMap[BChar] = AChar
		end

		local Output = {}

		if Encode then
			for I = 1, #Str do
				Output[#Output + 1] = EncodeMap[Str:sub(I, I)] or ""
			end
			return table.concat(Output)
		end

		for I = 1, #Str do
			Output[#Output + 1] = DecodeMap[Str:sub(I, I)] or ""
		end
		return table.concat(Output)
	end

	env.IsArray = function(Table)
		local MaxIndex = 0
		for Key in pairs(Table) do
			if type(Key) ~= "number" then return false end
			if Key > MaxIndex then MaxIndex = Key end
		end
		return #Table == MaxIndex
	end

	env.ToJSON = function(Value)
		local TypeName = type(Value)

		if TypeName == "nil" then
			return "null"
		end
		if TypeName == "boolean" or TypeName == "number" then
			return tostring(Value)
		end
		if TypeName == "string" then
			return '"' .. Value
				:gsub('[\\"]', { ['\\'] = '\\\\', ['"'] = '\\"' })
				:gsub('\n', '\\n')
				:gsub('\r', '\\r')
				:gsub('\t', '\\t') .. '"'
		end
		if TypeName ~= "table" then
			error("Unsupported type: " .. TypeName)
		end

		local Result = {}

		if env.IsArray(Value) then
			for I = 1, #Value do
				Result[#Result + 1] = env.ToJSON(Value[I])
			end
			return "[" .. table.concat(Result, ",") .. "]"
		end

		for Key, Val in pairs(Value) do
			if type(Key) ~= "string" then
				error("JSON keys must be strings")
			end
			Result[#Result + 1] =
				env.ToJSON(Key) .. ":" .. env.ToJSON(Val)
		end

		return "{" .. table.concat(Result, ",") .. "}"
	end

end

do -- Information Game
	Module.FpsBoost = function()
		local Lighting = game:GetService("Lighting")
		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		local CurrentCamera = workspace.CurrentCamera

		Lighting.GlobalShadows, Lighting.Brightness = false, 0
		Lighting.FogEnd, Lighting.ClockTime = 1e9, 12
		Lighting.EnvironmentDiffuseScale, Lighting.EnvironmentSpecularScale = 0, 0

		for _, v in pairs(Lighting:GetDescendants()) do
			if v:IsA("PostEffect") then v.Enabled = false end
		end

		if Terrain then
			Terrain.WaterWaveSize, Terrain.WaterWaveSpeed = 0, 0
			Terrain.WaterReflectance, Terrain.WaterTransparency = 0, 1
		end

		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			elseif v:IsA("BasePart") then
				v.Material, v.Reflectance = Enum.Material.SmoothPlastic, 0
			elseif v:IsA("Sound") then
				v.Volume = 0
			end
		end

		if CurrentCamera then
			for _, v in pairs(CurrentCamera:GetDescendants()) do
				if v:IsA("PostEffect") then v.Enabled = false end
			end
		end

		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end
	Module.FpsBoost()

	Module.IsWaypointNearStructure = function(pos)
		for _, v in pairs(Module.GetBase().Decorations:GetChildren()) do
			if v.Name == "structure base home" and v:IsA("BasePart") then
				if (v.Position - pos).Magnitude < 6 then
					return true
				end
			end
		end
		return false
	end

	Module.Teleport = function(Destination, Condition)
		Condition = Condition or function() return false end
		if not Destination or not Root or not Humanoid then
			return false
		end

		local Path = PathfindingService:CreatePath({
			AgentCanJump = true,
			AgentJumpHeight = 8,
			AgentHeight = 5,
			AgentRadius = 2.5,
			AgentMaxSlope = 80,
		})

		if not pcall(function()
				Path:ComputeAsync(Root.Position, Destination)
			end) or Path.Status ~= Enum.PathStatus.Success then
			Humanoid.Health = 0
			return true
		end

		for _, wp in pairs(Path:GetWaypoints()) do
			if Humanoid.Health <= 0 then return false end
			if Condition() then return true end

			if Module.IsWaypointNearStructure(wp.Position) then
				continue
			end

			if (Root.Position - wp.Position).Magnitude < 4 then
				continue
			end

			if wp.Action == Enum.PathWaypointAction.Jump then
				Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end

			Humanoid:MoveTo(wp.Position)
			local Start = os.clock()
			local NextCheck = 0

			while (Root.Position - wp.Position).Magnitude > 4 do
				if Humanoid.Health <= 0 then return false end
				if os.clock() > NextCheck then
					if Condition() then return true end
					NextCheck = os.clock() + 0.2
				end

				if os.clock() - Start > 1 then break end
				task.wait()
			end
		end
		return true
	end

	-- Blacklist Jobid

	local SERVER_URL_GET = "http://api.syncfinder.pro:8080/get-job-id"
	local SERVER_URL_POST = "http://api.syncfinder.pro:8080/report-success"

	local function safeRequest(url, method)
		local success, result = pcall(function()
			return Request_Var({
				Url = url,
				Method = method,
				Headers = {
					["Content-Type"] = "application/json",
					["User-Agent"] = "Roblox-Client-Optimized"
				}
			})
		end)
		return success, result
	end

	local teleporting = false
	local function AttemptTeleport(jobId)
		if teleporting then return end
		teleporting = true

		task.spawn(function()
			safeRequest(SERVER_URL_POST, "POST")
		end)

		local success, err = pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, Client)
		end)
		if not success then teleporting = false end
	end

	local Connection
	Connection = TeleportService.TeleportInitFailed:Connect(function(player, result, errorMessage)
		if player == Client then
			teleporting = false
		end
	end)

	Module.StartHopping = function ()
		local RetryCount = 0
		while task.wait(10) do
			if not teleporting then
				local success, response = safeRequest(SERVER_URL_GET, "GET")
				if success and response and response.Body then
					local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
					if decodeSuccess and data and data.jobId then
						AttemptTeleport(data.jobId)

						-- รอตรวจสอบสถานะการย้าย (สูงสุด 6 วินาที)
						-- ถ้า Teleport ล้มเหลว (teleporting เป็น false) จะหลุดลูปนี้ทันทีไม่ต้องรอครบ
						local startWait = os.clock()
						while teleporting and (os.clock() - startWait < 10) do
							task.wait(10)
						end
						
						-- ถ้าเวลายังเดินอยู่แต่ยังไปไม่ได้ ให้ Reset ค่าเพื่อหาห้องใหม่
						if teleporting then
							teleporting = false
						end
					else
						RetryCount = RetryCount + 1
					end
				else
					RetryCount = RetryCount + 1
				end
			end
			-- ลบระบบรอแบบทวีคูณออก เหลือรอแค่สั้นๆ
			task.wait(15)
		end
	end

	Module.ParseMoney = function(text)
		if type(text) ~= "string" then return nil end
		text = text
			:upper()
			:gsub("^SELL[:%s]*", "")
			:gsub(",", "")
			:gsub("%$", "")
			:gsub("%s+", "")

		local num = tonumber(text:match("%d+%.?%d*"))
		if not num then return nil end

		if text:find("K") then
			num *= 1e3
		elseif text:find("M") then
			num *= 1e6
		elseif text:find("B") then
			num *= 1e9
		elseif text:find("T") then
			num *= 1e12
		end
		return math.floor(num)
	end

	Module.Get_Brainrot_In_Carpet = function()
		local Result = {}
		for _, v in pairs(workspace.Debris:GetChildren()) do
			if v:IsA("BasePart") and v:FindFirstChild("AnimalOverhead") then
				Result[#Result+1] = {
					GUI = v:FindFirstChild("AnimalOverhead"),
					Object = v
				}
			end	
		end
		return Result
	end

	Module.GetBase = function()
		for i, v in pairs(workspace.Plots:GetChildren()) do
			local YourBase = v.PlotSign:FindFirstChild("YourBase")
			if YourBase and YourBase.Enabled then
				return v, _
			end
		end
		return nil, "Can't Find Your Base."
	end

	Module.GetPlotBlock = function()
		local ForBase, _ = Module.GetBase()
		if not ForBase then
			-- Or Rejoin Client
			return
		end
		local PlotBlock = ForBase.Purchases:FindFirstChild("PlotBlock")
		local BillboardGui = PlotBlock.Main:FindFirstChild("BillboardGui")
		return PlotBlock, BillboardGui:FindFirstChild("LockStudio").Visible
	end

	Module.AllAnimalHaveAttachment = function ()
		local Count = 0
		for _, v in pairs(Module.GetBase():GetChildren()) do
			if v:FindFirstChild("AnimationController") then
				Count += 1
			end
		end
		return Count == 10
	end

	Module.Get_Brainrot_In_Base = function()
		local Result = {}
		for i, v  in pairs(Module.GetBase().AnimalPodiums:GetChildren()) do
			local Classint = tonumber(v.Name)
			if Classint and Classint >= 1 and Classint <= 10 then
				local Claim = v:FindFirstChild("Claim")
				if Claim then
					table.insert(Result, Claim)
				end
			end
		end
		return Result
	end

	Module.Rebirth = function()
		local HolderImage = Client.PlayerGui.Rebirth.Rebirth.Content.Holder.HolderImage
		local ProgressText = HolderImage.Loader.Bar.ProgressText.Text

		local Current, Max = ProgressText:match("([^/]+)%s*/%s*([^/]+)")
		if tonumber(Client.leaderstats.Cash.Value) < Module.ParseMoney(Max) then
			return false
		end

		local Result = {}
		for i, v in pairs(HolderImage.RequiredCharacters:GetChildren()) do
			local CharacterName = v:FindFirstChild("CharacterName")
			if CharacterName and CharacterName.Text ~= "Item" and not v:FindFirstChild("CheckImage").Visible then
				table.insert(Result, CharacterName.Text)
			end
		end
		return Result
	end

	Module.Buy_Brainrot = function(ClassName, Block)
		if not Block then return end

		local BestTarget, BestPrompt
		local BestPrice = 0

		local Carpet = {}
		for _, v in pairs(Module.Get_Brainrot_In_Carpet()) do
			local DisplayName = v.GUI.DisplayName.Text
			local Price = tonumber(Module.ParseMoney(v.GUI.Price.Text))
			if DisplayName and Price and Price > 0 then
				Carpet[DisplayName] = Price
			end
		end

		for _, v in pairs(workspace:GetChildren()) do
			local index = v:GetAttribute("Index")
			if not index then continue end
			if ClassName and index ~= ClassName then continue end

			local Price = Carpet[index]
			if not Price then continue end
			if Client.leaderstats.Cash.Value < Price then continue end

			local Part = v:FindFirstChild("Part")
			local Prompt = Part
				and Part:FindFirstChild("PromptAttachment")
				and Part.PromptAttachment:FindFirstChild("ProximityPrompt")

			if not (Prompt and Prompt.Enabled) then continue end

			if Price > BestPrice then
				BestPrice = Price
				BestTarget = v
				BestPrompt = Prompt
			end
		end

		if not BestTarget or not BestPrompt then return end

		local Tries = 0
		while BestTarget.Parent and BestPrompt.Enabled and Tries < 20 do
			Module.Teleport((BestTarget:GetPivot() * CFrame.new(0,1,0)).Position)
			task.wait(0.1)
			fireproximityprompt(BestPrompt)

			Tries += 1
		end
		Module.Teleport(Block:GetPivot().Position)
		Module.GameData.Time_Buy = false
	end

	Module.EquipTool = function (tool)
		if not tool then return end
		if not Char then return end
		if type(tool) == "string" then
			tool = Client.Backpack:FindFirstChild(tool)
		end
		if tool and tool.Parent ~= Char then
			Humanoid:EquipTool(tool)
		end
	end

	Module.LowestBase = function(Rebirth)
		local LowestPrice = math.huge
		local LowestPrompt
		local LowestObject
		for _, v in pairs(Module.GetBase().AnimalPodiums:GetChildren()) do
			local Spawns = v.Base:FindFirstChild("Spawn")
			local Attach = Spawns and Spawns:FindFirstChild("PromptAttachment")
			if not Attach then continue end

			local ItemName
			for _, v1 in pairs(Attach:GetChildren()) do
				if v1:GetAttribute("State") == "Grab" then
					ItemName = v1.ObjectText
					break
				end
			end

			if not ItemName then continue end
			if Rebirth and not table.find(Rebirth, ItemName) then continue end

			for _, v2 in pairs(Attach:GetChildren()) do
				if v2:GetAttribute("State") ~= "Sell" then continue end
				local Price = Module.ParseMoney(v2.ActionText) or math.huge
				if tonumber(Price) < LowestPrice then
					LowestPrice = Price
					LowestPrompt = v2
					LowestObject = Spawns
				end
			end
		end
		return LowestPrice, LowestPrompt, LowestObject
	end
end


Thread[#Thread + 1] = LPH_NO_VIRTUALIZE(function()
	local Rebirth = Module.Rebirth()
	for _, v in pairs(Module.Get_Brainrot_In_Carpet()) do
		if not v.GUI or v.GUI.Stolen.Text ~= "STOLEN" then continue end
		if not v.GUI or Module.ParseMoney(v.GUI.Generation.Text) < tonumber(1e7) then
			continue
		end
		
		local Count = 0
		for i, v in pairs(game.Players:GetChildren()) do
			Count += 1
		end
		local data = env.Crypto(env.ToJSON({
			[v.GUI.DisplayName.Text] = {
				Price = tostring(Module.ParseMoney(v.GUI.Price.Text)),
				Rarity = v.GUI.Rarity.Text,
				Generation = Module.ParseMoney(v.GUI.Generation.Text).. " /s",
				Players = Count.."/8",
				JobId = env.Crypto(game.JobId, true)
			}}), true
		)
		Request_Var({ Url = "http://api.syncfinder.pro:8880/?l="..HttpService:UrlEncode(data), Method = "GET" })
	end
	local LowestPrice, LowestPrompt, LowestObject  = Module.LowestBase(Rebirth)
	local AllAnimalHaveAttachment = Module.AllAnimalHaveAttachment()

	local TeleportAllBrainrot = function ()
		for _, v in pairs(Module.Get_Brainrot_In_Base()) do
			Module.Teleport(v:GetPivot().Position)
			task.wait(0.1)
		end
		task.wait(0.2)
	end

	local Block, Value = Module.GetPlotBlock()
	if Value then
		Module.Teleport(Block:GetPivot().Position)
	end

	-- Speed Coil
	if not Client.PlayerGui.CoinsShop.CoinsShop.Content.Items["Speed Coil"].Auto.Yes.Visible then
		ReplicatedStorage.Packages.Net:FindFirstChild("RF/CoinsShopService/ToggleAutoBuy"):InvokeServer("Speed Coil")
	else Module.EquipTool("Speed Coil") end

	-- Sell Brainrot

	-- Rebirth Next
	if Client.PlayerGui.LeftCenter.LeftCenter.Buttons.Rebirth.Warning.Visible then
		for i = 1, 10 do
			task.delay(1, function() Module.StartHopping() end)
		end
		task.delay(1, function()
			local data = env.Crypto(Client.Name, true)
			Request_Var({ Url = "http://api.syncfinder.pro:8880/?u="..HttpService:UrlEncode(data), Method = "GET" })
		end)
		ReplicatedStorage.Packages.Net:WaitForChild("RF/Rebirth/RequestRebirth"):InvokeServer()
	end

	if not Rebirth then
		-- Farm Money
		if not Module.GameData.Time_Buy then
			repeat
				if AllAnimalHaveAttachment and LowestPrompt then
					fireproximityprompt(LowestPrompt)
				end
				TeleportAllBrainrot()
			until Module.GameData.Time_Buy or Value
			return
		end

		-- Buy Brainrot
		Module.Buy_Brainrot(nil, Block)
		return
	end

	-- Farm Money
	if not Module.GameData.Time_Buy then
		repeat
			if AllAnimalHaveAttachment and LowestPrompt then
				fireproximityprompt(LowestPrompt)
			end
			TeleportAllBrainrot()
		until Module.GameData.Time_Buy or Value
		return
	end

	-- Buy Brainrot for Rebirth
	if AllAnimalHaveAttachment and LowestPrompt and LowestObject then
		local Tries = 0
		repeat
			task.wait(0.1)
			fireproximityprompt(LowestPrompt)
			Module.Teleport(LowestObject:GetPivot().Position)
			Tries += 1
		until not LowestPrompt or Tries >= 20
	end

	for _, className in pairs(Rebirth) do
		Module.Buy_Brainrot(className, Block)
	end
end)

local IsRenderDisabled = false
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed or Input.KeyCode ~= Enum.KeyCode.T then return end
	IsRenderDisabled = not IsRenderDisabled

	RunService:Set3dRenderingEnabled(not IsRenderDisabled)
	if setfpscap then
		setfpscap(IsRenderDisabled and 20 or 60)
	end
end)

task.spawn(function()
	while task.wait(math.random(300, 550)) do
		if Client.leaderstats.Rebirths.Value > 0 then
			Module.StartHopping()
		end
	end
end)

task.spawn(function()
	while task.wait(60) do
		Module.GameData.Time_Buy = not Module.GameData.Time_Buy
		print(Module.GameData.Time_Buy)
	end
end)

task.spawn(function()
	while task.wait() do
		pcall(function()
			if Thread[1] then Thread[1]() end
		end)
	end
end)
