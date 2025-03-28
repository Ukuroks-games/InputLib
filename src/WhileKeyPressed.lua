local UserInputService = game:GetService("UserInputService")

export type WhileKeyPressedController = {
	Destroying: RBXScriptSignal,
	Destroy: () -> nil
}

--[[

]]
return function (callback: () -> any, Keys: { Enum.KeyCode }): WhileKeyPressedController
	local pressed = Instance.new("BoolValue")

	local b = UserInputService.InputBegan:Connect(function(input: InputObject, a1: boolean) 
		if table.find(Keys, input.KeyCode) then
			pressed.Value = true
		end
	end)

	local e = UserInputService.InputEnded:Connect(function(input: InputObject, a1: boolean) 
		if table.find(Keys, input.KeyCode) then
			pressed.Value = false
		end
	end)

	local c = pressed.Changed:Connect(function(a0: boolean) 
		while pressed.Value do
			callback()
			wait()	-- для того чтоб всё не зависло нах
		end
	end)


	local DestroyingEvent = Instance.new("BindableEvent")

	return {
		Destroying = DestroyingEvent.Event,
		Destroy = function()
			DestroyingEvent:Fire()

			b:Disconnect()
			e:Disconnect()
			c:Disconnect()

			pressed:Destroy()
			DestroyingEvent:Destroy()

		end
	}
end
