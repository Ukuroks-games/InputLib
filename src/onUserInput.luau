--!strict

local UserInputService = game:GetService("UserInputService")

return function(
	type: { Enum.UserInputType },
	state: { Enum.UserInputState },
	callback: ((a: boolean, b: boolean) -> boolean)?
): BindableEvent
	local event = Instance.new("BindableEvent")

	local c = callback
		or function(a: boolean, b: boolean): boolean
			return a or b
		end

	local function F(input: InputObject, a1: boolean)
		if
			c(
				table.find(type, input.UserInputType) ~= nil,
				table.find(state, input.UserInputState) ~= nil
			)
		then
			event:Fire(input)
		end
	end

	UserInputService.InputBegan:Connect(F)
	UserInputService.InputChanged:Connect(F)

	return event
end
