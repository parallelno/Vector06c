	; this line for VSCode proper formating
BREAKABLE_SPAWN_RATE_MAX	= 255
BREAKABLE_SPAWN_RATE_DELTA	= 256/8 ; destroying 8 breakable items makes their spawning chance = 255 - BREAKABLE_SPAWN_RATE_MAX
MONSTER_SPAWN_RATE_MAX		= 250
MONSTER_SPAWN_RATE_DELTA	= 256/16

RESOURCE_COIN_VAL			= 5
RESOURCE_POTION_RED_VAL		= 5
RESOURCE_POTION_BLUE_VAL	= 25

CABBAGE_HEALH_VAL			= 1

GAME_REQ_ROOM_INIT	= 0 | GAME_REQ
GAME_REQ_LEVEL_INIT	= 1 | GAME_REQ
GAME_REQ_PAUSE		= 2 | GAME_REQ
GAME_REQ_ROOM_DRAW	= 3 | GAME_REQ
GAME_REQ_END_HOME		= 4 | GAME_REQ
