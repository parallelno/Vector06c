; max monsters in the room
MONSTERS_MAX = 15
; monster types
MONSTER_TYPE_ENEMY = 0
MONSTER_TYPE_ALLY = 1

MONSTER_RUNTIME_DATA_DESTR = $fc ; a monster is ready to be destroyed
MONSTER_RUNTIME_DATA_EMPTY = $fd ; a monster data is available for a new monster
MONSTER_RUNTIME_DATA_LAST = $fe ; the end of the last existing monster data
MONSTER_RUNTIME_DATA_END = $ff ; the end of the data

; statuses.
; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
MONSTER_STATUS_INVIS = $ff
