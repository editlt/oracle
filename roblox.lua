-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")
local ModeButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Toggle Button (Enable/Disable)
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 200, 0, 50)
ToggleButton.Position = UDim2.new(0.5, -100, 0, 100)
ToggleButton.Text = "Start Kill Loop"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 24

-- Mode Button (Single/All)
ModeButton.Parent = ScreenGui
ModeButton.Size = UDim2.new(0, 200, 0, 50)
ModeButton.Position = UDim2.new(0.5, -100, 0, 160)
ModeButton.Text = "Mode: Single Target"
ModeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeButton.Font = Enum.Font.SourceSans
ModeButton.TextSize = 24

-- Variables
local killLoop = false
local modeAllPlayers = false
local TargetUserId = 1159486467

-- Toggle Kill Loop
ToggleButton.MouseButton1Click:Connect(function()
    killLoop = not killLoop
    if killLoop then
        ToggleButton.Text = "Stop Kill Loop"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleButton.Text = "Start Kill Loop"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Switch Mode
ModeButton.MouseButton1Click:Connect(function()
    modeAllPlayers = not modeAllPlayers
    if modeAllPlayers then
        ModeButton.Text = "Mode: All Players"
        ModeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
    else
        ModeButton.Text = "Mode: Single Target"
        ModeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    end
end)

-- Kill Loop
task.spawn(function()
    while true do
        task.wait(1)
        if killLoop and game.ReplicatedStorage:FindFirstChild("CarbonResource") then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    if modeAllPlayers or player.UserId == TargetUserId then
                        game.ReplicatedStorage.CarbonResource.Events:GetChildren()[4]:FireServer(
                            player.Character.Humanoid,
                            100,
                            "Head",
                            {'nil', 'Auth', 'nil', 'nil'}
                        )
                    end
                end
            end
        end
    end
end)
