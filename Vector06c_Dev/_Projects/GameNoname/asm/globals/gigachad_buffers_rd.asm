GC_PLAYER_TASKS = 14
GC_PLAYER_STACK_SIZE = 16
GC_PLAYER_BUFFER_SIZE = $100

gcplayer_buffer = $10000 - GC_PLAYER_BUFFER_SIZE * GC_PLAYER_TASKS
GCPlayerTaskStack = gcplayer_buffer - GC_PLAYER_STACK_SIZE * GC_PLAYER_TASKS

; array of task stack pointers. GCPlayerTaskSPs[i] = taskSP
GCPlayerTaskSPs = GCPlayerTaskStack - GC_PLAYER_TASKS * WORD_LEN
GCPlayerTaskSPsEnd = GCPlayerTaskStack

; a pointer to a current task sp. *GCPlayerCurrentTaskSPp = GCPlayerTaskSPs[currentTask]
GCPlayerCurrentTaskSPp = GCPlayerTaskSPs - WORD_LEN;
__gigachad_buffers = GCPlayerCurrentTaskSPp

; task stacks
GCPlayerTaskStack00 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 0
GCPlayerTaskStack01 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 1
GCPlayerTaskStack02 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 2
GCPlayerTaskStack03 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 3
GCPlayerTaskStack04 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 4
GCPlayerTaskStack05 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 5
GCPlayerTaskStack06 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 6
GCPlayerTaskStack07 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 7
GCPlayerTaskStack08 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 8
GCPlayerTaskStack09 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 9
GCPlayerTaskStack10 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 10
GCPlayerTaskStack11 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 11
GCPlayerTaskStack12 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 12
GCPlayerTaskStack13 = GCPlayerTaskStack + GC_PLAYER_STACK_SIZE * 13

gcplayer_buffer00 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 0
gcplayer_buffer01 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 1
gcplayer_buffer02 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 2
gcplayer_buffer03 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 3
gcplayer_buffer04 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 4
gcplayer_buffer05 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 5
gcplayer_buffer06 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 6
gcplayer_buffer07 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 7
gcplayer_buffer08 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 8
gcplayer_buffer09 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 9
gcplayer_buffer10 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 10
gcplayer_buffer11 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 11
gcplayer_buffer12 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 12
gcplayer_buffer13 = gcplayer_buffer + GC_PLAYER_BUFFER_SIZE * 13
