ending_home:
			lda global_request
			sta @global_req+1
			call ending_home_init

@loop:
			; return when a user hits any option in the main menu
			lda global_request
@global_req:
			cpi TEMP_BYTE
			rnz
			ret

ending_home_init:
			ret