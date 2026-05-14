local tidepool2 = {
    identifier = "Tidepool-2",
    title = "Tidepool-2: Jumpman",
    theme = THEME.TIDE_POOL,
	world = 4,
	level = 2,
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
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:set_cursed(true, false)
		entity.flags = clr_flag(entity.flags, ENT_FLAG.FACING_LEFT)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_OCTOPUS)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
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