--// AETHER UNIVERSAL EXPLOIT - 2025
--// UI: Fluent + Acrylic Blur | Full ESP | Smooth Aimbot | FPS Boost
--// Creado para Modo Bypass

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Configuración Global
getgenv().Aether = {
    Aimbot = { Enabled = false, Smoothness = 0.15, FOV = 100, TeamCheck = true, WallCheck = true, Priority = "Head" },
    ESP = { Enabled = false, Name = true, Distance = true, Health = true, Box = true, Tracer = true },
    Others = { FPSBoost = false, InfJump = false, Speed = 16, Noclip = false, ClickTP = false }
}

--// Cargar Fluent UI (Synapse/Fluxus)
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/z1nkio/Fluent/main/Fluent.lua"))()
local Window = Fluent:CreateWindow({
    Title = "Aether Exploit",
    SubTitle = "Universal 2025",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

--// Pestañas
local AimbotTab = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" })
local ESPTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local OthersTab = Window:AddTab({ Title = "Others", Icon = "zap" })

--// Funciones de Aimbot
local function GetClosestPlayer()
    local Closest, Distance = nil, math.huge
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Root = Player.Character.HumanoidRootPart
            local Head = Player.Character:FindFirstChild("Head") or Root
            local Pos, OnScreen = Camera:WorldToViewportPoint(Head.Position)
            local Dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Pos.X, Pos.Y)).Magnitude

            if OnScreen and Dist < getgenv().Aether.Aimbot.FOV and Dist < Distance then
                if not getgenv().Aether.Aimbot.TeamCheck or Player.Team ~= LocalPlayer.Team then
                    if not getgenv().Aether.Aimbot.WallCheck or #Camera:GetPartsObscuringTarget({Head.Position}, {LocalPlayer.Character, Player.Character}) == 0 then
                        Closest, Distance = Player, Dist
                    end
                end
            end
        end
    end
    return Closest
end

local function SmoothAim(TargetPos)
    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
    local TargetScreen = Camera:WorldToViewportPoint(TargetPos)
    local ScreenPos = Vector2.new(TargetScreen.X, TargetScreen.Y)
    local Delta = (ScreenPos - MousePos) * getgenv().Aether.Aimbot.Smoothness
    mousemoverel(Delta.X, Delta.Y)
end

--// Aimbot Loop
RunService.RenderStepped:Connect(function()
    if getgenv().Aether.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local Target = GetClosestPlayer()
        if Target and Target.Character then
            local Part = Target.Character:FindFirstChild(getgenv().Aether.Aimbot.Priority) or Target.Character.HumanoidRootPart
            SmoothAim(Part.Position)
        end
    end
end)

--// Dibujar FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 0, 100)
FOVCircle.Filled = false
FOVCircle.Radius = getgenv().Aether.Aimbot.FOV
FOVCircle.Visible = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOVCircle.Radius = getgenv().Aether.Aimbot.FOV
    FOVCircle.Visible = getgenv().Aether.Aimbot.Enabled
end)

--// ESP System
local ESPObjects = {}

local function CreateESP(Player)
    if ESPObjects[Player] then return end

    local Box = Drawing.new("Square")
    Box.Thickness = 2
    Box.Color = Color3.fromRGB(0, 255, 0)
    Box.Filled = false
    Box.Transparency = 1

    local Tracer = Drawing.new("Line")
    Tracer.Thickness = 1.5
    Tracer.Color = Color3.fromRGB(0, 255, 0)

    local Name = Drawing.new("Text")
    Name.Size = 14
    Name.Center = true
    Name.Outline = true
    Name.Font = 2

    local Distance = Drawing.new("Text")
    Distance.Size = 13
    Distance.Center = true
    Distance.Outline = true
    Distance.Font = 2

    local Health = Drawing.new("Text")
    Health.Size = 13
    Health.Center = true
    Health.Outline = true
    Health.Font = 2

    ESPObjects[Player] = { Box = Box, Tracer = Tracer, Name = Name, Distance = Distance, Health = Health }
end

local function UpdateESP()
    for Player, Drawings in pairs(ESPObjects) do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Root = Player.Character.HumanoidRootPart
            local Head = Player.Character:FindFirstChild("Head") or Root
            local Humanoid = Player.Character.Humanoid
            local Pos, OnScreen = Camera:WorldToViewportPoint(Root.Position)
            local HeadPos = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0, 0.5, 0))
            local LegPos = Camera:WorldToViewportPoint(Root.Position - Vector3.new(0, 3, 0))

            local BoxSize = Vector2.new(2200 / Pos.Z, HeadPos.Y - LegPos.Y)
            local BoxPos = Vector2.new(Pos.X - BoxSize.X / 2, Pos.Y - BoxSize.Y / 2)

            local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - Root.Position).Magnitude

            Drawings.Box.Size = BoxSize
            Drawings.Box.Position = BoxPos
            Drawings.Box.Visible = getgenv().Aether.ESP.Box and OnScreen

            Drawings.Tracer.From = Vector2.new(Mouse.X, Camera.ViewportSize.Y)
            Drawings.Tracer.To = Vector2.new(Pos.X, Pos.Y + 36)
            Drawings.Tracer.Visible = getgenv().Aether.ESP.Tracer and OnScreen

            Drawings.Name.Text = Player.DisplayName
            Drawings.Name.Position = Vector2.new(Pos.X, HeadPos.Y - 20)
            Drawings.Name.Visible = getgenv().Aether.ESP.Name and OnScreen

            Drawings.Distance.Text = math.floor(Distance) .. "m"
            Drawings.Distance.Position = Vector2.new(Pos.X, LegPos.Y + 5)
            Drawings.Distance.Visible = getgenv().Aether.ESP.Distance and OnScreen

            Drawings.Health.Text = math.floor(Humanoid.Health) .. "/" .. Humanoid.MaxHealth
            Drawings.Health.Position = Vector2.new(BoxPos.X - 30, BoxPos.Y)
            Drawings.Health.Visible = getgenv().Aether.ESP.Health and OnScreen

            Drawings.Health.Color = Color3.fromHSV((Humanoid.Health / Humanoid.MaxHealth) * 0.33, 1, 1)
        else
            for _, v in pairs(Drawings) do v.Visible = false end
        end
    end
end

for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then CreateESP(Player) end
end

Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function() CreateESP(Player) end)
end)

RunService.RenderStepped:Connect(UpdateESP)

--// UI: Aimbot
AimbotTab:AddToggle("aimbot_enabled", {
    Title = "Aimbot",
    Default = false,
    Callback = function(v) getgenv().Aether.Aimbot.Enabled = v end
})

AimbotTab:AddSlider("aimbot_smooth", {
    Title = "Suavidad",
    Min = 0.05, Max = 0.5, Default = 0.15, Rounding = 2,
    Callback = function(v) getgenv().Aether.Aimbot.Smoothness = v end
})

AimbotTab:AddSlider("aimbot_fov", {
    Title = "FOV",
    Min = 10, Max = 300, Default = 100,
    Callback = function(v) getgenv().Aether.Aimbot.FOV = v end
})

AimbotTab:AddDropdown("aimbot_priority", {
    Title = "Prioridad",
    Values = {"Head", "HumanoidRootPart", "UpperTorso"},
    Default = "Head",
    Callback = function(v) getgenv().Aether.Aimbot.Priority = v end
})

AimbotTab:AddToggle("aimbot_teamcheck", { Title = "Team Check", Default = true, Callback = function(v) getgenv().Aether.Aimbot.TeamCheck = v end })
AimbotTab:AddToggle("aimbot_wallcheck", { Title = "Wall Check", Default = true, Callback = function(v) getgenv().Aether.Aimbot.WallCheck = v end })

--// UI: ESP
ESPTab:AddToggle("esp_enabled", { Title = "ESP General", Default = false, Callback = function(v) getgenv().Aether.ESP.Enabled = v end })
ESPTab:AddToggle("esp_name", { Title = "Nombre", Default = true, Callback = function(v) getgenv().Aether.ESP.Name = v end })
ESPTab:AddToggle("esp_distance", { Title = "Distancia", Default = true, Callback = function(v) getgenv().Aether.ESP.Distance = v end })
ESPTab:AddToggle("esp_health", { Title = "Salud", Default = true, Callback = function(v) getgenv().Aether.ESP.Health = v end })
ESPTab:AddToggle("esp_box", { Title = "Box 2D", Default = true, Callback = function(v) getgenv().Aether.ESP.Box = v end })
ESPTab:AddToggle("esp_tracer", { Title = "Tracer", Default = true, Callback = function(v) getgenv().Aether.ESP.Tracer = v end })

--// UI: Others
OthersTab:AddToggle("fps_boost", {
    Title = "FPS Boost",
    Default = false,
    Callback = function(v)
        getgenv().Aether.Others.FPSBoost = v
        if v then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") then
                    v.Transparency = 1
                end
            end
        end
    end
})

OthersTab:AddToggle("inf_jump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v)
        getgenv().Aether.Others.InfJump = v
        if v then
            UserInputService.JumpRequest:Connect(function()
                if getgenv().Aether.Others.InfJump then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end
})

OthersTab:AddSlider("walkspeed", {
    Title = "WalkSpeed",
    Min = 16, Max = 200, Default = 16,
    Callback = function(v)
        getgenv().Aether.Others.Speed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

OthersTab:AddToggle("noclip", {
    Title = "Noclip",
    Default = false,
    Callback = function(v)
        getgenv().Aether.Others.Noclip = v
        if v then
            RunService.Stepped:Connect(function()
                if getgenv().Aether.Others.Noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

OthersTab:AddToggle("click_tp", {
    Title = "Click TP (CTRL + Click)",
    Default = false,
    Callback = function(v)
        getgenv().Aether.Others.ClickTP = v
        if v then
            Mouse.Button1Down:Connect(function()
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and LocalPlayer.Character then
                    LocalPlayer.Character:MoveTo(Mouse.Hit.p)
                end
            end)
        end
    end
})

--// Final
Fluent:Notify({ Title = "Aether", Content = "Exploit cargado correctamente." })
print("Aether Universal Exploit - Loaded.")
