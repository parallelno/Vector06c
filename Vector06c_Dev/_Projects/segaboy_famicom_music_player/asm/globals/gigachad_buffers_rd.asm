GC_PLAYER_TASKS = 14
GC_PLAYER_STACK_SIZE = 16
GC_PLAYER_BUFFER_SIZE = $100

gcplayer_buffer = $10000 - GC_PLAYER_BUFFER_SIZE * GC_PLAYER_TASKS
gsplayer_task_stack = gcplayer_buffer - GC_PLAYER_STACK_SIZE * GC_PLAYER_TASKS

; array of task stack pointers. gsplayer_task_sps[i] = taskSP
gsplayer_task_sps = gsplayer_task_stack - GC_PLAYER_TASKS * WORD_LEN
gsplayer_task_sps_end = gsplayer_task_stack

; a pointer to a current task sp. *gsplayer_current_task_spp = gsplayer_task_sps[current_task]
gsplayer_current_task_spp = gsplayer_task_sps - WORD_LEN;
__gigachad_buffers = gsplayer_current_task_spp

; task stacks
gsplayer_task_stack00 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 0
gsplayer_task_stack01 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 1
gsplayer_task_stack02 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 2
gsplayer_task_stack03 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 3
gsplayer_task_stack04 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 4
gsplayer_task_stack05 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 5
gsplayer_task_stack06 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 6
gsplayer_task_stack07 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 7
gsplayer_task_stack08 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 8
gsplayer_task_stack09 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 9
gsplayer_task_stack10 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 10
gsplayer_task_stack11 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 11
gsplayer_task_stack12 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 12
gsplayer_task_stack13 = gsplayer_task_stack + GC_PLAYER_STACK_SIZE * 13

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
