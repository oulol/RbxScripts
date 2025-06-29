local Player = game.Players.LocalPlayer
local Character = Player.Character

local ShowHitboxes = true

task.spawn(function()
  while task.wait(1) do
    if not ShowHitboxes then
      for _, Plot in workspace.Plots:GetChildren() do
        Plot.StealHitbox.Transparency = 1
        Plot.DeliveryHitbox.Transparency = 1
      end
    else
      for _, Plot in workspace.Plots:GetChildren() do
        Plot.StealHitbox.Transparency = 0.8
        Plot.StealHitbox.Color3 = Color3.new(1, 0, 0)
        Plot.DeliveryHitbox.Transparency = 0.8
        Plot.DeliveryHitbox.Color3 = Color3.new(0, 1, 0)
      end
    end
  end
end)
