-- FE Rain script
-- Hats required: Any

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local DropsSpeed = 100
local AutoSpeed = false

RunService.Heartbeat:Connect(function()
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("Accessory") then
            v.Handle.Velocity = Vector3.new(0,-DropsSpeed,0)
        end
    end
end)

local MainControl = Instance.new("ScreenGui",LocalPlayer.PlayerGui)
local Frame = Instance.new("Frame",MainControl)
local ButtonAuto = Instance.new("TextButton",Frame)
local ButtonPlus = Instance.new("TextButton",Frame)
local ButtonMinus = Instance.new("TextButton",Frame)
local Current = Instance.new("TextLabel",Frame)

Frame.Size=UDim2.new(0,32,0,128)
Frame.Position=UDim2.new(0,0,1,-128)
Frame.BackgroundColor3=Color3.new(0,0,0)
Frame.BackgroundTransparency=0.6

ButtonAuto.Size=UDim2.new(0,32,0,32)
ButtonAuto.BackgroundTransparency=1
ButtonAuto.TextColor3=Color3.new(1,1,1)
ButtonAuto.Text="A"

ButtonPlus.Size=UDim2.new(0,32,0,32)
ButtonPlus.Position=UDim2.new(0,0,0,32)
ButtonPlus.BackgroundTransparency=1
ButtonPlus.TextColor3=Color3.new(1,1,1)
ButtonPlus.Text="+"
ButtonPlus.MouseButton1Click:Connect(function() DropsSpeed = DropsSpeed + 1 end)

ButtonMinus.Size=UDim2.new(0,32,0,32)
ButtonMinus.Position=UDim2.new(0,0,0,98)
ButtonMinus.BackgroundTransparency=1
ButtonMinus.TextColor3=Color3.new(1,1,1)
ButtonMinus.Text="-"
ButtonMinus.MouseButton1Click:Connect(function() DropsSpeed = DropsSpeed - 1 end)

Current.Size=UDim2.new(0,32,0,32)
Current.Position=UDim2.new(0,0,0,64)
Current.BackgroundTransparency=1
Current.TextColor3=Color3.new(1,1,1)
Current.Text=DropsSpeed
spawn(function() while wait() do Current.Text=DropsSpeed end end)

for i,P in pairs(Character:GetChildren()) do
    if P:IsA("Accessory") then
        local Handle = P:FindFirstChildOfClass("Part")
        Handle.AccessoryWeld:Destroy()
        pcall(function() Handle.Mesh:Destroy() end)
        pcall(function() Handle.SpecialMesh:Destroy() end)
        Handle.Touched:Connect(function()
            local RandomPlayer = Players:GetPlayers()[math.random(1,#Players:GetPlayers())]
            while not RandomPlayer.Character:FindFirstChild("HumanoidRootPart") do RandomPlayer = Players:GetPlayers()[math.random(1,#Players:GetPlayers())] wait() end
            Handle.CFrame = CFrame.new(Vector3.new(RandomPlayer.Character.HumanoidRootPart.Position.X+math.random(-20,20),Character.Head.Position.Y+math.random(30,200),RandomPlayer.Character.HumanoidRootPart.Position.Z+math.random(-20,20)))
        end)
    end
end
