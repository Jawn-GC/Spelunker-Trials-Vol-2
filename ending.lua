local ending = {
    identifier = "Ending",
    title = "Ending",
    theme = THEME.CITY_OF_GOLD,
    width = 4,
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
	
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if players[1].health == 0 and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_ANKH) == true then			
			spawn(ENT_TYPE.ITEM_BOMB, 25, 95, 0, 0, 0)
			spawn(ENT_TYPE.ITEM_BOMB, 23, 95, 0, 0, 0)		
		end
    end, ON.FRAME)
	
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