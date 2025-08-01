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


function GetItems(Mutation)
	local Items = {}
	for _, Item in Player.Backpack:GetChildren() do
		if Item:GetAttribute("f") == "Tomato" and Item:GetAttribute(Mutation) then
			print(table.unpack(Item:GetAttributes()))
			table.insert(Items, Item)
		end
	end
	
	print(Mutation, #Items)
	
	return Items
end

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

function Gift(OPlayer: Player, Amount, Mutation)
	if not OPlayer.Character:FindFirstChild("HumanoidRootPart") or not OPlayer.Character.HumanoidRootPart:FindFirstChild("ProximityPrompt") then
		return
	end
	
	local Items = GetItems(Mutation)
	if #Items == 0 then
		Say("No " .. Mutation .. " items in stock.")
		return
	end
	
	TpTo(OPlayer.Character:GetPivot())
	local Timeout = 0
	for I=1,Amount do
		local Item = Items[I]
		if not Item then Say("Error.") continue end
		Timeout = 0
		Player.Character.Humanoid:EquipTool(Item)
		task.wait(0.2)
		for I=1,5 do
			fireproximityprompt(OPlayer.Character.HumanoidRootPart.ProximityPrompt)
			task.wait(0.1)
		end
		repeat task.wait(0.1) Timeout += 0.1 until Item.Parent ~= Player.Character or Timeout >= 30
		if Timeout >= 30 then
			break
		end
	end
	Player.Character.Humanoid:UnequipTools()
	if Timeout >= 30 then
		Say("Trade timeout.")
	else
		Say("Trade finished.")
	end
	TpRb()
end

function Harvest(Amount, Mutation)
	local Harvested = 0
	for _, Plant in Farm.Plants_Physical:GetChildren() do
		for __, Fruit: Model in Plant.Fruits:GetChildren() do
			if not Fruit:GetAttribute(Mutation) then continue end
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

local Conns = {}
local Channel: TextChannel = game:GetService("TextChatService").TextChannels.RBXGeneral

function Say(Text: string)
	Channel:SendAsync(Text, "")
end

function ChatCb(Msg, Plr)
	local MsgS = string.split(Msg, " ")
	if Msg == ".stop" then
		for _, Conn in Conns do
			Say("Stopping.")
			Conn:Disconnect()
		end
	elseif Msg == ".stock" then
		local T = 0
		local C = 0
		for _, Plant in Farm.Plants_Physical:GetChildren() do
			for __, Fruit: Model in Plant.Fruits:GetChildren() do
				if Fruit:GetAttribute("Tranquil") then
					T += 1
				end

				if Fruit:GetAttribute("Corrupt") then
					C += 1
				end
			end
		end

		T += #GetItems("Tranquil")
		C += #GetItems("Corrupt")

		Say("Tranquil: " .. T .. "; Corrupt: " .. C)
	elseif MsgS[1] == ".give" then
		local Mutation = MsgS[2]
		local Amount = tonumber(MsgS[3])
		local InInventory = GetItems(Mutation)
		Say("Working...")
		if #InInventory < Amount then
			Harvest(Amount - #InInventory, Mutation)
			repeat task.wait() InInventory = GetItems(Mutation) until #InInventory >= Amount
		end
		Gift(Plr, Amount, Mutation)
	end
end

Conns[#Conns + 1] = game.Players.PlayerAdded:Connect(function(Plr)
	Conns[#Conns + 1] = Plr.Chatted:Connect(function(Msg, Rep)
		ChatCb(Msg, Plr)
	end)
end)

for _, Plr in game.Players:GetPlayers() do
	Conns[#Conns + 1] = Plr.Chatted:Connect(function(Msg, Rep)
		ChatCb(Msg, Plr)
	end)
end

Say("Started.")
