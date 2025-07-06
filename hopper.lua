local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local correctKey = "viper2025"
local scriptURL = "https://raw.githubusercontent.com/0ksy1/viperhub/refs/heads/main/main"
local keyFile = "viper_key.txt"

local function isValidKey(k)
	return k == correctKey
end

local function saveKey(k)
	pcall(function()
		writefile(keyFile, k)
	end)
end

local function loadSavedKey()
	if isfile(keyFile) then
		local k = readfile(keyFile)
		if isValidKey(k) then
			return true
		end
	end
	return false
end

local function execScript()
	loadstring(game:HttpGet(scriptURL))()
end

if loadSavedKey() then
	execScript()
	return
end

-- 📦 GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "KeySystem"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
	while stroke and stroke.Parent do
		local hue = tick() % 5 / 5
		stroke.Color = Color3.fromHSV(hue, 1, 1)
		wait(0.05)
	end
end)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🔐 Enter Key"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9, 0, 0, 36)
input.Position = UDim2.new(0.05, 0, 0, 55)
input.PlaceholderText = "Paste your key here..."
input.Text = ""
input.ClearTextOnFocus = false
input.Font = Enum.Font.Gotham
input.TextSize = 16
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 100)
status.BackgroundTransparency = 1
status.Text = ""
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(255, 80, 80)
status.TextWrapped = true

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.5, 0, 0, 34)
button.Position = UDim2.new(0.25, 0, 1, -42)
button.Text = "Unlock"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

button.MouseButton1Click:Connect(function()
	local entered = input.Text
	if isValidKey(entered) then
		status.TextColor3 = Color3.fromRGB(100, 255, 100)
		status.Text = "✅ Key correct! Loading..."
		saveKey(entered)
		wait(0.5)
		pcall(execScript)
		gui:Destroy()
	else
		status.Text = "❌ Incorrect key. Try again."
	end
end)
