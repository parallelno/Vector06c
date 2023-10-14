; hl - ptr to actor_status_timer
; out:
; hl - ptr to actor_pos_x+1
.macro ACTOR_UPDATE_MOVEMENT(actor_status_timer, actor_speed_y)
 			; hl - ptr to actor_status_timer
			; advance hl to actor_speed_y+1
			HL_ADVANCE_BY_DIFF_BC(actor_status_timer, actor_speed_y+1)
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
; TODO: think of converting it into a func. each macro takes 492 bytes
.macro ACTOR_UPDATE_MOVEMENT_CHECK_TILE_COLLISION(actor_status_timer, actor_pos_x, ACTOR_COLLISION_WIDTH, ACTOR_COLLISION_HEIGHT, collision_handler) 
			HL_ADVANCE_BY_DIFF_BC(actor_status_timer, actor_pos_x)
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
			; check if X<TILE_WIDTH or > ROOM_WIDTH * TILE_WIDTH - TILE_WIDTH
			cpi TILE_WIDTH
			jc @collided
			cpi ROOM_WIDTH * TILE_WIDTH - TILE_WIDTH
			jnc @collided
			; check if Y<TILE_HEIGHT or > ROOM_HEIGHT * TILE_HEIGHT - TILE_HEIGHT
			mov a, e
			cpi TILE_HEIGHT
			jc @collided
			cpi ROOM_HEIGHT * TILE_HEIGHT - TILE_HEIGHT
			jnc @collided


			; check the collision with a collidable tiles
			lxi b, (ACTOR_COLLISION_WIDTH-1)<<8 | ACTOR_COLLISION_HEIGHT-1
			; de - pos_xy
			; bc - width, height
			call room_get_collision_tiledata
			ani TILEDATA_COLLIDABLE
			jz @apply_new_pos

@collided:	pop h
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