-- =========================================
-- SCRIPT PARA DELTA: MENU COMPLETO (MOBILE)
-- Status + Funções + ESP + Aimbot Mobile + Team Check + IY
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

-- Configurações do ESP
local ESPEnabled = false
local ESPMaxDistance = 2000
local ESPBoxes = true
local ESPHealth = true
local ESPDistance = true
local ESPSkeleton = true
local ESPTeamCheck = false

-- Configurações do Aimbot (Mobile)
local AimbotEnabled = false
local AimbotTarget = nil
local AimbotFOV = 150 -- raio em pixels a partir do centro da tela
local AimbotTeamCheck = false

-- Tabelas de Drawing Objects
local ESPDrawings = {}
local SkeletonDrawings = {}

-- =========================================
-- FUNÇÃO AUXILIAR: TEAM CHECK
-- =========================================
local function IsTeammate(player)
    if not LocalPlayer.Team or not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

-- =========================================
-- ABA 1: STATUS DO JOGADOR
-- =========================================
local StatusTab = Window:CreateTab("Status", 4483362458)

StatusTab:CreateLabel("👤 Nome: " .. LocalPlayer.Name)
StatusTab:CreateLabel("🖼️ Avatar: https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=150&height=150&format=png")
StatusTab:CreateLabel("📅 Conta criada: " .. os.date("!%d/%m/%Y", os.time() - (LocalPlayer.AccountAge * 86400)))
StatusTab:CreateLabel("📜 Script: Meu Hub Delta v1.4 (Mobile)")

-- =========================================
-- ABA 2: FUNÇÕES
-- =========================================
local CheatTab = Window:CreateTab("Funções", 4483362458)

-- --- SEÇÃO: MOVIMENTAÇÃO ---
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
    Callback = function(Value)
        InfJumpEnabled = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- --- SEÇÃO: VISUAL (ESP) ---
CheatTab:CreateSection("Visual (ESP)")

CheatTab:CreateToggle({
    Name = "Ativar ESP",
    CurrentValue = false,
    Flag = "ESP_Master",
    Callback = function(Value)
        ESPEnabled = Value
        if not Value then
            for _, drawings in pairs(ESPDrawings) do
                for _, d in pairs(drawings) do
                    if d.Remove then d:Remove() end
                end
            end
            for _, drawings in pairs(SkeletonDrawings) do
                for _, d in pairs(drawings) do
                    if d.Remove then d:Remove() end
                end
            end
            ESPDrawings = {}
            SkeletonDrawings = {}
        end
    end,
})

CheatTab:CreateToggle({
    Name = "Caixa (Box)",
    CurrentValue = true,
    Flag = "ESP_Box",
    Callback = function(Value) ESPBoxes = Value end,
})

CheatTab:CreateToggle({
    Name = "Barra de Vida",
    CurrentValue = true,
    Flag = "ESP_Health",
    Callback = function(Value) ESPHealth = Value end,
})

CheatTab:CreateToggle({
    Name = "Distância",
    CurrentValue = true,
    Flag = "ESP_Distance",
    Callback = function(Value) ESPDistance = Value end,
})

CheatTab:CreateToggle({
    Name = "Esqueleto (Skeleton)",
    CurrentValue = true,
    Flag = "ESP_Skeleton",
    Callback = function(Value) ESPSkeleton = Value end,
})

CheatTab:CreateToggle({
    Name = "ESP: Team Check (Ignorar Aliados)",
    CurrentValue = false,
    Flag = "ESP_TeamCheck",
    Callback = function(Value) ESPTeamCheck = Value end,
})

CheatTab:CreateSlider({
    Name = "Distância Máxima do ESP",
    Range = {100, 5000},
    Increment = 100,
    Suffix = " studs",
    CurrentValue = 2000,
    Flag = "ESP_MaxDist",
    Callback = function(Value) ESPMaxDistance = Value end,
})

-- --- SEÇÃO: COMBATE (AIMBOT MOBILE) ---
CheatTab:CreateSection("Combate")

CheatTab:CreateToggle({
    Name = "Aimbot (Centro da Tela)",
    CurrentValue = false,
    Flag = "Aimbot_Master",
    Callback = function(Value)
        AimbotEnabled = Value
        if not Value then AimbotTarget = nil end
    end,
})

CheatTab:CreateToggle({
    Name = "Aimbot: Team Check (Ignorar Aliados)",
    CurrentValue = false,
    Flag = "Aimbot_TeamCheck",
    Callback = function(Value)
        AimbotTeamCheck = Value
        if Value and AimbotTarget and IsTeammate(AimbotTarget) then
            AimbotTarget = nil
        end
    end,
})

CheatTab:CreateSlider({
    Name = "Aimbot FOV (Raio do Centro)",
    Range = {50, 400},
    Increment = 10,
    Suffix = " px",
    CurrentValue = 150,
    Flag = "Aimbot_FOV",
    Callback = function(Value) AimbotFOV = Value end,
})

CheatTab:CreateLabel("Arraste a tela para trocar de alvo automaticamente")

-- --- SEÇÃO: OUTROS ---
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
-- LÓGICA DO ESP (DRAWING API)
-- =========================================
local function CreateESPDrawings(player)
    if player == LocalPlayer then return end

    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Visible = false

    local healthBg = Drawing.new("Line")
    healthBg.Thickness = 2
    healthBg.Color = Color3.fromRGB(0, 0, 0)
    healthBg.Visible = false

    local healthBar = Drawing.new("Line")
    healthBar.Thickness = 2
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Visible = false

    local distanceText = Drawing.new("Text")
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.Color = Color3.fromRGB(255, 255, 255)
    distanceText.Visible = false

    ESPDrawings[player] = {
        Box = box,
        HealthBg = healthBg,
        HealthBar = healthBar,
        Distance = distanceText,
    }

    local boneConnections = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"},
        {"RightLowerLeg", "RightFoot"},
    }

    local skeletonLines = {}
    for i = 1, #boneConnections do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Color = Color3.fromRGB(0, 255, 0)
        line.Visible = false
        table.insert(skeletonLines, line)
    end

    SkeletonDrawings[player] = {
        Lines = skeletonLines,
        Connections = boneConnections,
    }
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
        else
            drawings.Box.Visible = false
        end

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

            if healthPercent > 0.6 then
                drawings.HealthBar.Color = Color3.fromRGB(0, 255, 0)
            elseif healthPercent > 0.3 then
                drawings.HealthBar.Color = Color3.fromRGB(255, 165, 0)
            else
                drawings.HealthBar.Color = Color3.fromRGB(255, 0, 0)
            end
        else
            drawings.HealthBg.Visible = false
            drawings.HealthBar.Visible = false
        end

        if ESPDistance then
            drawings.Distance.Visible = true
            drawings.Distance.Text = "[" .. math.floor(distance) .. "m]"
            drawings.Distance.Position = Vector2.new(screenPos.X, boxY - 18)
        else
            drawings.Distance.Visible = false
        end

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
                    else
                        SkeletonDrawings[player].Lines[i].Visible = false
                    end
                else
                    SkeletonDrawings[player].Lines[i].Visible = false
                end
            end
        elseif SkeletonDrawings[player] then
            for _, line in pairs(SkeletonDrawings[player].Lines) do line.Visible = false end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESPDrawings(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    CreateESPDrawings(player)
end)

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
-- LÓGICA DO AIMBOT (MOBILE - CENTRO DA TELA)
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

-- A cada frame: escolhe o alvo mais próximo do centro e trava a câmera
RunService.RenderStepped:Connect(function()
    if not AimbotEnabled then
        AimbotTarget = nil
        return
    end

    local newTarget = GetPlayerClosestToCenter()

    if newTarget then
        AimbotTarget = newTarget
        local head = newTarget.Character and newTarget.Character:FindFirstChild("Head")
        if head then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    else
        AimbotTarget = nil
    end
end)

-- =========================================
-- LOOP PRINCIPAL DO ESP
-- =========================================
RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

-- =========================================
-- INICIALIZAÇÃO
-- =========================================
Rayfield:Notify({
    Title = "Menu Carregado",
    Content = "ESP + Aimbot Mobile + Team Check prontos!",
    Duration = 5,
})
