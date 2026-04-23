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
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SKELETON)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_BONES)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
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
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)
	
	define_tile_code("floating_firebug")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local bug_id = spawn(ENT_TYPE.MONS_FIREBUG_UNCHAINED, x, y, layer, 0, 0)
		local bug = get_entity(bug_id)
		bug.flags = set_flag(bug.flags, ENT_FLAG.FACING_LEFT)
		bug.user_data = {x = x, y = y}
		
		if bug ~= nil then
			bug:set_post_update_state_machine(function(self)
				bug.x = bug.user_data.x
				bug.y = bug.user_data.y
			end)
		end
		
		return true
	end, "floating_firebug")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			players[1].more_flags = clr_flag(players[1].more_flags, 15)
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