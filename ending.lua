local ending = {
    identifier = "Ending",
    title = "Ending",
    theme = THEME.CITY_OF_GOLD,
	world = 7,
	level = 5,
    width = 5,
    height = 4,
    file_name = "CoG.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

ending.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	toast("Congratulations!")
end

ending.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return ending