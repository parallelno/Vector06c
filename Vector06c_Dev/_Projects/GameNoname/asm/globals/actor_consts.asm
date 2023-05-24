	; this line for VSCode proper formating
; statuses.
; TODO: optimize. use a lastRemovedMonsterRuntimeDataPtr as a starter to find empty data
ACTOR_RUNTIME_DATA_DESTR  = $fc ; an actor's runtime data is ready to be destroyed
ACTOR_RUNTIME_DATA_EMPTY  = $fd ; an actor's runtime data is available for a new actor
ACTOR_RUNTIME_DATA_LAST   = $fe ; the end of the last existing actor's runtime data
ACTOR_RUNTIME_DATA_END    = $ff ; the end of the actor's runtime data

; a status describes what set of animations and behavior is active
; for ex. HERO_STATUS_ATTACK plays hero_attk_r or hero_attk_l depending on the direction and it spawns a weapon trail
;ACTOR_STATUS_INVIS = $ff
ACTOR_STATUS_BIT_INVIS = %1000_0000
ACTOR_STATUS_BIT_BLINK = %0100_0000