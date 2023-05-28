; source\sprites\backs.json
backs_anims:
			.word backs_torch_front, backs_flag_front, backs_dialog_press_key, 
backs_torch_front:
			.byte 3, 0 ; offset to the next frame
			.word __backs_torch_front0, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_torch_front1, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_torch_front2, 
			.byte 243, $ff ; offset to the first frame
			.word __backs_torch_front3, 
backs_flag_front:
			.byte 3, 0 ; offset to the next frame
			.word __backs_flag_front0, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_flag_front1, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_flag_front2, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_flag_front3, 
			.byte 3, 0 ; offset to the next frame
			.word __backs_flag_front2, 
			.byte 235, $ff ; offset to the first frame
			.word __backs_flag_front1, 
backs_dialog_press_key:
			.byte 3, 0 ; offset to the next frame
			.word __backs_dialog_press_key0, 
			.byte 251, $ff ; offset to the first frame
			.word __backs_dialog_press_key1, 
