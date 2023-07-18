-- TopBar --
local TopBar = game.CoreGui.TopBarApp.TopBarFrame
game.CoreGui.TopBarApp.LegacyCloseMenu.Position=UDim2.new(0,10,0,0)
TopBar.BackgroundColor3=Color3.new(0,0,0)
TopBar.BackgroundTransparency=0.6
TopBar.RightFrame.MoreMenu.Visible=false
TopBar.RightFrame.HealthBar.HealthBar.Visible=false
TopBar.LeftFrame.Position=UDim2.new(0,10,0,-2)
TopBar.LeftFrame.MenuIcon.Background.ImageTransparency=1
TopBar.LeftFrame.MenuIcon.Background.StateOverlay.Image=""
TopBar.LeftFrame.ChatIcon.Background.ImageTransparency=1
TopBar.LeftFrame.ChatIcon.Background.StateOverlay.Image=""

TopBar.RightFrame.Layout.Padding=UDim.new(0,0)
local Health=Instance.new("Frame",TopBar.RightFrame)
Health.Name="PlrHealth"
Health.Size=UDim2.new(0,175,1,0)
Health.BackgroundTransparency=1
local Name=Instance.new("TextLabel",Health)
Name.Name="PlayerName"
Name.Text=game:GetService("Players").LocalPlayer.Name
Name.Size=UDim2.new(0.8,0,0.7,0)
Name.Position=UDim2.new(0,0,0,1)
Name.TextSize=9
Name.TextXAlignment="Left"
Name.TextColor3=Color3.new(1,1,1)
Name.BackgroundTransparency=1
local HealthBarMain=Instance.new("Frame",Health)
HealthBarMain.Size=UDim2.new(0.9,0,0,3)
HealthBarMain.Name="HealthBar"
HealthBarMain.Position=UDim2.new(0,0,0.75,0)
HealthBarMain.BackgroundTransparency=1
HealthBarMain.BorderSizePixel=0
local HealthBar=Instance.new("Frame",HealthBarMain)
HealthBar.Size=UDim2.new(1,0,1,0)
HealthBar.BorderSizePixel=0
HealthBar.Name="Color"
task.spawn(function()
    while task.wait() do
        HealthBar.BackgroundColor3=TopBar.RightFrame.HealthBar.HealthBar.Fill.ImageColor3
        repeat task.wait() until game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid")
        local Hmnd=game:GetService("Players").LocalPlayer.Character.Humanoid
        if Hmnd.Health >= Hmnd.MaxHealth then
            HealthBar.BackgroundTransparency=1
            HealthBarMain.BackgroundTransparency=1
        else
            HealthBar.BackgroundTransparency=0
            HealthBarMain.BackgroundTransparency=0
            local PPH=1/Hmnd.MaxHealth
            HealthBar.Size=UDim2.new(PPH*Hmnd.Health,0,1,0)
        end
    end
end)
if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") then
    for i,Stat in pairs(game:GetService("Players").LocalPlayer.leaderstats:GetChildren()) do
        local CStat=Instance.new("Frame",TopBar.RightFrame)
        CStat.Size=UDim2.new(0,64,1,0)
        CStat.Name="Stat_"..Stat.name
        CStat.BackgroundTransparency=1
        local StatN=Instance.new("TextLabel",CStat)
        StatN.Size=UDim2.new(1,0,0,20)
        StatN.TextColor3=Color3.new(1,1,1)
        StatN.Position=UDim2.new(0,0,0,1)
        StatN.BackgroundTransparency=1
        StatN.Name="StatLabel"
        StatN.Text=Stat.Name
        local Label=Instance.new("TextLabel",CStat)
        Label.Size=UDim2.new(1,0,0,20)
        Label.TextColor3=Color3.new(1,1,1)
        Label.Position=UDim2.new(0,0,0,17)
        Label.BackgroundTransparency=1
        Label.Name="StatVal"
        Label.RichText=true
        Label.Text="<b>"..tostring(Stat.Value).."</b>"
        Stat.Changed:Connect(function(Val)
            Label.Text=Val
        end)
    end
end
