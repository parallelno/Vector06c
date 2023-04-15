import os
from pathlib import Path
from PIL import Image
import json
import common
import common_gfx
import build

def export_if_updated(source_path, generated_dir, force_export):
	source_name = common.path_to_basename(source_path)

	sprite_path = generated_dir + source_name + "_sprites" + build.EXT_ASM

	export_paths = {"ram_disk" : sprite_path }

	if force_export or is_source_updated(source_path):
		export(	source_path, sprite_path)

		print(f"export_decal: {source_path} got exported.")
		return True, export_paths
	else:
		return False, export_paths

def export(source_j_path, asmSpritePath):
	source_name = common.path_to_basename(source_j_path)
	source_dir = str(Path(source_j_path).parent) + "\\"
	asm_sprite_dir = str(Path(asmSpritePath).parent) + "\\"

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_PICTURE :
		print(f'export_sprite ERROR: asset_type != "{build.ASSET_TYPE_PICTURE}", path: {source_j_path}')
		print("Stop export")
		exit(1)

	path_png = source_dir + source_j["path_png"]
	image = Image.open(path_png)

	_, colors = common.palette_to_asm(image, source_j)

	image = common.remap_colors(image, colors)

	asm = "; " + source_j_path + "\n"
	asm += f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S" + "\n"
	asm += f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M" + "\n\n"
	asm += lists_of_sprites_ptrs_to_asm("__" + source_name, source_j)
	asm += sprites_to_asm("__" + source_name, source_j, image)

	# save asm
	if not os.path.exists(asm_sprite_dir):
		os.mkdir(asm_sprite_dir)

	with open(asmSpritePath, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):
	with open(source_j_path, "rb") as file:
		source_j = json.load(file)
	
	source_dir = str(Path(source_j_path).parent) + "\\"
	path_png = source_dir + source_j["path_png"]

	if build.is_file_updated(source_j_path) | build.is_file_updated(path_png):
		return True
	return False


