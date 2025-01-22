local sound = require('play_sound')

local temple2 = {
    identifier = "Temple-2",
    title = "Temple-2: Phantom",
    theme = THEME.TEMPLE,
    width = 4,
    height = 4,
    file_name = "Temple-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_TEMPLE)
	
	--Death Blocks
	define_tile_code("death_block")
	local death_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_blocks[#death_blocks + 1] = get_entity(block_id)
		death_blocks[#death_blocks].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_blocks[#death_blocks].more_flags = set_flag(death_blocks[#death_blocks].more_flags, 17) --Unpushable
		death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 10) --No Gravity
		death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 6)
		return true
	end, "death_block")
	
	--Death Block Custom 1
	define_tile_code("death_block_custom1")
	local death_block_custom1
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_block_custom1 = get_entity(block_id)
		death_block_custom1.color:set_rgba(100, 0, 0, 255) --Dark Red
		death_block_custom1.more_flags = set_flag(death_block_custom1.more_flags, 17) --Unpushable
		death_block_custom1.flags = set_flag(death_block_custom1.flags, 10) --No Gravity
		death_block_custom1.flags = set_flag(death_block_custom1.flags, 6)
		return true
	end, "death_block_custom1")
	
	--Death Block Custom 2
	define_tile_code("death_block_custom2")
	local death_block_custom2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_block_custom2 = get_entity(block_id)
		death_block_custom2.color:set_rgba(100, 0, 0, 255) --Dark Red
		death_block_custom2.more_flags = set_flag(death_block_custom2.more_flags, 17) --Unpushable
		death_block_custom2.flags = set_flag(death_block_custom2.flags, 10) --No Gravity
		death_block_custom2.flags = set_flag(death_block_custom2.flags, 6)
		return true
	end, "death_block_custom2")
	
	--Blue ON/OFF Blocks (that block crush traps)
	define_tile_code("blue_on_off_block2")
	local blue_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		blue_blocks2[#blue_blocks2 + 1] = get_entity(block_id)
		blue_blocks2[#blue_blocks2].color:set_rgba(0, 100, 255, 255) --Light Blue
		blue_blocks2[#blue_blocks2].more_flags = set_flag(blue_blocks2[#blue_blocks2].more_flags, 17) --Unpushable
		blue_blocks2[#blue_blocks2].flags = set_flag(blue_blocks2[#blue_blocks2].flags, 10) --No Gravity
		return true
	end, "blue_on_off_block2")
	
	--Blue ON/OFF Blocks (that don't block crush traps)
	define_tile_code("blue_on_off_block3")
	local blue_blocks3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		blue_blocks3[#blue_blocks3 + 1] = get_entity(block_id)
		blue_blocks3[#blue_blocks3].color:set_rgba(0, 100, 255, 255) --Light Blue
		blue_blocks3[#blue_blocks3].more_flags = set_flag(blue_blocks3[#blue_blocks3].more_flags, 17) --Unpushable
		blue_blocks3[#blue_blocks3].flags = set_flag(blue_blocks3[#blue_blocks3].flags, 10) --No Gravity
		return true
	end, "blue_on_off_block3")
	
	--Red ON/OFF Blocks
	define_tile_code("red_on_off_block2")
	local red_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		red_blocks2[#red_blocks2 + 1] = get_entity(block_id)
		red_blocks2[#red_blocks2].color:set_rgba(180, 40, 0, 150) --Red, Transparent
		red_blocks2[#red_blocks2].more_flags = set_flag(red_blocks2[#red_blocks2].more_flags, 17) --Unpushable
		red_blocks2[#red_blocks2].flags = set_flag(red_blocks2[#red_blocks2].flags, 10) --No Gravity
		red_blocks2[#red_blocks2].flags = set_flag(red_blocks2[#red_blocks2].flags, 4) --No Collision
		return true
	end, "red_on_off_block2")
	
	--ON/OFF Thwomps
	define_tile_code("blue_on_off_thwomp_large")
	local blue_blocks_large = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE, x + 0.5, y - 0.5, layer, 0, 0)
		blue_blocks_large[#blue_blocks_large + 1] = get_entity(block_id)
		blue_blocks_large[#blue_blocks_large].color:set_rgba(0, 100, 255, 255) --Light Blue
		blue_blocks_large[#blue_blocks_large].flags = clr_flag(blue_blocks_large[#blue_blocks_large].flags, 4) --Collision with Player
		return true
	end, "blue_on_off_thwomp_large")

	define_tile_code("red_on_off_thwomp_large")
	local red_blocks_large = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE, x + 0.5, y - 0.5, layer, 0, 0)
		red_blocks_large[#red_blocks_large + 1] = get_entity(block_id)
		red_blocks_large[#red_blocks_large].color:set_rgba(180, 40, 0, 150) --Red, Transparent
		red_blocks_large[#red_blocks_large].flags = set_flag(red_blocks_large[#red_blocks_large].flags, 4) --No Collision with Player
		red_blocks_large[#red_blocks_large].flags = set_flag(red_blocks_large[#red_blocks_large].flags, 6) --Indestructible
		return true
	end, "red_on_off_thwomp_large")
	
	define_tile_code("blue_on_off_thwomp")
	local blue_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP, x, y, layer, 0, 0)
		blue_blocks[#blue_blocks + 1] = get_entity(block_id)
		blue_blocks[#blue_blocks].color:set_rgba(0, 100, 255, 255) --Light Blue
		blue_blocks[#blue_blocks].flags = clr_flag(blue_blocks[#blue_blocks].flags, 4) --Collision with Player
		return true
	end, "blue_on_off_thwomp")

	define_tile_code("red_on_off_thwomp")
	local red_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP, x, y, layer, 0, 0)
		red_blocks[#red_blocks + 1] = get_entity(block_id)
		red_blocks[#red_blocks].color:set_rgba(180, 40, 0, 150) --Red, Transparent
		red_blocks[#red_blocks].flags = set_flag(red_blocks[#red_blocks].flags, 4) --No Collision with Player
		return true
	end, "red_on_off_thwomp")
	
	--Custom Large Red Crush Trap
	define_tile_code("red_on_off_thwomp_large_custom")
	local red_on_off_thwomp_large_custom
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE, x + 0.5, y - 0.5, layer, 0, 0)
		red_on_off_thwomp_large_custom = get_entity(block_id)
		red_on_off_thwomp_large_custom.color:set_rgba(180, 40, 0, 150) --Red, Transparent
		red_on_off_thwomp_large_custom.flags = set_flag(red_on_off_thwomp_large_custom.flags, 4) --No Collision with Player
		return true
	end, "red_on_off_thwomp_large_custom")
	
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
	
	--TNT Switch
	define_tile_code("tnt_switch")
	local tnt_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch = get_entity(block_id)
		return true
	end, "tnt_switch")
	
	--TNT Block
	define_tile_code("tnt")
	local tnt
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y, layer, 0, 0)		
		tnt = get_entity(block_id)
		return true
	end, "tnt")
	
	--Spring Trap (for secret)
	define_tile_code("spring_custom")
	local spring
	local spring_x
	local spring_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.FLOOR_SPRING_TRAP, x, y, layer, 0, 0)		
		spring = get_entity(block_id)
		spring_x = x
		spring_y = y
		return true
	end, "spring_custom")
	
	local frames = 0
	local frames_reset = 0
	local tnt_activated = false
	local secret_door_spawned = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if off == true then
			frames_reset = 0
		elseif #players ~= 0 and players[1].x < 27 and players[1].x > 25 and players[1].y < 106 and players[1].y > 104 and off == false then
			frames_reset = frames_reset + 1
		end
	
		--Secret Door Conditions
		if #players ~= 0 and players[1].x < 27 and players[1].x > 25 and players[1].y < 106 and players[1].y > 104 and off == false and frames_reset > 180 and secret_door_spawned == false then
			secret_door_spawned = true
			spring:destroy()
			spawn(ENT_TYPE.BG_DOOR_FRONT_LAYER, spring_x, spring_y, 0, 0, 0)
			spawn(ENT_TYPE.FLOOR_DOOR_LAYER, spring_x, spring_y, 0, 0, 0)
			sound.play_sound(VANILLA_SOUND.UI_SECRET)
		end
	
		if tnt_switch.timer == 90 and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
	
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		death_block_custom1.color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255)
		if #players ~= 0 and players[1].standing_on_uid == death_block_custom1.uid then
			kill_entity(players[1].uid, false)
		end
	
		death_block_custom2.color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255)
		if #players ~= 0 and players[1].standing_on_uid == death_block_custom2.uid then
			kill_entity(players[1].uid, false)
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
				blue_blocks[i].flags = set_flag(blue_blocks[i].flags, 4)
			end
			
			for i = 1,#blue_blocks2 do
				blue_blocks2[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks2[i].flags = set_flag(blue_blocks2[i].flags, 4)
			end
			
			for i = 1,#blue_blocks3 do
				blue_blocks3[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks3[i].flags = clr_flag(blue_blocks3[i].flags, 3) --Not Solid
			end
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(180, 40, 0, 255) --Red		
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 4)
			end	

			for i = 1,#red_blocks2 do
				red_blocks2[i].color:set_rgba(180, 40, 0, 255) --Red		
				red_blocks2[i].flags = clr_flag(red_blocks2[i].flags, 4)
			end

			for i = 1,#blue_blocks_large do
				blue_blocks_large[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks_large[i].flags = set_flag(blue_blocks_large[i].flags, 4)
			end
			
			for i = 1,#red_blocks_large do
				red_blocks_large[i].color:set_rgba(180, 40, 0, 255) --Red		
				red_blocks_large[i].flags = clr_flag(red_blocks_large[i].flags, 4)
			end
			
			red_on_off_thwomp_large_custom.color:set_rgba(180, 40, 0, 255) --Red
			red_on_off_thwomp_large_custom.flags = clr_flag(red_on_off_thwomp_large_custom.flags, 4)
		elseif off == false and switch_hit == true then
			switch_hit = false
			off = true
		
			for i = 1,#switches do
				switches[i].color:set_rgba(0, 100, 255, 255) --Light Blue
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_blocks[i].flags = clr_flag(blue_blocks[i].flags, 4)
			end
			
			for i = 1,#blue_blocks2 do
				blue_blocks2[i].color:set_rgba(0, 100, 255, 255) --Light Blue, Transparent
				blue_blocks2[i].flags = clr_flag(blue_blocks2[i].flags, 4)
			end
			
			for i = 1,#blue_blocks3 do
				blue_blocks3[i].color:set_rgba(0, 100, 255, 255) --Light Blue, Transparent
				blue_blocks3[i].flags = set_flag(blue_blocks3[i].flags, 3) --Not Solid
			end
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(180, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 4)
			end

			for i = 1,#red_blocks2 do
				red_blocks2[i].color:set_rgba(180, 40, 0, 150) --Red		
				red_blocks2[i].flags = set_flag(red_blocks2[i].flags, 4)
			end
			
			for i = 1,#blue_blocks_large do
				blue_blocks_large[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_blocks_large[i].flags = clr_flag(blue_blocks_large[i].flags, 4)
			end
			
			for i = 1,#red_blocks_large do
				red_blocks_large[i].color:set_rgba(180, 40, 0, 150) --Red, Transparent	
				red_blocks_large[i].flags = set_flag(red_blocks_large[i].flags, 4)
			end
			
			red_on_off_thwomp_large_custom.color:set_rgba(180, 40, 0, 150) --Red
			red_on_off_thwomp_large_custom.flags = set_flag(red_on_off_thwomp_large_custom.flags, 4)
		end
	
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
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
		
		death_block_custom1.x = red_on_off_thwomp_large_custom.x - 0.5
		death_block_custom2.x = red_on_off_thwomp_large_custom.x + 0.5
		
        frames = frames + 1

    end, ON.FRAME)
	
	toast(temple2.title)
end

temple2.unload_level = function()
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

return temple2