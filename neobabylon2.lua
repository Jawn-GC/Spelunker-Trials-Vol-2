local neobabylon2 = {
    identifier = "Neo Babylon-2",
    title = "Neo Babylon-2: Slick",
    theme = THEME.NEO_BABYLON,
    width = 4,
    height = 4,
    file_name = "Neo Babylon-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = 0.08
		ent.distance = 1.1

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_BABYLON)
	
	--Climbing Gloves
	define_tile_code("climbers")
	local climbers
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, x, y, layer, 0, 0)		
		 climbers = get_entity(block_id)
		 climbers.color:set_rgba(210, 100, 255, 255)
		 return true
	end, "climbers")
	
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
	
	--TNT Switch
	define_tile_code("tnt_switch")
	local tnt_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch = get_entity(block_id)
		return true
	end, "tnt_switch")
	
	--TNT Switch 2
	define_tile_code("tnt_switch2")
	local tnt_switch2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch2 = get_entity(block_id)
		return true
	end, "tnt_switch2")
	
	--TNT Block
	define_tile_code("tnt")
	local tnt
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y, layer, 0, 0)		
		tnt = get_entity(block_id)
		return true
	end, "tnt")
	
	--Laser Gate
	define_tile_code("laser_gate")
	local laser_gate
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate = get_entity(block_id)
		return true
	end, "laser_gate")
	
	--Laser Gate
	define_tile_code("laser_gate_timed")
	local laser_gate_timed = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate_timed[#laser_gate_timed + 1] = get_entity(block_id)
		return true
	end, "laser_gate_timed")
	
	--Laser Gate Switch
	define_tile_code("laser_switch")
	local laser_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		laser_switch = get_entity(block_id)
		return true
	end, "laser_switch")
	
	local frames = 0
	local switch1_activated = false
	local switch2_activated = false
	local tnt_activated = false
	local gate_deactivated = false
	local timed_laser_gate_on = true
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			laser_gate:activate_laserbeam(true)
		end
	
		if #players > 0 and players[1].state == CHAR_STATE.HANGING and entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES) then
			players[1].y = players[1].y - 0.025
		end
	
		if tnt_switch.timer == 90 and switch1_activated == false then
			switch1_activated = true
		end
	
		if tnt_switch2.timer == 90 and switch2_activated == false then
			switch2_activated = true
		end
	
		if switch1_activated == true and switch2_activated == true and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
	
		if laser_switch.timer == 90 and gate_deactivated == false then
			gate_deactivated = true
			laser_gate:activate_laserbeam(false)
		end
	
		if frames % 60 == 0 then
			timed_laser_gate_on = not timed_laser_gate_on
		end
	
		for i = 1,#laser_gate_timed do
			laser_gate_timed[i]:activate_laserbeam(timed_laser_gate_on)
		end
		
        frames = frames + 1
    end, ON.FRAME)
	
	toast(neobabylon2.title)
end

neobabylon2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon2