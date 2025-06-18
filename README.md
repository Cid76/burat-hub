-- Burat Hub: Dragon Blox Script (For Educational Use Only)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Settings
local autoTrain = true
local autoQuest = true
local autoCollectDragonBalls = true
local autoCollectAllDrops = true

-- Auto Train
task.spawn(function()
    while autoTrain do
        local punchRemote = player:FindFirstChild("Remotes") and player.Remotes:FindFirstChild("Train") and player.Remotes.Train:FindFirstChild("Punch")
        if punchRemote then
            punchRemote:FireServer()
        end
        task.wait(0.2)
    end
end)

-- Auto Quest
task.spawn(function()
    while autoQuest do
        for _, npc in ipairs(workspace:GetDescendants()) do
            if npc:IsA("Model") and npc:FindFirstChild("Quest") then
                local questRemote = player:FindFirstChild("Remotes") and player.Remotes:FindFirstChild("Quest") and player.Remotes.Quest:FindFirstChild("Start")
                if questRemote then
                    questRemote:FireServer(npc.Name)
                end
            end
        end
        task.wait(10)
    end
end)

-- Auto Collect Dragon Balls
task.spawn(function()
    while autoCollectDragonBalls do
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Part") and string.lower(item.Name):find("dragonball") then
                player.Character:MoveTo(item.Position)
                task.wait(0.5)
            end
        end
        task.wait(15)
    end
end)

-- Auto Collect ANY Dropped Items or Spawned Parts
task.spawn(function()
    while autoCollectAllDrops do
        for _, item in ipairs(workspace:GetDescendants()) do
            if item:IsA("Part") and item:IsDescendantOf(workspace) and item.Name ~= "Baseplate" then
                local magnitude = (player.Character.PrimaryPart.Position - item.Position).Magnitude
                if magnitude < 300 then -- only nearby items
                    player.Character:MoveTo(item.Position)
                    task.wait(0.4)
                end
            end
        end
        task.wait(10)
    end
end)

print("✅ Burat Hub Loaded (Auto Train, Quest, Dragon Ball, All Drops)")
