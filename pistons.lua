local sound = require('play_sound')

local plates = {}         -- {plate_uid, pressed, rx, ry} with its base_uid as key
local sinking_blocks = {} -- {block_uid, start_y, target_y, rx, ry, is_sinking} with its base_uid as key

local function create_custom_texture(filename, w ,h)
	local tex_def = TextureDefinition.new()
	tex_def.texture_path = f'Data/Textures/{filename}'
	tex_def.width = w
	tex_def.height = h
	tex_def.tile_width = 128
	tex_def.tile_height = 128
	return define_texture(tex_def)
end

local tex_sinking_block = create_custom_texture("Sinking_Block.png", 128, 128)
-- local tex_sinking_block_base_up = create_custom_texture("Sinking_Block_Base_Default.png", 128, 128)
local tex_sinking_block_base_up = create_custom_texture("Sinking_Block_Base_Up.png", 128, 128)
local tex_sinking_block_base_down = create_custom_texture("Sinking_Block_Base_Down.png", 128, 128)
local tex_pressure_plate_base_active = create_custom_texture("Pressure_Plate_Base_Active", 128, 128)
local tex_pressure_plate_base_inactive = create_custom_texture("Pressure_Plate_Base_Inactive", 128, 128)
local tex_pressure_plate_button = create_custom_texture("Pressure_Plate_Button", 512, 128)

IGNORED_ENTITIES = { -- Entities that should not trigger the pressure plates
	[ENT_TYPE.ACTIVEFLOOR_BONEBLOCK] = true,
	[ENT_TYPE.ACTIVEFLOOR_BUSHBLOCK] = true,
	[ENT_TYPE.ITEM_BLOOD] = true,
	[ENT_TYPE.ITEM_RUBBLE] = true,
	[ENT_TYPE.ITEM_WHIP] = true,
	[ENT_TYPE.ITEM_WHIP_FLAME] = true,
	[ENT_TYPE.ITEM_CLIMBABLE_ROPE] = true,
	[ENT_TYPE.ITEM_UNROLLED_ROPE] = true,
	[ENT_TYPE.ITEM_WEB] = true,
	[ENT_TYPE.ITEM_WEBSHOT] = true,
	[ENT_TYPE.ITEM_SPARK] = true,
	[ENT_TYPE.ITEM_FIREBALL] = true,
	[ENT_TYPE.ITEM_ACIDSPIT] = true,
	[ENT_TYPE.ITEM_INKSPIT] = true,
	[ENT_TYPE.ITEM_WALLTORCH] = true,
	[ENT_TYPE.ITEM_WALLTORCHFLAME] = true,
	[ENT_TYPE.ITEM_LITWALLTORCH] = true,
	[ENT_TYPE.ITEM_AUTOWALLTORCH] = true,
	[ENT_TYPE.ITEM_TORCHFLAME] = true,
	[ENT_TYPE.ITEM_LAMPFLAME] = true,
	[ENT_TYPE.ITEM_BULLET] = true,
	[ENT_TYPE.ITEM_PLASMACANNON_SHOT] = true,
	[ENT_TYPE.ITEM_FREEZERAYSHOT] = true,
	[ENT_TYPE.ITEM_CLONEGUNSHOT] = true,
	[ENT_TYPE.ITEM_TURKEY_NECK] = true,
	[ENT_TYPE.MONS_MEGAJELLYFISH] = true,
	[ENT_TYPE.MONS_MEGAJELLYFISH_BACKGROUND] = true,
	[ENT_TYPE.MONS_WITCHDOCTORSKULL] = true,
	[ENT_TYPE.MONS_GHIST] = true,
	[ENT_TYPE.MONS_GHIST_SHOPKEEPER ] = true,
	[ENT_TYPE.MONS_GHOST] = true,
	[ENT_TYPE.MONS_GHOST_MEDIUM_SAD] = true,
	[ENT_TYPE.MONS_GHOST_MEDIUM_HAPPY] = true,
	[ENT_TYPE.MONS_GHOST_SMALL_ANGRY] = true,
	[ENT_TYPE.MONS_GHOST_SMALL_SAD] = true,
	[ENT_TYPE.MONS_GHOST_SMALL_SURPRISED] = true,
	[ENT_TYPE.MONS_GHOST_SMALL_HAPPY] = true,
	[ENT_TYPE.MONS_CRITTERDUNGBEETLE] = true,
	[ENT_TYPE.MONS_CRITTERBUTTERFLY] = true,
	[ENT_TYPE.MONS_CRITTERSNAIL] = true,
	[ENT_TYPE.MONS_CRITTERFISH] = true,
	[ENT_TYPE.MONS_CRITTERANCHOVY] = true,
	[ENT_TYPE.MONS_CRITTERCRAB] = true,
	[ENT_TYPE.MONS_CRITTERLOCUST] = true,
	[ENT_TYPE.MONS_CRITTERPENGUIN] = true,
	[ENT_TYPE.MONS_CRITTERFIREFLY] = true,
	[ENT_TYPE.MONS_CRITTERDRONE] = true,
	[ENT_TYPE.MONS_CRITTERSLIME] = true
}

define_tile_code("mj3gc_pressure_plate")
define_tile_code("mj3gc_sinking_block")

set_pre_tile_code_callback(function(x, y, layer)
	local base_uid = spawn_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, layer, 0, 0)
    local plate_uid = spawn_entity(ENT_TYPE.ITEM_ROCK, x, y + 1, layer, 0, 0)

	local base_ent = get_entity(base_uid)
	base_ent:set_texture(tex_pressure_plate_base_inactive)

	local plate_ent = get_entity(plate_uid)
	plate_ent.flags = set_flag(plate_ent.flags, ENT_FLAG.PAUSE_AI_AND_PHYSICS)
	plate_ent:set_texture(tex_pressure_plate_button)
	plate_ent.animation_frame = 0

	local rx, ry = get_room_index(x, y)
	plates[base_uid] = {
		plate_uid = plate_uid,
		pressed = false,
		rx = rx,
		ry = ry
	}

    return true
end, "mj3gc_pressure_plate")

set_pre_tile_code_callback(function(x, y, layer)
	local base_uid = spawn_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, layer, 0, 0)
	local block_uid = spawn_entity(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y + 1, layer, 0, 0)
	
	local base_ent = get_entity(base_uid)
	base_ent:set_texture(tex_sinking_block_base_up)
	
	local block_ent = get_entity(block_uid)
	block_ent:set_texture(tex_sinking_block)
	block_ent.flags = clr_flag(block_ent.flags, ENT_FLAG.COLLIDES_WALLS)
	block_ent.flags = set_flag(block_ent.flags, ENT_FLAG.NO_GRAVITY)
	block_ent.flags = set_flag(block_ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)
	block_ent.more_flags = set_flag(block_ent.more_flags, ENT_MORE_FLAG.DISABLE_INPUT)

	local rx, ry = get_room_index(x, y)
	sinking_blocks[base_uid] = {
		block_uid = block_uid,
		start_y = y + 1.0,
		target_y = y,
		rx = rx,
		ry = ry,
		is_sinking = false,
    }
    
    return true
end, "mj3gc_sinking_block")

set_callback(function()
	local scan_mask = MASK.PLAYER | MASK.MONSTER | MASK.ITEM | MASK.ACTIVEFLOOR | MASK.MOUNT
	local room_pressed_state = {}

	for base_uid, data in pairs(plates) do
		local base_ent = get_entity(base_uid)
		local plate_ent = get_entity(data.plate_uid)

		if base_ent == nil and plate_ent ~= nil then
			plate_ent.flags = clr_flag(plate_ent.flags, ENT_FLAG.PAUSE_AI_AND_PHYSICS)
			plate_ent:destroy()
			plate_ent = nil
		elseif base_ent ~= nil and plate_ent == nil then
			base_ent:destroy()
			base_ent = nil
		end

		if base_ent == nil or plate_ent == nil then
			plates[base_uid] = nil
		else
			local hitbox = get_hitbox(base_uid)
			hitbox.left = hitbox.left + 0.15
			hitbox.right = hitbox.right - 0.15
			hitbox.bottom = hitbox.top
			hitbox.top = hitbox.top + 0.2

			local hit_ents = get_entities_overlapping_hitbox(0, scan_mask, hitbox, base_ent.layer)
			local is_pressed = false

			for _, hit_uid in ipairs(hit_ents) do
				local hit_ent = get_entity(hit_uid)
				
				if hit_uid ~= base_uid and hit_uid ~= data.plate_uid then
					if hit_ent ~= nil and not IGNORED_ENTITIES[hit_ent.type.id] then
						is_pressed = true
						break
					end
				end
			end

			data.pressed = is_pressed

			if is_pressed then
				if plate_ent.animation_frame < 3 then
					plate_ent.animation_frame = plate_ent.animation_frame + 1
				end
			else
				if plate_ent.animation_frame > 0 then
					plate_ent.animation_frame = plate_ent.animation_frame - 1
				end
			end

			if is_pressed then
				base_ent:set_texture(tex_pressure_plate_base_active)
				local room_key = tostring(data.rx) .. "_" .. tostring(data.ry)
				room_pressed_state[room_key] = true
			else
				base_ent:set_texture(tex_pressure_plate_base_inactive)
			end
		end
	end

	for base_uid, data in pairs(sinking_blocks) do
		local base_ent = get_entity(base_uid)
		local block_ent = get_entity(data.block_uid)

		if base_ent == nil and block_ent ~= nil then
			block_ent:destroy()
			block_ent = nil
		elseif base_ent ~= nil and block_ent == nil then
			base_ent:destroy()
			base_ent = nil
		end

		if base_ent == nil or block_ent == nil then
            sinking_blocks[base_uid] = nil
        else
			local room_key = tostring(data.rx) .. "_" .. tostring(data.ry)
			local should_sink = room_pressed_state[room_key] or false

			local bx, by, bl = get_position(data.block_uid)
			local speed = 0.05
			
			if should_sink and not data.is_sinking then
				sound.play_sound(VANILLA_SOUND.TRAPS_TIKI_TRIGGER, base_uid)
			elseif not should_sink and data.is_sinking then
				sound.play_sound(VANILLA_SOUND.TRAPS_TIKI_TRIGGER, base_uid)
			end
			
			if should_sink then
				data.is_sinking = true
				if by > data.target_y then
					block_ent.velocityy = -speed
					base_ent:set_texture(tex_sinking_block_base_down)
				else
					move_entity(data.block_uid, bx, data.target_y, 0, 0)
				end
			else
				data.is_sinking = false
				if by < data.start_y then
					block_ent.velocityy = speed
					base_ent:set_texture(tex_sinking_block_base_up)
				else
					move_entity(data.block_uid, bx, data.start_y, 0, 0)
				end
			end
		end
	end
end, ON.FRAME)

set_callback(function()
	plates = {}
	sinking_blocks = {}
end, ON.PRE_LEVEL_GENERATION)