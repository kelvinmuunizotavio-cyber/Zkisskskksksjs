-- =========================================
-- SCRIPT PARA DELTA: MENU COMPLETO (MOBILE)
-- Status + Funções + ESP + Aimbot Mobile + Team Check + Tiro + Botão Flutuante + IY
-- =========================================

-- 1. CARREGAR A BIBLIOTECA DE UI (RAYFIELD)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. CRIAR A JANELA PRINCIPAL
local Window = Rayfield:CreateWindow({
    Name = "Meu Hub Delta",
    LoadingTitle = "Carregando...",
    LoadingSubtitle = "by Você",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "Acesso Restrito",
        Subtitle = "Digite a senha para entrar",
        Note = "Senha: delta123",
        FileName = "KeyDelta",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"delta123"}
    }
})

-- =========================================
-- SERVIÇOS E VARIÁVEIS GLOBAIS
-- =========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPMaxDistance = 2000
local ESPBoxes = true
local ESPHealth = true
local ESPDistance = true
local ESPSkeleton = true
local ESPTeamCheck = false

local AimbotEnabled = false
local AimbotTarget = nil
local AimbotFOV = 150
local AimbotTeamCheck = false

local ESPDrawings = {}
local SkeletonDrawings = {}

local function IsTeammate(player)
    if not LocalPlayer.Team or not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

-- =========================================
-- ABA 1: STATUS
-- =========================================
local StatusTab = Window:CreateTab("Status", 4483362458)
StatusTab:CreateLabel("👤 Nome: " .. LocalPlayer.Name)
StatusTab:CreateLabel("🖼️ Avatar: https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png")
StatusTab:CreateLabel("📅 Conta criada: " .. os.date("!%d/%m/%Y", os.time() - (LocalPlayer.AccountAge * 86400)))
StatusTab:CreateLabel("📜 Script: Meu Hub Delta v1.6 (Mobile + Botão Flutuante)")

-- =========================================
-- ABA 2: FUNÇÕES
-- =========================================
local CheatTab = Window:CreateTab("Funções", 4483362458)

CheatTab:CreateSection("Movimentação")

CheatTab:CreateInput({
    Name = "Velocidade (Speed)",
    CurrentValue = "16",
    PlaceholderText = "Digite a velocidade...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    end,
})

CheatTab:CreateInput({
    Name = "Força do Pulo (JumpPower)",
    CurrentValue = "50",
    PlaceholderText = "Digite a força do pulo...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local jump = tonumber(Text)
        if jump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = jump
        end
    end,
})

local InfJumpEnabled = false
CheatTab:CreateToggle({
    Name = "Pulo Infinito",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(Value) InfJumpEnabled = Value end,
})

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

CheatTab:CreateSection("Visual (ESP)")

CheatTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESP_Master",
    Callback = function(Value)
        ESPEnabled = Value
        if not Value then
            for _, drawings in pairs(ESPDrawings) do
                for _, d in pairs(drawings) do if d.Remove then d:Remove() end end
            end
            for _, drawings in pairs(SkeletonDrawings) do
                for _, d in pairs(drawings) do if d.Remove then d:Remove() end end
            end
            ESPDrawings = {}
            SkeletonDrawings = {}
        end
    end,
})

CheatTab:CreateToggle({Name = "Caixa (Box)", CurrentValue = true, Flag = "ESP_Box", Callback = function(Value) ESPBoxes = Value end})
CheatTab:CreateToggle({Name = "Barra de Vida", CurrentValue = true, Flag = "ESP_Health", Callback = function(Value) ESPHealth = Value end})
CheatTab:CreateToggle({Name = "Distância", CurrentValue = true, Flag = "ESP_Distance", Callback = function(Value) ESPDistance = Value end})
CheatTab:CreateToggle({Name = "Esqueleto (Skeleton)", CurrentValue = true, Flag = "ESP_Skeleton", Callback = function(Value) ESPSkeleton = Value end})
CheatTab:CreateToggle({Name = "ESP: Team Check", CurrentValue = false, Flag = "ESP_TeamCheck", Callback = function(Value) ESPTeamCheck = Value end})

CheatTab:CreateSlider({
    Name = "Distância Máxima do ESP",
    Range = {100, 5000}, Increment = 100, Suffix = " studs",
    CurrentValue = 2000, Flag = "ESP_MaxDist",
    Callback = function(Value) ESPMaxDistance = Value end,
})

CheatTab:CreateSection("Combate")

CheatTab:CreateToggle({
    Name = "Aimbot (Centro da Tela)",
    CurrentValue = false, Flag = "Aimbot_Master",
    Callback = function(Value)
        AimbotEnabled = Value
        if not Value then AimbotTarget = nil end
    end,
})

CheatTab:CreateToggle({
    Name = "Aimbot: Team Check",
    CurrentValue = false, Flag = "Aimbot_TeamCheck",
    Callback = function(Value)
        AimbotTeamCheck = Value
        if Value and AimbotTarget and IsTeammate(AimbotTarget) then AimbotTarget = nil end
    end,
})

CheatTab:CreateSlider({
    Name = "Aimbot FOV (Raio do Centro)",
    Range = {50, 400}, Increment = 10, Suffix = " px",
    CurrentValue = 150, Flag = "Aimbot_FOV",
    Callback = function(Value) AimbotFOV = Value end,
})

CheatTab:CreateLabel("Arraste a tela para trocar de alvo")

CheatTab:CreateSection("Outros")

CheatTab:CreateButton({
    Name = "Abrir Infinite Yield",
    Callback = function()
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            end)
            if not success then
                Rayfield:Notify({Title = "Erro", Content = "Falha: " .. tostring(err), Duration = 5})
            end
        end)
    end,
})

-- =========================================
-- LÓGICA DO ESP
-- =========================================
local function CreateESPDrawings(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Thickness = 1; box.Filled = false; box.Color = Color3.fromRGB(255, 0, 0); box.Visible = false

    local healthBg = Drawing.new("Line")
    healthBg.Thickness = 2; healthBg.Color = Color3.fromRGB(0, 0, 0); healthBg.Visible = false

    local healthBar = Drawing.new("Line")
    healthBar.Thickness = 2; healthBar.Color = Color3.fromRGB(0, 255, 0); healthBar.Visible = false

    local distanceText = Drawing.new("Text")
    distanceText.Size = 14; distanceText.Center = true; distanceText.Outline = true
    distanceText.Color = Color3.fromRGB(255, 255, 255); distanceText.Visible = false

    ESPDrawings[player] = {Box = box, HealthBg = healthBg, HealthBar = healthBar, Distance = distanceText}

    local boneConnections = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
    }

    local skeletonLines = {}
    for i = 1, #boneConnections do
        local line = Drawing.new("Line")
        line.Thickness = 1; line.Color = Color3.fromRGB(0, 255, 0); line.Visible = false
        table.insert(skeletonLines, line)
    end
    SkeletonDrawings[player] = {Lines = skeletonLines, Connections = boneConnections}
end

local function UpdateESP()
    if not ESPEnabled then return end
    for player, drawings in pairs(ESPDrawings) do
        if not player or not player.Parent or not player.Character then
            for _, d in pairs(drawings) do d.Visible = false end
            if SkeletonDrawings[player] then
                for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
            end
            continue
        end
        if ESPTeamCheck and IsTeammate(player) then
            for _, d in pairs(drawings) do d.Visible = false end
            if SkeletonDrawings[player] then
                for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
            end
            continue
        end
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        if not humanoid or not rootPart or humanoid.Health <= 0 then
            for _, d in pairs(drawings) do d.Visible = false end
            if SkeletonDrawings[player] then
                for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
            end
            continue
        end
        local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
        if distance > ESPMaxDistance then
            for _, d in pairs(drawings) do d.Visible = false end
            if SkeletonDrawings[player] then
                for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
            end
            continue
        end
        local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        if not onScreen then
            for _, d in pairs(drawings) do d.Visible = false end
            if SkeletonDrawings[player] then
                for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
            end
            continue
        end
        local headScreen = Camera:WorldToViewportPoint(head.Position)
        local height = math.abs(screenPos.Y - headScreen.Y) * 2.2
        local width = height * 0.55
        local boxX = screenPos.X - width / 2
        local boxY = screenPos.Y - height / 2
        if ESPBoxes then
            drawings.Box.Visible = true
            drawings.Box.Size = Vector2.new(width, height)
            drawings.Box.Position = Vector2.new(boxX, boxY)
        else drawings.Box.Visible = false end
        if ESPHealth then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barHeight = height * healthPercent
            local barX = boxX - 6
            local barY = boxY + height - barHeight
            drawings.HealthBg.Visible = true
            drawings.HealthBg.From = Vector2.new(barX, boxY)
            drawings.HealthBg.To = Vector2.new(barX, boxY + height)
            drawings.HealthBar.Visible = true
            drawings.HealthBar.From = Vector2.new(barX, barY)
            drawings.HealthBar.To = Vector2.new(barX, boxY + height)
            if healthPercent > 0.6 then drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.3 then drawings.HealthBar.Color = Color3.fromRGB(255, 165, 0)
            else drawings.HealthBar.Color = Color3.fromRGB(255, 0, 0) end
        else
            drawings.HealthBg.Visible = false
            drawings.HealthBar.Visible = false
        end
        if ESPDistance then
            drawings.Distance.Visible = true
            drawings.Distance.Text = "[" .. math.floor(distance) .. "m]"
            drawings.Distance.Position = Vector2.new(screenPos.X, boxY - 18)
        else drawings.Distance.Visible = false end
        if ESPSkeleton and SkeletonDrawings[player] then
            for i, conn in ipairs(SkeletonDrawings[player].Connections) do
                local part1 = character:FindFirstChild(conn[1])
                local part2 = character:FindFirstChild(conn[2])
                if part1 and part2 then
                    local pos1, on1 = Camera:WorldToViewportPoint(part1.Position)
                    local pos2, on2 = Camera:WorldToViewportPoint(part2.Position)
                    if on1 and on2 then
                        SkeletonDrawings[player].Lines[i].Visible = true
                        SkeletonDrawings[player].Lines[i].From = Vector2.new(pos1.X, pos1.Y)
                        SkeletonDrawings[player].Lines[i].To = Vector2.new(pos2.X, pos2.Y)
                    else SkeletonDrawings[player].Lines[i].Visible = false end
                else SkeletonDrawings[player].Lines[i].Visible = false end
            end
        elseif SkeletonDrawings[player] then
            for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then CreateESPDrawings(player) end
end
Players.PlayerAdded:Connect(function(player) CreateESPDrawings(player) end)
Players.PlayerRemoving:Connect(function(player)
    if ESPDrawings[player] then
        for _, d in pairs(ESPDrawings[player]) do if d.Remove then d:Remove() end end
        ESPDrawings[player] = nil
    end
    if SkeletonDrawings[player] then
        for _, line in pairs(SkeletonDrawings[player].Lines) do if line.Remove then line:Remove() end end
        SkeletonDrawings[player] = nil
    end
end)

-- =========================================
-- LÓGICA DO AIMBOT (CENTRO DA TELA)
-- =========================================
local function GetPlayerClosestToCenter()
    local viewport = Camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local closestPlayer = nil
    local closestDistance = AimbotFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if AimbotTeamCheck and IsTeammate(player) then continue end
        if not player.Character then continue end
        local head = player.Character:FindFirstChild("Head")
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not head or not humanoid or humanoid.Health <= 0 then continue end
        local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        if not onScreen then continue end
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestPlayer = player
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then AimbotTarget = nil return end
    local newTarget = GetPlayerClosestToCenter()
    if newTarget then
        AimbotTarget = newTarget
        local head = newTarget.Character and newTarget.Character:FindFirstChild("Head")
        if head then Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position) end
    else AimbotTarget = nil end
end)

-- =========================================
-- FUNÇÃO DE TIRO
-- =========================================
local function ShootAtTarget()
    local target = AimbotTarget
    if not target or not target.Character then target = GetPlayerClosestToCenter() end
    if not target or not target.Character then
        Rayfield:Notify({Title = "Atirar", Content = "Nenhum inimigo no centro da mira.", Duration = 2})
        return
    end
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
    local character = LocalPlayer.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    local mouse = LocalPlayer:GetMouse()
    if tool then pcall(function() tool:Activate() end) end
    if mouse then
        pcall(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(mouse.X, mouse.Y))
        end)
    end
    pcall(function()
        local VirtualUser = game:GetService("VirtualUser")
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2))
    end)
end

-- =========================================
-- BOTÃO FLUTUANTE DE TIRO (FORA DO PAINEL)
-- =========================================
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local oldBtn = playerGui:FindFirstChild("ShootFloatingButton")
if oldBtn then oldBtn:Destroy() end

local shootGui = Instance.new("ScreenGui")
shootGui.Name = "ShootFloatingButton"
shootGui.ResetOnSpawn = false
shootGui.IgnoreGuiInset = true
shootGui.Parent = playerGui

local shootBtn = Instance.new("TextButton")
shootBtn.Size = UDim2.new(0, 70, 0, 70)
shootBtn.Position = UDim2.new(0, 20, 0.5, -35)
shootBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
shootBtn.Text = "🔫"
shootBtn.TextSize = 30
shootBtn.TextColor3 = Color3.new(1, 1, 1)
shootBtn.Font = Enum.Font.SourceSansBold
shootBtn.BorderSizePixel = 0
shootBtn.AutoButtonColor = false
shootBtn.Parent = shootGui

local shootCorner = Instance.new("UICorner")
shootCorner.CornerRadius = UDim.new(1, 0)
shootCorner.Parent = shootBtn

local shootStroke = Instance.new("UIStroke")
shootStroke.Color = Color3.fromRGB(255, 255, 255)
shootStroke.Thickness = 2
shootStroke.Parent = shootBtn

-- Arrastar
local dragging = false
local dragStart = nil
local startPos = nil

shootBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = shootBtn.Position
    end
end)

shootBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        shootBtn.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Clique = atirar (só se não foi arrasto)
local clickStart = nil
shootBtn.MouseButton1Down:Connect(function() clickStart = tick() end)
shootBtn.MouseButton1Up:Connect(function()
    if clickStart and (tick() - clickStart) < 0.3 then
        pcall(function() ShootAtTarget() end)
    end
    clickStart = nil
end)

-- =========================================
-- LOOPS
-- =========================================
RunService.RenderStepped:Connect(function() UpdateESP() end)

Rayfield:Notify({
    Title = "Menu Carregado",
    Content = "ESP + Aimbot + Botão Flutuante de Tiro prontos!",
    Duration = 5,
})
