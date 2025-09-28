local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InputLib = require(ReplicatedStorage.Packages.InputLib)


local e = InputLib.OnUserInput({Enum.UserInputType.Keyboard})

e.Event:Connect(function( any)  
	print("Keyboard input")
end)