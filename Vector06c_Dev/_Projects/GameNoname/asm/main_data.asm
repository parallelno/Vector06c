main_screens_call_ptrs:
			.word func_ret			; GLOBAL_REQ_NONE		= 0
			.word main_menu			; GLOBAL_REQ_MAIN_MENU	= 1
			.word main_game			; GLOBAL_REQ_GAME		= 2
			.word settings_screen	; GLOBAL_REQ_OPTIONS	= 3
			.word scores_screen		; GLOBAL_REQ_SCORES		= 4
			.word credits_screen	; GLOBAL_REQ_CREDITS	= 5
			.word ending_home		; GLOBAL_REQ_END_HOME	= 6