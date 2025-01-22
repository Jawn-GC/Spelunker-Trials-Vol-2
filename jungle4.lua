local jungle4 = {
    identifier = "Jungle-4",
    title = "Jungle-4: Volitant",
    theme = THEME.JUNGLE,
    width = 3,
    height = 6,
    file_name = "Jungle-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Monkeys.
        local x, y, layer = get_position(entity.uid)
        local vines = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #vines > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MONKEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	--Wooden Arrow
	define_tile_code("wooden_arrow")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_WOODEN_ARROW, x, y, layer)
		return true
	end, "wooden_arrow")
	
	define_tile_code("blue_vine")
	local blue_vine = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_VINE, x, y, layer, 0, 0)
		blue_vine[#blue_vine + 1] = get_entity(block_id)
		blue_vine[#blue_vine].color:set_rgba(0, 100, 255, 255) --Light Blue
		return true
	end, "blue_vine")

	
	define_tile_code("red_vine")
	local red_vine = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_VINE, x, y, layer, 0, 0)
		red_vine[#red_vine + 1] = get_entity(block_id)
		red_vine[#red_vine].color:set_rgba(255, 40, 0, 150) --Red, Transparent
		red_vine[#red_vine].flags = clr_flag(red_vine[#red_vine].flags, 9) --Can't be climbed
		return true
	end, "red_vine")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			players[1]:remove_powerup(ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES)
		end
	
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 60 --Reduce wait time after hitting switch
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
			
			for i = 1,#blue_vine do
				blue_vine[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_vine[i].flags = clr_flag(blue_vine[i].flags, 9) --Can't be climbed
			end
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red		
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3) --Collision
			end

			for i = 1,#red_vine do
				red_vine[i].color:set_rgba(255, 40, 0, 255) --Red
				red_vine[i].flags = set_flag(red_vine[i].flags, 9)
			end			
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

			for i = 1,#blue_vine do
				blue_vine[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_vine[i].flags = set_flag(blue_vine[i].flags, 9)
			end
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 3) --No Collision
			end
			
			for i = 1,#red_vine do
				red_vine[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_vine[i].flags = clr_flag(red_vine[i].flags, 9) --Can't be climbed
			end	
		end
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(jungle4.title)
end

jungle4.unload_level = function()
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

return jungle4