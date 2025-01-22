local sound = require('play_sound')

local neobabylon3 = {
    identifier = "Neo Babylon-3",
    title = "Neo Babylon-3: Fast Travel",
    theme = THEME.NEO_BABYLON,
    width = 6,
    height = 7,
    file_name = "Neo3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = 0.1
		ent.distance = 1.1

	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	local start_blocks = {}
	local end_blocks = {}
	local return_blocks = {}
	local main_laser_gates = {}
	local start_activated = {false, false, false}
	local return_activated = {false, false, false}
	
	--Tele Block Set 1
	define_tile_code("tele_block_start1")
	local index1
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local start_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		local end_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 1, y - 25, layer, 0, 0)
		local return_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 10, y - 14, layer, 0, 0)
		local gate_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x + 12, y, layer, 0, 0)
		
		start_blocks[#start_blocks + 1] = get_entity(start_id)
		end_blocks[#end_blocks + 1] = get_entity(end_id)
		return_blocks[#return_blocks + 1] = get_entity(return_id)
		main_laser_gates[#main_laser_gates + 1] = get_entity(gate_id)
		
		start_blocks[#start_blocks].color:set_rgba(150, 0, 200, 255) --Purple
		end_blocks[#end_blocks].color:set_rgba(150, 0, 200, 255)
		return_blocks[#return_blocks].color:set_rgba(150, 0, 200, 255)
		return true
	end, "tele_block_start1")
	
	--Tele Block Set 2
	define_tile_code("tele_block_start2")
	local index2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local start_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		local end_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 34, y - 39, layer, 0, 0)
		local return_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x - 4, y - 43, layer, 0, 0)
		local gate_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x + 10, y, layer, 0, 0)
		
		start_blocks[#start_blocks + 1] = get_entity(start_id)
		end_blocks[#end_blocks + 1] = get_entity(end_id)
		return_blocks[#return_blocks + 1] = get_entity(return_id)
		main_laser_gates[#main_laser_gates + 1] = get_entity(gate_id)
		
		start_blocks[#start_blocks].color:set_rgba(150, 0, 200, 255) --Purple
		end_blocks[#end_blocks].color:set_rgba(150, 0, 200, 255)
		return_blocks[#return_blocks].color:set_rgba(150, 0, 200, 255)
		return true
	end, "tele_block_start2")
	
	--Tele Block Set 3
	define_tile_code("tele_block_start3")
	local index3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local start_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		local end_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 43, y - 25, layer, 0, 0)
		local return_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x + 36, y - 9, layer, 0, 0)
		local gate_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x + 8, y, layer, 0, 0)
		
		start_blocks[#start_blocks + 1] = get_entity(start_id)
		end_blocks[#end_blocks + 1] = get_entity(end_id)
		return_blocks[#return_blocks + 1] = get_entity(return_id)
		main_laser_gates[#main_laser_gates + 1] = get_entity(gate_id)
		
		start_blocks[#start_blocks].color:set_rgba(150, 0, 200, 255) --Purple
		end_blocks[#end_blocks].color:set_rgba(150, 0, 200, 255)
		return_blocks[#return_blocks].color:set_rgba(150, 0, 200, 255)
		return true
	end, "tele_block_start3")
	
	--Laser Gate 4 Switch
	define_tile_code("laser_switch")
	local laser_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		laser_switch = get_entity(block_id)
		return true
	end, "laser_switch")
	
	--Laser Gate 4
	define_tile_code("laser_gate4")
	local laser_gate4
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate4 = get_entity(block_id)
		return true
	end, "laser_gate4")
	
	--Laser Gate 5 Switch
	define_tile_code("laser_switch2")
	local laser_switch2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		laser_switch2 = get_entity(block_id)
		return true
	end, "laser_switch2")
	
	--Laser Gate 5
	define_tile_code("laser_gate5")
	local laser_gate5
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_FORCEFIELD, x, y, layer, 0, 0)		
		laser_gate5 = get_entity(block_id)
		return true
	end, "laser_gate5")
	
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
	
	--Oscillating Spring Block
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
	
	local frames = 0
	local gate4_deactivated = false
	local gate5_deactivated = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			players[1]:remove_powerup(ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES)
		end
	
		if frames == 0 then
			for i = 1,#main_laser_gates do
				main_laser_gates[i]:activate_laserbeam(true)
			end
			laser_gate4:activate_laserbeam(true)
			laser_gate5:activate_laserbeam(true)
		end
	
		if laser_switch.timer == 90 and gate4_deactivated == false then
			gate4_deactivated = true
			laser_gate4:activate_laserbeam(false)
		end
	
		if laser_switch2.timer == 90 and gate5_deactivated == false then
			gate5_deactivated = true
			laser_gate5:activate_laserbeam(false)
		end
	
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
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
		
		spring_blocks[osc_index].x = osc_x + 2 * math.sin(0.04 * frames)
	
		--Tele Block Sets
		for i = 1,#start_blocks do
			if start_activated[i] == false then
				start_blocks[i].color:set_rgba(150 + math.ceil(40 * math.sin(0.05 * frames)), 0, 200 + math.ceil(40 * math.sin(0.05 * frames)), 255) --Pulse effect
			elseif start_activated[i] == true then
				start_blocks[i].color = Color:gray()
			end
			
			if return_activated[i] == false then
				return_blocks[i].color:set_rgba(150 + math.ceil(40 * math.sin(0.05 * frames)), 0, 200 + math.ceil(40 * math.sin(0.05 * frames)), 255) --Pulse effect
			elseif return_activated[i] == true then
				return_blocks[i].color:set_rgba(150, 0, 200, 255)
			end
			
			if #players ~= 0 and players[1].standing_on_uid == start_blocks[i].uid and start_activated[i] == false then
				start_activated[i] = true
				players[1]:perform_teleport(math.floor(end_blocks[i].x - start_blocks[i].x), math.floor(end_blocks[i].y - start_blocks[i].y))
			end
			
			if #players ~= 0 and players[1].standing_on_uid == return_blocks[i].uid and return_activated[i] == false then
				return_activated[i] = true
				players[1]:perform_teleport(math.floor(start_blocks[i].x - return_blocks[i].x), math.floor(start_blocks[i].y - return_blocks[i].y))
				main_laser_gates[i]:activate_laserbeam(false)
			end
		end
        frames = frames + 1
    end, ON.FRAME)
	
	toast(neobabylon3.title)
end

neobabylon3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon3