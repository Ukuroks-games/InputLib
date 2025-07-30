local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputLib = require(ReplicatedStorage.Packages.InputLib)

InputLib.WhileKeyPressed(
	function(InputObject: InputObject, a: boolean)
		print("Thumbstick position:", InputObject.Position)
	end,
	{
		Enum.KeyCode.Thumbstick1,
	}
)
