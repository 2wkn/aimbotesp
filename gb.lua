-- LocalScript Único - gbzinbr scripts (FOV no Centro do Ecrã / Mobile)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 1. CRIAÇÃO DA INTERFACE PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GbzinbrScriptsGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Mini Quadrado com Imagem (Botão Flutuante para Abrir/Fechar)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 20, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.Image = "rbxassetid://113552756681096" -- SUBSTITUI O 0 PELO ID DA TUA IMAGEM CARREGADA
toggleButton.AutoButtonColor = false
toggleButton.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(220, 30, 30)
btnStroke.Thickness = 1.5
btnStroke.Parent = toggleButton

-- Janela Principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 480, 0, 380)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 40)
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

-- Barra Superior (Título)
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(225, 25, 25)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 10)
titleFix.Position = UDim2.new(0, 0, 1, -10)
titleFix.BackgroundColor3 = Color3.fromRGB(225, 25, 25)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "gbzinbr scripts"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 26, 0, 26)
closeButton.Position = UDim2.new(1, -32, 0, 6)
closeButton.BackgroundTransparency = 1
closeButton.Text = "x"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar


-- 2. SISTEMA DE ABAS (TABS)
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, -20, 0, 36)
tabsContainer.Position = UDim2.new(0, 10, 0, 48)
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabsContainer

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -100)
contentContainer.Position = UDim2.new(0, 10, 0, 92)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame


-- 3. FUNÇÃO DE ARRASTAR (DRAG & DROP)
local function makeDraggable(guiObject, dragTarget)
	dragTarget = dragTarget or guiObject
	local dragging = false
	local mousePos, framePos

	dragTarget.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = guiObject.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - mousePos
			guiObject.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)
end

makeDraggable(toggleButton)
makeDraggable(mainFrame, titleBar)


-- 4. CONFIGURAÇÕES GLOBAIS DE LOGICA
local SETTINGS = {
	AimbotMaster = false,
	AimbotMode = "Legit",
	ShowFOV = false,
	IgnoreDead = true,
	WallCheck = false,
	SmoothLock = true,
	TeamCheck = false,
	FOVRadius = 150, -- Raio ajustado para o centro da mira

	EspMaster = false,
	Box2D = false,
	Name = false,
	HealthBar = false,
	Skeleton = false,

	Fullbright = false,
	SpeedHack = false
}

local tabButtons = {}
local tabPages = {}

local function createTab(name, layoutOrder)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 105, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.LayoutOrder = layoutOrder
	btn.Parent = tabsContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.ScrollBarThickness = 3
	page.Visible = false
	page.Parent = contentContainer
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 6)
	listLayout.Parent = page
	
	table.insert(tabButtons, {Button = btn, Page = page})
	table.insert(tabPages, page)
	return page
end

local function createToggleWithCallback(parent, text, order, defaultState, callback)
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(1, 0, 0, 42)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	toggleFrame.BorderSizePixel = 0
	toggleFrame.LayoutOrder = order
	toggleFrame.Parent = parent
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = toggleFrame
	
	local box = Instance.new("TextButton")
	box.Size = UDim2.new(0, 22, 0, 22)
	box.Position = UDim2.new(0, 12, 0.5, -11)
	box.BackgroundColor3 = defaultState and Color3.fromRGB(220, 20, 20) or Color3.fromRGB(30, 30, 30)
	box.Text = defaultState and "✓" or ""
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.AutoButtonColor = false
	box.Parent = toggleFrame
	
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = box
	
	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = Color3.fromRGB(50, 50, 50)
	boxStroke.Parent = box
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 46, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220, 220, 220)
	label.TextSize = 13
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, 0)
	line.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
	line.BorderSizePixel = 0
	line.Parent = toggleFrame
	
	local enabled = defaultState
	box.MouseButton1Click:Connect(function()
		enabled = not enabled
		if enabled then
			TweenService:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 20, 20)}):Play()
			box.Text = "✓"
		else
			TweenService:Create(box, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
			box.Text = ""
		end
		callback(enabled)
	end)
end

-- Criar Aba Aimbot
local aimbotTab = createTab("Aimbot", 1)
createToggleWithCallback(aimbotTab, "Ativar Aimbot", 1, false, function(v) SETTINGS.AimbotMaster = v end)

local modeFrame = Instance.new("Frame")
modeFrame.Size = UDim2.new(1, 0, 0, 42)
modeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
modeFrame.BorderSizePixel = 0
modeFrame.LayoutOrder = 2
modeFrame.Parent = aimbotTab

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 6)
modeCorner.Parent = modeFrame

local modeLabel = Instance.new("TextLabel")
modeLabel.Size = UDim2.new(1, -120, 1, 0)
modeLabel.Position = UDim2.new(0, 12, 0, 0)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Modo do Aimbot"
modeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
modeLabel.TextSize = 13
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Parent = modeFrame

local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(0, 90, 0, 26)
modeButton.Position = UDim2.new(1, -102, 0.5, -13)
modeButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
modeButton.Text = "Legit"
modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modeButton.TextSize = 13
modeButton.Font = Enum.Font.GothamBold
modeButton.AutoButtonColor = false
modeButton.Parent = modeFrame

local modeBtnCorner = Instance.new("UICorner")
modeBtnCorner.CornerRadius = UDim.new(0, 6)
modeBtnCorner.Parent = modeButton

modeButton.MouseButton1Click:Connect(function()
	if SETTINGS.AimbotMode == "Legit" then
		SETTINGS.AimbotMode = "Rage"
		modeButton.Text = "Rage"
		modeButton.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
	else
		SETTINGS.AimbotMode = "Legit"
		modeButton.Text = "Legit"
		modeButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
	end
end)

local modeLine = Instance.new("Frame")
modeLine.Size = UDim2.new(1, 0, 0, 1)
modeLine.Position = UDim2.new(0, 0, 1, 0)
modeLine.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
modeLine.BorderSizePixel = 0
modeLine.Parent = modeFrame

createToggleWithCallback(aimbotTab, "Mostrar FOV", 3, false, function(v) SETTINGS.ShowFOV = v end)
createToggleWithCallback(aimbotTab, "Ignorar Mortos (Death Check)", 4, true, function(v) SETTINGS.IgnoreDead = v end)
createToggleWithCallback(aimbotTab, "Verificar Paredes (Wall Check)", 5, false, function(v) SETTINGS.WallCheck = v end)
createToggleWithCallback(aimbotTab, "Suavização (Smooth Lock)", 6, true, function(v) SETTINGS.SmoothLock = v end)
createToggleWithCallback(aimbotTab, "Mirar Aliados (Team Check)", 7, false, function(v) SETTINGS.TeamCheck = v end)

-- Criar Aba ESP
local espTab = createTab("Esp", 2)
createToggleWithCallback(espTab, "Ativar ESP Master", 1, false, function(v) SETTINGS.EspMaster = v end)
createToggleWithCallback(espTab, "Box ESP (Cantos 2D)", 2, false, function(v) SETTINGS.Box2D = v end)
createToggleWithCallback(espTab, "Name ESP", 3, false, function(v) SETTINGS.Name = v end)
createToggleWithCallback(espTab, "Health Bar (Verde)", 4, false, function(v) SETTINGS.HealthBar = v end)
createToggleWithCallback(espTab, "Skeleton ESP (Esqueleto)", 5, false, function(v) SETTINGS.Skeleton = v end)

-- Criar Aba Diversos
local diversosTab = createTab("Diversos", 3)
createToggleWithCallback(diversosTab, "Fullbright (Iluminação Máxima)", 1, false, function(v) SETTINGS.Fullbright = v end)
createToggleWithCallback(diversosTab, "Speed Hack (Velocidade x2)", 2, false, function(v) SETTINGS.SpeedHack = v end)

-- Criar Aba Info
local infoTab = createTab("Info", 4)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "gbzinbr scripts\nPainel de Controlo Total\nEstado: Operacional com Lógica Ativa."
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Parent = infoTab


-- 5. LÓGICA DE EXECUÇÃO GERAL (RENDERLOOP)
-- FOV posicionado exatamente no meio do ecrã (perfeito para Mobile e mira central)
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 60
fovCircle.Radius = SETTINGS.FOVRadius
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Visible = false

local espCache = {}

local function removeEsp(player)
	if espCache[player] then
		for _, obj in pairs(espCache[player]) do
			pcall(function() obj:Remove() end)
		end
		espCache[player] = nil
	end
end

Players.PlayerRemoving:Connect(removeEsp)

local function getClosestTargetToCenter()
	local closestTarget = nil
	local shortestDist = SETTINGS.FOVRadius
	local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local isTeam = false
			if not SETTINGS.TeamCheck and player.Team and localPlayer.Team and player.Team == localPlayer.Team then
				isTeam = true
			end

			if not isTeam and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
				local humanoid = player.Character.Humanoid
				if not SETTINGS.IgnoreDead or humanoid.Health > 0 then
					local targetPart = player.Character:FindFirstChild("Head") or player.Character.HumanoidRootPart
					local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)

					if onScreen then
						local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
						if magnitude < shortestDist then
							shortestDist = magnitude
							closestTarget = targetPart
						end
					end
				end
			end
		end
	end
	return closestTarget
end

RunService.RenderStepped:Connect(function()
	-- Fixar o círculo de FOV exatamente no centro da tela (mira)
	fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
	fovCircle.Visible = SETTINGS.AimbotMaster and SETTINGS.ShowFOV

	if SETTINGS.AimbotMaster then
		-- No telemóvel/mobile, o aimbot atua diretamente quando ativado (ou com toque/mira centralizada)
		if SETTINGS.AimbotMode == "Rage" or UserInputService.TouchEnabled or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
			local target = getClosestTargetToCenter()
			if target then
				local currentCamCF = camera.CFrame
				local targetCamCF = CFrame.new(currentCamCF.Position, target.Position)
				
				if SETTINGS.SmoothLock and SETTINGS.AimbotMode == "Legit" then
					camera.CFrame = currentCamCF:Lerp(targetCamCF, 0.25)
				else
					camera.CFrame = targetCamCF
				end
			end
		end
	end

	if SETTINGS.Fullbright then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	end

	if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		local hum = localPlayer.Character.Humanoid
		if SETTINGS.SpeedHack then
			hum.WalkSpeed = 32
		else
			hum.WalkSpeed = 16
		end
	end

	if not SETTINGS.EspMaster then
		for player, _ in pairs(espCache) do
			removeEsp(player)
		end
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local character = player.Character
			local humanoid = character.Humanoid
			local rootPart = character.HumanoidRootPart
			
			if not espCache[player] then
				espCache[player] = {
					Box = Drawing.new("Square"),
					BoxOutline = Drawing.new("Square"),
					Name = Drawing.new("Text"),
					HealthBarBg = Drawing.new("Square"),
					HealthBar = Drawing.new("Square"),
					SkelHeadToChest = Drawing.new("Line"),
					SkelLeftArm = Drawing.new("Line"),
					SkelRightArm = Drawing.new("Line"),
					SkelLeftLeg = Drawing.new("Line"),
					SkelRightLeg = Drawing.new("Line"),
				}
				
				espCache[player].Box.Thickness = 1.5
				espCache[player].Box.Filled = false
				espCache[player].Box.Color = Color3.fromRGB(255, 50, 50)
				
				espCache[player].BoxOutline.Thickness = 2.5
				espCache[player].BoxOutline.Filled = false
				espCache[player].BoxOutline.Color = Color3.fromRGB(0, 0, 0)
				
				espCache[player].Name.Size = 13
				espCache[player].Name.Center = true
				espCache[player].Name.Outline = true
				espCache[player].Name.Color = Color3.fromRGB(255, 255, 255)
				
				espCache[player].HealthBarBg.Filled = true
				espCache[player].HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
				espCache[player].HealthBar.Filled = true
				
				for _, lineName in ipairs({"SkelHeadToChest", "SkelLeftArm", "SkelRightArm", "SkelLeftLeg", "SkelRightLeg"}) do
					espCache[player][lineName].Thickness = 1.5
					espCache[player][lineName].Color = Color3.fromRGB(255, 255, 255)
				end
			end

			local esp = espCache[player]
			local cf = rootPart.CFrame
			local sz = character:GetExtentsSize()
			
			local top3D = (cf + Vector3.new(0, sz.Y / 2 + 0.5, 0)).Position
			local bottom3D = (cf - Vector3.new(0, sz.Y / 2 + 0.5, 0)).Position
			
			local top2D, topVisible = camera:WorldToViewportPoint(top3D)
			local bottom2D, bottomVisible = camera:WorldToViewportPoint(bottom3D)

			if (topVisible or bottomVisible) and humanoid.Health > 0 then
				local height = math.abs(top2D.Y - bottom2D.Y)
				local width = height / 2
				local pos = Vector2.new(top2D.X - width / 2, top2D.Y)

				if SETTINGS.Box2D then
					esp.BoxOutline.Visible = true
					esp.BoxOutline.Size = Vector2.new(width, height)
					esp.BoxOutline.Position = pos

					esp.Box.Visible = true
					esp.Box.Size = Vector2.new(width, height)
					esp.Box.Position = pos
				else
					esp.Box.Visible = false
					esp.BoxOutline.Visible = false
				end

				if SETTINGS.Name then
					esp.Name.Visible = true
					esp.Name.Text = player.Name
					esp.Name.Position = Vector2.new(top2D.X, top2D.Y - 18)
				else
					esp.Name.Visible = false
				end

				if SETTINGS.HealthBar then
					local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
					local barHeight = height * healthPercent
					
					esp.HealthBarBg.Visible = true
					esp.HealthBarBg.Size = Vector2.new(4, height + 2)
					esp.HealthBarBg.Position = Vector2.new(pos.X + width + 3, pos.Y - 1)

					esp.HealthBar.Visible = true
					esp.HealthBar.Size = Vector2.new(2, barHeight)
					esp.HealthBar.Position = Vector2.new(pos.X + width + 4, pos.Y + (height - barHeight))
					esp.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
				else
					esp.HealthBarBg.Visible = false
					esp.HealthBar.Visible = false
				end

				if SETTINGS.Skeleton and character:FindFirstChild("Head") then
					local head = character.Head
					local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
					local leftArm = character:FindFirstChild("LeftUpperArm") or character:FindFirstChild("Left Arm")
					local rightArm = character:FindFirstChild("RightUpperArm") or character:FindFirstChild("Right Arm")
					local leftLeg = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
					local rightLeg = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")

					local function to2D(part)
						if not part then return nil, false end
						local vec, vis = camera:WorldToViewportPoint(part.Position)
						return Vector2.new(vec.X, vec.Y), vis
					end

					local headPos, hVis = to2D(head)
					local torsoPos, tVis = to2D(upperTorso)
					local lArmPos, laVis = to2D(leftArm)
					local rArmPos, raVis = to2D(rightArm)
					local lLegPos, llVis = to2D(leftLeg)
					local rLegPos, rlVis = to2D(rightLeg)

					if hVis and tVis then
						esp.SkelHeadToChest.Visible = true
						esp.SkelHeadToChest.From = headPos
						esp.SkelHeadToChest.To = torsoPos
					else
						esp.SkelHeadToChest.Visible = false
					end

					if tVis and laVis then
						esp.SkelLeftArm.Visible = true
						esp.SkelLeftArm.From = torsoPos
						esp.SkelLeftArm.To = lArmPos
					else
						esp.SkelLeftArm.Visible = false
					end

					if tVis and raVis then
						esp.SkelRightArm.Visible = true
						esp.SkelRightArm.From = torsoPos
						esp.SkelRightArm.To = rArmPos
					else
						esp.SkelRightArm.Visible = false
					end

					if tVis and llVis then
						esp.SkelLeftLeg.Visible = true
						esp.SkelLeftLeg.From = torsoPos
						esp.SkelLeftLeg.To = lLegPos
					else
						esp.SkelLeftLeg.Visible = false
					end

					if tVis and rlVis then
						esp.SkelRightLeg.Visible = true
						esp.SkelRightLeg.From = torsoPos
						esp.SkelRightLeg.To = rLegPos
					else
						esp.SkelRightLeg.Visible = false
					end
				else
					esp.SkelHeadToChest.Visible = false
					esp.SkelLeftArm.Visible = false
					esp.SkelRightArm.Visible = false
					esp.SkelLeftLeg.Visible = false
					esp.SkelRightLeg.Visible = false
				end
			else
				esp.Box.Visible = false
				esp.BoxOutline.Visible = false
				esp.Name.Visible = false
				esp.HealthBarBg.Visible = false
				esp.HealthBar.Visible = false
				esp.SkelHeadToChest.Visible = false
				esp.SkelLeftArm.Visible = false
				esp.SkelRightArm.Visible = false
				esp.SkelLeftLeg.Visible = false
				esp.SkelRightLeg.Visible = false
			end
		else
			removeEsp(player)
		end
	end
end)


-- 6. SISTEMA DE TROCA DE ABAS
local function switchTab(selectedBtn, selectedPage)
	for _, tab in ipairs(tabButtons) do
		TweenService:Create(tab.Button, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(25, 25, 25),
			TextColor3 = Color3.fromRGB(180, 180, 180)
		}):Play()
		tab.Page.Visible = false
	end
	
	TweenService:Create(selectedBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(225, 25, 25),
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
	selectedPage.Visible = true
end

for _, tab in ipairs(tabButtons) do
	tab.Button.MouseButton1Click:Connect(function()
		switchTab(tab.Button, tab.Page)
	end)
end

switchTab(tabButtons[1].Button, tabButtons[1].Page)


-- 7. SISTEMA DE ABRIR / FECHAR (TOGGLE DO MINI QUADRADO)
local isOpen = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isDraggingButton = false

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		isDraggingButton = false
	end
end)
toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
			isDraggingButton = true
		end
	end
end)

toggleButton.MouseButton1Up:Connect(function()
	if not isDraggingButton then
		isOpen = not isOpen
		if isOpen then
			mainFrame.Visible = true
			mainFrame.BackgroundTransparency = 1
			TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0}):Play()
		else
			local tw = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1})
			tw:Play()
			tw.Completed:Connect(function()
				if not isOpen then mainFrame.Visible = false end
			end)
		end
	end
end)

closeButton.MouseButton1Click:Connect(function()
	if isOpen then
		isOpen = false
		mainFrame.Visible = false
	end
end)
