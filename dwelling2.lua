local dwelling2 = {
    identifier = "Dwelling-2",
    title = "Dwelling-2: Fetch Quest",
    theme = THEME.DWELLING,
    width = 6,
    height = 3,
    file_name = "Dwelling-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Horned Lizard to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
		entity.flags = clr_flag(entity.flags, 12)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Unpushable Blocks
		entity.more_flags = set_flag(entity.more_flags, 17)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	--Rope Pile
	define_tile_code("ropes")
	local rope
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_ROPEPILE, x, y, layer, 0, 0)		
		rope = get_entity(block_id)
		return true
	end, "ropes")
	
	toast(dwelling2.title)
end

dwelling2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling2
