	; 
HERO_RUN_SPEED		= $0200 ; low byte is a subpixel speed, high byte is a speed in pixels
HERO_RUN_SPEED_N	= $ffff - HERO_RUN_SPEED + 1
HERO_RUN_SPEED_D	= $016a ; for diagonal moves

HERO_RUN_SPEED_IMPACTED		= $0300 ; low byte is a subpixel speed, high byte is a speed in pixels
HERO_RUN_SPEED_IMPACTED_N	= $ffff - HERO_RUN_SPEED_IMPACTED + 1

HERO_DIR_HORIZ_MASK		= %0011
HERO_DIR_HORIZ_RESET	= %0100
HERO_DIR_RIGHT			= %0011
HERO_DIR_LEFT			= %0010
HERO_DIR_VERT_MASK		= %1100
HERO_DIR_VERT_RESET		= %0001
HERO_DIR_UP				= %1100
HERO_DIR_DOWN			= %1000


; hero statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_r_attk or hero_l_attk depending on the direction and it spawns a weapon trail
HERO_STATUS_IDLE			= 0
HERO_STATUS_ATTACK			= 1
HERO_STATUS_MOVE			= 2
HERO_STATUS_INVINCIBLE		= 3 | ACTOR_STATUS_BIT_BLINK
HERO_STATUS_IMPACTED		= 4 | ACTOR_STATUS_BIT_BLINK

HERO_STATUS_DEATH				= 0 | ACTOR_STATUS_BIT_NON_GAMEPLAY
HERO_STATUS_DEATH_FADE_INIT_GB	= 1 | ACTOR_STATUS_BIT_NON_GAMEPLAY
HERO_STATUS_DEATH_FADE_GB		= 2 | ACTOR_STATUS_BIT_NON_GAMEPLAY
HERO_STATUS_DEATH_FADE_R		= 3 | ACTOR_STATUS_BIT_NON_GAMEPLAY | ACTOR_STATUS_BIT_INVIS
HERO_STATUS_DEATH_WAIT_SPARKER		= 4 | ACTOR_STATUS_BIT_NON_GAMEPLAY | ACTOR_STATUS_BIT_INVIS

; duration of statuses (in updateDurations)
HERO_STATUS_ATTACK_DURATION		= 12
HERO_STATUS_INVINCIBLE_DURATION	= 20
HERO_STATUS_IMPACTED_DURATION	= 5
HERO_STATUS_DEATH_WAIT_SPARKER_DURATION	= 35

; animation speed (the less the slower, 0-255, 255 means next frame every update)
HERO_ANIM_SPEED_MOVE	= 65
HERO_ANIM_SPEED_IDLE	= 4
HERO_ANIM_SPEED_ATTACK	= 160

; gameplay
HERO_HEALTH_MAX = 8

HERO_COLLISION_WIDTH = 15
HERO_COLLISION_HEIGHT = 11
