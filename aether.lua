--// AETHER UNIVERSAL EXPLOIT - FIXED 2025
--// UI: Rayfield (Siempre Online) | Full ESP | Smooth Aimbot
--// Compatible: Synapse X, KRNL, Fluxus, Delta

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Config
getgenv().Aether = {
    Aimbot = { Enabled = false, Smoothness = 0.15, FOV = 100, TeamCheck = true, WallCheck = true, Priority = "Head" },
    ESP = { Enabled = false, Name = true, Distance = true, Health = true, Box = true, Tracer = true },
    Others = { FPSBoost = false, InfJump = false, Speed = 16, Noclip = false, ClickTP = false }
}

--// CARGAR RAYFIELD UI (100% ONLINE 2025)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Aether Exploit",
    LoadingTitle = "Cargando Aether...",
    LoadingSubtitle = "Universal 2025",
    ConfigurationSaving = { Enabled = true, FolderName = "AetherConfig" },
    Discord = { Enabled = false },
    KeySystem = false
})

--// Pestañas
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local ESPTab = Window:CreateTab("ESP", 4483362458)
local OthersTab = Window:CreateTab("Others", 4483362458)

--// Aimbot
local function GetClosest()
    local Closest, Dist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head") or root
            local pos, onscreen = Camera:WorldToViewportPoint(head.Position)
            local mouseDist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude

            if onscreen and mouseDist < getgenv().Aether.Aimbot.FOV and mouseDist < Dist then
                if not getgenv().Aether.Aimbot.TeamCheck or p.Team ~= LocalPlayer.Team then
                    if not getgenv().Aether.Aimbot.WallCheck or #Camera:GetPartsObscuringTarget({head.Position}, {LocalPlayer.Character, p.Character}) == 0 then
                        Closest, Dist = p, mouseDist
                    end
                end
            end
        end
    end
    return Closest
end

RunService.RenderStepped:Connect(function()
    if getgenv().Aether.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosest()
        if target and target.Character then
            local part = target.Character:FindFirstChild(getgenv().Aether.Aimbot.Priority) or target.Character.HumanoidRootPart
            local screen = Camera:WorldToViewportPoint(part.Position)
            local delta = Vector2.new(screen.X, screen.Y) - Vector2.new(Mouse.X, Mouse.Y)
            mousemoverel(delta.X * getgenv().Aether.Aimbot.Smoothness, delta.Y * getgenv().Aether.Aimbot.Smoothness)
        end
    end
end)

--// FOV Circle
local FOV = Drawing.new("Circle")
FOV.Radius = 100
FOV.Color = Color3.fromRGB(255, 100, 100)
FOV.Thickness = 2
FOV.Filled = false
FOV.Transparency = 0.8

RunService.RenderStepped:Connect(function()
    FOV.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
    FOV.Radius = getgenv().Aether.Aimbot.FOV
    FOV.Visible = getgenv().Aether.Aimbot.Enabled
end)

--// ESP
local ESP = {}
local function AddESP(p)
    if ESP[p] or p == LocalPlayer then return end
    local box = Drawing.new("Square")
    local tracer = Drawing.new("Line")
    local name = Drawing.new("Text")
    local dist = Drawing.new("Text")
    local health = Drawing.new("Text")

    box.Thickness = 2; box.Filled = false; box.Color = Color3.new(0,1,0)
    tracer.Thickness = 1.5; tracer.Color = Color3.new(0,1,0)
    name.Size = 14; name.Center = true; name.Outline = true
    dist.Size = 13; dist.Center = true; dist.Outline = true
    health.Size = 13; health.Center = true; health.Outline = true

    ESP[p] = {box=box, tracer=tracer, name=name, dist=dist, health=health}
end

for _, p in ipairs(Players:GetPlayers()) do AddESP(p) end
Players.PlayerAdded:Connect(AddESP)

RunService.RenderStepped:Connect(function()
    for p, draw in pairs(ESP) do
        if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head") or root
            local hum = p.Character.Humanoid
            local pos, onscreen = Camera:WorldToViewportPoint(root.Position)
            local headpos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
            local legpos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3,0))
            local size = Vector2.new(2200 / pos.Z, headpos.Y - legpos.Y)
            local boxpos = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude

            draw.box.Size = size; draw.box.Position = boxpos; draw.box.Visible = getgenv().Aether.ESP.Box and onscreen
            draw.tracer.From = Vector2.new(Mouse.X, Camera.ViewportSize.Y); draw.tracer.To = Vector2.new(pos.X, pos.Y + 36); draw.tracer.Visible = getgenv().Aether.ESP.Tracer and onscreen
            draw.name.Text = p.DisplayName; draw.name.Position = Vector2.new(pos.X, headpos.Y - 20); draw.name.Visible = getgenv().Aether.ESP.Name and onscreen
            draw.dist.Text = math.floor(distance).."m"; draw.dist.Position = Vector2.new(pos.X, legpos.Y + 5); draw.dist.Visible = getgenv().Aether.ESP.Distance and onscreen
            draw.health.Text = math.floor(hum.Health).."/"..hum.MaxHealth; draw.health.Position = Vector2.new(boxpos.X - 30, boxpos.Y); draw.health.Visible = getgenv().Aether.ESP.Health and onscreen
            draw.health.Color = Color3.fromHSV((hum.Health/hum.MaxHealth)*0.33, 1, 1)
        else
            for _, v in pairs(draw) do v.Visible = false end
        end
    end
end)

--// UI CONTROLES
AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v) getgenv().Aether.Aimbot.Enabled = v end
})

AimbotTab:CreateSlider({
    Name = "Suavidad",
    Range = {0.05, 0.5},
    Increment = 0.01,
    CurrentValue = 0.15,
    Callback = function(v) getgenv().Aether.Aimbot.Smoothness = v end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 300},
    Increment = 5,
    CurrentValue = 100,
    Callback = function(v) getgenv().Aether.Aimbot.FOV = v end
})

AimbotTab:CreateDropdown({
    Name = "Prioridad",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = "Head",
    Callback = function(v) getgenv().Aether.Aimbot.Priority = v end
})

-- ESP Toggles
ESPTab:CreateToggle({ Name = "Box", CurrentValue = true, Callback = function(v) getgenv().Aether.ESP.Box = v end })
ESPTab:CreateToggle({ Name = "Tracer", CurrentValue = true, Callback = function(v) getgenv().Aether.ESP.Tracer = v end })
ESPTab:CreateToggle({ Name = "Nombre", CurrentValue = true, Callback = function(v) getgenv().Aether.ESP.Name = v end })
ESPTab:CreateToggle({ Name = "Distancia", CurrentValue = true, Callback = function(v) getgenv().Aether.ESP.Distance = v end })
ESPTab:CreateToggle({ Name = "Salud", CurrentValue = true, Callback = function(v) getgenv().Aether.ESP.Health = v end })

-- Others
OthersTab:CreateToggle({
    Name = "FPS Boost",
    CurrentValue = false,
    Callback = function(v)
        getgenv().Aether.Others.FPSBoost = v
        if v then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then v.Material = Enum.Material.SmoothPlastic; v.Reflectance = 0
                elseif v:IsA("Decal") then v.Transparency = 1 end
            end
        end
    end
})

OthersTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        getgenv().Aether.Others.InfJump = v
        if v then
            UserInputService.JumpRequest:Connect(function()
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end
})

OthersTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        if LocalPlayer.Character then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

OthersTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        getgenv().Aether.Others.Noclip = v
        if v then
            RunService.Stepped:Connect(function()
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        end
    end
})

Rayfield:Notify({
    Title = "Aether",
    Content = "Exploit cargado correctamente.",
    Duration = 5
})
