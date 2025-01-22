local temple3 = {
    identifier = "Temple-3",
    title = "Temple-3: Gunpowder",
    theme = THEME.TEMPLE,
    width = 4,
    height = 4,
    file_name = "Temple-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_TEMPLE)
	
	--Shotgun
	define_tile_code("shotgun_centered")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_SHOTGUN, x, y, layer, 0, 0)
		return true
	end, "shotgun_centered")
	
	--Death Blocks
	define_tile_code("death_block")
	local death_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_blocks[#death_blocks + 1] = get_entity(block_id)
		death_blocks[#death_blocks].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_blocks[#death_blocks].more_flags = set_flag(death_blocks[#death_blocks].more_flags, 17) --Unpushable
		death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 10) --No Gravity
		--death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 6)
		return true
	end, "death_block")
	
	--Death Blocks with gravity
	define_tile_code("death_block_grav")
	local death_blocks_grav = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_blocks_grav[#death_blocks_grav + 1] = get_entity(block_id)
		death_blocks_grav[#death_blocks_grav].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_blocks_grav[#death_blocks_grav].more_flags = set_flag(death_blocks_grav[#death_blocks_grav].more_flags, 17) --Unpushable
		death_blocks_grav[#death_blocks_grav].flags = set_flag(death_blocks_grav[#death_blocks_grav].flags, 6)
		return true
	end, "death_block_grav")
	
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
		crush_trap[#crush_trap].flags = set_flag(crush_trap[#crush_trap].flags, 14)
		return true
	end, "crush_trap")
	
	define_tile_code("large_crush_trap_no_bounce")
	local no_bounce_index
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE, x + 0.5, y - 0.5, layer, 0, 0)		
		crush_trap[#crush_trap + 1] = get_entity(block_id)
		no_bounce_index = #crush_trap
		
		crush_trap_activated[#crush_trap_activated + 1] = false
		crush_trap_moved[#crush_trap_moved + 1] = false
		return true
	end, "large_crush_trap_no_bounce")
	
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
		floating_firebug.health = 3
		return true
	end, "floating_firebug")
	
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
	
	local frames = 0
	local tnt_activated = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
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
		
		for i = 1,#death_blocks_grav do
			death_blocks_grav[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks_grav[i].uid then
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
	
		crush_trap[no_bounce_index].bounce_back_timer = 0 --Prevent a particular large crush trap from bouncing off the floor
	
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x
			floating_firebug.y = firebug_y + 0.1 * math.sin(0.05 * frames)
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(temple3.title)
end

temple3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return temple3