hero_dead:
			lda hero_status
			cpi HERO_STATUS_DEATH_FADE_INIT_GB
			jz hero_dead_fade_init_gb
			cpi HERO_STATUS_DEATH_FADE_GB
			jz hero_dead_fade_gb
			cpi HERO_STATUS_DEATH_FADE_R
			jz hero_dead_fade_r
			cpi HERO_STATUS_DEATH_WAIT_SPARKER
			jz hero_dead_wait_sparker
			;cpi ACTOR_STATUS_NO_UPDATE
			;rz
			ret

hero_dead_fade_init_gb:
			KILL_ALL_MONSTERS()
			KILL_ALL_BULLETS()

			; set the status
			mvi a, HERO_STATUS_DEATH_FADE_GB
			sta hero_status

			; kill all the backs
			jmp backs_init

HERO_STATUS_DEATH_FADE_UPDATE_RATE = %00010001
HERO_STATUS_DEATH_FADE_GB_TIMER = 7
hero_dead_fade_gb:
			; fade out a pallete
			; do a palette animation only every Nth frame
@anim_rate:
			mvi a, HERO_STATUS_DEATH_FADE_UPDATE_RATE
			rrc
			sta @anim_rate + 1
			rnc

			lxi h, palette
			mvi c, PALETTE_COLORS

@fade_gb_counter:
			mvi a, HERO_STATUS_DEATH_FADE_GB_TIMER
			ora a
			jz @next_status
			dcr a
			sta @fade_gb_counter + 1

@loop_bg:
			mov a, m
			rrc
			ani %01011000
			mov b, a
			mov a, m
			ani %00000111
			ora b
			mov m, a

			inx h
			dcr c
			jnz @loop_bg

@update_palette:
			lxi h, palette_update_request
			mvi m, PALETTE_UPD_REQ_YES
			ret

@next_status:
			; reset a fade timer
			lxi h, @fade_gb_counter + 1
			mvi m, HERO_STATUS_DEATH_FADE_GB_TIMER

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_FADE_R

			; draw vfx
			; bc - vfx scrXY
			; de - vfx_anim_ptr (ex. vfx_puff)
			lxi h, hero_pos_x + 1
			mov b, m
			INX_H(2)
			mov c, m
			lxi d, vfx4_hero_death
			call vfx_init4
			ret

HERO_STATUS_DEATH_FADE_R_TIMER = 7
hero_dead_fade_r:
			HERO_UPDATE_ANIM(HERO_ANIM_SPEED_ATTACK)
			; fade out R channel
			; do a palette animation only every Nth frame
@anim_rate:
			mvi a, HERO_STATUS_DEATH_FADE_UPDATE_RATE
			rrc
			sta @anim_rate + 1
			rnc

			lxi h, palette
			mvi c, PALETTE_COLORS

@fade_r_counter:
			mvi a, HERO_STATUS_DEATH_FADE_R_TIMER
			ora a
			jz @next_status
			dcr a
			sta @fade_r_counter + 1

@loop_r:
			mov a, m
			ora a
			jz @next
			dcr m
@next:
			inx h
			dcr c
			jnz @loop_r

@update_palette:
			lxi h, palette_update_request
			mvi m, PALETTE_UPD_REQ_YES
			ret

@next_status:
			; reset a fade timer
			lxi h, @fade_r_counter + 1
			mvi m, HERO_STATUS_DEATH_FADE_R_TIMER

			; set the status
			lxi h, hero_status
			mvi m, HERO_STATUS_DEATH_WAIT_SPARKER
			;advance hl to hero_status_timer
			inx h
			mvi m, HERO_STATUS_DEATH_WAIT_SPARKER_DURATION
			; stop drawing a hero
			mvi a, HERO_RENDER_STATUS_FALSE
			sta hero_global_status_no_render

			; fill all visual buffs with thedarkers color in the current palette
			call fill_all_black

			; fill up the tile_data_buff with tiledata = 1 
			; (walkable tile, restore back, no decal)
			;lxi h, room_tiledata
			;mvi a, <room_tiledata_end
			;mvi c, 1
			;call fill_mem_short
			mvi c, 1
			call room_fill_tiledata

			; copy a palette from the ram-disk, then request for using it
			call level_init_palette

			; create an actor to move it to the right which spawns sparkle effects
			lxi h, hero_pos_x + 1
			mov b, m
			mvi m, 256 - TILE_WIDTH ; sparker the end position where it goes
			INX_H(2)
			mov c, m
			mvi m, 128
			jmp sparker_init


hero_dead_wait_sparker:
			lxi h, hero_status_timer
			dcr m
			rnz
			jmp trigger_hero_no_health
			ret