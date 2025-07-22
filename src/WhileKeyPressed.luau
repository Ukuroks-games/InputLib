local watchKey = require(script.Parent.watchKey)

export type WhileKeyPressedController = {
	--[[
		Current keys state
	]]
	State: BoolValue,
	--[[
		Fire where function called
	]]
	Called: RBXScriptSignal,
	Destroying: RBXScriptSignal,
	Destroy: () -> nil,
}

--[[
	Call function while key pressed
]]
return function(
	callback: () -> any,
	Keys: { Enum.KeyCode }
): WhileKeyPressedController
	local pressed, connections = watchKey(Keys)
	local CalledEvent = Instance.new("BindableEvent")

	local c = pressed.Changed:Connect(function(_: boolean)
		while pressed.Value do
			CalledEvent:Fire()
			callback()
			task.wait() -- для того что бы всё не зависло нах
		end
	end)

	local DestroyingEvent = Instance.new("BindableEvent")

	return {
		State = pressed,
		Destroying = DestroyingEvent.Event,
		Called = CalledEvent.Event,
		Destroy = function()
			DestroyingEvent:Fire()

			for _, v in pairs(connections) do
				if v then
					v:Disconnect()
				end
			end

			c:Disconnect()

			pressed:Destroy()
			CalledEvent:Destroy()
			DestroyingEvent:Destroy()
		end,
	}
end
