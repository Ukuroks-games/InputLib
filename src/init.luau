local WhileKeyPressed = require(script.WhileKeyPressed)
local watchKey = require(script.watchKey)

export type WhileKeyPressedController = WhileKeyPressed.WhileKeyPressedController

return {
	WhileKeyPressed = WhileKeyPressed,
	watchKey = watchKey,
}
