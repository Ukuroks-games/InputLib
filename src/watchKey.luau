local UserInputService = game:GetService("UserInputService")

--[[
	Watch to keys state.

	while one of keys pressed BollValue.Value is true, where it unpressed Value is false.

	returned connections destroying automatically, but if you wanna to disconnect them, you must just disconnect all connections in table
]]
return function(Keys: { Enum.KeyCode }): (BoolValue, { RBXScriptConnection })
	local pressed = Instance.new("BoolValue")

	local b = UserInputService.InputBegan:Connect(
		function(input: InputObject, _: boolean)
			if table.find(Keys, input.KeyCode) then
				pressed.Value = true
			end
		end
	)

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

	return pressed, { b, e, d }
end
