local volcana1 = {
    identifier = "Volcana-1",
    title = "Volcana-1: Instability",
    theme = THEME.VOLCANA,
    width = 4,
    height = 4,
    file_name = "Volcana-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana1.load_level = function()
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
	
	local pushblocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Unpushable Blocks
		pushblocks[#pushblocks+1] = entity
		entity.more_flags = set_flag(entity.more_flags, 17)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK)
	
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
	
	--Oscillating Unfalling Platform
	define_tile_code("osc_stable_platform")
	local osc_stable_platform
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		osc_stable_platform = get_entity(block_id)
		osc_stable_platform.flags = set_flag(osc_stable_platform.flags, 10)
		osc_stable_platform.shaking_factor = 0.01
		osc_stable_platform.color:set_rgba(190, 160, 210, 255) --Light Purple
		osc_stable_platform.timer = 1
		return true
	end, "osc_stable_platform")
	
	--Oscillating Unfalling Platform 2
	define_tile_code("osc_stable_platform2")
	local osc_stable_platform2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		osc_stable_platform2 = get_entity(block_id)
		osc_stable_platform2.flags = set_flag(osc_stable_platform2.flags, 10)
		osc_stable_platform2.shaking_factor = 0.01
		osc_stable_platform2.color:set_rgba(190, 160, 210, 255) --Light Purple
		osc_stable_platform2.timer = 1
		return true
	end, "osc_stable_platform2")
	
	--Oscillating Unfalling Platform 3
	define_tile_code("osc_stable_platform3")
	local osc_stable_platform3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		osc_stable_platform3 = get_entity(block_id)
		osc_stable_platform3.flags = set_flag(osc_stable_platform3.flags, 10)
		osc_stable_platform3.shaking_factor = 0.01
		osc_stable_platform3.color:set_rgba(190, 160, 210, 255) --Light Purple
		osc_stable_platform3.timer = 1
		return true
	end, "osc_stable_platform3")
	
	--Falling Lift
	define_tile_code("falling_lift")
	local falling_lift = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id1 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		local block_id2 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x+1, y, layer, 0, 0)
		local block_id3 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x+2, y, layer, 0, 0)
		
		falling_lift[#falling_lift+1] = get_entity(block_id1)
		falling_lift[#falling_lift+1] = get_entity(block_id2)
		falling_lift[#falling_lift+1] = get_entity(block_id3)

		falling_lift[1].color:set_rgba(130, 200, 210, 255) --Light Blue
		falling_lift[2].color:set_rgba(130, 200, 210, 255) --Light Blue
		falling_lift[3].color:set_rgba(130, 200, 210, 255) --Light Blue
		return true
	end, "falling_lift")
	
	--Falling Triple (Vertical)
	define_tile_code("falling_triple")
	local falling_triple = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id1 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		local block_id2 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y+2, layer, 0, 0)
		local block_id3 = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y+4, layer, 0, 0)
		
		falling_triple[#falling_triple+1] = get_entity(block_id1)
		falling_triple[#falling_triple+1] = get_entity(block_id2)
		falling_triple[#falling_triple+1] = get_entity(block_id3)

		falling_triple[1].color:set_rgba(130, 200, 210, 255) --Light Blue
		falling_triple[2].color:set_rgba(130, 200, 210, 255) --Light Blue
		falling_triple[3].color:set_rgba(130, 200, 210, 255) --Light Blue
		return true
	end, "falling_triple")
	
	local frames = 0
	local lift_fell = false
	local triple_fell = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
        frames = frames + 1
		
		for i = 1,#stable_platforms do
			stable_platforms[i].timer = -1 --Prevents bottom of platform from hurting the player after activation (unless the platform is moving)
		end
		
		osc_stable_platform.velocityx = 0.1 * math.cos(0.05 * frames)
		osc_stable_platform2.velocityy = 0.1 * math.cos(0.05 * frames)
		osc_stable_platform3.velocityy = 0.1 * -math.cos(0.05 * frames)
		
		--All platforms of the lift will fall if one is touched
		if lift_fell == false then
			for i = 1,#falling_lift do
				if falling_lift[i].timer == 60 then
					lift_fell = true
					for j = 1,#falling_lift do
						falling_lift[j].timer = 40
					end
					break
				end
			end
		end
		
		--All platforms of the triple will fall if one is touched
		if triple_fell == false then
			for i = 1,#falling_triple do
				if falling_triple[i].timer == 60 then
					triple_fell = true
					for j = 1,#falling_triple do
						falling_triple[j].timer = 95
					end
					break
				end
			end
		end
		
		--Keeps pushblocks unpushable
		for i = 1,#pushblocks do
			pushblocks[i].more_flags = set_flag(pushblocks[i].more_flags, 17)
		end
		
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
		
    end, ON.FRAME)
	
	toast(volcana1.title)
end

volcana1.unload_level = function()
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

return volcana1