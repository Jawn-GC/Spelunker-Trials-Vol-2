local tidepool2 = {
    identifier = "Tidepool-2",
    title = "Tidepool-2: Jumpman",
    theme = THEME.TIDE_POOL,
    width = 3,
    height = 7,
    file_name = "Tidepool-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
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
	
	--Oscillating Death Blocks 2
	define_tile_code("osc_death_block2")
	local osc_death_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_death_blocks2[#osc_death_blocks2 + 1] = get_entity(block_id)
		osc_death_blocks2[#osc_death_blocks2].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks2[#osc_death_blocks2].flags = set_flag(osc_death_blocks2[#osc_death_blocks2].flags, 10) -- No Gravity
		osc_death_blocks2[#osc_death_blocks2].flags = clr_flag(osc_death_blocks2[#osc_death_blocks2].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block2")
	
	--Oscillating Death Blocks 3
	define_tile_code("osc_death_block3")
	local osc_death_blocks3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y + 0.5, layer, 0, 0)
		osc_death_blocks3[#osc_death_blocks3 + 1] = get_entity(block_id)
		osc_death_blocks3[#osc_death_blocks3].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks3[#osc_death_blocks3].flags = set_flag(osc_death_blocks3[#osc_death_blocks3].flags, 10) -- No Gravity
		osc_death_blocks3[#osc_death_blocks3].flags = clr_flag(osc_death_blocks3[#osc_death_blocks3].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block3")
	
	--Oscillating Death Blocks 4
	define_tile_code("osc_death_block4")
	local osc_death_blocks4 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_death_blocks4[#osc_death_blocks4 + 1] = get_entity(block_id)
		osc_death_blocks4[#osc_death_blocks4].color:set_rgba(100, 0, 0, 255) --Dark Red
		osc_death_blocks4[#osc_death_blocks4].flags = set_flag(osc_death_blocks4[#osc_death_blocks4].flags, 10) -- No Gravity
		osc_death_blocks4[#osc_death_blocks4].flags = clr_flag(osc_death_blocks4[#osc_death_blocks4].flags, 13)-- No collision with walls
		return true
	end, "osc_death_block4")
	
	--Spring Shoes
	define_tile_code("springs")
	local springs
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, x, y, layer, 0, 0)		
		 springs = get_entity(block_id)
		 return true
	end, "springs")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		for i = 1,#osc_death_blocks2 do
			osc_death_blocks2[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks2[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		for i = 1,#osc_death_blocks3 do
			osc_death_blocks3[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks3[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		for i = 1,#osc_death_blocks4 do
			osc_death_blocks4[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == osc_death_blocks4[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
	
		for i = 1,#osc_death_blocks do
			osc_death_blocks[i].velocityy = 0.08 * -math.sin(0.04 * frames)
		end
	
		for i = 1,#osc_death_blocks2 do
			osc_death_blocks2[i].velocityx = 0.16 * math.sin(0.04 * frames)
		end
	
		for i = 1,#osc_death_blocks3 do
			osc_death_blocks3[i].velocityy = 0.1 * math.cos(0.06 * frames)
		end
	
		for i = 1,#osc_death_blocks4 do
			osc_death_blocks4[i].velocityy = 0.1 * -math.cos(0.05 * frames)
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(tidepool2.title)
end

tidepool2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool2