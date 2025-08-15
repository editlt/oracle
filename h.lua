-- Create ScreenGui that stays after death
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KillPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main draggable frame
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0.5, -110, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

-- Toggle Kill Loop button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(1, -20, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.Text = "Start Kill Loop"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.TextSize = 20

-- Mode button
local ModeButton = Instance.new("TextButton")
ModeButton.Parent = Frame
ModeButton.Size = UDim2.new(1, -20, 0, 40)
ModeButton.Position = UDim2.new(0, 10, 0, 60)
ModeButton.Text = "Mode: Single Target"
ModeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
ModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ModeButton.Font = Enum.Font.SourceSans
ModeButton.TextSize = 20

-- UserId input box (only used for single target mode)
local UserIdBox = Instance.new("TextBox")
UserIdBox.Parent = Frame
UserIdBox.Size = UDim2.new(1, -20, 0, 30)
UserIdBox.Position = UDim2.new(0, 10, 0, 110)
UserIdBox.PlaceholderText = "Enter UserId"
UserIdBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
UserIdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
UserIdBox.Font = Enum.Font.SourceSans
UserIdBox.TextSize = 18
UserIdBox.Text = ""

-- Variables
local killLoop = false
local modeAllPlayers = false
local TargetUserId = 1159486467

-- Button functions
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

ModeButton.MouseButton1Click:Connect(function()
    modeAllPlayers = not modeAllPlayers
    if modeAllPlayers then
        ModeButton.Text = "Mode: All Players"
        ModeButton.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
        UserIdBox.Visible = false
    else
        ModeButton.Text = "Mode: Single Target"
        ModeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
        UserIdBox.Visible = true
    end
end)

UserIdBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(UserIdBox.Text)
        if num then
            TargetUserId = num
            print("Target UserId set to:", TargetUserId)
        else
            print("Invalid UserId entered!")
        end
    end
end)

-- Kill loop
task.spawn(function()
    while true do
        task.wait(1)
        if killLoop and game.ReplicatedStorage:FindFirstChild("CarbonResource") then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    if modeAllPlayers or player.UserId == TargetUserId then
                        game.ReplicatedStorage.CarbonResource.Events:GetChildren()[4]:FireServer(
                            player.Character.Humanoid,
                            math.huge,
                            "Head",
                            {'nil', 'Auth', 'nil', 'nil'}
                        )
                    end
                end
            end
        end
    end
end)
