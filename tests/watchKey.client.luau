local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputLib = require(ReplicatedStorage.Packages.InputLib)

local Frame = Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui").KeyState

local State = InputLib.watchKey({ Enum.KeyCode.A })

State.Changed:Connect(function(_: boolean)
	Frame.Text = '"A" press state: ' .. tostring(State.Value)
end)
