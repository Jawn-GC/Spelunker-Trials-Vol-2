local tidepool1 = {
    identifier = "Tidepool-1",
    title = "Tidepool-1: Death's Touch",
    theme = THEME.TIDE_POOL,
    width = 4,
    height = 4,
    file_name = "Tidepool-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
	--Death Blocks
	define_tile_code("death_block")
	local death_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_blocks[#death_blocks + 1] = get_entity(block_id)
		death_blocks[#death_blocks].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_blocks[#death_blocks].more_flags = set_flag(death_blocks[#death_blocks].more_flags, 17) --Unpushable
		death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 10) --No Gravity
		return true
	end, "death_block")
	
	--Floating Firebug
	define_tile_code("floating_firebug")
	local floating_firebug
	local firebug_x
	local firebug_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y + 0.5, layer, 0, 0)
		floating_firebug = get_entity(block_id)
		firebug_x = x
		firebug_y = y + 0.5
		floating_firebug.flags = set_flag(floating_firebug.flags, 10)
		floating_firebug.flags = set_flag(floating_firebug.flags, 17)
		floating_firebug.health = 2
		return true
	end, "floating_firebug")
	
	--Oscillating Death Blocks
	define_tile_code("osc_death_block")
	local osc_death_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_death_blocks[#osc_death_blocks + 1] = get_entity(block_id)
		osc_death_blocks[#osc_death_blocks].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks[#osc_death_blocks].flags = set_flag(osc_death_blocks[#osc_death_blocks].flags, 10) -- No Gravity
		osc_death_blocks[#osc_death_blocks].flags = clr_flag(osc_death_blocks[#osc_death_blocks].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block")
	
	--Oscillating Death Blocks 2
	define_tile_code("osc_death_block2")
	local osc_death_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_death_blocks2[#osc_death_blocks2 + 1] = get_entity(block_id)
		osc_death_blocks2[#osc_death_blocks2].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks2[#osc_death_blocks2].flags = set_flag(osc_death_blocks2[#osc_death_blocks2].flags, 10) -- No Gravity
		osc_death_blocks2[#osc_death_blocks2].flags = clr_flag(osc_death_blocks2[#osc_death_blocks2].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block2")
	
	--Oscillating Death Blocks 3
	define_tile_code("osc_death_block3")
	local osc_death_blocks3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_death_blocks3[#osc_death_blocks3 + 1] = get_entity(block_id)
		osc_death_blocks3[#osc_death_blocks3].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks3[#osc_death_blocks3].flags = set_flag(osc_death_blocks3[#osc_death_blocks3].flags, 10) -- No Gravity
		osc_death_blocks3[#osc_death_blocks3].flags = clr_flag(osc_death_blocks3[#osc_death_blocks3].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block3")
	
	--Oscillating Death Blocks 4
	define_tile_code("osc_death_block4")
	local osc_death_blocks4 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y + 0.5, layer, 0, 0)
		osc_death_blocks4[#osc_death_blocks4 + 1] = get_entity(block_id)
		osc_death_blocks4[#osc_death_blocks4].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks4[#osc_death_blocks4].flags = set_flag(osc_death_blocks4[#osc_death_blocks4].flags, 10) -- No Gravity
		osc_death_blocks4[#osc_death_blocks4].flags = clr_flag(osc_death_blocks4[#osc_death_blocks4].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block4")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		--Remove Vlad's Cape from the player
		if frames == 0 and players[1]:worn_backitem() ~= -1 then
			local cape
			cape = get_entity(players[1]:worn_backitem())
			players[1]:unequip_backitem()
			cape:destroy()
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
		
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		for i = 1,#osc_death_blocks2 do
			osc_death_blocks2[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks2[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		for i = 1,#osc_death_blocks3 do
			osc_death_blocks3[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks3[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		for i = 1,#osc_death_blocks4 do
			osc_death_blocks4[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks4[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x + 2 * math.sin(0.05 * frames)
			floating_firebug.y = firebug_y
		end
		
		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].velocityy = 0.08 * -math.sin(0.04 * frames)
		end
		
		for i = 1,#osc_death_blocks2 do
			osc_death_blocks2[i].velocityy = 0.08 * -math.cos(0.04 * frames)
		end
		
		for i = 1,#osc_death_blocks3 do
			osc_death_blocks3[i].velocityy = 0.1 * -math.cos(0.03333 * frames)
		end
		
		for i = 1,#osc_death_blocks4 do
			osc_death_blocks4[i].velocityy = 0.06 * -math.cos(0.04 * frames)
		end
		
        frames = frames + 1
    end, ON.FRAME)
	
	toast(tidepool1.title)
end

tidepool1.unload_level = function()
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

return tidepool1