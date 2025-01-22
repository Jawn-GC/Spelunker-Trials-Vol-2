local sunkencity1 = {
    identifier = "Sunken City-1",
    title = "Sunken City-1: Bittersweet",
    theme = THEME.SUNKEN_CITY,
    width = 4,
    height = 4,
    file_name = "Sunken City-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

sunkencity1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snakes to stand on thorns
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
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if floating_firebug.flags == 1074878016 then
			floating_firebug.x = firebug_x + math.sin(0.05 * frames)
			floating_firebug.y = firebug_y
		end
	
        frames = frames + 1
    end, ON.FRAME)
	
	toast(sunkencity1.title)
end

sunkencity1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return sunkencity1