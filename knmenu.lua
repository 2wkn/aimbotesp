--[[
    KN MENU - Versão Final com Opção FOV Mobile (Centro do Ecrã vs Rato)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
if not player then
    player = Players.PlayerAdded:Wait()
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then return end

if playerGui:FindFirstChild("KnMenuGui") then
    playerGui.KnMenuGui:Destroy()
end

-- Criar ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KnMenuGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Cores do Tema
local COLOR_BG = Color3.fromRGB(15, 15, 15)
local COLOR_PANEL = Color3.fromRGB(22, 22, 22)
local COLOR_GOLD = Color3.fromRGB(255, 190, 0)
local COLOR_TEXT = Color3.fromRGB(240, 240, 240)
local COLOR_MUTED = Color3.fromRGB(150, 150, 150)

--------------------------------------------------------------------------------
-- CONTAINER CENTRALIZADO
--------------------------------------------------------------------------------
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 1020, 0, 540)
mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
mainContainer.Position = UDim2.new(0.5, 0, 0.5, 20)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = true
mainContainer.Parent = screenGui

--------------------------------------------------------------------------------
-- CONTROLO INDEPENDENTE: TECLA K E BOTÃO DIREITO DO RATO
--------------------------------------------------------------------------------
local cheatState = {
    GodMode = false,
    InfiniteHealth = false,
    InfiniteArmor = false,
    SuperJump = false,
    SpeedMultiplier = 1.0,
    
    ESPEnabled = false,
    WallhackVisibleOnly = false,
    Fullbright = false,
    NoFog = false,
    
    AimbotEnabled = false,
    AimKeyHeld = false,
    ShowFOV = false,
    FOVMobile = false, -- Nova opção: FOV no centro do ecrã
    FOVRadius = 120,
    AimTargetPart = "Head",
    FOVColor = Color3.fromRGB(0, 170, 255)
}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.K then
        mainContainer.Visible = not mainContainer.Visible
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        cheatState.AimKeyHeld = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        cheatState.AimKeyHeld = false
    end
end)

--------------------------------------------------------------------------------
-- FUNÇÃO DE VERIFICAÇÃO DE VISIBILIDADE (WALLHACK CHECK)
--------------------------------------------------------------------------------
local function isTargetVisible(targetPart)
    if not cheatState.WallhackVisibleOnly then return true end
    
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then return false end
    
    local origin = character.Head.Position
    local targetPosition = targetPart.Position
    local direction = targetPosition - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character, targetPart.Parent}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult == nil then
        return true
    end
    
    return false
end

--------------------------------------------------------------------------------
-- 1. BARRA LATERAL ESQUERDA (Menu de Navegação)
--------------------------------------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 200, 0, 520)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = COLOR_BG
sidebar.BorderSizePixel = 0
sidebar.Parent = mainContainer

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 12)
sidebarCorner.Parent = sidebar

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = COLOR_GOLD
sidebarStroke.Transparency = 0.7
sidebarStroke.Thickness = 1.5
sidebarStroke.Parent = sidebar

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(1, 0, 0, 100)
logoFrame.BackgroundTransparency = 1
logoFrame.Parent = sidebar

local logoTitle = Instance.new("TextLabel")
logoTitle.Size = UDim2.new(1, 0, 0, 25)
logoTitle.Position = UDim2.new(0, 0, 0, 55)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "KN"
logoTitle.TextColor3 = COLOR_TEXT
logoTitle.TextSize = 20
logoTitle.Font = Enum.Font.GothamBold
logoTitle.Parent = logoFrame

local logoSub = Instance.new("TextLabel")
logoSub.Size = UDim2.new(1, 0, 0, 15)
logoSub.Position = UDim2.new(0, 0, 0, 78)
logoSub.BackgroundTransparency = 1
logoSub.Text = "MENU"
logoSub.TextColor3 = COLOR_GOLD
logoSub.TextSize = 13
logoSub.Font = Enum.Font.GothamBold
logoSub.Parent = logoFrame

local navContainer = Instance.new("ScrollingFrame")
navContainer.Size = UDim2.new(1, -10, 0, 340)
navContainer.Position = UDim2.new(0, 5, 0, 105)
navContainer.BackgroundTransparency = 1
navContainer.BorderSizePixel = 0
navContainer.CanvasSize = UDim2.new(0, 0, 0, 310)
navContainer.ScrollBarThickness = 3
navContainer.Parent = sidebar

local navLayout = Instance.new("UIListLayout")
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Padding = UDim.new(0, 6)
navLayout.Parent = navContainer

local sidebarFooter = Instance.new("Frame")
sidebarFooter.Size = UDim2.new(1, -16, 0, 55)
sidebarFooter.Position = UDim2.new(0, 8, 1, -63)
sidebarFooter.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
sidebarFooter.BorderSizePixel = 0
sidebarFooter.Parent = sidebar

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 8)
footerCorner.Parent = sidebarFooter

local onlineDot = Instance.new("Frame")
onlineDot.Size = UDim2.new(0, 8, 0, 8)
onlineDot.Position = UDim2.new(0, 12, 0, 15)
onlineDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
onlineDot.BorderSizePixel = 0
onlineDot.Parent = sidebarFooter
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = onlineDot

local onlineText = Instance.new("TextLabel")
onlineText.Size = UDim2.new(0, 160, 0, 15)
onlineText.Position = UDim2.new(0, 28, 0, 11)
onlineText.BackgroundTransparency = 1
onlineText.Text = "made by: kn #dinis"
onlineText.TextColor3 = COLOR_TEXT
onlineText.TextSize = 11
onlineText.Font = Enum.Font.GothamMedium
onlineText.TextXAlignment = Enum.TextXAlignment.Left
onlineText.Parent = sidebarFooter

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 15)
versionText.Position = UDim2.new(0, 12, 0, 32)
versionText.BackgroundTransparency = 1
versionText.Text = "v1.0"
versionText.TextColor3 = COLOR_MUTED
versionText.TextSize = 11
versionText.Font = Enum.Font.Gotham
versionText.TextXAlignment = Enum.TextXAlignment.Left
versionText.Parent = sidebarFooter

--------------------------------------------------------------------------------
-- 2. BARRA SUPERIOR DE STATUS
--------------------------------------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(0, 560, 0, 45)
topBar.Position = UDim2.new(0, 215, 0, 0)
topBar.BackgroundColor3 = COLOR_BG
topBar.BorderSizePixel = 0
topBar.Parent = mainContainer

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

local topBarStroke = Instance.new("UIStroke")
topBarStroke.Color = COLOR_GOLD
topBarStroke.Transparency = 0.7
topBarStroke.Thickness = 1
topBarStroke.Parent = topBar

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(0, 300, 1, 0)
welcomeLabel.Position = UDim2.new(0, 15, 0, 0)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Bem-vindo(a), " .. player.Name .. "!"
welcomeLabel.TextColor3 = COLOR_TEXT
welcomeLabel.TextSize = 13
welcomeLabel.Font = Enum.Font.GothamMedium
welcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
welcomeLabel.Parent = topBar

local clockLabel = Instance.new("TextLabel")
clockLabel.Size = UDim2.new(0, 100, 1, 0)
clockLabel.Position = UDim2.new(1, -140, 0, 0)
clockLabel.BackgroundTransparency = 1
clockLabel.Text = "13:45:30"
clockLabel.TextColor3 = COLOR_TEXT
clockLabel.TextSize = 13
clockLabel.Font = Enum.Font.GothamMedium
clockLabel.Parent = topBar

task.spawn(function()
    while true do
        local date = os.date("*t")
        clockLabel.Text = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
        task.wait(1)
    end
end)

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0, 30, 0, 30)
settingsBtn.Position = UDim2.new(1, -38, 0.5, -15)
settingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
settingsBtn.Text = "..."
settingsBtn.TextColor3 = COLOR_GOLD
settingsBtn.TextSize = 16
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.Parent = topBar
local settingsCorner = Instance.new("UICorner")
settingsCorner.CornerRadius = UDim.new(0, 6)
settingsCorner.Parent = settingsBtn

--------------------------------------------------------------------------------
-- 3. BANNER PRINCIPAL (KN MENU)
--------------------------------------------------------------------------------
local mainBanner = Instance.new("Frame")
mainBanner.Size = UDim2.new(0, 560, 0, 100)
mainBanner.Position = UDim2.new(0, 215, 0, 55)
mainBanner.BackgroundColor3 = COLOR_BG
mainBanner.BorderSizePixel = 0
mainBanner.Parent = mainContainer

local bannerCorner = Instance.new("UICorner")
bannerCorner.CornerRadius = UDim.new(0, 10)
bannerCorner.Parent = mainBanner

local bannerStroke = Instance.new("UIStroke")
bannerStroke.Color = COLOR_GOLD
bannerStroke.Transparency = 0.5
bannerStroke.Thickness = 1.5
bannerStroke.Parent = mainBanner

local bannerTitle = Instance.new("TextLabel")
bannerTitle.Size = UDim2.new(0, 400, 0, 30)
bannerTitle.Position = UDim2.new(0, 20, 0, 22)
bannerTitle.BackgroundTransparency = 1
bannerTitle.Text = "KN MENU"
bannerTitle.TextColor3 = COLOR_GOLD
bannerTitle.TextSize = 22
bannerTitle.Font = Enum.Font.GothamBold
bannerTitle.TextXAlignment = Enum.TextXAlignment.Left
bannerTitle.Parent = mainBanner

local bannerSub = Instance.new("TextLabel")
bannerSub.Size = UDim2.new(0, 400, 0, 20)
bannerSub.Position = UDim2.new(0, 20, 0, 52)
bannerSub.BackgroundTransparency = 1
bannerSub.Text = "Domine o jogo com estilo."
bannerSub.TextColor3 = COLOR_MUTED
bannerSub.TextSize = 13
bannerSub.Font = Enum.Font.Gotham
bannerSub.TextXAlignment = Enum.TextXAlignment.Left
bannerSub.Parent = mainBanner

--------------------------------------------------------------------------------
-- 4. PAINEL DIREITO DUPLO: JOGADORES & CARROS
--------------------------------------------------------------------------------
local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0, 210, 0, 520)
rightPanel.Position = UDim2.new(0, 790, 0, 0)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainContainer

local switchPlayersBtn = Instance.new("TextButton")
switchPlayersBtn.Size = UDim2.new(0.48, 0, 0, 30)
switchPlayersBtn.Position = UDim2.new(0, 0, 0, 0)
switchPlayersBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 15)
switchPlayersBtn.Text = "Jogadores"
switchPlayersBtn.TextColor3 = COLOR_GOLD
switchPlayersBtn.TextSize = 11
switchPlayersBtn.Font = Enum.Font.GothamBold
switchPlayersBtn.Parent = rightPanel
local spc = Instance.new("UICorner")
spc.CornerRadius = UDim.new(0, 6)
spc.Parent = switchPlayersBtn

local switchCarsBtn = Instance.new("TextButton")
switchCarsBtn.Size = UDim2.new(0.48, 0, 0, 30)
switchCarsBtn.Position = UDim2.new(0.52, 0, 0, 0)
switchCarsBtn.BackgroundColor3 = COLOR_BG
switchCarsBtn.Text = "Carros"
switchCarsBtn.TextColor3 = COLOR_MUTED
switchCarsBtn.TextSize = 11
switchCarsBtn.Font = Enum.Font.Gotham
switchCarsBtn.Parent = rightPanel
local scc = Instance.new("UICorner")
scc.CornerRadius = UDim.new(0, 6)
scc.Parent = switchCarsBtn

local playerListPanel = Instance.new("Frame")
playerListPanel.Size = UDim2.new(1, 0, 0, 480)
playerListPanel.Position = UDim2.new(0, 0, 0, 38)
playerListPanel.BackgroundColor3 = COLOR_BG
playerListPanel.BorderSizePixel = 0
playerListPanel.Visible = true
playerListPanel.Parent = rightPanel

local plCorner = Instance.new("UICorner")
plCorner.CornerRadius = UDim.new(0, 10)
plCorner.Parent = playerListPanel
local plStroke = Instance.new("UIStroke")
plStroke.Color = COLOR_GOLD
plStroke.Transparency = 0.7
plStroke.Thickness = 1.5
plStroke.Parent = playerListPanel

local plHeader = Instance.new("TextLabel")
plHeader.Size = UDim2.new(1, -20, 0, 35)
plHeader.Position = UDim2.new(0, 12, 0, 5)
plHeader.BackgroundTransparency = 1
plHeader.Text = "Jogadores Online (0)"
plHeader.TextColor3 = COLOR_TEXT
plHeader.TextSize = 12
plHeader.Font = Enum.Font.GothamBold
plHeader.TextXAlignment = Enum.TextXAlignment.Left
plHeader.Parent = playerListPanel

local plScroll = Instance.new("ScrollingFrame")
plScroll.Size = UDim2.new(1, -8, 1, -45)
plScroll.Position = UDim2.new(0, 4, 0, 40)
plScroll.BackgroundTransparency = 1
plScroll.BorderSizePixel = 0
plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.ScrollBarThickness = 3
plScroll.Parent = playerListPanel

local plLayout = Instance.new("UIListLayout")
plLayout.SortOrder = Enum.SortOrder.LayoutOrder
plLayout.Padding = UDim.new(0, 4)
plLayout.Parent = plScroll

local function updatePlayerList()
    for _, child in ipairs(plScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local playersList = Players:GetPlayers()
    plHeader.Text = "Jogadores Online (" .. #playersList .. ")"
    plScroll.CanvasSize = UDim2.new(0, 0, 0, #playersList * 32)
    
    for _, p in ipairs(playersList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 0
        btn.Text = "  " .. p.Name
        btn.TextColor3 = COLOR_TEXT
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = plScroll
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = btn
    end
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local carListPanel = Instance.new("Frame")
carListPanel.Size = UDim2.new(1, 0, 0, 480)
carListPanel.Position = UDim2.new(0, 0, 0, 38)
carListPanel.BackgroundColor3 = COLOR_BG
carListPanel.BorderSizePixel = 0
carListPanel.Visible = false
carListPanel.Parent = rightPanel

local clCorner = Instance.new("UICorner")
clCorner.CornerRadius = UDim.new(0, 10)
clCorner.Parent = carListPanel
local clStroke = Instance.new("UIStroke")
clStroke.Color = COLOR_GOLD
clStroke.Transparency = 0.7
clStroke.Thickness = 1.5
clStroke.Parent = carListPanel

local clHeader = Instance.new("TextLabel")
clHeader.Size = UDim2.new(1, -20, 0, 35)
clHeader.Position = UDim2.new(0, 12, 0, 5)
clHeader.BackgroundTransparency = 1
clHeader.Text = "Veículos Próximos (0)"
clHeader.TextColor3 = COLOR_TEXT
clHeader.TextSize = 12
clHeader.Font = Enum.Font.GothamBold
clHeader.TextXAlignment = Enum.TextXAlignment.Left
clHeader.Parent = carListPanel

local clScroll = Instance.new("ScrollingFrame")
clScroll.Size = UDim2.new(1, -8, 1, -45)
clScroll.Position = UDim2.new(0, 4, 0, 40)
clScroll.BackgroundTransparency = 1
clScroll.BorderSizePixel = 0
clScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
clScroll.ScrollBarThickness = 3
clScroll.Parent = carListPanel

local clLayout = Instance.new("UIListLayout")
clLayout.SortOrder = Enum.SortOrder.LayoutOrder
clLayout.Padding = UDim.new(0, 4)
clLayout.Parent = clScroll

local function updateCarList()
    for _, child in ipairs(clScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local cars = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") or obj:IsA("Seat") then
            local model = obj.Parent
            if model and model:IsA("Model") and not table.find(cars, model) then
                table.insert(cars, model)
            end
        end
    end
    
    clHeader.Text = "Veículos Próximos (" .. #cars .. ")"
    clScroll.CanvasSize = UDim2.new(0, 0, 0, #cars * 32)
    
    for _, car in ipairs(cars) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        btn.BorderSizePixel = 0
        btn.Text = "  " .. car.Name
        btn.TextColor3 = COLOR_TEXT
        btn.TextSize = 11
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = clScroll
        
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local primaryPart = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
                if primaryPart then
                    player.Character.HumanoidRootPart.CFrame = primaryPart.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end)
    end
end

task.spawn(function()
    while true do
        if carListPanel.Visible then
            updateCarList()
        end
        task.wait(3)
    end
end)

switchPlayersBtn.MouseButton1Click:Connect(function()
    switchPlayersBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 15)
    switchPlayersBtn.TextColor3 = COLOR_GOLD
    switchPlayersBtn.Font = Enum.Font.GothamBold
    switchCarsBtn.BackgroundColor3 = COLOR_BG
    switchCarsBtn.TextColor3 = COLOR_MUTED
    switchCarsBtn.Font = Enum.Font.Gotham
    playerListPanel.Visible = true
    carListPanel.Visible = false
    updatePlayerList()
end)

switchCarsBtn.MouseButton1Click:Connect(function()
    switchCarsBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 15)
    switchCarsBtn.TextColor3 = COLOR_GOLD
    switchCarsBtn.Font = Enum.Font.GothamBold
    switchPlayersBtn.BackgroundColor3 = COLOR_BG
    switchPlayersBtn.TextColor3 = COLOR_MUTED
    switchPlayersBtn.Font = Enum.Font.Gotham
    carListPanel.Visible = true
    playerListPanel.Visible = false
    updateCarList()
end)

--------------------------------------------------------------------------------
-- 5. CONTAINER DAS ABAS
--------------------------------------------------------------------------------
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(0, 560, 0, 345)
contentContainer.Position = UDim2.new(0, 215, 0, 175)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainContainer

local function createCard(parent, title, size, position)
    local card = Instance.new("Frame")
    card.Size = size
    card.Position = position
    card.BackgroundColor3 = COLOR_PANEL
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = COLOR_GOLD
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = card
    
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 12, 0, 5)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = COLOR_GOLD
    titleLbl.TextSize = 13
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card
    
    return card
end

local tabs = {}
local function createTabFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = contentContainer
    return frame
end

--------------------------------------------------------------------------------
-- ABA 1: INÍCIO
--------------------------------------------------------------------------------
local tabInicio = createTabFrame()
tabInicio.Visible = true
tabs["Início"] = tabInicio

local playerCard = createCard(tabInicio, "Player", UDim2.new(0, 270, 0, 165), UDim2.new(0, 0, 0, 0))

local function addToggle(parent, text, yPos, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 180, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = COLOR_TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    
    local toggleBg = Instance.new("TextButton")
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -48, 0, yPos + 1)
    toggleBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggleBg.Text = ""
    toggleBg.AutoButtonColor = false
    toggleBg.Parent = parent
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = toggleBg
    
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0, 14, 0, 14)
    circle.Position = UDim2.new(0, 2, 0, 2)
    circle.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    circle.BorderSizePixel = 0
    circle.Parent = toggleBg
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = circle
    
    local state = false
    toggleBg.MouseButton1Click:Connect(function()
        state = not state
        if state then
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_GOLD}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 20, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
        end
        if callback then callback(state) end
    end)
end

addToggle(playerCard, "God Mode", 32, function(v) cheatState.GodMode = v end)
addToggle(playerCard, "Vida Infinita", 57, function(v) cheatState.InfiniteHealth = v end)
addToggle(playerCard, "Colete Infinito", 82, function(v) cheatState.InfiniteArmor = v end)
addToggle(playerCard, "Super Pulo", 107, function(v)
    cheatState.SuperJump = v
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").JumpPower = v and 120 or 50
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if cheatState.GodMode or cheatState.InfiniteHealth then
                humanoid.Health = humanoid.MaxHealth
            end
            if cheatState.SuperJump then
                humanoid.JumpPower = 120
            end
            humanoid.WalkSpeed = 16 * cheatState.SpeedMultiplier
        end
    end
end)

local speedLbl = Instance.new("TextLabel")
speedLbl.Size = UDim2.new(0, 180, 0, 20)
speedLbl.Position = UDim2.new(0, 12, 0, 132)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "Velocidade do Jogador"
speedLbl.TextColor3 = COLOR_TEXT
speedLbl.TextSize = 12
speedLbl.Font = Enum.Font.Gotham
speedLbl.TextXAlignment = Enum.TextXAlignment.Left
speedLbl.Parent = playerCard

local speedVal = Instance.new("TextLabel")
speedVal.Size = UDim2.new(0, 50, 0, 20)
speedVal.Position = UDim2.new(1, -60, 0, 132)
speedVal.BackgroundTransparency = 1
speedVal.Text = "1.0x"
speedVal.TextColor3 = COLOR_GOLD
speedVal.TextSize = 12
speedVal.Font = Enum.Font.GothamBold
speedVal.TextXAlignment = Enum.TextXAlignment.Right
speedVal.Parent = playerCard

local sliderBg = Instance.new("TextButton")
sliderBg.Size = UDim2.new(1, -24, 0, 8)
sliderBg.Position = UDim2.new(0, 12, 0, 152)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sliderBg.Text = ""
sliderBg.AutoButtonColor = false
sliderBg.BorderSizePixel = 0
sliderBg.Parent = playerCard
local sc1 = Instance.new("UICorner")
sc1.CornerRadius = UDim.new(1, 0)
sc1.Parent = sliderBg

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.2, 0, 1, 0)
sliderFill.BackgroundColor3 = COLOR_GOLD
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg
local sc2 = Instance.new("UICorner")
sc2.CornerRadius = UDim.new(1, 0)
sc2.Parent = sliderFill

local mouse = player:GetMouse()
local sliding = false
sliderBg.MouseButton1Down:Connect(function() sliding = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        local multiplier = math.round((1 + (pos * 4)) * 10) / 10
        cheatState.SpeedMultiplier = multiplier
        speedVal.Text = string.format("%.1fx", multiplier)
    end
end)

-- Card 2: Veículos
local vehCard = createCard(tabInicio, "Veículos", UDim2.new(0, 270, 0, 165), UDim2.new(0, 290, 0, 0))

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(1, -24, 0, 26)
spawnBtn.Position = UDim2.new(0, 12, 0, 32)
spawnBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
spawnBtn.Text = "Selecionar Veículo"
spawnBtn.TextColor3 = COLOR_MUTED
spawnBtn.TextSize = 12
spawnBtn.Font = Enum.Font.Gotham
spawnBtn.Parent = vehCard
local sbc = Instance.new("UICorner")
sbc.CornerRadius = UDim.new(0, 6)
sbc.Parent = spawnBtn

local delVehBtn = Instance.new("TextButton")
delVehBtn.Size = UDim2.new(1, -24, 0, 26)
delVehBtn.Position = UDim2.new(0, 12, 0, 64)
delVehBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
delVehBtn.Text = "Deletar Veículo                                      "
delVehBtn.TextColor3 = COLOR_TEXT
delVehBtn.TextSize = 12
delVehBtn.Font = Enum.Font.Gotham
delVehBtn.TextXAlignment = Enum.TextXAlignment.Left
delVehBtn.Parent = vehCard
local dvbc = Instance.new("UICorner")
dvbc.CornerRadius = UDim.new(0, 6)
dvbc.Parent = delVehBtn

addToggle(vehCard, "Jetpack", 98, function(v) print("Jetpack:", v) end)

local vehSpeedLbl = Instance.new("TextLabel")
vehSpeedLbl.Size = UDim2.new(0, 180, 0, 20)
vehSpeedLbl.Position = UDim2.new(0, 12, 0, 122)
vehSpeedLbl.BackgroundTransparency = 1
vehSpeedLbl.Text = "Velocidade do Veículo"
vehSpeedLbl.TextColor3 = COLOR_TEXT
vehSpeedLbl.TextSize = 12
vehSpeedLbl.Font = Enum.Font.Gotham
vehSpeedLbl.TextXAlignment = Enum.TextXAlignment.Left
vehSpeedLbl.Parent = vehCard

local vehSpeedVal = Instance.new("TextLabel")
vehSpeedVal.Size = UDim2.new(0, 50, 0, 20)
vehSpeedVal.Position = UDim2.new(1, -60, 0, 122)
vehSpeedVal.BackgroundTransparency = 1
vehSpeedVal.Text = "1.0x"
vehSpeedVal.TextColor3 = COLOR_GOLD
vehSpeedVal.TextSize = 12
vehSpeedVal.Font = Enum.Font.GothamBold
vehSpeedVal.TextXAlignment = Enum.TextXAlignment.Right
vehSpeedVal.Parent = vehCard

local vSliderBg = Instance.new("Frame")
vSliderBg.Size = UDim2.new(1, -24, 0, 4)
vSliderBg.Position = UDim2.new(0, 12, 0, 146)
vSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
vSliderBg.BorderSizePixel = 0
vSliderBg.Parent = vehCard
local vsc1 = Instance.new("UICorner")
vsc1.CornerRadius = UDim.new(1, 0)
vsc1.Parent = vSliderBg
local vSliderFill = Instance.new("Frame")
vSliderFill.Size = UDim2.new(0.2, 0, 1, 0)
vSliderFill.BackgroundColor3 = COLOR_GOLD
vSliderFill.BorderSizePixel = 0
vSliderFill.Parent = vSliderBg
local vsc2 = Instance.new("UICorner")
vsc2.CornerRadius = UDim.new(1, 0)
vsc2.Parent = vSliderFill

-- Card 3: Teleporte
local tpCard = createCard(tabInicio, "Teleporte", UDim2.new(0, 270, 0, 165), UDim2.new(0, 0, 0, 175))

local function addTpButton(parent, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 34)
    btn.Position = UDim2.new(0, 12, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = "  " .. text
    btn.TextColor3 = COLOR_TEXT
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn
    return btn
end

addTpButton(tpCard, "Teleportar para Marcador", 35)
addTpButton(tpCard, "Teleportar para o Jogador", 78)
addTpButton(tpCard, "Teleportar para Veículo", 121)

--------------------------------------------------------------------------------
-- ABA 2: AIMBOT & FOV PERSONALIZÁVEL (MOUSE OU CENTRO/MOBILE)
--------------------------------------------------------------------------------
local tabAimbot = createTabFrame()
tabs["Aimbot"] = tabAimbot

local aimbotCard1 = createCard(tabAimbot, "Configurações de Mira", UDim2.new(0, 270, 0, 165), UDim2.new(0, 0, 0, 0))
local aimbotCard2 = createCard(tabAimbot, "Circulo FOV", UDim2.new(0, 270, 0, 165), UDim2.new(0, 290, 0, 0))

addToggle(aimbotCard1, "Ativar Aimbot", 32, function(v)
    cheatState.AimbotEnabled = v
end)

local targetBtn = Instance.new("TextButton")
targetBtn.Size = UDim2.new(1, -24, 0, 30)
targetBtn.Position = UDim2.new(0, 12, 0, 60)
targetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
targetBtn.Text = "Alvo: Cabeça (Head)"
targetBtn.TextColor3 = COLOR_GOLD
targetBtn.TextSize = 12
targetBtn.Font = Enum.Font.GothamBold
targetBtn.Parent = aimbotCard1
local tbc = Instance.new("UICorner")
tbc.CornerRadius = UDim.new(0, 6)
tbc.Parent = targetBtn

targetBtn.MouseButton1Click:Connect(function()
    if cheatState.AimTargetPart == "Head" then
        cheatState.AimTargetPart = "HumanoidRootPart"
        targetBtn.Text = "Alvo: Tronco (Torso)"
    else
        cheatState.AimTargetPart = "Head"
        targetBtn.Text = "Alvo: Cabeça (Head)"
    end
end)

addToggle(aimbotCard2, "Mostrar Círculo FOV", 32, function(v)
    cheatState.ShowFOV = v
end)

-- Nova opção: FOV Mobile (Coloca o FOV no centro da tela)
addToggle(aimbotCard2, "FOV Mobile", 57, function(v)
    cheatState.FOVMobile = v
end)

-- Slider de Tamanho/Raio do FOV (Reposicionado ligeiramente abaixo para acomodar o novo botão)
local fovSizeLbl = Instance.new("TextLabel")
fovSizeLbl.Size = UDim2.new(0, 180, 0, 20)
fovSizeLbl.Position = UDim2.new(0, 12, 0, 90)
fovSizeLbl.BackgroundTransparency = 1
fovSizeLbl.Text = "Tamanho do FOV"
fovSizeLbl.TextColor3 = COLOR_TEXT
fovSizeLbl.TextSize = 12
fovSizeLbl.Font = Enum.Font.Gotham
fovSizeLbl.TextXAlignment = Enum.TextXAlignment.Left
fovSizeLbl.Parent = aimbotCard2

local fovSizeVal = Instance.new("TextLabel")
fovSizeVal.Size = UDim2.new(0, 50, 0, 20)
fovSizeVal.Position = UDim2.new(1, -60, 0, 90)
fovSizeVal.BackgroundTransparency = 1
fovSizeVal.Text = "120"
fovSizeVal.TextColor3 = COLOR_GOLD
fovSizeVal.TextSize = 12
fovSizeVal.Font = Enum.Font.GothamBold
fovSizeVal.TextXAlignment = Enum.TextXAlignment.Right
fovSizeVal.Parent = aimbotCard2

local fovSliderBg = Instance.new("TextButton")
fovSliderBg.Size = UDim2.new(1, -24, 0, 8)
fovSliderBg.Position = UDim2.new(0, 12, 0, 113)
fovSliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovSliderBg.Text = ""
fovSliderBg.AutoButtonColor = false
fovSliderBg.BorderSizePixel = 0
fovSliderBg.Parent = aimbotCard2
local fsc1 = Instance.new("UICorner")
fsc1.CornerRadius = UDim.new(1, 0)
fsc1.Parent = fovSliderBg

local fovSliderFill = Instance.new("Frame")
fovSliderFill.Size = UDim2.new(0.3, 0, 1, 0)
fovSliderFill.BackgroundColor3 = COLOR_GOLD
fovSliderFill.BorderSizePixel = 0
fovSliderFill.Parent = fovSliderBg
local fsc2 = Instance.new("UICorner")
fsc2.CornerRadius = UDim.new(1, 0)
fsc2.Parent = fovSliderFill

local fovSliding = false
fovSliderBg.MouseButton1Down:Connect(function() fovSliding = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then fovSliding = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if fovSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((mouse.X - fovSliderBg.AbsolutePosition.X) / fovSliderBg.AbsoluteSize.X, 0, 1)
        fovSliderFill.Size = UDim2.new(pos, 0, 1, 0)
        cheatState.FOVRadius = math.round(pos * 350) + 20
        fovSizeVal.Text = tostring(cheatState.FOVRadius)
    end
end)

local colorsList = {
    {Name = "Azul", Color = Color3.fromRGB(0, 170, 255)},
    {Name = "Vermelho", Color = Color3.fromRGB(255, 50, 50)},
    {Name = "Verde", Color = Color3.fromRGB(50, 255, 50)},
    {Name = "Amarelo", Color = Color3.fromRGB(255, 220, 0)},
    {Name = "Branco", Color = Color3.fromRGB(255, 255, 255)}
}
local currentColorIdx = 1

local colorBtn = Instance.new("TextButton")
colorBtn.Size = UDim2.new(1, -24, 0, 28)
colorBtn.Position = UDim2.new(0, 12, 0, 130)
colorBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
colorBtn.Text = "Cor do FOV: Azul"
colorBtn.TextColor3 = COLOR_TEXT
colorBtn.TextSize = 12
colorBtn.Font = Enum.Font.Gotham
colorBtn.Parent = aimbotCard2
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 6)
cbc.Parent = colorBtn

colorBtn.MouseButton1Click:Connect(function()
    currentColorIdx = currentColorIdx + 1
    if currentColorIdx > #colorsList then
        currentColorIdx = 1
    end
    local selected = colorsList[currentColorIdx]
    cheatState.FOVColor = selected.Color
    colorBtn.Text = "Cor do FOV: " .. selected.Name
end)

local fovCircleFrame = Instance.new("Frame")
fovCircleFrame.Name = "FOVCircle"
fovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircleFrame.BackgroundTransparency = 1
fovCircleFrame.Visible = false
fovCircleFrame.Parent = screenGui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = Color3.fromRGB(0, 170, 255)
fovStroke.Thickness = 1.5
fovStroke.Parent = fovCircleFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovCircleFrame

-- Loop principal: Gere o FOV (Rato ou Centro/Mobile) e o cálculo do Aimbot
RunService.RenderStepped:Connect(function()
    local camera = Workspace.CurrentCamera
    local referencePoint
    
    if cheatState.FOVMobile then
        -- FOV no centro exato da tela
        referencePoint = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    else
        -- FOV no cursor do rato
        referencePoint = UserInputService:GetMouseLocation()
    end
    
    fovCircleFrame.Visible = cheatState.ShowFOV
    local diameter = cheatState.FOVRadius * 2
    fovCircleFrame.Size = UDim2.new(0, diameter, 0, diameter)
    fovCircleFrame.Position = UDim2.new(0, referencePoint.X, 0, referencePoint.Y)
    fovStroke.Color = cheatState.FOVColor
    
    if cheatState.AimbotEnabled and cheatState.AimKeyHeld then
        local closestPlayer = nil
        local shortestDist = cheatState.FOVRadius
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local targetPart = p.Character:FindFirstChild(cheatState.AimTargetPart) or p.Character:FindFirstChild("Head")
                    if targetPart then
                        if isTargetVisible(targetPart) then
                            local pos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local screenPos = Vector2.new(pos.X, pos.Y)
                                local distToRef = (screenPos - referencePoint).Magnitude
                                
                                if distToRef < shortestDist then
                                    shortestDist = distToRef
                                    closestPlayer = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
        
        if closestPlayer then
            camera.CFrame = CFrame.new(camera.CFrame.Position, closestPlayer.Position)
        end
    end
end)

--------------------------------------------------------------------------------
-- ABA 3: VISUAL
--------------------------------------------------------------------------------
local tabVisual = createTabFrame()
tabs["Visual"] = tabVisual

local visualCard1 = createCard(tabVisual, "ESP e Wallhack", UDim2.new(0, 270, 0, 165), UDim2.new(0, 0, 0, 0))
local visualCard2 = createCard(tabVisual, "Iluminação e Ambiente", UDim2.new(0, 270, 0, 165), UDim2.new(0, 290, 0, 0))

addToggle(visualCard1, "ESP Jogadores (Highlight)", 32, function(v)
    cheatState.ESPEnabled = v
    if v then
        task.spawn(function()
            while cheatState.ESPEnabled do
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        if not p.Character:FindFirstChild("KnESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "KnESP"
                            hl.FillColor = Color3.fromRGB(255, 190, 0)
                            hl.FillTransparency = 0.5
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.OutlineTransparency = 0
                            hl.Parent = p.Character
                        end
                    end
                end
                task.wait(1)
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("KnESP") then
                    p.Character.KnESP:Destroy()
                end
            end
        end)
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("KnESP") then
                p.Character.KnESP:Destroy()
            end
        end
    end
end)

addToggle(visualCard1, "Wallhack (Aimbot Visível)", 65, function(v)
    cheatState.WallhackVisibleOnly = v
end)

addToggle(visualCard2, "Fullbright (Remover Escuridão)", 32, function(v)
    cheatState.Fullbright = v
    task.spawn(function()
        while cheatState.Fullbright do
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 999999
            task.wait(0.5)
        end
        Lighting.GlobalShadows = true
        Lighting.Brightness = 1
    end)
end)

--------------------------------------------------------------------------------
-- OUTRAS ABAS SECUNDÁRIAS
--------------------------------------------------------------------------------
local function createDummyTab(name)
    if tabs[name] then return end
    local t = createTabFrame()
    tabs[name] = t
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Painel de " .. name .. " em desenvolvimento."
    lbl.TextColor3 = COLOR_MUTED
    lbl.TextSize = 16
    lbl.Font = Enum.Font.GothamBold
    lbl.Parent = t
end

createDummyTab("Jogador")
createDummyTab("Veículos")
createDummyTab("Teleporte")
createDummyTab("Misc")
createDummyTab("Configurações")

--------------------------------------------------------------------------------
-- NAVEGAÇÃO SIDEBAR
--------------------------------------------------------------------------------
local navButtonsData = {
    {Name = "Início"},
    {Name = "Jogador"},
    {Name = "Veículos"},
    {Name = "Teleporte"},
    {Name = "Aimbot"},
    {Name = "Visual"},
    {Name = "Misc"},
    {Name = "Configurações"}
}

local activeNavButton = nil

for i, data in ipairs(navButtonsData) do
    local navBtn = Instance.new("TextButton")
    navBtn.Size = UDim2.new(1, 0, 0, 34)
    navBtn.BackgroundColor3 = (data.Name == "Início") and Color3.fromRGB(35, 30, 15) or COLOR_BG
    navBtn.BorderSizePixel = 0
    navBtn.Text = "    " .. data.Name
    navBtn.TextColor3 = (data.Name == "Início") and COLOR_GOLD or COLOR_TEXT
    navBtn.TextSize = 13
    navBtn.Font = (data.Name == "Início") and Enum.Font.GothamBold or Enum.Font.Gotham
    navBtn.TextXAlignment = Enum.TextXAlignment.Left
    navBtn.Parent = navContainer
    
    local nc = Instance.new("UICorner")
    nc.CornerRadius = UDim.new(0, 8)
    nc.Parent = navBtn
    
    if data.Name == "Início" then
        activeNavButton = navBtn
    end
    
    navBtn.MouseButton1Click:Connect(function()
        if activeNavButton then
            activeNavButton.BackgroundColor3 = COLOR_BG
            activeNavButton.TextColor3 = COLOR_TEXT
            activeNavButton.Font = Enum.Font.Gotham
        end
        activeNavButton = navBtn
        navBtn.BackgroundColor3 = Color3.fromRGB(35, 30, 15)
        navBtn.TextColor3 = COLOR_GOLD
        navBtn.Font = Enum.Font.GothamBold
        
        for tabName, tabFrame in pairs(tabs) do
            tabFrame.Visible = (tabName == data.Name)
        end
    end)
end

print("[KnMenu] Opção 'FOV Mobile' adicionada com sucesso na aba Aimbot!")
