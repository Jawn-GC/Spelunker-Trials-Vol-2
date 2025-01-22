local neobabylon4 = {
    identifier = "Neo Babylon-4",
    title = "Neo Babylon-4: Blue Pill",
    theme = THEME.NEO_BABYLON,
    width = 5,
    height = 5,
    file_name = "Neo Babylon-4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon4.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = 0.1
		ent.distance = 2.0

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_BABYLON)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	--Jetpack
	define_tile_code("blue_pill")
	local blue_pill
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_JETPACK, x, y, layer, 0, 0)		
		blue_pill = get_entity(block_id)
		return true
	end, "blue_pill")
	
	--Oscillating Laser
	define_tile_code("osc_laser")
	local osc_laser
	local osc_laser_x
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		osc_laser = get_entity(block_id)
		osc_laser.flags = set_flag(osc_laser.flags, 6)
		osc_laser_x = x
		return true
	end, "osc_laser")
	
	--Permanent Horizontal Lasers
	define_tile_code("horizontal_laser")
	local horizontal_laser = {}
	local laser_on = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD, x, y, layer, 0, 0)		
		horizontal_laser[#horizontal_laser + 1] = get_entity(block_id)
		horizontal_laser[#horizontal_laser].flags = set_flag(horizontal_laser[#horizontal_laser].flags, 6)
		laser_on[#laser_on + 1] = false
		return true
	end, "horizontal_laser")
	
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
	
	--Laser Gate
	define_tile_code("laser_gate")
	local laser_gate
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate = get_entity(block_id)
		return true
	end, "laser_gate")
	
	--Laser Gate Switch
	define_tile_code("laser_switch")
	local laser_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		laser_switch = get_entity(block_id)
		return true
	end, "laser_switch")
	
	--Laser Gate 2
	define_tile_code("laser_gate2")
	local laser_gate2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate2 = get_entity(block_id)
		return true
	end, "laser_gate2")
	
	--Laser Gate Switch 2
	define_tile_code("laser_switch2")
	local laser_switch2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		laser_switch2 = get_entity(block_id)
		return true
	end, "laser_switch2")
	
	local frames = 0
	local tnt_activated = false
	local gate_deactivated = false
	local gate2_deactivated = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			osc_laser:activate_laserbeam(true)
			laser_gate:activate_laserbeam(true)
			laser_gate2:activate_laserbeam(true)
		end
	
		osc_laser.x = osc_laser_x + math.sin(0.06 * frames)
	
		if tnt_switch.timer == 90 and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
	
		if laser_switch.timer == 90 and gate_deactivated == false then
			gate_deactivated = true
			laser_gate:activate_laserbeam(false)
		end
	
		if laser_switch2.timer == 90 and gate2_deactivated == false then
			gate2_deactivated = true
			laser_gate2:activate_laserbeam(false)
		end
	
		for i = 1,#horizontal_laser do
			if horizontal_laser[i].timer > 0 and laser_on[i] == false then
				laser_on[i] = true
			end
		end
		
		for i = 1,#horizontal_laser do
			if laser_on[i] == true then
				horizontal_laser[i].timer = 2 -- Keep forcefield on
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
		
        frames = frames + 1
		
    end, ON.FRAME)
	
	toast(neobabylon4.title)
end

neobabylon4.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon4