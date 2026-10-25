-- LocalScript em StarterGui (UI Redesenhada + Aimbot Legit com Transição Tronco -> Cabeça)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Destruir UI anterior se existir
if PlayerGui:FindFirstChild("AimbotMenuGui") then
	PlayerGui.AimbotMenuGui:Destroy()
end

-- ScreenGui Principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main Frame (Janela Principal)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 520, 0, 380)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 50)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainFrame

-- Barra Lateral (Sidebar Navigation)
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 12)
sidebarCorner.Parent = sidebar

local sidebarFix = Instance.new("Frame")
sidebarFix.Size = UDim2.new(0, 12, 1, 0)
sidebarFix.Position = UDim2.new(1, -12, 0, 0)
sidebarFix.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
sidebarFix.BorderSizePixel = 0
sidebarFix.Parent = sidebar

-- Título da Sidebar
local appTitle = Instance.new("TextLabel")
appTitle.Size = UDim2.new(1, 0, 0, 50)
appTitle.BackgroundTransparency = 1
appTitle.Text = "FIND AN EXIT"
appTitle.TextColor3 = Color3.fromRGB(0, 170, 255)
appTitle.TextSize = 15
appTitle.Font = Enum.Font.GothamBold
appTitle.Parent = sidebar

-- Container dos Botões da Sidebar
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 1, -60)
tabContainer.Position = UDim2.new(0, 10, 0, 50)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = sidebar

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 8)
tabListLayout.Parent = tabContainer

-- Area de Conteúdo Principal
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -150, 1, -45)
contentArea.Position = UDim2.new(0, 145, 0, 40)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

-- Botão Fechar (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -34, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230, 50, 50), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 36), TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
end)

-- Sistema de Páginas
local pages = {}

local function createPage(name)
	local pageScroll = Instance.new("ScrollingFrame")
	pageScroll.Name = name .. "Page"
	pageScroll.Size = UDim2.new(1, -10, 1, -5)
	pageScroll.BackgroundTransparency = 1
	pageScroll.BorderSizePixel = 0
	pageScroll.ScrollBarThickness = 3
	pageScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
	pageScroll.Visible = false
	pageScroll.Parent = contentArea
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = pageScroll
	
	pages[name] = pageScroll
	return pageScroll
end

local aimbotPage = createPage("Aimbot")
local espPage = createPage("ESP")

aimbotPage.Visible = true

local function createTabButton(name, targetPage)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = (targetPage == aimbotPage) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(30, 30, 38)
	btn.Text = name
	btn.TextColor3 = (targetPage == aimbotPage) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 170)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 13
	btn.AutoButtonColor = false
	btn.Parent = tabContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		for _, b in pairs(tabContainer:GetChildren()) do
			if b:IsA("TextButton") then
				TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 38), TextColor3 = Color3.fromRGB(160, 160, 170)}):Play()
			end
		end
		targetPage.Visible = true
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
end

createTabButton("Aimbot", aimbotPage)
createTabButton("Visuals (ESP)", espPage)

-- ==========================================
-- CONFIGURAÇÕES E ESTADO (SETTINGS)
-- ==========================================
local Settings = {
	AimbotEnabled = true,
	AimbotMode = "Legit",
	ShowFOV = true,
	WallCheck = true,
	DeathCheck = true,
	SmoothLock = true,
	TeamCheck = false,
	FOVRadius = 120,
	Smoothness = 3,
	ESPBoxEnabled = true,
	ESPNameEnabled = true,
	ESPHealthEnabled = true
}

-- Componentes Visuais
local function createToggle(parentPage, name, settingKey, defaultState)
	Settings[settingKey] = defaultState
	
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Size = UDim2.new(1, -6, 0, 38)
	toggleFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	toggleFrame.Parent = parentPage
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggleFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	local switchBg = Instance.new("TextButton")
	switchBg.Size = UDim2.new(0, 40, 0, 20)
	switchBg.Position = UDim2.new(1, -50, 0.5, -10)
	switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 55)
	switchBg.Text = ""
	switchBg.AutoButtonColor = false
	switchBg.Parent = toggleFrame
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switchBg
	
	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 14, 0, 14)
	circle.Position = defaultState and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BorderSizePixel = 0
	circle.Parent = switchBg
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle
	
	switchBg.MouseButton1Click:Connect(function()
		Settings[settingKey] = not Settings[settingKey]
		local state = Settings[settingKey]
		
		local targetPos = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
		local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 55)
		
		TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
		TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
	end)
end

local function createModeSelector(parentPage, name, settingKey, options, defaultOption)
	Settings[settingKey] = defaultOption
	
	local modeFrame = Instance.new("Frame")
	modeFrame.Size = UDim2.new(1, -6, 0, 38)
	modeFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	modeFrame.Parent = parentPage
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = modeFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.5, 0, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = modeFrame
	
	local modeBtn = Instance.new("TextButton")
	modeBtn.Size = UDim2.new(0, 80, 0, 24)
	modeBtn.Position = UDim2.new(1, -90, 0.5, -12)
	modeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	modeBtn.Text = defaultOption
	modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	modeBtn.Font = Enum.Font.GothamBold
	modeBtn.TextSize = 12
	modeBtn.AutoButtonColor = false
	modeBtn.Parent = modeFrame
	
	local modeCorner = Instance.new("UICorner")
	modeCorner.CornerRadius = UDim.new(0, 6)
	modeCorner.Parent = modeBtn
	
	local currentIndex = 1
	for i, opt in ipairs(options) do if opt == defaultOption then currentIndex = i end end
	
	modeBtn.MouseButton1Click:Connect(function()
		currentIndex = currentIndex % #options + 1
		local selected = options[currentIndex]
		Settings[settingKey] = selected
		modeBtn.Text = selected
	end)
end

local function createSlider(parentPage, name, settingKey, minVal, maxVal, defaultVal)
	Settings[settingKey] = defaultVal
	
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -6, 0, 50)
	sliderFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
	sliderFrame.Parent = parentPage
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = sliderFrame
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.6, 0, 0, 22)
	label.Position = UDim2.new(0, 12, 0, 4)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(210, 210, 220)
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0.3, 0, 0, 22)
	valueLabel.Position = UDim2.new(0.7, -12, 0, 4)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(defaultVal)
	valueLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame
	
	local barBg = Instance.new("TextButton")
	barBg.Size = UDim2.new(1, -24, 0, 5)
	barBg.Position = UDim2.new(0, 12, 0, 32)
	barBg.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	barBg.Text = ""
	barBg.AutoButtonColor = false
	barBg.Parent = sliderFrame
	
	local barBgCorner = Instance.new("UICorner")
	barBgCorner.CornerRadius = UDim.new(1, 0)
	barBgCorner.Parent = barBg
	
	local fill = Instance.new("Frame")
	local fillPercent = (defaultVal - minVal) / (maxVal - minVal)
	fill.Size = UDim2.new(fillPercent, 0, 1, 0)
	fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	fill.BorderSizePixel = 0
	fill.Parent = barBg
	
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = fill

	local dragging = false
	
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
		local newVal = math.floor(minVal + ((maxVal - minVal) * pos))
		
		Settings[settingKey] = newVal
		valueLabel.Text = tostring(newVal)
		fill.Size = UDim2.new(pos, 0, 1, 0)
	end

	barBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			updateSlider(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateSlider(input)
		end
	end)
end

-- Preencher Aimbot
createToggle(aimbotPage, "Ativar Aimbot", "AimbotEnabled", true)
createModeSelector(aimbotPage, "Modo do Aimbot", "AimbotMode", {"Legit", "Full"}, "Legit")
createToggle(aimbotPage, "Mostrar FOV", "ShowFOV", true)
createToggle(aimbotPage, "Ignorar Mortos (Death Check)", "DeathCheck", true)
createToggle(aimbotPage, "Verificar Paredes (Wall Check)", "WallCheck", true)
createToggle(aimbotPage, "Suavização (Smooth Lock)", "SmoothLock", true)
createToggle(aimbotPage, "Mirar Aliados (Team Check)", "TeamCheck", false)
createSlider(aimbotPage, "Raio do FOV", "FOVRadius", 30, 500, 120)
createSlider(aimbotPage, "Suavidade", "Smoothness", 1, 10, 3)

-- Preencher Visuals (ESP)
createToggle(espPage, "Ativar Box ESP", "ESPBoxEnabled", true)
createToggle(espPage, "Mostrar Nome do Jogador", "ESPNameEnabled", true)
createToggle(espPage, "Mostrar Barra de Vida (HP)", "ESPHealthEnabled", true)

-- Tecla 'K' para abrir/fechar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.K then
		mainFrame.Visible = not mainFrame.Visible
	end
end)

-- ==========================================
-- LÓGICA DE MIRA MODIFICADA (LEGIT: TRONCO -> CABEÇA)
-- ==========================================

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Filled = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 170, 255)
FOVCircle.NumSides = 64
FOVCircle.Transparency = 0.8

local espObjects = {}

-- Variáveis de Controlo do Modo Legit (Sequência Tronco -> Cabeça)
local lockStartTime = 0
local currentTarget = nil
local LEGIT_BODY_TIME = 0.35 -- Tempo em segundos mirado no tronco (aproximadamente o tempo de 2 tiros)

local function createESP(player)
	if espObjects[player] then return end
	local data = {}
	
	data.Box = Drawing.new("Square")
	data.Box.Visible = false
	data.Box.Filled = false
	data.Box.Thickness = 1.5
	data.Box.Color = Color3.fromRGB(0, 170, 255)
	data.Box.Transparency = 0.8
	
	data.Name = Drawing.new("Text")
	data.Name.Visible = false
	data.Name.Size = 12
	data.Name.Center = true
	data.Name.Outline = true
	data.Name.Color = Color3.fromRGB(255, 255, 255)
	data.Name.Font = Drawing.Fonts.UI
	
	data.HealthBarBg = Drawing.new("Square")
	data.HealthBarBg.Visible = false
	data.HealthBarBg.Filled = true
	data.HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
	data.HealthBarBg.Transparency = 0.7
	
	data.HealthBar = Drawing.new("Square")
	data.HealthBar.Visible = false
	data.HealthBar.Filled = true
	data.HealthBar.Color = Color3.fromRGB(0, 255, 0)
	data.HealthBar.Transparency = 0.9
	
	espObjects[player] = data
end

local function removeESP(player)
	if espObjects[player] then
		for _, drawing in pairs(espObjects[player]) do
			drawing:Remove()
		end
		espObjects[player] = nil
	end
end

Players.PlayerRemoving:Connect(removeESP)

local function isAlive(player)
	if not Settings.DeathCheck then return true end
	if not player or not player.Character then return false end
	local character = player.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	
	if not humanoid or humanoid.Health <= 0 then return false end
	if humanoid:GetState() == Enum.HumanoidStateType.Dead then return false end
	
	local head = character:FindFirstChild("Head")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not head or not hrp then return false end
	
	return true
end

local function isVisible(targetPart, targetCharacter)
	if not Settings.WallCheck then return true end
	
	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	
	local ignoreList = {}
	if LocalPlayer.Character then table.insert(ignoreList, LocalPlayer.Character) end
	if targetCharacter then table.insert(ignoreList, targetCharacter) end
	
	raycastParams.FilterDescendantsInstances = ignoreList
	raycastParams.IgnoreWater = true
	
	local raycastResult = workspace:Raycast(origin, direction, raycastParams)
	return raycastResult == nil
end

local function getClosestPlayerInFOV()
	local closestPlayer = nil
	local shortestDistance = Settings.FOVRadius
	local mousePos = UserInputService:GetMouseLocation()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if isAlive(player) then
				if not Settings.TeamCheck or player.Team ~= LocalPlayer.Team then
					local head = player.Character:FindFirstChild("Head")
					
					if head then
						local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

						if onScreen then
							local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
							
							if distance < shortestDistance then
								if isVisible(head, player.Character) then
									shortestDistance = distance
									closestPlayer = player
								end
							end
						end
					end
				end
			end
		end
	end

	return closestPlayer
end

-- Loop Principal
RunService.RenderStepped:Connect(function()
	local mousePos = UserInputService:GetMouseLocation()
	
	FOVCircle.Position = mousePos
	FOVCircle.Radius = Settings.FOVRadius
	FOVCircle.Visible = Settings.AimbotEnabled and Settings.ShowFOV
	
	-- Atualização do ESP
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if not espObjects[player] then createESP(player) end
			
			local esp = espObjects[player]
			local character = player.Character
			local hrp = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			
			if character and hrp and humanoid and isAlive(player) then
				local topPos = hrp.Position + Vector3.new(0, 3, 0)
				local bottomPos = hrp.Position - Vector3.new(0, 3.5, 0)
				
				local topScreenPos, topOnScreen = Camera:WorldToViewportPoint(topPos)
				local bottomScreenPos, bottomOnScreen = Camera:WorldToViewportPoint(bottomPos)
				
				if topOnScreen and bottomOnScreen then
					local sizeY = math.abs(topScreenPos.Y - bottomScreenPos.Y)
					local sizeX = sizeY * 0.65
					local boxPos = Vector2.new(topScreenPos.X - sizeX / 2, topScreenPos.Y)
					
					if Settings.ESPBoxEnabled then
						esp.Box.Size = Vector2.new(sizeX, sizeY)
						esp.Box.Position = boxPos
						esp.Box.Visible = true
					else
						esp.Box.Visible = false
					end
					
					if Settings.ESPNameEnabled then
						esp.Name.Text = player.Name
						esp.Name.Position = Vector2.new(topScreenPos.X, boxPos.Y - 15)
						esp.Name.Visible = true
					else
						esp.Name.Visible = false
					end
					
					if Settings.ESPHealthEnabled then
						local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
						local barHeight = sizeY * healthPercent
						
						esp.HealthBarBg.Size = Vector2.new(4, sizeY + 2)
						esp.HealthBarBg.Position = Vector2.new(boxPos.X - 7, boxPos.Y - 1)
						esp.HealthBarBg.Visible = true
						
						esp.HealthBar.Size = Vector2.new(2, barHeight)
						esp.HealthBar.Position = Vector2.new(boxPos.X - 6, boxPos.Y + (sizeY - barHeight))
						esp.HealthBar.Visible = true
						
						esp.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
					else
						esp.HealthBarBg.Visible = false
						esp.HealthBar.Visible = false
					end
				else
					esp.Box.Visible = false
					esp.Name.Visible = false
					esp.HealthBarBg.Visible = false
					esp.HealthBar.Visible = false
				end
			else
				esp.Box.Visible = false
				esp.Name.Visible = false
				esp.HealthBarBg.Visible = false
				esp.HealthBar.Visible = false
			end
		end
	end
	
	-- LÓGICA DO AIMBOT COM TRANSIÇÃO LEGIT (TRONCO -> CABEÇA)
	if Settings.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local target = getClosestPlayerInFOV()
		
		if target and target.Character then
			-- Reiniciar timer se for um alvo novo
			if currentTarget ~= target then
				currentTarget = target
				lockStartTime = tick()
			end
			
			local targetPart = nil
			local elapsedTime = tick() - lockStartTime
			
			if Settings.AimbotMode == "Full" then
				-- Modo Full: Trava direto na cabeça
				targetPart = target.Character:FindFirstChild("Head")
			else
				-- Modo Legit: Primeiro 2 Tiros no Tronco (HumanoidRootPart), depois sobe para a Cabeça
				if elapsedTime < LEGIT_BODY_TIME then
					targetPart = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("UpperTorso")
				else
					targetPart = target.Character:FindFirstChild("Head")
				end
			end
			
			if targetPart then
				local targetScreenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
				
				if onScreen then
					local targetVector = Vector2.new(targetScreenPos.X, targetScreenPos.Y)
					
					if Settings.AimbotMode == "Full" then
						Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
					else
						if Settings.SmoothLock then
							local moveDelta = (targetVector - mousePos) / Settings.Smoothness
							mousemoverel(moveDelta.X, moveDelta.Y)
						else
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
						end
					end
				end
			end
		else
			currentTarget = nil
		end
	else
		currentTarget = nil
	end
end)
