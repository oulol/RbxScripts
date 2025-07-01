-- Auto Summer Harvest script by oulol lolll

local ReplicatedStorage = game.ReplicatedStorage
local Events = ReplicatedStorage.GameEvents

local Player = game:GetService("Players").LocalPlayer

local Farm = nil
for _, LFarm in workspace.Farm:GetChildren() do
    if LFarm:GetAttribute("Loaded") and LFarm.Important.Data.Owner.Value == Player.Name then
        Farm = LFarm.Important
        break
    end
end

firesignal(Events.Notification.OnClientEvent,
    "Farm detected"
)

local CFB = nil
function TpTo(CF)
    Player.Character.HumanoidRootPart.Anchored = true
    CFB = Player.Character.HumanoidRootPart.CFrame
    Player.Character.HumanoidRootPart.CFrame = CF
    task.wait(0.01)
end

function TpRb()
    task.wait(0.01)
    Player.Character.HumanoidRootPart.CFrame = CFB
    Player.Character.HumanoidRootPart.Anchored = false
end

function Buy(Amount)
    firesignal(Events.Notification.OnClientEvent,
        "Buy sent"
    )

    for I=1,Amount do
        Events.BuySeedStock:FireServer("Tomato")
    end
end

function Harvest(Amount)
    local Harvested = 0
    for _, Plant in Farm.Plants_Physical:GetChildren() do
        for __, Fruit in Plant.Fruits:GetChildren() do
            for ___, Desc in Fruit:GetDescendants() do
                print(Desc.ClassName)
                if Desc:IsA("ProximityPrompt") and Desc.Enabled then
                    TpTo(CFrame.new(Desc.Parent.Position))
                    task.wait()
                    fireproximityprompt(Desc)
                    Harvested += 1
                    break
                end
            end
            if Harvested == Amount then
                TpRb()
                return true
            end
        end
    end

    TpRb()
    return false
end

function Plant(Amount)
    local Item = nil
    local RealAmount = 0
    for I=1,999 do
        RealAmount = I
        if Player.Backpack:FindFirstChild("Tomato Seed [X"..I.."]") then
            Item = Player.Backpack:FindFirstChild("Tomato Seed [X"..I.."]")
            break
        end
    end

    if Item == nil then
        return
    end

    if Amount > RealAmount then
        Amount = RealAmount
    end

    Player.Character.Humanoid:EquipTool(Item)
    task.wait(0.1)

    for I=1,Amount do
        local Locations = Farm.Plant_Locations:GetChildren()
        local Location = Locations[math.random(1, #Locations)]
        local Size = Location.Size
        local Pos = Vector3.new(
            Location.Position.x + math.random(-Size.x / 2, Size.x / 2),
            0,
            Location.Position.z + math.random(-Size.z / 2, Size.z / 2)
        )
        TpTo(CFrame.new(Pos))
        Events.Plant_RE:FireServer(Pos, "Tomato")
        TpRb()
        task.wait(0.5)
    end

    task.wait(0.1)
    Player.Character.Humanoid:UnequipTools()
end

function GiveAll()
    Events.SummerHarvestRemoteEvent:FireServer("SubmitAllPlants")
end

function StartsWith(Str, Start)
    return Str:sub(1, #Start) == Start
end

function AmountInInv()
    local Amount = 0
    for _, Item in Player.Backpack:GetChildren() do
        if StartsWith(Item.Name, "Tomato") then
            Amount += 1
        end
    end

    return Amount
end

local summer = false

task.spawn(function()
    while task.wait(1) do
        local date = os.date("*t")
        summer = (date.min < 10)
    end
end)

task.spawn(function()
    while true do
        Buy(3)
        task.wait(10)
    end
end)

while true do
    if summer then
        Harvest(10)
        GiveAll()
        task.wait(0.2)
    else
        Plant(999)
        task.wait(1)
        if AmountInInv() < 140 then
            Harvest(10)
        end
    end
end

-- loadstring(game:HttpGet("https://raw.githubusercontent.com/oulol/RbxScripts/refs/heads/main/GAGBot.lua"))()
