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
HealthBarMain.BackgroundColor3=Color3.new(0.7,0.7,0.7)
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

-- Player List --
game.CoreGui.PlayerList.PlayerListMaster.OffsetFrame.PlayerScrollList.Visible=false
List = Instance.new("ScrollingFrame",game.CoreGui.PlayerList.PlayerListMaster.OffsetFrame)
List.Size=UDim2.new(0,300,0,350)
List.Position=UDim2.new(1,-314,0,4)
List.BackgroundTransparency=1
List.BorderSizePixel=0
List.ScrollBarThickness=2

function UpdateList()
    if List:FindFirstChild("CurrentList") then List.CurrentList:Destroy() end
	List.CanvasSize=UDim2.new(0,0,0,#game:GetService("Players"):GetPlayers() * 27)
    local NewFrame = Instance.new("Frame",List)
    local Stats
    local ListScore
    if game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats") then Stats = true else Stats = false end
	NewFrame.Visible=false
    local Additional = 0
    if Stats then
        Additional = 70 * #game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):GetChildren()
        if game:GetService("Players").LocalPlayer.leaderstats:FindFirstChildOfClass("IntValue") then ListScore = game:GetService("Players").LocalPlayer.leaderstats:FindFirstChildOfClass("IntValue").Name end
    end
	NewFrame.Size=UDim2.new(0,200+Additional,1,0)
    NewFrame.Position=UDim2.new(1,-200-Additional,0,0)
    NewFrame.BorderSizePixel=0
    NewFrame.BackgroundTransparency=1
    NewFrame.Name="CurrentList"
    Layout=Instance.new("UIListLayout",NewFrame)
    Layout.FillDirection="Vertical"
    Layout.Name="Layout"
    Layout.SortOrder="LayoutOrder"
    Layout.Padding=UDim.new(0,2)
    PlrFrame = Instance.new("Frame",NewFrame)
    PlrFrame.BackgroundTransparency=1
    PlrFrame.Name="FrameBase"
    PlrFrame.Size=UDim2.new(1,0,0,25)
    PlrFrame.BorderSizePixel=0
    PlrFrame.Visible=false
    PlrFrameLayout = Instance.new("UIListLayout",PlrFrame)
    PlrFrameLayout.FillDirection="Horizontal"
    PlrFrameLayout.Name="Layout"
    PlrFrameLayout.SortOrder="LayoutOrder"
    PlrFrameLayout.Padding=UDim.new(0,2)
    PlrFrameLayout.HorizontalAlignment="Right"
    PlrFrameNull = Instance.new("Frame",PlrFrame)
    PlrFrameNull.BackgroundTransparency=1
    PlrFrameNull.Size=UDim2.new(0,1,1,0)
    PlrFrameNull.LayoutOrder=9999999
    PlrNameFrame = Instance.new("TextLabel",PlrFrame)
    PlrNameFrame.Name="Plr"
    PlrNameFrame.BackgroundTransparency=0.6
    PlrNameFrame.BackgroundColor3=Color3.new(0,0,0)
    PlrNameFrame.Size=UDim2.new(0,168,1,0)
    PlrNameFrame.LayoutOrder=-9999999
    PlrNameFrame.TextColor3=Color3.new(1,1,1)
    PlrNameFrame.Text=""
    PlrNameFrame.BorderSizePixel=0
    if Stats then
        for i,Stat in pairs(game:GetService("Players").LocalPlayer:FindFirstChild("leaderstats"):GetChildren()) do
            local Frame = Instance.new("TextLabel",PlrFrame)
            Frame.Size=UDim2.new(0,62,1,0)
            Frame.LayoutOrder=i
            Frame.BackgroundTransparency=0.6
            Frame.BackgroundColor3=Color3.new(0,0,0)
            Frame.BorderSizePixel=0
            Frame.Name="Stat_"..Stat.Name
            Frame.TextColor3=Color3.new(1,1,1)
            Frame.Text=""
        end
    end
    for i,Plr in pairs(game:GetService("Players"):GetPlayers()) do
        local Frame = PlrFrame:Clone()
        Frame.Parent=NewFrame
        Frame.Plr.Text = Plr.Name
        Frame.Name=Plr.Name
        Frame.Visible=true
        if Stats then
            for i,Stat in pairs(Plr.leaderstats:GetChildren()) do
                Frame["Stat_"..Stat.Name].Text=Stat.Value
            end
            Frame.LayoutOrder=Plr.leaderstats[ListScore].Value * -1
        end
    end
    NewFrame.Visible=true
end

task.spawn(function()
    while task.wait(0.1) do
        UpdateList()
    end
end)
