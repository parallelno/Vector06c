; we are here when a hero does not collide with colladable tiles, and there is no tiledata_func_id>0 round
hero_no_collision_no_tiledata:
			lhld char_temp_x
			shld hero_pos_x
			lhld char_temp_y
			shld hero_pos_y
			ret

; we are here when a hero does not collides with collidable tiles, but there is some tiledata around, ex. teleport
hero_no_collision:
			lhld char_temp_x
			shld hero_pos_x
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

hero_check_collision_top_left:
			lda char_temp_x+1
			; get the inverted offset_x inside the tile
			cma
			ani %00001111
			mov c, a
			lda char_temp_y+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offset_y inside the tile
			ani %00001111
			cmp c
			jz hero_move_tile_br
			jnc hero_move_tile_r
			jmp hero_move_tile_b

hero_check_collision_top_right:
			lda char_temp_x+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda char_temp_y+1
			adi HERO_COLLISION_HEIGHT-1
			; get the offset inside the tile
			ani %00001111
			cmp c
			jz hero_move_tile_bl
			jc hero_move_tile_b
			jmp hero_move_tile_l

hero_check_collision_bottom_left:
			lda char_temp_x+1
			; get the offset inside the tile
			cma
			ani %00001111
			mov c, a
			lda char_temp_y+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz hero_move_tile_tr
			jc hero_move_tile_t
			jmp hero_move_tile_r

hero_check_collision_bottom_right:
			lda char_temp_x+1
			adi HERO_COLLISION_WIDTH-1
			; get the offset inside the tile
			ani %00001111
			mov c, a
			lda char_temp_y+1
			; get the offset inside the tile
			cma
			ani %00001111
			cmp c
			jz hero_move_tile_tl
			jc hero_move_tile_t
			jmp hero_move_tile_l

; move the hero to the right out of of the collided tile
hero_move_tile_r:
			lda char_temp_x+1
			stc		; to move outside the current tile
			adc c
			sta hero_pos_x+1
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

; move the hero under the collided tile
hero_move_tile_b:
			lhld char_temp_x
			shld hero_pos_x
			mov c, a
			lda char_temp_y+1
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the bottom-right corner of the collided tile
hero_move_tile_br:
			lxi h, char_temp_x+1
			stc		; to move outside the current tile
			adc m
			sta hero_pos_x+1
			INX_H(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the left out of of the collided tile
hero_move_tile_l:
			lda char_temp_x+1
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_x+1
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata

; move the hero to the bottom-left corner of the collided tile
hero_move_tile_bl:
			lxi h, char_temp_x+1
			sub m
			cma
			sta hero_pos_x+1
			INX_H(2)
			mov a, m
			stc		; to move outside the current tile
			sbb c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero on top of the collided tile
hero_move_tile_t:
			lhld char_temp_x
			shld hero_pos_x
			mov c, a
			lda char_temp_y+1
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the top-right corner of the collided tile
hero_move_tile_tr:
			lxi h, char_temp_x+1
			stc		; to move outside the current tile
			adc m
			sta hero_pos_x+1
			INX_H(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; move the hero to the top-left corner of the collided tile
hero_move_tile_tl:
			lxi h, char_temp_x+1
			sub m
			cma
			sta hero_pos_x+1
			INX_H(2)
			mov a, m
			stc		; to move outside the current tile
			adc c
			sta hero_pos_y+1
			jmp hero_check_tiledata

; when the hero runs into a tile from top or bottom, move him only horizontally
hero_move_horizontally:
			; do not move vertically
			lhld char_temp_x
			shld hero_pos_x
			jmp hero_check_tiledata

; when the hero runs into a tile from left or right, move him only vertically
hero_move_vertically:
			; do not move horizontally
			lhld char_temp_y
			shld hero_pos_y
			jmp hero_check_tiledata
