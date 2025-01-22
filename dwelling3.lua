local dwelling3 = {
    identifier = "Dwelling-3",
    title = "Dwelling-3: Harmonic Oscillator",
    theme = THEME.DWELLING,
    width = 4,
    height = 4,
    file_name = "Dwelling-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity.flags = clr_flag(entity.flags, 18)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_ARROW)
	
	--Oscillating Platforms
	local osc_blocks = {}
	local y_pos
	define_tile_code("osc_block")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 15, y + 1, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 20, y + 4, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 23, y + 2, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 26, y, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 4, y - 11, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 10, y - 11, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 18, y - 9, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 18, y - 8, layer, 0, 0))
		osc_blocks[#osc_blocks + 1] = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 18, y - 7, layer, 0, 0))
		
		y_pos = y
	end, "osc_block")
	
	--Set Velocities of Oscillating Platforms
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then	
			for i = 1,#osc_blocks do
				osc_blocks[i].color:set_rgba(200, 150, 90, 255) --Light Brown
				osc_blocks[i].flags = set_flag(osc_blocks[i].flags, 10) -- No Gravity
				osc_blocks[i].flags = clr_flag(osc_blocks[i].flags, 13) -- No Collision with walls
			end
		end
		osc_blocks[1].velocityx = 0.12 * -math.cos(0.04 * frames)
		osc_blocks[2].velocityy = 0.1 * -math.cos(0.05 * frames)
		osc_blocks[3].velocityx = 0.15 * math.sin(0.05 * frames)
		osc_blocks[4].velocityx = 0.15 * -math.cos(0.05 * frames)
		osc_blocks[5].velocityx = 0.15 * -math.sin(0.05 * frames)
		osc_blocks[6].velocityy = 0.05 * math.cos(0.05 * frames)
		osc_blocks[7].velocityy = 0.05 * -math.cos(0.05 * frames)
		osc_blocks[8].velocityx = 0.15 * math.cos(0.05 * frames)
		osc_blocks[9].velocityx = 0.15 * math.cos(0.05 * frames)
		osc_blocks[10].velocityx = 0.15 * math.cos(0.05 * frames)
		
		--These blocks drift downward for some reason, reset y position every frame. (Cringe)
		osc_blocks[1].y = y_pos
		osc_blocks[3].y = y_pos + 4
		osc_blocks[4].y = y_pos + 2
		osc_blocks[5].y = y_pos
		
		frames = frames + 1
    end, ON.FRAME)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	toast(dwelling3.title)
end

dwelling3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling3
