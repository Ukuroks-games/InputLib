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
	callback: (InputObject: InputObject, boolean) -> any?,
	Keys: { Enum.KeyCode }
): WhileKeyPressedController
	local input = {} :: { InputObject: InputObject?, a: boolean? }
	local pressed, connections = watchKey(Keys, input)
	local CalledEvent = Instance.new("BindableEvent")

	table.insert(
		connections,
		pressed.Changed:Connect(function(_: boolean)
			while pressed.Value do
				CalledEvent:Fire()
				callback(input.InputObject, input.a)
				task.wait() -- для того что бы всё не зависло нах
			end
		end)
	)

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

			pressed:Destroy()
			CalledEvent:Destroy()
			DestroyingEvent:Destroy()
		end,
	}
end
