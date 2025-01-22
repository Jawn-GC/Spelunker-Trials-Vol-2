local dwelling4 = {
    identifier = "Dwelling-4",
    title = "Dwelling-4: Dichromatic",
    theme = THEME.DWELLING,
    width = 4,
    height = 4,
    file_name = "Dwelling-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity.flags = clr_flag(entity.flags, 18)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_ARROW)
	
	--Oscillating Blocks
	define_tile_code("oscillating_platform1")
	local oscillating_platform1
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		oscillating_platform1 = get_entity(block_id)
		oscillating_platform1.color:set_rgba(0, 100, 255, 255) --Light Blue
		oscillating_platform1.flags = set_flag(oscillating_platform1.flags, 10)
		return true
	end, "oscillating_platform1")
	
	define_tile_code("oscillating_platform2")
	local oscillating_platform2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		oscillating_platform2 = get_entity(block_id)
		oscillating_platform2.color:set_rgba(255, 40, 0, 150) --Red, Transparent
		oscillating_platform2.flags = set_flag(oscillating_platform2.flags, 10)
		return true
	end, "oscillating_platform2")
	
	define_tile_code("oscillating_platform3")
	local oscillating_platform3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		oscillating_platform3 = get_entity(block_id)
		oscillating_platform3.color:set_rgba(0, 100, 255, 255) --Light Blue
		oscillating_platform3.flags = set_flag(oscillating_platform3.flags, 10)
		return true
	end, "oscillating_platform3")
	
	--Switch Activation
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()		
		frames = frames + 1
		oscillating_platform1.velocityy = 0.1 * math.cos(0.05 * frames)
		oscillating_platform2.velocityy = 0.1 * math.cos(0.05 * frames)
		oscillating_platform3.velocityx = 0.15 * -math.cos(0.05 * frames)
		
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 20 --Reduce wait time after hitting switch
			end
		end
		
		if off == true and switch_hit == true then
			switch_hit = false
			off = false
		
			for i = 1,#switches do
				switches[i].color:set_rgba(255, 40, 0, 255) --Red
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks[i].flags = clr_flag(blue_blocks[i].flags, 3) --No Collision
			end
			
			oscillating_platform1.color:set_rgba(0, 100, 255, 150)
			oscillating_platform1.flags = clr_flag(oscillating_platform1.flags, 3)
			
			oscillating_platform3.color:set_rgba(0, 100, 255, 150)
			oscillating_platform3.flags = clr_flag(oscillating_platform1.flags, 3)
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red		
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3) --Collision
			end
			
			oscillating_platform2.color:set_rgba(255, 40, 0, 255)
			oscillating_platform2.flags = set_flag(oscillating_platform1.flags, 3)
			
		elseif off == false and switch_hit == true then
			switch_hit = false
			off = true
		
			for i = 1,#switches do
				switches[i].color:set_rgba(0, 100, 255, 255) --Light Blue
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_blocks[i].flags = set_flag(blue_blocks[i].flags, 3) --Collision
			end
			
			oscillating_platform1.color:set_rgba(0, 100, 255, 255)
			oscillating_platform1.flags = set_flag(oscillating_platform1.flags, 3)	
			
			oscillating_platform3.color:set_rgba(0, 100, 255, 255)
			oscillating_platform3.flags = set_flag(oscillating_platform1.flags, 3)
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 3) --No Collision
			end
			
			oscillating_platform2.color:set_rgba(255, 40, 0, 150)
			oscillating_platform2.flags = clr_flag(oscillating_platform1.flags, 3)
		end
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
    end, ON.FRAME)
	
	toast(dwelling4.title)
end

dwelling4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end

	switch_hit = false
	off = true
	switches = {}
	blue_blocks = {}
	red_blocks = {}
end

return dwelling4
