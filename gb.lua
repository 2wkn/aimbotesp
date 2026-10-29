-- LocalScript Único - gbzinbr scripts (ESP e Aimbot Nativos - Sem Drawing API)
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

-- Círculo de FOV Nativo (Frame Gui Centrado)
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOV_Circle"
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovFrame.Size = UDim2.new(0, 300, 0, 300) -- FOV de 150 de raio
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
fovFrame.Parent = screenGui

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(255, 255, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3
fovStroke.Parent = fovFrame

-- Mini Quadrado Flutuante
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 20, 0.5, -20)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.Image = "rbxassetid://0" -- Substitui pelo teu ID de Imagem
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
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar


-- 2. SISTEMA DE ABAS
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


-- 3. FUNÇÃO DE ARRASTAR
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


-- 4. CONFIGURAÇÕES GLOBAIS
local SETTINGS = {
	AimbotMaster = false,
	AimbotMode = "Legit",
	ShowFOV = false,
	IgnoreDead = true,
	WallCheck = false, -- Desativado por padrão para testes sem falhas
	SmoothLock = true,
	TeamCheck = false,
	FOVRadius = 150,

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
createToggleWithCallback(aimbotTab, "Verificar Equipa (Team Check)", 7, false, function(v) SETTINGS.TeamCheck = v end)

-- Criar Aba ESP
local espTab = createTab("Esp", 2)
createToggleWithCallback(espTab, "Ativar ESP Master", 1, false, function(v) SETTINGS.EspMaster = v end)
createToggleWithCallback(espTab, "Box ESP (Caixa / Highlight)", 2, false, function(v) SETTINGS.Box2D = v end)
createToggleWithCallback(espTab, "Name ESP", 3, false, function(v) SETTINGS.Name = v end)
createToggleWithCallback(espTab, "Health Bar (Verde)", 4, false, function(v) SETTINGS.HealthBar = v end)

-- Criar Aba Diversos
local diversosTab = createTab("Diversos", 3)
createToggleWithCallback(diversosTab, "Fullbright (Iluminação)", 1, false, function(v) SETTINGS.Fullbright = v end)
createToggleWithCallback(diversosTab, "Speed Hack (Velocidade x2)", 2, false, function(v) 
	SETTINGS.SpeedHack = v 
	if not v and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.WalkSpeed = 16
	end
end)

-- Criar Aba Info
local infoTab = createTab("Info", 4)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 100)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "gbzinbr scripts\nSistema Nativo sem Erros\nCompatível com PC e Mobile."
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextWrapped = true
infoLabel.Parent = infoTab


-- 5. LÓGICA DE EXECUÇÃO NATIVA (SEM DRAWING API)
local espStorage = {}

local function cleanPlayerESP(player)
	if espStorage[player] then
		for _, v in pairs(espStorage[player]) do
			pcall(function() v:Destroy() end)
		end
		espStorage[player] = nil
	end
end

Players.PlayerRemoving:Connect(cleanPlayerESP)

local function isTeammate(otherPlayer)
	if not SETTINGS.TeamCheck then return false end
	if localPlayer.Team and otherPlayer.Team then
		return localPlayer.Team == otherPlayer.Team
	end
	if localPlayer.TeamColor and otherPlayer.TeamColor then
		return localPlayer.TeamColor == otherPlayer.TeamColor
	end
	return false
end

local function getClosestTargetToCenter()
	local closestTarget = nil
	local shortestDist = SETTINGS.FOVRadius
	local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and not isTeammate(player) then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
				local humanoid = char.Humanoid
				if not SETTINGS.IgnoreDead or humanoid.Health > 0 then
					local targetPart = char:FindFirstChild("Head") or char.HumanoidRootPart
					local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)

					if onScreen then
						local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
						if dist < shortestDist then
							shortestDist = dist
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
	-- FOV Nativo
	fovFrame.Visible = SETTINGS.AimbotMaster and SETTINGS.ShowFOV

	-- Aimbot Nativo
	if SETTINGS.AimbotMaster then
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

	-- Speed Hack
	if SETTINGS.SpeedHack and localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
		localPlayer.Character.Humanoid.WalkSpeed = 32
	end

	-- Fullbright
	if SETTINGS.Fullbright then
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
		Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	end

	-- ESP Nativo (BillboardGui e Highlight)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and not isTeammate(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
			local char = player.Character
			local hum = char.Humanoid
			local head = char:FindFirstChild("Head")

			if SETTINGS.EspMaster and hum.Health > 0 then
				if not espStorage[player] then
					espStorage[player] = {}

					-- Highlight (Box / Silhueta ESP)
					local hl = Instance.new("Highlight")
					hl.Name = "ESP_Highlight"
					hl.FillColor = Color3.fromRGB(255, 30, 30)
					hl.FillTransparency = 0.6
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
					hl.OutlineTransparency = 0
					hl.Parent = char
					espStorage[player].Highlight = hl

					-- Billboard (Nome e Vida)
					local bb = Instance.new("BillboardGui")
					bb.Name = "ESP_Billboard"
					bb.Size = UDim2.new(0, 120, 0, 40)
					bb.StudsOffset = Vector3.new(0, 3, 0)
					bb.AlwaysOnTop = true
					bb.Adornee = head or char.HumanoidRootPart
					bb.Parent = char

					local nameLabel = Instance.new("TextLabel")
					nameLabel.Name = "NameLabel"
					nameLabel.Size = UDim2.new(1, 0, 0, 18)
					nameLabel.BackgroundTransparency = 1
					nameLabel.Text = player.Name
					nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					nameLabel.TextStrokeTransparency = 0
					nameLabel.TextSize = 13
					nameLabel.Font = Enum.Font.GothamBold
					nameLabel.Parent = bb

					local hpBg = Instance.new("Frame")
					hpBg.Name = "HpBg"
					hpBg.Size = UDim2.new(1, 0, 0, 4)
					hpBg.Position = UDim2.new(0, 0, 0, 20)
					hpBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
					hpBg.BorderSizePixel = 0
					hpBg.Parent = bb

					local hpFill = Instance.new("Frame")
					hpFill.Name = "HpFill"
					hpFill.Size = UDim2.new(1, 0, 1, 0)
					hpFill.BackgroundColor3 = Color3.fromRGB(0, 230, 118)
					hpFill.BorderSizePixel = 0
					hpFill.Parent = hpBg

					espStorage[player].Billboard = bb
					espStorage[player].HpFill = hpFill
				end

				-- Atualizar Visibilidade do ESP
				local st = espStorage[player]
				if st and st.Highlight and st.Billboard then
					st.Highlight.Enabled = SETTINGS.Box2D
					st.Billboard.Enabled = SETTINGS.Name or SETTINGS.HealthBar
					st.Billboard.NameLabel.Visible = SETTINGS.Name
					st.Billboard.HpBg.Visible = SETTINGS.HealthBar

					-- Atualizar Barra de Vida
					local healthRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
					st.HpFill.Size = UDim2.new(healthRatio, 0, 1, 0)
					st.HpFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthRatio), 255 * healthRatio, 0)
				end
			else
				cleanPlayerESP(player)
			end
		else
			cleanPlayerESP(player)
		end
	end
end)


-- 6. TROCA DE ABAS
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


-- 7. SISTEMA DE ABRIR / FECHAR
local isOpen = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local isDraggingButton = false

toggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingButton = false
	end
end)

toggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		isDraggingButton = true
	end
end)

local function toggleMenu()
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
end

toggleButton.MouseButton1Up:Connect(toggleMenu)
toggleButton.TouchEnded:Connect(toggleMenu)

closeButton.MouseButton1Click:Connect(function()
	if isOpen then
		isOpen = false
		mainFrame.Visible = false
	end
end)
