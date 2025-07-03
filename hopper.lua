-- made by viper 

repeat wait() until game:IsLoaded()
repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")


local speedMultiplier = 1.4 -- 
local toggled = true


local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local isRunning = false

local petsToFind = {
	["Graipuss Medussi"] = true,
	["Los Tralaleritos"] = true,
	["La Vacca Saturno Saturnita"] = true,
	["La Grande Combinasion"] = true,
	["Tralalero Tralala"] = true
}

RunService.RenderStepped:Connect(function(dt)
	if not toggled then return end
	if humanoid.MoveDirection.Magnitude > 0 then
		-- Двигаем игрока вручную вперёд по MoveDirection
		local moveDir = humanoid.MoveDirection.Unit
		local delta = moveDir * humanoid.WalkSpeed * (speedMultiplier - 1) * dt
		hrp.CFrame = hrp.CFrame + delta
	end
end)


UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.V then
		toggled = not toggled
		print("⚙️ SpeedHack " .. (toggled and "включён" or "выключен"))
	end
end)

local function loadPetSettings()
	local success, result = pcall(function()
		return HttpService:JSONDecode(readfile("PetFinderSettings.json"))
	end)
	if success and typeof(result) == "table" then
		for name, state in pairs(result) do
			if petsToFind[name] ~= nil then
				petsToFind[name] = state
			end
		end
	end
end

local function savePetSettings()
	writefile("PetFinderSettings.json", HttpService:JSONEncode(petsToFind))
end

loadPetSettings()

local success, result = pcall(function()
	return HttpService:JSONDecode(readfile("NotSameServers.json"))
end)

if success and typeof(result) == "table" then
	AllIDs = result
else
	AllIDs = { actualHour }
	writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
end

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "ServerHopGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 360)
frame.Position = UDim2.new(0.5, -200, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 12, 40)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -90, 0, 34)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌌  Server Hopper v1"
title.Font = Enum.Font.FredokaOne
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(240, 230, 255)

local serverIdButton = Instance.new("TextButton", frame)
serverIdButton.Size = UDim2.new(0, 32, 0, 32)
serverIdButton.Position = UDim2.new(1, -96, 0, 2)
serverIdButton.Text = "🆔"
serverIdButton.BackgroundColor3 = Color3.fromRGB(70, 0, 140)
serverIdButton.TextColor3 = Color3.new(1, 1, 1)
serverIdButton.Font = Enum.Font.GothamBold
serverIdButton.TextSize = 16
Instance.new("UICorner", serverIdButton).CornerRadius = UDim.new(0, 8)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -32, 0, 2)
closeButton.Text = "✖"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
closeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local idFrame = Instance.new("Frame", gui)
idFrame.Size = UDim2.new(0, 360, 0, 120)
idFrame.Position = UDim2.new(0.5, -180, 0.7, 0)
idFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
idFrame.Visible = false
Instance.new("UICorner", idFrame)

local idLabel = Instance.new("TextLabel", idFrame)
idLabel.Size = UDim2.new(1, -20, 0.6, 0)
idLabel.Position = UDim2.new(0, 10, 0, 10)
idLabel.BackgroundTransparency = 1
idLabel.TextColor3 = Color3.new(1, 1, 1)
idLabel.Font = Enum.Font.Gotham
idLabel.TextSize = 14
idLabel.TextWrapped = true
idLabel.Text = "Server ID: \n" .. game.JobId

local copyBtn = Instance.new("TextButton", idFrame)
copyBtn.Size = UDim2.new(0.5, 0, 0.2, 0)
copyBtn.Position = UDim2.new(0.25, 0, 0.75, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 255)
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.Text = "Copy"
Instance.new("UICorner", copyBtn)

copyBtn.MouseButton1Click:Connect(function()
	setclipboard(game.JobId)
	copyBtn.Text = "Copied!"
	task.wait(1.5)
	copyBtn.Text = "Copy"
end)

serverIdButton.MouseButton1Click:Connect(function()
	idFrame.Visible = not idFrame.Visible
end)


local petToggle = Instance.new("TextButton", frame)
petToggle.Size = UDim2.new(0, 32, 0, 32)
petToggle.Position = UDim2.new(1, -64, 0, 2)
petToggle.Text = "⚙️"
petToggle.BackgroundColor3 = Color3.fromRGB(90, 0, 160)
petToggle.TextColor3 = Color3.new(1,1,1)
petToggle.Font = Enum.Font.GothamBold
petToggle.TextSize = 16
Instance.new("UICorner", petToggle).CornerRadius = UDim.new(0, 8)

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(1, -32, 0, 2)
closeButton.Text = "✖"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
closeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextWrapped = true
statusLabel.Text = "🔍 Waiting for server hop"
statusLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
statusLabel.Font = Enum.Font.GothamMedium
statusLabel.TextSize = 20

local petResultLabel = Instance.new("TextLabel", frame)
petResultLabel.Size = UDim2.new(1, -20, 0, 100)
petResultLabel.Position = UDim2.new(0, 10, 0, 85)
petResultLabel.BackgroundTransparency = 1
petResultLabel.TextXAlignment = Enum.TextXAlignment.Left
petResultLabel.TextWrapped = true
petResultLabel.TextYAlignment = Enum.TextYAlignment.Top
petResultLabel.Text = "🐾 Found pets: none"
petResultLabel.TextColor3 = Color3.fromRGB(180, 200, 255)
petResultLabel.Font = Enum.Font.Gotham
petResultLabel.TextSize = 20

-- RGB Pulse
local function pulseRGB(obj)
	spawn(function()
		while obj and obj.Parent do
			obj.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
			wait(0.2)
		end
	end)
end

local function scanForPets()
	local found = {}
	for _, obj in pairs(Workspace:GetDescendants()) do
		if petsToFind[obj.Name] then
			if not obj:FindFirstChild("PetTag") then
				local tag = Instance.new("BillboardGui", obj)
				tag.Name = "PetTag"
				tag.Size = UDim2.new(0, 100, 0, 40)
				tag.AlwaysOnTop = true
				tag.StudsOffset = Vector3.new(0, 3, 0)
				local label = Instance.new("TextLabel", tag)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextStrokeTransparency = 0.5
				label.TextScaled = true
				label.Font = Enum.Font.GothamBold
				label.Text = obj.Name
				pulseRGB(label)
			end
			table.insert(found, obj.Name)
		end
	end
	if #found > 0 then
		petResultLabel.Text = "✅ Found pets:\n" .. table.concat(found, "\n")
	else
		petResultLabel.Text = "❌ Found pets: none"
	end
end

spawn(function()
	while true do
		scanForPets()
		wait(5)
	end
end)

local function teleportToNextServer()
	local url = "https://games.roblox.com/v1/games/" .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100"
	if foundAnything ~= "" then
		url = url .. "&cursor=" .. HttpService:UrlEncode(foundAnything)
	end

	local success, response = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	if not success then
		statusLabel.Text = "⚠️ Error getting servers (API Limit) wait 5 sec"
		wait(5)
		return
	end

	if response.nextPageCursor then
		foundAnything = response.nextPageCursor
	end

	local num = 0
	for _, v in pairs(response.data) do
		local id = tostring(v.id)
		local possible = true

		if v.playing < v.maxPlayers then
			for _, existing in pairs(AllIDs) do
				if num ~= 0 and id == tostring(existing) then
					possible = false
				elseif num == 0 and tonumber(actualHour) ~= tonumber(existing) then
					pcall(function()
						delfile("NotSameServers.json")
					end)
					AllIDs = { actualHour }
				end
				num += 1
			end

			if possible then
				table.insert(AllIDs, id)
				statusLabel.Text = "🌐 teleporting:\n" .. id
				pcall(function()
					writefile("NotSameServers.json", HttpService:JSONEncode(AllIDs))
					TeleportService:TeleportToPlaceInstance(PlaceID, id, LocalPlayer)
				end)
				wait(0.5)
			end
		end
	end
end

local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(0.7, 0, 0, 36)
startButton.Position = UDim2.new(0.5, -0.35 * 360, 1, -46)
startButton.Text = "▶️ Start Hop"
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 18
startButton.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
Instance.new("UICorner", startButton).CornerRadius = UDim.new(0, 8)

startButton.MouseButton1Click:Connect(function()
	isRunning = true
	spawn(function()
		while isRunning do
			statusLabel.Text = "🔁 Getting servers"
			teleportToNextServer()
			wait(5)
		end
	end)
end)

local petPanel = Instance.new("Frame")
petPanel.Size = UDim2.new(0, 160, 0, 140)
petPanel.Position = UDim2.new(1, 10, 0, 0)
petPanel.BackgroundColor3 = Color3.fromRGB(40, 0, 70)
petPanel.Visible = false
petPanel.Parent = frame
Instance.new("UICorner", petPanel).CornerRadius = UDim.new(0, 10)

local y = 10
for name, state in pairs(petsToFind) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 24)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.Text = (state and "✔️ " or "❌ ") .. name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
	btn.Parent = petPanel
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	y = y + 28

	btn.MouseButton1Click:Connect(function()
		petsToFind[name] = not petsToFind[name]
		btn.Text = (petsToFind[name] and "✅ " or "❌ ") .. name
		savePetSettings()
	end)
end

petToggle.MouseButton1Click:Connect(function()
	petPanel.Visible = not petPanel.Visible
end)

frame:GetPropertyChangedSignal("Position"):Connect(function()
	petPanel.Position = UDim2.new(1, 10, 0, 0)
end)
