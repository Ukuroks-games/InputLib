local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputLib = require(ReplicatedStorage.Packages.InputLib)

local controller = InputLib.WhileKeyPressed(function(InputObject: InputObject)
	print("Thumbstick position:", InputObject.Position)
end, {
	Enum.KeyCode.Thumbstick1,
})

while wait(5) do
	print("pause")
	controller.Pause()
	wait(5)
	print("resume")
	controller.Resume()
end
