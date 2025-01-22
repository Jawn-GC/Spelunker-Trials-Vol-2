local jungle1 = {
    identifier = "Jungle-1",
    title = "Jungle-1: 1001 Thorns",
    theme = THEME.JUNGLE,
    width = 4,
    height = 4,
    file_name = "Jungle-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

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
	
	--Floating Firebug 2
	define_tile_code("floating_firebug2")
	local floating_firebug2
	local firebug2_x
	local firebug2_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y, layer, 0, 0)
		floating_firebug2 = get_entity(block_id)
		firebug2_x = x
		firebug2_y = y
		floating_firebug2.flags = set_flag(floating_firebug2.flags, 10)
		floating_firebug2.flags = set_flag(floating_firebug2.flags, 17)
		floating_firebug2.health = 2
		return true
	end, "floating_firebug2")
	
	--Floating Firebug 3
	define_tile_code("floating_firebug3")
	local floating_firebug3
	local firebug3_x
	local firebug3_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x + 0.5, y, layer, 0, 0)
		floating_firebug3 = get_entity(block_id)
		firebug3_x = x + 0.5
		firebug3_y = y
		floating_firebug3.flags = set_flag(floating_firebug3.flags, 10)
		floating_firebug3.flags = set_flag(floating_firebug3.flags, 17)
		floating_firebug3.flags = clr_flag(floating_firebug3.flags, 13)
		floating_firebug3.health = 2
		return true
	end, "floating_firebug3")
	
	--Floating Firebug 4
	define_tile_code("floating_firebug4")
	local floating_firebug4
	local firebug4_x
	local firebug4_y
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y + 0.5, layer, 0, 0)
		floating_firebug4 = get_entity(block_id)
		firebug4_x = x
		firebug4_y = y + 0.5
		floating_firebug4.flags = set_flag(floating_firebug4.flags, 10)
		floating_firebug4.flags = set_flag(floating_firebug4.flags, 17)
		floating_firebug4.flags = clr_flag(floating_firebug4.flags, 13)
		floating_firebug4.health = 2
		return true
	end, "floating_firebug4")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			players[1].more_flags = clr_flag(players[1].more_flags, 15)
		end
		
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x
			floating_firebug.y = firebug_y + 0.1 * math.sin(0.05 * frames)
		end

		if floating_firebug2.flags == 1074878016 then
			floating_firebug2.x = firebug2_x + 2 * math.sin(0.05 * frames)
			floating_firebug2.y = firebug2_y
		end
		
		if floating_firebug3.flags == 1074873920 then
			floating_firebug3.x = firebug3_x + 1.4 * math.sin(0.05 * frames)
			floating_firebug3.y = firebug3_y
		end	
		
		if floating_firebug4.flags == 1074808384 then
			floating_firebug4.x = firebug4_x
			floating_firebug4.y = firebug4_y + 2.5 * math.sin(0.04 * frames)
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(jungle1.title)
end

jungle1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return jungle1