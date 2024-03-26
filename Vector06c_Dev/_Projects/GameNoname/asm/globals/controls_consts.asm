	; this line for VSCode proper formating

	// Keyboard encoding matrix:
	//              columns
	//     │ 7   6   5   4   3   2   1   0
	// ────┼───────────────────────────────
	//   7 │SPC  ^   ]   \   [   Z   Y   X
	//   6 │ W   V   U   T   S   R   Q   P
	// r 5 │ O   N   M   L   K   J   I   H
	// o 4 │ G   F   E   D   C   B   A   @
	// w 3 │ /   .   =   ,   ;   :   9   8
	// s 2 │ 7   6   5   4   3   2   1   0
	//   1 │F5  F4  F3  F2  F1  AR2 STR LDA, // LDA - is a left diagonal arrow
	//   0 │DN  RT  UP  LFT ZAB VK  PS  TAB


    // mvi a, KEY_CODE_ROW_N
	// in  2 ; sets the row to check
	// out 3 ; outputs columns pressed. 0xff if pressed nothing

KEY_CODE_ROW_0	= <~(1<<0)
KEY_CODE_ROW_1	= <~(1<<1)
KEY_CODE_ROW_2	= <~(1<<2)
KEY_CODE_ROW_3	= <~(1<<3)
KEY_CODE_ROW_4	= <~(1<<4)
KEY_CODE_ROW_5	= <~(1<<5)
KEY_CODE_ROW_6	= <~(1<<6)
KEY_CODE_ROW_7	= <~(1<<7)
; key codes:
KEY_CODE_NO		= $ff
; key row 0
KEY_CODE_TAB	= <~(1<<0) ; (клавиша ТАБ на клавиатуре Вектор 06ц), CONTROL_CODE_RETURN - return or to show the in-game return_menu)
KEY_CODE_ALT	= <~(1<<1) ; (клавиша ПС на клавиатуре Вектор 06ц), CONTROL_CODE_FIRE2 - in-game weapon select 
KEY_CODE_ENTER	= <~(1<<2) ; (клавиша ВК на клавиатуре Вектор 06ц)
KEY_CODE_DEL	= <~(1<<3) ; (клавиша ЗАБ на клавиатуре Вектор 06ц)
KEY_CODE_LEFT	= <~(1<<4)
KEY_CODE_UP		= <~(1<<5)
KEY_CODE_RIGHT	= <~(1<<6)
KEY_CODE_DOWN	= <~(1<<7)
; key row 7
KEY_CODE_X			= <~(1<<0)
KEY_CODE_Y			= <~(1<<1)
KEY_CODE_Z			= <~(1<<2)
KEY_CODE_S_BRAKET_L	= <~(1<<3)
KEY_CODE_BACKSLASH	= <~(1<<4)
KEY_CODE_S_BRAKET_R	= <~(1<<5)
KEY_CODE_CARET		= <~(1<<6)
KEY_CODE_SPACE		= <~(1<<7) ; CONTROL_CODE_FIRE1

; joy_code formats:
; 	joystick "P": ABxxDULR (bit = 0 means pressed)
; 	joystick "C": BAxxDULR (bit = 0 means pressed)
; 	joystick "USPID": URDLABxx (bit = 1 means pressed)
; where:
;	A - fire 1 key
;	B - fire 2 key
;	U - up key
;	D - down key
;	L - left key
;	R - right key
;	x - N/A
JOY_CODE_RIGHT	= <~(1<<0)
JOY_CODE_LEFT	= <~(1<<1)
JOY_CODE_UP		= <~(1<<2)
JOY_CODE_DOWN	= <~(1<<3)
JOY_CODE_FIRE2	= <~(1<<6)
JOY_CODE_FIRE1	= <~(1<<7)

CONTROL_CODE_NO			= 0

CONTROL_CODE_RIGHT		= <(1<<0)
CONTROL_CODE_LEFT		= <(1<<1)
CONTROL_CODE_UP			= <(1<<2)
CONTROL_CODE_DOWN		= <(1<<3)
CONTROL_CODE_RETURN		= <(1<<4)
CONTROL_CODE_KEY_SPACE	= <(1<<5) ; always binds to a key_code_space
CONTROL_CODE_FIRE2		= <(1<<6)
CONTROL_CODE_FIRE1		= <(1<<7)

CONTROL_PRESET_KEYBOARD = 0
CONTROL_PRESET_JOYSTICK = 1