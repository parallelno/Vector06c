; hl points to actor_status_timer
; out:
; hl points to actor_pos_x+1
.macro ACTOR_UPDATE_MOVEMENT(actor_status_timer, actorSpeedY)
 			; hl - ptr to actor_status_timer
			; advance hl to actorSpeedY+1
			HL_ADVANCE_BY_DIFF_BC(actorSpeedY+1, actor_status_timer)
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
; hl points to actor_pos_y+1
; uses:
; bc, de, hl, a
; TODO: think of converting it into func. it saves > 492 bytes
.macro ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(actor_status_timer, actor_pos_x, ACTOR_COLLISION_WIDTH, ACTOR_COLLISION_HEIGHT, collision_handler) 
			HL_ADVANCE_BY_DIFF_BC(actor_pos_x, actor_status_timer)
			push h ; (stack) <- pos_x ptr, to restore it in @apply_new_pos
			; bc <- pos_x
			mov c, m
			inx h
			mov b, m
			inx h
			; stack <- pos_y
			mov e, m
			inx h
			mov d, m
			inx h
			push d
			; de <- speed_x
			mov e, m
			inx h
			mov d, m
			inx h
			; (new_pos_x) <- pos_x + speed_x
			xchg
			dad b
			shld @new_pos_x + 1
			mov a, h ; pos_x + speed_x for checking a collision
			xchg
			; hl points to speed_y
			; de <- speed_y
			mov e, m
			inx h
			mov d, m
			; (new_pos_y) <- pos_y + speed_y
			xchg
			pop b
			dad b
			shld @new_pos_y + 1
			; a - pos_x + speed_x
			; hl - pos_y + speed_y
			; de - points to speed_y+1

			; check the collision tiles
			
			mov d, a
			mov e, h
			; check if X<TILE_WIDTH or > ROOM_WIDTH * TILE_WIDTH - TILE_WIDTH
			cpi TILE_WIDTH
			jc collision_handler
			cpi ROOM_WIDTH * TILE_WIDTH - TILE_WIDTH
			jnc collision_handler
			; check if Y<TILE_HEIGHT or > ROOM_HEIGHT * TILE_HEIGHT - TILE_HEIGHT
			mov a, e
			cpi TILE_HEIGHT
			jc collision_handler
			cpi ROOM_HEIGHT * TILE_HEIGHT - TILE_HEIGHT
			jnc collision_handler

			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			; de - pos_xy
			; bc - width, height
			call room_get_collision_tiledata
			ani TILEDATA_COLLIDABLE
			jnz collision_handler

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