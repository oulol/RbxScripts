local ReplicatedStorage = game.ReplicatedStorage
local Events = ReplicatedStorage.GameEvents

local Player = game:GetService("Players").LocalPlayer

local Farm = nil

repeat
  for _, LFarm in workspace.Farm:GetChildren() do
      if LFarm:GetAttribute("Loaded") and LFarm.Important.Data.Owner.Value == Player.Name then
          Farm = LFarm.Important
          break
      end
  end
  task.wait()
until Farm ~= nil

function Notify(text)
    print("FARM -", text)
end


Notify("Script started")
local TpBusy = false
local CFB = nil
function TpTo(CF)
    CFB = Player.Character.HumanoidRootPart.CFrame
    task.wait()
    Player.Character.HumanoidRootPart.CFrame = CF
    task.wait(0.01)
end

function TpRb()
    task.wait(0.01)
    Player.Character.HumanoidRootPart.CFrame = CFB
end

function Buy(Amount)
    for I=1,Amount do
        Events.BuySeedStock:FireServer("Tomato")
    end
end

function Harvest(Amount)
    Notify("Harvesting")
    local Harvested = 0
    for _, Plant in Farm.Plants_Physical:GetChildren() do
        for __, Fruit in Plant.Fruits:GetChildren() do
            for ___, Desc in Fruit:GetDescendants() do
                if Desc:IsA("ProximityPrompt") and Desc.Enabled then
                    ReplicatedStorage.ByteNetReliable:FireServer(buffer.fromstring("\001\001\000\001"), {Fruit})
                    Harvested += 1
                    break
                end
            end
            if Harvested == Amount then
                return true
            end
        end
    end

    return false
end

function Plant(Amount)
    Notify("Planting")
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
        task.wait(0.1)
    end

    task.wait(0.1)
    Player.Character.Humanoid:UnequipTools()
end

function SellAll()
    Events.Sell_Inventory:FireServer()
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

local Queue = {}

workspace.ChildAdded:Connect(function(Obj)
    if Obj:IsA("Model") and Obj:GetAttribute("OWNER") == Player.Name then
        table.insert(Queue, Obj)
        Notify("Queued seed pickup")
        task.wait(0.1)
    end
end)


task.spawn(function()
    while true do
        Buy(3)
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        TpBusy = true
        for _, Seed in Queue do
            Notify("Picking a seed up")
            TpTo(Seed:GetPivot())
            repeat task.wait() until Seed.Parent ~= workspace
            TpRb()
        end
        TpBusy = false
        Queue = {}
        task.wait(1)
    end
end)

TpTo(workspace.NPCS.Steven:GetPivot())

while true do
    Plant(999)
    task.wait(1)
    Harvest(25)
    task.wait(0.2)
    if TpBusy then
        continue
    end
    SellAll()
    task.wait(0.2)
end
