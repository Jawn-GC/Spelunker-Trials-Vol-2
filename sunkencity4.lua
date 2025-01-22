local sound = require('play_sound')

local sunkencity4 = {
    identifier = "Sunken City-4",
    title = "Sunken City-4: Triumph",
    theme = THEME.SUNKEN_CITY,
    width = 5,
    height = 5,
    file_name = "Sunken City-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_SUNKEN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snakes to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity.flags = clr_flag(entity.flags, 18)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_ARROW)
	
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
	
	--Crush Traps that only activate once
	define_tile_code("large_crush_trap")
	local crush_trap = {}
	local crush_trap_activated = {}
	local crush_trap_moved = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE, x + 0.5, y - 0.5, layer, 0, 0)		
		crush_trap[#crush_trap + 1] = get_entity(block_id)
		crush_trap_activated[#crush_trap_activated + 1] = false
		crush_trap_moved[#crush_trap_moved + 1] = false
		return true
	end, "large_crush_trap")
	
	define_tile_code("crush_trap")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP, x, y, layer, 0, 0)		
		crush_trap[#crush_trap + 1] = get_entity(block_id)
		crush_trap_activated[#crush_trap_activated + 1] = false
		crush_trap_moved[#crush_trap_moved + 1] = false
		return true
	end, "crush_trap")
	
	--Spring Blocks
	define_tile_code("spring_block")
	local spring_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		spring_blocks[#spring_blocks + 1] = get_entity(block_id)
		spring_blocks[#spring_blocks].color:set_rgba(150, 255, 150, 255) --Light Green
		spring_blocks[#spring_blocks].more_flags = set_flag(spring_blocks[#spring_blocks].more_flags, 17) --Unpushable
		spring_blocks[#spring_blocks].flags = set_flag(spring_blocks[#spring_blocks].flags, 10) --No Gravity
		return true
	end, "spring_block")
	
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
	
	--Oscillating Blocks
	define_tile_code("osc_block")
	local osc_blocks = {}
	local osc_x = {}
	local osc_y = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_blocks[#osc_blocks + 1] = get_entity(block_id)
		osc_blocks[#osc_blocks].color:set_rgba(200, 150, 90, 255) --Light Brown
		osc_blocks[#osc_blocks].flags = set_flag(osc_blocks[#osc_blocks].flags, 10) -- No Gravity
		osc_blocks[#osc_blocks].flags = clr_flag(osc_blocks[#osc_blocks].flags, 13)-- No collision with walls
		osc_x[#osc_blocks] = x
		osc_y[#osc_blocks] = y
		return true
	end, "osc_block")
	
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
	
		--Crush Traps
		for i = 1,#crush_trap do
			if crush_trap[i].timer == 30 then
				crush_trap_activated[i] = true
			end
		end
		
		for i = 1,#crush_trap do
			if crush_trap_activated[i] == true and crush_trap[i].timer == 0 then
				crush_trap_moved[i] = true
			end
		end
		
		for i = 1,#crush_trap do 
			if crush_trap_moved[i] == true then
				crush_trap[i].timer = 0
				crush_trap[i].color = Color:gray()
			end
		end
	
		for i = 1,#spring_blocks do
			spring_blocks[i].color:set_rgba(80 + math.ceil(50 * math.sin(0.06 * frames)), 255, 110 + math.ceil(50 * math.sin(0.06 * frames)), 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == spring_blocks[i].uid then
				players[1].velocityy = 0.3
				spawn(ENT_TYPE.FX_SPRINGTRAP_RING, spring_blocks[i].x, spring_blocks[i].y + 0.5, 0, 0, 0)
				sound.play_sound(VANILLA_SOUND.TRAPS_SPRING_TRIGGER)
			end
		end

		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end

		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].velocityy = 0.05 * math.sin(0.05 * frames)
		end

		for i = 1,#osc_blocks do
			osc_blocks[i].x = osc_x[i] + 2 * math.sin(0.05 * frames)
		end

        frames = frames + 1
    end, ON.FRAME)
	
	toast(sunkencity4.title)
end

sunkencity4.unload_level = function()
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

return sunkencity4