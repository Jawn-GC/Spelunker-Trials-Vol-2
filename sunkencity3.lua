local sound = require('play_sound')

local sunkencity3 = {
    identifier = "Sunken City-3",
    title = "Sunken City-3: Icarus",
    theme = THEME.SUNKEN_CITY,
    width = 4,
    height = 6,
    file_name = "Sunken City-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snakes to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	--Vlad's Cape
	define_tile_code("red_pill")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_VLADS_CAPE, x + 0.5, y, layer)
		return true
	end, "red_pill")
	
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
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y, layer, 0, 0)
		floating_firebug = get_entity(block_id)
		firebug_x = x
		firebug_y = y
		floating_firebug.flags = set_flag(floating_firebug.flags, 10)
		floating_firebug.flags = set_flag(floating_firebug.flags, 17)
		floating_firebug.health = 2
		return true
	end, "floating_firebug")
	
	--Floating Firebug 2
	define_tile_code("floating_firebug2")
	local floating_firebug2
	local firebug2_x
	local firebug2_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y, layer, 0, 0)
		floating_firebug2 = get_entity(block_id)
		firebug2_x = x
		firebug2_y = y
		floating_firebug2.flags = set_flag(floating_firebug2.flags, 10)
		floating_firebug2.flags = set_flag(floating_firebug2.flags, 17)
		floating_firebug2.health = 2
		return true
	end, "floating_firebug2")
	
	--Oscillating Spring Block 1
	define_tile_code("osc_spring_block")
	local spring_blocks = {}
	local osc_index
	local osc_x
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		spring_blocks[#spring_blocks + 1] = get_entity(block_id)
		spring_blocks[#spring_blocks].color:set_rgba(150, 255, 150, 255) --Light Green
		spring_blocks[#spring_blocks].more_flags = set_flag(spring_blocks[#spring_blocks].more_flags, 17) --Unpushable
		spring_blocks[#spring_blocks].flags = set_flag(spring_blocks[#spring_blocks].flags, 10) --No Gravity
		spring_blocks[#spring_blocks].flags = clr_flag(spring_blocks[#spring_blocks].flags, 13)
		osc_index = #spring_blocks
		osc_x = x
		return true
	end, "osc_spring_block")
	
	--Oscillating Spring Block 2
	define_tile_code("osc_spring_block2")
	local osc_index2
	local osc_x2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		spring_blocks[#spring_blocks + 1] = get_entity(block_id)
		spring_blocks[#spring_blocks].color:set_rgba(150, 255, 150, 255) --Light Green
		spring_blocks[#spring_blocks].more_flags = set_flag(spring_blocks[#spring_blocks].more_flags, 17) --Unpushable
		spring_blocks[#spring_blocks].flags = set_flag(spring_blocks[#spring_blocks].flags, 10) --No Gravity
		spring_blocks[#spring_blocks].flags = clr_flag(spring_blocks[#spring_blocks].flags, 13)
		osc_index2 = #spring_blocks
		osc_x2 = x
		return true
	end, "osc_spring_block2")
	
	define_tile_code("blue_vine")
	local blue_vine = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_VINE, x, y, layer, 0, 0)
		blue_vine[#blue_vine + 1] = get_entity(block_id)
		blue_vine[#blue_vine].color:set_rgba(0, 100, 255, 255) --Light Blue
		return true
	end, "blue_vine")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
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
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red		
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3) --Collision
			end

			for i = 1,#blue_vine do
				blue_vine[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_vine[i].flags = clr_flag(blue_vine[i].flags, 9) --Can't be climbed
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
			
			for i = 1,#blue_vine do
				blue_vine[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_vine[i].flags = set_flag(blue_vine[i].flags, 9)
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
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x - 2 * math.sin(0.05 * frames)
			floating_firebug.y = firebug_y
		end
		
		if floating_firebug2.flags == 1074878016 then
			floating_firebug2.x = firebug2_x
			floating_firebug2.y = firebug2_y + 0.1 * math.sin(0.05 * frames)
		end
		
		for i = 1,#spring_blocks do
			spring_blocks[i].color:set_rgba(80 + math.ceil(50 * math.sin(0.06 * frames)), 255, 110 + math.ceil(50 * math.sin(0.06 * frames)), 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == spring_blocks[i].uid then
				players[1].velocityy = 0.3
				spawn(ENT_TYPE.FX_SPRINGTRAP_RING, spring_blocks[i].x, spring_blocks[i].y + 0.5, 0, 0, 0)
				sound.play_sound(VANILLA_SOUND.TRAPS_SPRING_TRIGGER)
			end
		end

		spring_blocks[osc_index].x = osc_x + 2 * math.sin(0.05 * frames)
		spring_blocks[osc_index2].x = osc_x2 + 2 * math.sin(0.05 * frames)
		
		frames = frames + 1
		
	end, ON.FRAME)
	toast(sunkencity3.title)
end

sunkencity3.unload_level = function()
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

return sunkencity3