local neobabylon2 = {
    identifier = "Neo Babylon-2",
    title = "Neo Babylon-2: Orbit",
    theme = THEME.NEO_BABYLON,
	world = 6,
	level = 2,
    width = 5,
    height = 3,
    file_name = "Neo Babylon-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

neobabylon2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	activate_sparktraps_hack(true);

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(ent)

		ent.speed = 0.08
		ent.distance = 1.1
		ent.rotation_angle = math.pi
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SPARK)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_BABYLON)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

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

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		local x,y,l = get_position(entity.uid)
		local hh_uid = spawn(ENT_TYPE.CHAR_HIREDHAND, x, y, l, 0, 0)
		local hh = get_entity(hh_uid)
		
		hh.flags = set_flag(hh.flags, ENT_FLAG.PAUSE_AI_AND_PHYSICS)
		hh.color.a = 0
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_SPARK_TRAP)

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
        frames = frames + 1
    end, ON.FRAME)
	
	toast(neobabylon2.title)
end

neobabylon2.unload_level = function()
    if not level_state.loaded then return end
    
	activate_sparktraps_hack(false);
	
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return neobabylon2