local UserInputService = game:GetService("UserInputService")

--[[
	Watch to keys state.

	while one of keys pressed BollValue.Value is true, where it unpressed Value is false.

	returned connections destroying automatically, but if you wanna to disconnect them, you must just disconnect all connections in table
]]
return function(
	Keys: { Enum.KeyCode },
	Input: { InputObject: InputObject?, a: boolean? }?
): (BoolValue, { RBXScriptConnection })
	local pressed = Instance.new("BoolValue")

	local function InputF(input: InputObject, a: boolean)
		if table.find(Keys, input.KeyCode) then
			if Input then
				Input.InputObject = input
				Input.a = a
			end
			pressed.Value = true
		end
	end

	local b = UserInputService.InputBegan:Connect(InputF)
	local f = UserInputService.InputChanged:Connect(InputF)

	local e = UserInputService.InputEnded:Connect(
		function(input: InputObject, _: boolean)
			if table.find(Keys, input.KeyCode) then
				pressed.Value = false
			end
		end
	)

	local d = pressed.Destroying:Connect(function(_: any)
		b:Disconnect()
		e:Disconnect()
	end)

	return pressed, { b, e, d, f }
end
