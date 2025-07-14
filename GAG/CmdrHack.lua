local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
print("Executing UserID bypass")

local originalReq = clonefunction(require)

local function hook(Module)
	print(Module:GetFullName())
	if Module.Name == "IsCommandAuthorized" then
		return function(...) return true end
	end
	return originalReq(Module)
end

local duhReq = hookfunction(require, hook)

--[[for _, Name in {"AuthorizedUsers", "AuthorizedUsersDevGame", "AuthorizedUsersLiveGame"} do
	if ReplicatedStorage.Data:FindFirstChild(Name) then ReplicatedStorage.Data[Name]:Destroy() end
	local Module = Instance.new("ModuleScript")
	Module.Name = Name
	Module.Source = "return {1,2,3,4,5}"
	Module.Parent = ReplicatedStorage.Data
	print(require(Module))
end]]
print("Executing CMDR")



--local EnableCommandUI = game:GetService("ReplicatedFirst").EnableCommandUI
local Icon = originalReq(ReplicatedStorage.Modules.Icon)
local ModernInputNotificationUserInterfaceService = originalReq(ReplicatedStorage.Modules.ModernInputNotificationUserInterfaceService)
local UserInputService = game:GetService("UserInputService")
task.spawn(function() -- Line 15
	local cmdr = originalReq(ReplicatedStorage:WaitForChild("CmdrClient"))
	if true then -- EnableCommandUI.Value then
		local icon = Icon.new()
		icon:setName("CMDR")
		icon:setOrder(5)
		icon:setLabel("CMDR")
		icon:align("Right")
		icon:setCaption("Toggle the admin console.")
		icon.deselectWhenOtherIconSelected = false

		ModernInputNotificationUserInterfaceService:CreateNotification({
			Text = "You have access to the developer command console! Press [F2] to toggle!",
			Icon = "rbxassetid://0",
			EnabledComponents = {
				OptionSet = true,
				Confirm = true,
				Decline = false,
				IconSet = true
			},
			Lifetime = 3
		})
		local enabled = false
		UserInputService.InputEnded:Connect(function(key) -- Line 59
			if UserInputService:GetFocusedTextBox() then return end
			if key.KeyCode ~= Enum.KeyCode.F2 then return end

			enabled = not enabled

			if enabled then
				icon:select()
			else
				icon:deselect()
			end
		end)

		icon.selected:Connect(function(arg1) -- Line 72
			cmdr:Show()
		end)

		icon.deselected:Connect(function(arg1) -- Line 76
			cmdr:Hide()
		end)
	end
	cmdr:SetActivationKeys({Enum.KeyCode.F2})
end)
