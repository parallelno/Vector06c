	; this line for VSCode proper formating
; statuses.
; TODO: optimize. use a lastRemovedMonsterRuntimeDataPtr as a starter to find empty data
;ACTOR_RUNTIME_DATA_ALIVE < $fc
ACTOR_RUNTIME_DATA_DESTR  = $fc ; an actor's runtime data is ready to be destroyed
ACTOR_RUNTIME_DATA_EMPTY  = $fd ; an actor's runtime data is available for a new actor
ACTOR_RUNTIME_DATA_LAST	  = $fe ; the end of the last existing actor's runtime data
ACTOR_RUNTIME_DATA_END	  = $ff ; the end of the actor's runtime data

; a global statuses that is used outside of the actor logic update.
; for ex. to skip rendering making the actor invisible, or make it blink every second frame
ACTOR_STATUS_BIT_INVIS			= %1000_0000
ACTOR_STATUS_BIT_BLINK			= %0100_0000
ACTOR_STATUS_BIT_NON_GAMEPLAY	= %0010_0000 ; non gameplay statuses can be combined with ACTOR_STATUS_BIT_NON_GAMEPLAY to make the status checking faster
ACTOR_STATUS_NO_UPDATE			= %1110_0000