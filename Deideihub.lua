-- Deidei Hub – Full GUI for Dragon Blox
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local replicated = game:GetService("ReplicatedStorage")

local remotes = {
    punch = replicated:FindFirstChild("ToggleItemRequest"),
    rebirth = replicated:FindFirstChild("UpdateItems"),
    collect = replicated:FindFirstChild("ClaimItem"),
    fly = replicated:FindFirstChild("Flight"),
    quest = replicated:FindFirstChild("SendQuest"),
    zeni = replicated:FindFirstChild("ClaimZeni"),
    exp = replicated:FindFirstChild("ClaimEXP"),
    skill = replicated:FindFirstChild("Skill_Charging"),
}

local toggles = {
    train = false,
    quest = false,
    rebirth = false,
    mobs = false,
    boss = false,
    dragonball = false,
    zeni = false,
    exp = false
}

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DeideiHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2

local title = Instance.new("TextLabel", frame)
title.Text = "⚔️ Deidei Hub"
title.Size = UDim2.new(1, 0, 0, 35)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

-- Toggle Button Creator
local function createToggle(text, field)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextScaled = true
    btn.Text = text .. ": OFF"
    btn.MouseButton1Click:Connect(function()
        toggles[field] = not toggles[field]
        btn.Text = text .. ": " .. (toggles[field] and "ON" or "OFF")
        btn.BackgroundColor3 = toggles[field] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

-- NPC Teleport Button
local function createTeleportButton(npcName)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Text = "Teleport to " .. npcName
    btn.Font = Enum.Font.SourceSans
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    btn.MouseButton1Click:Connect(function()
        local npc = workspace:FindFirstChild(npcName)
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            character:MoveTo(npc.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
        end
    end)
end

-- Add Toggles
createToggle("Auto Train", "train")
createToggle("Auto Quest", "quest")
createToggle("Auto Rebirth", "rebirth")
createToggle("Auto Kill Mobs", "mobs")
createToggle("Auto Boss Mobs", "boss")
createToggle("Auto Dragon Ball", "dragonball")
createToggle("Auto Collect Zeni", "zeni")
createToggle("Auto Collect EXP", "exp")

-- Add Teleports
createTeleportButton("Mark")
createTeleportButton("Goku")
createTeleportButton("Vegeta")
createTeleportButton("Beerus")

-- Anti-AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Main Automation Loop
task.spawn(function()
    while task.wait(0.5) do
        if toggles.train and remotes.skill then
            remotes.skill:FireServer()
        end
        if toggles.rebirth and remotes.rebirth then
            remotes.rebirth:FireServer()
        end
        if toggles.quest and remotes.quest then
            remotes.quest:FireServer("Bandit Quest") -- Replace if needed
        end
        if toggles.dragonball and remotes.punch then
            remotes.punch:FireServer("DragonBall")
        end
        if toggles.zeni and remotes.zeni then
            remotes.zeni:FireServer()
        end
        if toggles.exp and remotes.exp then
            remotes.exp:FireServer()
        end
        if (toggles.mobs or toggles.boss) and character then
            for _, mob in pairs(workspace:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
                    local name = mob.Name:lower()
                    if toggles.boss and not name:find("boss") then continue end
                    if toggles.mobs and name:find("boss") then continue end
                    character:MoveTo(mob.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
                    break
                end
            end
        end
    end
end)
