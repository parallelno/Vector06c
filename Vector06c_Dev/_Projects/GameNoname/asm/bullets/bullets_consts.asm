; max bullets in the room
BULLETS_MAX = 9

BULLET_RUNTIME_DATA_DESTR   = $fc ; a bullet is ready to be destroyed
BULLET_RUNTIME_DATA_EMPTY   = $fd ; a bullet data is available for a new bullet
BULLET_RUNTIME_DATA_LAST    = $fe ; the end of the last existing bullet data
BULLET_RUNTIME_DATA_END     = $ff ; the end of the data

; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
BULLET_STATUS_INVIS = $ff

BULLET_DIR_R = 0
BULLET_DIR_L = 1
BULLET_DIR_U = 2
BULLET_DIR_D = 3

BOMB_SLOW_ID	= 0
BOMB_DMG_ID		= 1
SCYTHE_ID		= 2