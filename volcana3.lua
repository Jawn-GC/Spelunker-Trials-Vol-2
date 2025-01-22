local sound = require('play_sound')

local volcana3 = {
    identifier = "Volcana-3",
    title = "Volcana-3: Rapid Fire",
    theme = THEME.VOLCANA,
    width = 5,
    height = 5,
    file_name = "Volcana-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible Vlad floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_VLAD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Magmamen.
        local x, y, layer = get_position(entity.uid)
        local lavas = get_entities_at(0, MASK.LAVA, x, y, layer, 1)
        if #lavas > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MAGMAMAN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Firebugs.
        local x, y, layer = get_position(entity.uid)
        local chains = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #chains > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREBUG)
	
	local rockdog
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        --Tame Rockdog
		--Set its health to one
		rockdog = entity
        entity:tame(true)
		entity.health = 1
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_ROCKDOG)
	
	--Thorns
	local thorns = {}
	define_tile_code("thorns")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.FLOOR_THORN_VINE, x, y, layer, 0, 0)
		thorns[#thorns + 1] = get_entity(block_id)
		return true
	end, "thorns")
	
	--Unfalling Platform
	define_tile_code("stable_platform")
	local stable_platforms = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM, x, y, layer, 0, 0)
		stable_platforms[#stable_platforms+1] = get_entity(block_id)
		stable_platforms[#stable_platforms].flags = set_flag(stable_platforms[#stable_platforms].flags, 10)
		stable_platforms[#stable_platforms].shaking_factor = 0.01
		stable_platforms[#stable_platforms].color:set_rgba(190, 160, 210, 255) --Light Purple
		return true
	end, "stable_platform")
	
	--Oscillating Unfalling Platform
	define_tile_code("osc_stable_platform")
	local osc_stable_platform
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_stable_platform = get_entity(block_id)
		osc_stable_platform.flags = set_flag(osc_stable_platform.flags, 10)
		osc_stable_platform.color:set_rgba(0, 100, 255, 255) --Light Blue
		return true
	end, "osc_stable_platform")
	
	--Oscillating Unfalling Platform 2
	define_tile_code("osc_stable_platform2")
	local osc_stable_platform2
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		osc_stable_platform2 = get_entity(block_id)
		osc_stable_platform2.flags = set_flag(osc_stable_platform2.flags, 10)
		osc_stable_platform2.color:set_rgba(0, 100, 255, 255) --Light Blue
		return true
	end, "osc_stable_platform2")
	
	--Oscillating Lift
	define_tile_code("osc_lift")
	local osc_lift = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		local block_id2 = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x+1, y, layer, 0, 0)
		osc_lift[#osc_lift+1] = get_entity(block_id)
		osc_lift[#osc_lift+1] = get_entity(block_id2)
		
		osc_lift[1].flags = clr_flag(osc_lift[1].flags, 3)
		osc_lift[1].flags = set_flag(osc_lift[1].flags, 10)
		osc_lift[1].flags = clr_flag(osc_lift[1].flags, 13)
		osc_lift[1].color:set_rgba(255, 40, 0, 150) --Red, Transparent
		
		osc_lift[2].flags = clr_flag(osc_lift[2].flags, 3)
		osc_lift[2].flags = set_flag(osc_lift[2].flags, 10)
		osc_lift[2].flags = clr_flag(osc_lift[2].flags, 13)
		osc_lift[2].color:set_rgba(255, 40, 0, 150) --Red, Transparent
		return true
	end, "osc_lift")
	
	local frames = 0
	local frames_reset = 0
	local x_door
	local y_door
	local secret_door_spawned = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
        frames = frames + 1
		
		if frames == 1 then
			x_door = rockdog.x
			y_door = rockdog.y
		end
		
		if off == true then
			frames_reset = 0
		elseif off == false then
			frames_reset = frames_reset + 1
		end
		
		--Secret Door Conditions
		if #players ~= 0 and players[1].x < 14 and players[1].x > 4 and players[1].y < 93 and players[1].y > 87 and off == false and frames_reset > 180 and secret_door_spawned == false then
			secret_door_spawned = true
			spawn(ENT_TYPE.BG_DOOR_FRONT_LAYER, x_door, y_door, 0, 0, 0)
			spawn(ENT_TYPE.FLOOR_DOOR_LAYER, x_door, y_door, 0, 0, 0)
			sound.play_sound(VANILLA_SOUND.UI_SECRET)
		end
		
		--Rapid Fire
		if rockdog.attack_cooldown == 47 then
			rockdog.attack_cooldown = 10
		end
		
		for i = 1,#thorns do
			if rockdog.standing_on_uid == thorns[i].uid then
				kill_entity(rockdog.uid, false)
			end
		end
		
		for i = 1,#stable_platforms do
			stable_platforms[i].timer = -1 --Prevents bottom of platform from hurting the player after activation (unless the platform is moving)
		end
		
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 20
			end
		end
		
		if off == true and switch_hit == true then
			switch_hit = false
			off = false
			
			for i = 1,#switches do
				switches[i].color:set_rgba(255, 40, 0, 255) --Red
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks[i].flags = clr_flag(blue_blocks[i].flags, 3) --No Collision
			end
			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red		
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3) --Collision
			end
			
			osc_stable_platform.color:set_rgba(0, 100, 255, 150) --Light Blue
			osc_stable_platform.flags = clr_flag(osc_stable_platform.flags, 3)
			
			osc_stable_platform2.color:set_rgba(0, 100, 255, 150) --Light Blue
			osc_stable_platform2.flags = clr_flag(osc_stable_platform2.flags, 3)
			
			osc_lift[1].flags = set_flag(osc_lift[1].flags, 3)
			osc_lift[1].color:set_rgba(255, 40, 0, 255) --Red, Transparent
		
			osc_lift[2].flags = set_flag(osc_lift[2].flags, 3)
			osc_lift[2].color:set_rgba(255, 40, 0, 255) --Red, Transparent
			
		elseif off == false and switch_hit == true then
			switch_hit = false
			off = true
			
			for i = 1,#switches do
				switches[i].color:set_rgba(0, 100, 255, 255) --Light Blue
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_blocks[i].flags = set_flag(blue_blocks[i].flags, 3) --Collision
			end

			
			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 3) --No Collision
			end
			
			osc_stable_platform.color:set_rgba(0, 100, 255, 255) --Light Blue
			osc_stable_platform.flags = set_flag(osc_stable_platform.flags, 3)
			
			osc_stable_platform2.color:set_rgba(0, 100, 255, 255) --Light Blue
			osc_stable_platform2.flags = set_flag(osc_stable_platform2.flags, 3)			
						
			osc_lift[1].flags = clr_flag(osc_lift[1].flags, 3)
			osc_lift[1].color:set_rgba(255, 40, 0, 150) --Red, Transparent
		
			osc_lift[2].flags = clr_flag(osc_lift[2].flags, 3)
			osc_lift[2].color:set_rgba(255, 40, 0, 150) --Red, Transparent
		end
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
		osc_stable_platform.velocityy = 0.15 * math.sin(0.075 * frames)
		osc_stable_platform2.velocityx = 0.15 * math.sin(0.075 * frames)
		
		osc_lift[1].velocityy = 0.1 * math.sin(0.05 * frames)
		osc_lift[2].velocityy = 0.1 * math.sin(0.05 * frames)
    end, ON.FRAME)
	
	toast(volcana3.title)
end

volcana3.unload_level = function()
    if not level_state.loaded then return end
	
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
	
	switch_hit = false
	off = true
	switches = {}
	blue_blocks = {}
	red_blocks = {}
end

return volcana3