local Player = game.Players.LocalPlayer
local Character = Player.Character

local BypassLasers = true

task.spawn(function()
  while task.wait(1) do
    if not BypassLasers then
      continue
    end
    for _, Plot in workspace.Plots:GetChildren() do
        if Plot:FindFirstChild("LaserHitbox") then
          Plot.LaserHitbox:Destroy()
        end
    end
  end
end)
