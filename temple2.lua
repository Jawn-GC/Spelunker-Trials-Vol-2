local sound = require('play_sound')

local temple2 = {
    identifier = "Temple-2",
    title = "Temple-2: Echo",
    theme = THEME.TEMPLE,
	world = 5,
	level = 2,
    width = 6,
    height = 4,
    file_name = "Temple-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

temple2.load_level = function()
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
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_TEMPLE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_STONE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity.inside = ENT_TYPE.FX_SHADOW
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_POT)

	local torch_on = false
	local torch
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		torch = entity
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_AUTOWALLTORCH)
	
	local frames = 0
	local player_info = {} --elements are {x, y, layer, texture, animation frame, direction facing}
	local clones = {}
	local i_frames = 0
	local ghost_touched = {}
	local DELAY = 1
	local NUM_CLONES = 1
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		if torch.is_lit then
			if #players ~= 0 then
				local px, py, pl = get_position(players[1].uid)
				local pt = players[1]:get_texture()
				local pa = players[1].animation_frame
				local pf = test_flag(players[1].flags, ENT_FLAG.FACING_LEFT)
				table.insert(player_info, 1, {px, py, pl, pt, pa, pf})
			end
			
			if frames == 0 then	
				for i = 1,NUM_CLONES do
					clones[#clones + 1] = spawn(ENT_TYPE.ITEM_ROCK, player_info[1][1], player_info[1][2], player_info[1][3], 0, 0)
					ghost_touched[#ghost_touched + 1] = false
				end

				for i = 1,#clones do
					get_entity(clones[i]).flags = set_flag(get_entity(clones[i]).flags,ENT_FLAG.PAUSE_AI_AND_PHYSICS)
					get_entity(clones[i]).flags = clr_flag(get_entity(clones[i]).flags,ENT_FLAG.PICKUPABLE)
					get_entity(clones[i]):set_texture(player_info[1][4])
					get_entity(clones[i]).animation_frame = player_info[1][5]
					get_entity(clones[i]).color.a = 0
				end
			end
			
			for i = 1,#clones do
				local threshold = DELAY * 60 * i
				
				if frames == threshold then
					get_entity(clones[i]).color.a = 0.7
					generate_world_particles(PARTICLEEMITTER.ALTAR_SMOKE, clones[i])
					sound.play_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
				end

				if #player_info >= threshold and get_entity(clones[i]) ~= nil then
					get_entity(clones[i]).x = player_info[threshold][1]
					get_entity(clones[i]).y = player_info[threshold][2]
					get_entity(clones[i]):set_layer(player_info[threshold][3])
					get_entity(clones[i]):set_texture(player_info[threshold][4])
					get_entity(clones[i]).animation_frame = player_info[threshold][5]
					if player_info[threshold][6] then
						get_entity(clones[i]).flags = set_flag(get_entity(clones[i]).flags, ENT_FLAG.FACING_LEFT)
					else
						get_entity(clones[i]).flags = clr_flag(get_entity(clones[i]).flags, ENT_FLAG.FACING_LEFT)
					end
				end

				if #players ~= 0 and get_entity(clones[i]) ~= nil and players[1]:overlaps_with(get_entity(clones[i])) and players[1].layer == get_entity(clones[i]).layer and players[1].state ~= CHAR_STATE.ENTERING and players[1].state ~= CHAR_STATE.EXITING and frames > threshold and i_frames == 0 and ghost_touched[i] == false then
					players[1]:damage(-1, 1, 0, 0, 0, 60)
					i_frames = 60
				end
				
				if #players ~= 0 and (players[1].state == CHAR_STATE.ENTERING or players[1].state == CHAR_STATE.EXITING) then
					i_frames = 60
				end
			end

			if #players ~= 0 and i_frames > 0 then
				i_frames = i_frames - 1
			end

			frames = frames + 1
		end
	end, ON.FRAME)

	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		frames = 0
		i_frames = 0
		clones = {}
		player_info = {}
		ghost_touched = {}
	end, ON.PRE_LEVEL_GENERATION)
	
	toast(temple2.title)
end

temple2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return temple2