local tidepool3 = {
    identifier = "Tidepool-3",
    title = "Tidepool-3: Effervescence",
    theme = THEME.TIDE_POOL,
    width = 5,
    height = 3,
    file_name = "Tidepool-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	--Tiamat Bubbles
	define_tile_code("bubble")
	local x_pos
	local y_pos
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		x_pos = x
		y_pos = y
		return true
	end, "bubble")
	
	--Blockade
	define_tile_code("blockade")
	local tnt
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		local block_id2 = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y + 1, layer, 0, 0)
		local block_id3 = spawn(ENT_TYPE.ACTIVEFLOOR_TIMEDPOWDERKEG, x, y + 2, layer, 0, 0)
		local block_id4 = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y + 3, layer, 0, 0)
		
		local pushblock = get_entity(block_id)
		pushblock.flags = set_flag(pushblock.flags, 10)
		
		 tnt = get_entity(block_id2)
		 return true
	end, "blockade")
	
	--TNT Switch
	define_tile_code("tnt_switch")
	local tnt_switch
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		tnt_switch = get_entity(block_id)
		return true
	end, "tnt_switch")
	
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
	
	local frames = 0
	local off = true
	local tnt_activated = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			players[1]:remove_powerup(ENT_TYPE.ITEM_POWERUP_SPRING_SHOES)
		end
	
		if tnt_switch.timer == 90 and tnt_activated == false then
			tnt_activated = true
			tnt.timer = 1
		end
	
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 20 --Reduce wait time after hitting switch
			end
		end
	
		if frames % 150 == 0 then
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos, y_pos, 0, 0, 0)
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 9, y_pos, 0, 0, 0)
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos - 5, y_pos + 5, 0, 0, 0)
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 24, y_pos + 4, 0, 0, 0)
		end
		
		if (frames - 40) > 0 and (frames - 40) % 150 == 0 then
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 4, y_pos + 11, 0, 0, 0)
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 14, y_pos + 11, 0, 0, 0)
			
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 30, y_pos, 0, 0, 0)
			spawn(ENT_TYPE.ACTIVEFLOOR_BUBBLE_PLATFORM, x_pos + 32, y_pos, 0, 0, 0)
		end
		
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(tidepool3.title)
end

tidepool3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool3