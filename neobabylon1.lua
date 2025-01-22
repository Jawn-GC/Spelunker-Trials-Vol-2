local sound = require('play_sound')

local neobabylon1 = {
    identifier = "Neo Babylon-1",
    title = "Neo Babylon-1: Launch",
    theme = THEME.NEO_BABYLON,
    width = 4,
    height = 4,
    file_name = "Neo Babylon-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_BABYLON)
	
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
	
	--Oscillating Spring Block 1
	define_tile_code("osc_spring_block")
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
	
	--Oscillating Spring Block 3
	define_tile_code("osc_spring_block3")
	local osc_index3
	local osc_y3
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y + 0.5, layer, 0, 0)
		spring_blocks[#spring_blocks + 1] = get_entity(block_id)
		spring_blocks[#spring_blocks].color:set_rgba(150, 255, 150, 255) --Light Green
		spring_blocks[#spring_blocks].more_flags = set_flag(spring_blocks[#spring_blocks].more_flags, 17) --Unpushable
		spring_blocks[#spring_blocks].flags = set_flag(spring_blocks[#spring_blocks].flags, 10) --No Gravity
		spring_blocks[#spring_blocks].flags = clr_flag(spring_blocks[#spring_blocks].flags, 13)
		osc_index3 = #spring_blocks
		osc_y3 = y + 0.5
		return true
	end, "osc_spring_block3")
	
	--Oscillating Spring Block 4
	define_tile_code("osc_spring_block4")
	local osc_index4
	local osc_x4
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		spring_blocks[#spring_blocks + 1] = get_entity(block_id)
		spring_blocks[#spring_blocks].color:set_rgba(150, 255, 150, 255) --Light Green
		spring_blocks[#spring_blocks].more_flags = set_flag(spring_blocks[#spring_blocks].more_flags, 17) --Unpushable
		spring_blocks[#spring_blocks].flags = set_flag(spring_blocks[#spring_blocks].flags, 10) --No Gravity
		spring_blocks[#spring_blocks].flags = clr_flag(spring_blocks[#spring_blocks].flags, 13)
		osc_index4 = #spring_blocks
		osc_x4 = x
		return true
	end, "osc_spring_block4")
	
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
	
	--Horizontal Laser
	define_tile_code("horizontal_laser")
	local laser
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD, x, y, layer, 0, 0)		
		laser = get_entity(block_id)
		return true
	end, "horizontal_laser")
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	local frames = 0
	local tnt_activated = false
	local laser_on = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if tnt_switch.timer == 90 and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
	
		if laser.timer > 0 and laser_on == false then
			laser_on = true
		end
		
		if laser_on == true then
			laser.timer = 2 -- Keep forcefield on
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
		spring_blocks[osc_index2].x = osc_x2 + 2 * math.sin(0.04 * frames)
		spring_blocks[osc_index3].y = osc_y3 + 1.5 * -math.sin(0.04 * frames)
		spring_blocks[osc_index4].x = osc_x4 + 1 * math.sin(0.04 * frames)
		
        frames = frames + 1
    end, ON.FRAME)
	
	toast(neobabylon1.title)
end

neobabylon1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon1