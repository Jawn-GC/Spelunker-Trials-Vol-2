local jungle2 = {
    identifier = "Jungle-2",
    title = "Jungle-2: Pyromania",
    theme = THEME.JUNGLE,
    width = 4,
    height = 4,
    file_name = "Jungle-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible Jungle Floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible Stone Floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_STONE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Monkeys.
        local x, y, layer = get_position(entity.uid)
        local vines = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #vines > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MONKEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	--Powerpack
	define_tile_code("pp")
	local pp
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_POWERPACK, x, y, layer, 0, 0)		
		 pp = get_entity(block_id)
		 return true
	end, "pp")
	
	--Wooden Arrow
	define_tile_code("wooden_arrow")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_WOODEN_ARROW, x, y, layer)
		return true
	end, "wooden_arrow")
	
	--Unlit Torches 1
	define_tile_code("unlit_torch1")
	local torches1 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_WALLTORCH, x, y, layer, 0, 0)
		torches1[#torches1 + 1] = get_entity(block_id)
		return true
	end, "unlit_torch1")
	
	--Fire Blocks 1
	define_tile_code("fire_block")
	local fire_blocks1 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		fire_blocks1[#fire_blocks1 + 1] = get_entity(block_id)
		fire_blocks1[#fire_blocks1].color:set_rgba(30, 200, 60, 255) --Green
		fire_blocks1[#fire_blocks1].more_flags = set_flag(fire_blocks1[#fire_blocks1].more_flags, 17) --Unpushable
		fire_blocks1[#fire_blocks1].flags = set_flag(fire_blocks1[#fire_blocks1].flags, 10) --No Gravity
		fire_blocks1[#fire_blocks1].flags = set_flag(fire_blocks1[#fire_blocks1].flags, 6) --Indescructible
		return true
	end, "fire_block")
	
	--Unlit Torch 2
	define_tile_code("unlit_torch2")
	local torch2
	local torch2_x
	local torch2_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_WALLTORCH, x, y + 0.5, layer, 0, 0)
		torch2	= get_entity(block_id)
		torch2_x = x
		torch2_y = y + 0.5
		torch2.flags = clr_flag(torch2.flags, 13) --No Collision with walls
		return true
	end, "unlit_torch2")
	
	--Fire Blocks 2
	define_tile_code("fire_block2")
	local fire_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		fire_blocks2[#fire_blocks2 + 1] = get_entity(block_id)
		fire_blocks2[#fire_blocks2].color:set_rgba(30, 200, 60, 255) --Green
		fire_blocks2[#fire_blocks2].more_flags = set_flag(fire_blocks2[#fire_blocks2].more_flags, 17) --Unpushable
		fire_blocks2[#fire_blocks2].flags = set_flag(fire_blocks2[#fire_blocks2].flags, 10) --No Gravity
		fire_blocks2[#fire_blocks2].flags = set_flag(fire_blocks2[#fire_blocks2].flags, 6) --Indescructible
		return true
	end, "fire_block2")
	
	--Unlit Torches 3
	define_tile_code("unlit_torch3")
	local torches3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_WALLTORCH, x, y + 0.5, layer, 0, 0)
		torches3[#torches3 + 1]	= get_entity(block_id)
		return true
	end, "unlit_torch3")
	
	--Fire Blocks 3
	define_tile_code("fire_block3")
	local fire_blocks3 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		fire_blocks3[#fire_blocks3 + 1] = get_entity(block_id)
		fire_blocks3[#fire_blocks3].color:set_rgba(30, 200, 60, 150) --Green, Transparent
		fire_blocks3[#fire_blocks3].more_flags = set_flag(fire_blocks3[#fire_blocks3].more_flags, 17) --Unpushable
		fire_blocks3[#fire_blocks3].flags = set_flag(fire_blocks3[#fire_blocks3].flags, 10) --No Gravity
		fire_blocks3[#fire_blocks3].flags = clr_flag(fire_blocks3[#fire_blocks3].flags, 3) --No Collision
		fire_blocks3[#fire_blocks3].flags = clr_flag(fire_blocks3[#fire_blocks3].flags, 6) --Indescructible
		return true
	end, "fire_block3")
	
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
		floating_firebug.health = 2
		return true
	end, "floating_firebug")
	
	--Oscillating Fire Blocks 1
	define_tile_code("osc_fire_block1")
	local osc_fire_blocks1 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_fire_blocks1[#osc_fire_blocks1 + 1] = get_entity(block_id)
		osc_fire_blocks1[#osc_fire_blocks1].color:set_rgba(30, 200, 60, 255) --Green
		osc_fire_blocks1[#osc_fire_blocks1].more_flags = set_flag(osc_fire_blocks1[#osc_fire_blocks1].more_flags, 17) --Unpushable
		osc_fire_blocks1[#osc_fire_blocks1].flags = set_flag(osc_fire_blocks1[#osc_fire_blocks1].flags, 10) --No Gravity
		osc_fire_blocks1[#osc_fire_blocks1].flags = clr_flag(osc_fire_blocks1[#osc_fire_blocks1].flags, 13) --No Collision with walls
		osc_fire_blocks1[#osc_fire_blocks1].flags = clr_flag(osc_fire_blocks1[#osc_fire_blocks1].flags, 6) --Indescructible
		return true		
	end, "osc_fire_block1")
	
	--Oscillating Fire Blocks 2
	define_tile_code("osc_fire_block2")
	local osc_fire_blocks2 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_fire_blocks2[#osc_fire_blocks1 + 1] = get_entity(block_id)
		osc_fire_blocks2[#osc_fire_blocks2].color:set_rgba(30, 200, 60, 150) --Green
		osc_fire_blocks2[#osc_fire_blocks2].more_flags = set_flag(osc_fire_blocks2[#osc_fire_blocks2].more_flags, 17) --Unpushable
		osc_fire_blocks2[#osc_fire_blocks2].flags = set_flag(osc_fire_blocks2[#osc_fire_blocks2].flags, 10) --No Gravity
		osc_fire_blocks2[#osc_fire_blocks2].flags = clr_flag(osc_fire_blocks2[#osc_fire_blocks2].flags, 13) --No Collision with walls
		osc_fire_blocks2[#osc_fire_blocks2].flags = clr_flag(osc_fire_blocks2[#osc_fire_blocks2].flags, 3) --No Collision
		osc_fire_blocks2[#osc_fire_blocks2].flags = clr_flag(osc_fire_blocks2[#osc_fire_blocks2].flags, 6) --Indescructible
		return true
	end, "osc_fire_block2")
	
	--Unlit Torches 4 (for oscillating fire blocks 1 & 2)
	define_tile_code("unlit_torch4")
	local torches4 = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_WALLTORCH, x, y, layer, 0, 0)
		torches4[#torches4 + 1]	= get_entity(block_id)
		return true
	end, "unlit_torch4")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		
		if torches1[1].is_lit == true and torches1[2].is_lit == true then
			for i = 1,#fire_blocks1 do
				fire_blocks1[i].color:set_rgba(30, 180, 60, 150) --Green, Transparent
				fire_blocks1[i].flags = clr_flag(fire_blocks1[i].flags, 3) --No Collision
			end
		end
		
		torch2.x = torch2_x + math.sin(0.05 * frames)
		torch2.y = torch2_y
		
		if torch2.is_lit == true then
			for i = 1,#fire_blocks2 do
				fire_blocks2[i].color:set_rgba(30, 180, 60, 150) --Green, Transparent
				fire_blocks2[i].flags = clr_flag(fire_blocks2[i].flags, 3) --No Collision
			end
		end
		
		if torches3[1].is_lit == true or torches3[2].is_lit == true then
			for i = 1,#fire_blocks3 do
				fire_blocks3[i].color:set_rgba(30, 180, 60, 255) --Green
				fire_blocks3[i].flags = set_flag(fire_blocks3[i].flags, 3) --Collision
			end
		end
		
		if torches4[1].is_lit == true and torches4[2].is_lit == true then
			for i = 1,#osc_fire_blocks1 do
				osc_fire_blocks1[i].color:set_rgba(30, 180, 60, 150) --Green, Transparent
				osc_fire_blocks1[i].flags = clr_flag(fire_blocks3[i].flags, 3) --No Collision
			end
			
			for i = 1,#osc_fire_blocks2 do
				osc_fire_blocks2[i].color:set_rgba(30, 180, 60, 255) --Green, Transparent
				osc_fire_blocks2[i].flags = set_flag(fire_blocks3[i].flags, 3) --No Collision
			end
		end
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x
			floating_firebug.y = firebug_y + 0.1 * math.sin(0.05 * frames)
		end
		
		osc_fire_blocks1[1].velocityy = 0.15 * math.cos(0.05 * frames)
		osc_fire_blocks2[1].velocityy = 0.15 * math.cos(0.05 * frames)
		
		frames = frames + 1
    end, ON.FRAME)
	
	toast(jungle2.title)
end

jungle2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return jungle2