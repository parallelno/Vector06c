.org $8000
.include "asm\\globals\\global_consts.asm"
RAM_DISK_S = RAM_DISK_S3
RAM_DISK_M = RAM_DISK_M3

__global_consts_rd_rd_data_start:
.include "asm\\globals\\global_consts_rd.asm"
__global_consts_rd_rd_data_end:
__sprite_rd_rd_data_start:
.include "asm\\render\\sprite_rd.asm"
.align 2
__sprite_rd_rd_data_end:
__draw_sprite_rd_rd_data_start:
.include "asm\\render\\draw_sprite_rd.asm"
.align 2
__draw_sprite_rd_rd_data_end:
__draw_sprite_hit_rd_rd_data_start:
.include "asm\\render\\draw_sprite_hit_rd.asm"
.align 2
__draw_sprite_hit_rd_rd_data_end:
__draw_sprite_invis_rd_rd_data_start:
.include "asm\\render\\draw_sprite_invis_rd.asm"
.align 2
__draw_sprite_invis_rd_rd_data_end:
__utils_rd_rd_data_start:
.include "asm\\common\\utils_rd.asm"
.align 2
__utils_rd_rd_data_end:
__sprite_preshift_rd_rd_data_start:
.include "asm\\render\\sprite_preshift_rd.asm"
.align 2
__sprite_preshift_rd_rd_data_end:
__text_rd_data_rd_data_start:
.include "generated\\text\\text_rd_data.asm"
.align 2
__text_rd_data_rd_data_end:
__text_ex_rd_rd_data_start:
.include "asm\\render\\text_ex_rd.asm"
.align 2
__text_ex_rd_rd_data_end:
__game_score_data_rd_rd_data_start:
.include "asm\\game_score_data_rd.asm"
.align 2
__game_score_data_rd_rd_data_end:
