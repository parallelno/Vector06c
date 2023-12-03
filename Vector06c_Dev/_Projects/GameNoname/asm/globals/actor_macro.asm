; hl - ptr to actor_status_timer
; out:
; hl - ptr to actor_pos_x+1
.macro ACTOR_UPDATE_MOVEMENT(actor_status_timer, actor_speed_y)
 			; hl - ptr to actor_status_timer
			; advance hl to actor_speed_y+1
			HL_ADVANCE(actor_status_timer, actor_speed_y+1, BY_BC)
			; bc <- speed_y
			mov b, m
			dcx h
			mov c, m
			dcx h
			; stack <- speed_x
			mov d, m
			dcx h
			mov e, m
			dcx h
			push d
			; de <- pos_y
			mov d, m
			dcx h
			mov e, m
			; (pos_y) <- pos_y + speed_y
			xchg
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
			DCX_H(2)
			; hl points to speed_x+1
			; de <- pos_x
			mov d, m
			dcx h
			mov e, m
			; (pos_x) <- pos_x + speed_x
			xchg
			pop b
			dad b
			xchg
			mov m, e
			inx h 
			mov m, d
.endmacro

; in:
; hl points to actor_status_timer
; out:
; if no collision: hl points to actor_pos_y+1 
; if a collision: hl points to actor_pos_x 
; uses:
; bc, de, hl, a
; TODO: it is 492 bytes long. think of converting it into a func. it can ponetially save +3.5K bytes
.macro ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(actor_status_timer, actor_pos_x, ACTOR_COLLISION_WIDTH, ACTOR_COLLISION_HEIGHT, collision_handler) 
			HL_ADVANCE(actor_status_timer, actor_pos_x, BY_BC)
			push h ; (stack) <- pos_x ptr, to restore it in @apply_new_pos
			mov c, m
			inx h
			mov b, m
			inx h
			; bc = pos_x
			mov e, m
			inx h
			mov d, m
			inx h
			push d
			; stack <- pos_y			
			mov e, m
			inx h
			mov d, m
			inx h
			; de = speed_x
			xchg
			dad b
			shld @new_pos_x + 1 ; temp store new_pos_x
			mov a, h 
			; a - >new_pos_x for checking a collision
			xchg
			; hl points to speed_y
			mov e, m
			inx h
			mov d, m
			; de <- speed_y			
			xchg
			pop b
			; bc - pos_y
			dad b
			shld @new_pos_y + 1 ; temp store new_pos_y
			; a - >new_pos_x for checking a collision
			; hl - new_pos_y
			; de - ptr to speed_y+1

			; check the collision tiles
			mov d, a
			mov e, h
			; a - >new_pos_x
			; d - >new_pos_x
			; e - >new_pos_y

			; check the collision with a border of the screen
			; check the X coord
			cpi TILE_WIDTH
			jc @collided
			cpi ROOM_WIDTH * TILE_WIDTH - TILE_WIDTH - ACTOR_COLLISION_WIDTH
			jnc @collided
			; check if the Y coord
			mov a, e
			cpi TILE_HEIGHT
			jc @collided
			cpi ROOM_HEIGHT * TILE_HEIGHT - TILE_HEIGHT - ACTOR_COLLISION_HEIGHT
			jnc @collided


			; check the collision with a collidable tiles
			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			; de - pos_xy
			; bc - width, height
			call room_get_collision_tiledata
			ani TILEDATA_COLLIDABLE
			jz @apply_new_pos

@collided:	pop h
			; hl points to pos_x
			jmp collision_handler

@apply_new_pos:
			pop h
			; hl points to pos_x
@new_pos_x:	lxi d, TEMP_WORD
@new_pos_y:	lxi b, TEMP_WORD
			; store a new pos_x
			mov m, e
			inx h
			mov m, d
			inx h
			; store a new pos_y
			mov m, c
			inx h
			mov m, b
.endmacro


; replaces the actor runtime data with a marker 
; indicating that there is no actor runtime data here and beyond
; used mostly for erasing all runtime data
.macro ACTOR_ERASE_RUNTIME_DATA(actor_update_ptr)
			lxi h, actor_update_ptr + 1
			mvi m, ACTOR_RUNTIME_DATA_LAST
.endmacro

; marks the actor's runtime data as it's going to be destroyed
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fill up lastRemovedBulletRuntimeDataPtr
.macro ACTOR_DESTROY()
			mvi m, ACTOR_RUNTIME_DATA_DESTR
.endmacro


; marks the actor runtime data as empty
; in:
; hl - update_ptr+1 ptr
; TODO: optimize. fiil up lastRemovedBulletRuntimeDataPtr
.macro ACTOR_EMPTY()
			mvi m, ACTOR_RUNTIME_DATA_EMPTY
.endmacro
/*
; draw an actor sprite into a backbuffer
; ex. ACTOR_DRAW(sprite_get_scr_addr_scythe, __RAM_DISK_S_SCYTHE)
; requires  (bullet_status - bullet_pos_x+1) == (monster_status - monster_pos_x+1)
; requires (bullet_pos_y+1 - bullet_anim_ptr) == (monster_pos_y+1 - monster_anim_ptr)
; requires (bullet_erase_scr_addr+1 - bullet_erase_wh) == (monster_erase_scr_addr+1 - monster_erase_wh)
; in:
; de - ptr to actor_draw_ptr 
; TODO: try to convert it into a function
.macro ACTOR_DRAW(sprite_get_scr_addr_actor, __ram_disk_s, check_invis = true)
			; validation

		.if !((bullet_status - bullet_pos_x+1) == (monster_status - monster_pos_x+1))
			.error "actor_erase func fails because !((bullet_status - bullet_pos_x+1) == (monster_status - monster_pos_x+1))"
		.endif
		.if !((bullet_pos_y+1 - bullet_anim_ptr) == (monster_pos_y+1 - monster_anim_ptr))
			.error "actor_erase func fails because !((bullet_pos_y+1 - bullet_anim_ptr) == (monster_pos_y+1 - monster_anim_ptr))"
		.endif
		.if !((bullet_erase_scr_addr+1 - bullet_erase_wh) == (monster_erase_scr_addr+1 - monster_erase_wh))
			.error "actor_erase func fails because !((bullet_erase_scr_addr+1 - bullet_erase_wh) == (monster_erase_scr_addr+1 - monster_erase_wh))"
		.endif

        .if check_invis
			; advance to bullet_status
			HL_ADVANCE(bullet_draw_ptr, bullet_status)
			mov a, m
			ani ACTOR_STATUS_BIT_INVIS
			rnz

			HL_ADVANCE(bullet_status, bullet_pos_x+1, BY_DE)
		.endif 
		.if check_invis == false
			HL_ADVANCE(bullet_draw_ptr, bullet_pos_x+1, BY_HL_FROM_D)
		.endif
			; hl - ptr to bullet_pos_x+1
			call sprite_get_scr_addr_actor
			; de - sprite screen addr
			; c - preshifted sprite idx*2 offset based on pos_x then +2
			; hl - ptr to pos_y+1
			mov a, c ; temp
			; advance to bullet_anim_ptr
			HL_ADVANCE(bullet_pos_y+1, bullet_anim_ptr, BY_BC)
			mov b, m
			inx h
			push h
			mov h, m
			mov l, b
			mov c, a
			; hl - anim_ptr
			; c - preshifted sprite idx*2 offset
			call sprite_get_addr
			
			CALL_RAM_DISK_FUNC(__draw_sprite_vm, __ram_disk_s | __RAM_DISK_M_DRAW_SPRITE_VM | RAM_DISK_M_8F)
			pop h
			inx h
			; hl - ptr to bullet_erase_scr_addr
			; store the current scr addr, into bullet_erase_scr_addr
			mov m, c
			inx h
			mov m, b
			; advance to bullet_erase_wh
			HL_ADVANCE(bullet_erase_scr_addr+1, bullet_erase_wh, BY_BC)
			; store a width and a height into bullet_erase_wh
			mov m, e
			inx h
			mov m, d
			ret
.endmacro
*/