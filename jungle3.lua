local jungle3 = {
    identifier = "Jungle-3",
    title = "Jungle-3: Safeguard",
    theme = THEME.JUNGLE,
    width = 4,
    height = 4,
    file_name = "Jungle-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity.flags = clr_flag(entity.flags, 18)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_ARROW)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Monkeys.
        local x, y, layer = get_position(entity.uid)
        local vines = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #vines > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MONKEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	--Oscillating Platform
	define_tile_code("osc_platform")
	local osc_platforms = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 0.5, y, layer, 0, 0)
		osc_platforms[#osc_platforms + 1] = get_entity(block_id)
		osc_platforms[#osc_platforms].color:set_rgba(30, 200, 60, 255) --Green
		osc_platforms[#osc_platforms].flags = set_flag(osc_platforms[#osc_platforms].flags, 10) -- No Gravity
		osc_platforms[#osc_platforms].flags = clr_flag(osc_platforms[#osc_platforms].flags, 13)-- No collision with walls
		return true
	end, "osc_platform")
	
	--Floating Firebug
	define_tile_code("floating_firebug")
	local floating_firebug
	local firebug_x
	local firebug_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y, layer, 0, 0)
		floating_firebug = get_entity(block_id)
		firebug_x = x
		firebug_y = y
		floating_firebug.flags = set_flag(floating_firebug.flags, 10)
		floating_firebug.flags = set_flag(floating_firebug.flags, 17)
		floating_firebug.health = 2
		return true
	end, "floating_firebug")
	
	--Oscillating Platforms 2
	define_tile_code("osc_platform2")
	local osc_platforms2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_platforms2[#osc_platforms2 + 1] = get_entity(block_id)
		osc_platforms2[#osc_platforms2].color:set_rgba(30, 200, 60, 255) --Green
		osc_platforms2[#osc_platforms2].flags = set_flag(osc_platforms2[#osc_platforms2].flags, 10) -- No Gravity
		osc_platforms2[#osc_platforms2].flags = clr_flag(osc_platforms2[#osc_platforms2].flags, 13)-- No collision with walls
		return true
	end, "osc_platform2")
	
	--Oscillating Platforms 3
	define_tile_code("osc_platform3")
	local osc_platforms3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_platforms3[#osc_platforms3 + 1] = get_entity(block_id)
		osc_platforms3[#osc_platforms3].color:set_rgba(30, 200, 60, 255) --Green
		osc_platforms3[#osc_platforms3].flags = set_flag(osc_platforms3[#osc_platforms3].flags, 10) -- No Gravity
		osc_platforms3[#osc_platforms3].flags = clr_flag(osc_platforms3[#osc_platforms3].flags, 13)-- No collision with walls
		return true
	end, "osc_platform3")
	
	--Climbing Gloves
	define_tile_code("climbers")
	local climbers
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, x, y, layer, 0, 0)		
		 climbers = get_entity(block_id)
		 return true
	end, "climbers")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
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
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red		
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3) --Collision
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

			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 3) --No Collision
			end
		end
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
		for i = 1,#osc_platforms do
			osc_platforms[i].velocityx = 0.115 * math.cos(0.046 * frames)
		end
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x - 2 * math.sin(0.05 * frames)
			floating_firebug.y = firebug_y
		end
		
		for i = 1,#osc_platforms2 do
			osc_platforms2[i].velocityy = 0.1 * math.cos(0.05 * frames)
		end
		
		for i = 1,#osc_platforms3 do
			osc_platforms3[i].velocityx = 0.1 * math.cos(0.05 * frames)
		end
		
        frames = frames + 1
    end, ON.FRAME)
	
	toast(jungle3.title)
end

jungle3.unload_level = function()
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

return jungle3