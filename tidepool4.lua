local tidepool4 = {
    identifier = "Tidepool-4",
    title = "Tidepool-4: Pursuit",
    theme = THEME.TIDE_POOL,
    width = 3,
    height = 7,
    file_name = "Tidepool-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity.flags = clr_flag(entity.flags, 18)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_WOODEN_ARROW)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 14)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SNAP_TRAP)
	
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
	
	--Death Floor
	define_tile_code("death_floor")
	local death_floor = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_floor[#death_floor + 1] = get_entity(block_id)
		death_floor[#death_floor].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_floor[#death_floor].more_flags = set_flag(death_floor[#death_floor].more_flags, 17) --Unpushable
		death_floor[#death_floor].flags = set_flag(death_floor[#death_floor].flags, 10) --No Gravity
		death_floor[#death_floor].flags = set_flag(death_floor[#death_floor].flags, 6)
		death_floor[#death_floor].flags = clr_flag(death_floor[#death_floor].flags, 13)
		return true
	end, "death_floor")
	
	--Death Floor Switch
	define_tile_code("floor_switch")
	local floor_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		floor_switch = get_entity(block_id)
		return true
	end, "floor_switch")
	
	--Floating Firebug
	define_tile_code("floating_firebug")
	local floating_firebug
	local firebug_x
	local firebug_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y - 0.5, layer, 0, 0)
		floating_firebug = get_entity(block_id)
		firebug_x = x
		firebug_y = y - 0.5
		floating_firebug.flags = set_flag(floating_firebug.flags, 10)
		floating_firebug.flags = set_flag(floating_firebug.flags, 17)
		floating_firebug.health = 2
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
	
	--TNT Switch 2
	define_tile_code("tnt_switch2")
	local tnt_switch2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch2 = get_entity(block_id)
		return true
	end, "tnt_switch2")
	
	--TNT Block 2
	define_tile_code("tnt2")
	local tnt2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y, layer, 0, 0)		
		tnt2 = get_entity(block_id)
		return true
	end, "tnt2")
	
	--TNT Switch 3
	define_tile_code("tnt_switch3")
	local tnt_switch3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch3 = get_entity(block_id)
		return true
	end, "tnt_switch3")
	
	--TNT Block 3
	define_tile_code("tnt3")
	local tnt3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y, layer, 0, 0)		
		tnt3 = get_entity(block_id)
		return true
	end, "tnt3")
	
	local frames = 0
	local floor_activated = false
	local tnt_activated = false
	local tnt2_activated = false
	local tnt3_activated = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		if floor_switch.timer == 90 and floor_activated == false then
			floor_activated = true
		end
		
		if tnt_switch.timer == 90 and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
		
		if tnt_switch2.timer == 90 and tnt2_activated == false then
			tnt2_activated = true
			tnt2.timer = 1
		end
		
		if tnt_switch3.timer == 90 and tnt3_activated == false then
			tnt3_activated = true
			tnt3.timer = 1
		end
		
		if floor_activated == true then
			for i = 1,#death_floor do
				if death_floor[1].y < 115 then
					death_floor[i].velocityy = 0.035
				elseif death_floor[1].y >= 115 then
					death_floor[i].velocityy = 0
				end
			end
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
		
		for i = 1,#death_floor do
			death_floor[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_floor[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x
			floating_firebug.y = firebug_y + 0.1 * math.sin(0.05 * frames)
		end
		
        frames = frames + 1
    end, ON.FRAME)
	
	toast(tidepool4.title)
end

tidepool4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool4