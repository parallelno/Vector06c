; lava pool is a quest monster. it can be destroied by snowflake weapon

; statuses.
FIREPOOL_STATUS_IDLE					= 0

; status duration in updates.
FIREPOOL_STATUS_DETECT_HERO_TIME	= 50
FIREPOOL_STATUS_SHOOT_PREP_TIME		= 30
FIREPOOL_STATUS_RELAX_TIME			= 25
FIREPOOL_STATUS_MOVE_TIME			= 55

; animation speed (the less the slower, 0-255, 255 means the next frame is almost every update)
FIREPOOL_ANIM_SPEED_IDLE	= 40

; gameplay
FIREPOOL_DAMAGE = 1
FIREPOOL_HEALTH = 0

FIREPOOL_COLLISION_WIDTH	= 16
FIREPOOL_COLLISION_HEIGHT	= 16

;========================================================
; called to spawn this monster
; in:
; c - tile_idx in the room_tiledata array.
; a - monster_id * 4
; out:
; a = 0
firepool_init:
			MONSTER_INIT(firepool_update, firepool_draw, monster_impacted, FIREPOOL_HEALTH, FIREPOOL_STATUS_IDLE, vfx_firepool)

; anim and a gameplay logic update
; in:
; de - ptr to monster_update_ptr in the runtime data
firepool_update:
			; advance hl to monster_status
			LXI_H_TO_DIFF(monster_update_ptr, monster_status)
			dad d
			mov a, m
			cpi MONSTER_STATUS_FREEZE
			jz @die

			; advance hl to monster_anim_timer
			HL_ADVANCE_BY_DIFF_DE(monster_status, monster_anim_timer)
			mvi a, FIREPOOL_ANIM_SPEED_IDLE
			; hl - monster_anim_timer
			; a - anim speed
			call actor_anim_update
			MONSTER_CHECK_COLLISION_HERO(FIREPOOL_COLLISION_WIDTH, FIREPOOL_COLLISION_HEIGHT, FIREPOOL_DAMAGE)
@die:
			push h
			; play a hit vfx
			; advance hl to monster_pos_x+1
			HL_ADVANCE_BY_DIFF_DE(monster_status, monster_pos_x+1)
			mov b, m
			; advance hl to monster_pos_y+1
			INX_H(2)
			mov c, m
			lxi d, vfx4_hit
			call vfx_init4
			pop h

			; mark this monster dead
			; advance hl to monster_update_ptr+1
			HL_ADVANCE_BY_DIFF_DE(monster_status, monster_update_ptr+1)
			jmp actor_destroy

; draw a sprite into a backbuffer
; in:
; de - ptr to monster_draw_ptr in the runtime data
firepool_draw:
			MONSTER_DRAW(sprite_get_scr_addr1, __RAM_DISK_S_VFX)
