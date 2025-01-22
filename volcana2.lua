local volcana2 = {
    identifier = "Volcana-2",
    title = "Volcana-2: Orbit",
    theme = THEME.VOLCANA,
    width = 4,
    height = 4,
    file_name = "Volcana-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Magmamen.
        local x, y, layer = get_position(entity.uid)
        local lavas = get_entities_at(0, MASK.LAVA, x, y, layer, 1)
        if #lavas > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MAGMAMAN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Firebugs.
        local x, y, layer = get_position(entity.uid)
        local chains = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #chains > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREBUG)
	
	--Unfalling Platform
	define_tile_code("stable_platform")
	local stable_platforms = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		stable_platforms[#stable_platforms+1] = get_entity(block_id)
		stable_platforms[#stable_platforms].flags = set_flag(stable_platforms[#stable_platforms].flags, 10)
		stable_platforms[#stable_platforms].shaking_factor = 0.01
		stable_platforms[#stable_platforms].color:set_rgba(190, 160, 210, 255) --Light Purple
		return true
	end, "stable_platform")
	
	--Orbiting Unfalling Platform
	define_tile_code("orb_stable_platform")
	local orb_stable_platform
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		orb_stable_platform = get_entity(block_id)
		orb_stable_platform.flags = set_flag(orb_stable_platform.flags, 10)
		orb_stable_platform.flags = clr_flag(orb_stable_platform.flags, 13)
		orb_stable_platform.shaking_factor = 0.01
		orb_stable_platform.color:set_rgba(0, 100, 255, 150) --Light Blue
		orb_stable_platform.timer = 1
		return true
	end, "orb_stable_platform")
	
	--Orbiting Unfalling Platform 2
	define_tile_code("orb_stable_platform2")
	local orb_stable_platform2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		orb_stable_platform2 = get_entity(block_id)
		orb_stable_platform2.flags = set_flag(orb_stable_platform2.flags, 10)
		orb_stable_platform2.flags = clr_flag(orb_stable_platform2.flags, 13)
		orb_stable_platform2.shaking_factor = 0.01
		orb_stable_platform2.color:set_rgba(0, 100, 255, 150) --Light Blue
		orb_stable_platform2.timer = 1
		return true
	end, "orb_stable_platform2")
	
	--Orbiting Unfalling Platform 3
	define_tile_code("orb_stable_platform3")
	local orb_stable_platform3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		orb_stable_platform3 = get_entity(block_id)
		orb_stable_platform3.flags = set_flag(orb_stable_platform3.flags, 10)
		orb_stable_platform3.flags = clr_flag(orb_stable_platform3.flags, 13)
		orb_stable_platform3.shaking_factor = 0.01
		orb_stable_platform3.color:set_rgba(0, 100, 255, 150) --Light Blue
		orb_stable_platform3.timer = 1
		return true
	end, "orb_stable_platform3")
	
	--Orbiting Unfalling Platform 4
	define_tile_code("orb_stable_platform4")
	local orb_stable_platform4
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		orb_stable_platform4 = get_entity(block_id)
		orb_stable_platform4.flags = set_flag(orb_stable_platform4.flags, 10)
		orb_stable_platform4.flags = clr_flag(orb_stable_platform4.flags, 13)
		orb_stable_platform4.shaking_factor = 0.01
		orb_stable_platform4.color:set_rgba(0, 100, 255, 150) --Light Blue
		orb_stable_platform4.timer = 1
		return true
	end, "orb_stable_platform4")
	
	--Orbiting Unfalling Platform 5
	define_tile_code("orb_stable_platform5")
	local orb_stable_platform5
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x + 0.5, y, layer, 0, 0)
		orb_stable_platform5 = get_entity(block_id)
		orb_stable_platform5.flags = set_flag(orb_stable_platform5.flags, 10)
		orb_stable_platform5.flags = clr_flag(orb_stable_platform5.flags, 13)
		orb_stable_platform5.shaking_factor = 0.01
		orb_stable_platform5.color:set_rgba(190, 160, 210, 255) --Light Purple
		orb_stable_platform5.timer = 1
		return true
	end, "orb_stable_platform5")
	
	--Orbiting Unfalling Platform 6
	--define_tile_code("orb_stable_platform6")
	--local orb_stable_platform6
	--level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		--local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x + 0.5, y, layer, 0, 0)
		--orb_stable_platform6 = get_entity(block_id)
		--orb_stable_platform6.flags = set_flag(orb_stable_platform6.flags, 10)
		--orb_stable_platform6.flags = clr_flag(orb_stable_platform6.flags, 13)
		--orb_stable_platform6.shaking_factor = 0.01
		--orb_stable_platform6.color:set_rgba(190, 160, 210, 255) --Light Purple
		--orb_stable_platform6.timer = 1
	--end, "orb_stable_platform6")
	
	local frames = 0
	local frames_no_reset = 0
	local phase_angle = 0
	local phase_angle2 = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		for i = 1,#stable_platforms do
			stable_platforms[i].timer = -1 --Prevents bottom of platform from hurting the player after activation (unless the platform is moving)
		end
		
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 60 --Reduce wait time after hitting switch
				
				if off == true then
					phase_angle = phase_angle + 0.05 * frames
					phase_angle2 = phase_angle2 + 0.04 * frames
				elseif off == false then
					phase_angle = phase_angle - 0.05 * frames
					phase_angle2 = phase_angle2 - 0.04 * frames
				end
				frames = 0
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
		
		--Swap direction of orbit on switch activation
		if off == true then
			orb_stable_platform.color:set_rgba(0, 100, 255, 255) --Light Blue
			orb_stable_platform.velocityx = 0.1 * -math.sin(phase_angle + 0.05 * frames)
			orb_stable_platform.velocityy = 0.1 * math.cos(phase_angle + 0.05 * frames)
			
			orb_stable_platform2.color:set_rgba(0, 100, 255, 255) --Light Blue
			orb_stable_platform2.velocityx = 0.1 * math.sin(phase_angle + 0.05 * frames)
			orb_stable_platform2.velocityy = 0.1 * -math.cos(phase_angle + 0.05 * frames)
			
			orb_stable_platform3.color:set_rgba(0, 100, 255, 255) --Light Blue
			orb_stable_platform3.velocityx = 0.15 * math.sin(phase_angle + 0.05 * frames)
			orb_stable_platform3.velocityy = 0.15 * math.cos(phase_angle + 0.05 * frames)
			
			orb_stable_platform4.color:set_rgba(0, 100, 255, 255) --Light Blue
			orb_stable_platform4.velocityx = 0.12 * math.sin(phase_angle2 + 0.04 * frames)
			orb_stable_platform4.velocityy = 0.12 * -math.cos(phase_angle2 + 0.04 * frames)
		elseif off == false then
			orb_stable_platform.color:set_rgba(255, 40, 0, 255) --Red
			orb_stable_platform.velocityx = 0.1 * math.sin(phase_angle - 0.05 * frames)
			orb_stable_platform.velocityy = 0.1 * -math.cos(phase_angle - 0.05 * frames)
		
			orb_stable_platform2.color:set_rgba(255, 40, 0, 255) --Red
			orb_stable_platform2.velocityx = 0.1 * -math.sin(phase_angle - 0.05 * frames)
			orb_stable_platform2.velocityy = 0.1 * math.cos(phase_angle - 0.05 * frames)
			
			orb_stable_platform3.color:set_rgba(255, 40, 0, 255) --Red
			orb_stable_platform3.velocityx = 0.15 * -math.sin(phase_angle - 0.05 * frames)
			orb_stable_platform3.velocityy = 0.15 * -math.cos(phase_angle - 0.05 * frames)
			
			orb_stable_platform4.color:set_rgba(255, 40, 0, 255) --Red
			orb_stable_platform4.velocityx = 0.12 * -math.sin(phase_angle2 - 0.04 * frames)
			orb_stable_platform4.velocityy = 0.12 * math.cos(phase_angle2 - 0.04 * frames)
		end
		
		orb_stable_platform5.velocityx = 0.1 * -math.sin(0.06667 * frames_no_reset)
		orb_stable_platform5.velocityy = 0.1 * math.cos(0.06667 * frames_no_reset)
		
		--orb_stable_platform6.velocityx = 0.15 * -math.sin(0.1 * frames_no_reset)
		--orb_stable_platform6.velocityy = 0.15 * math.cos(0.1 * frames_no_reset)
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
		frames = frames + 1
		frames_no_reset = frames_no_reset + 1
		
    end, ON.FRAME)
	
	toast(volcana2.title)
end

volcana2.unload_level = function()
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

return volcana2