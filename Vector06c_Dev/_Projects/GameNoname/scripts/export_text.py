import os
from pathlib import Path
import json
import common
import build


#=====================================================
def export_if_updated(source_path, generated_dir, force_export, localization = build.LOCAL_ENG):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + "_data" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_data( source_path, export_paths["ram_disk"], localization)
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths
	
def export_data(source_j_path, export_path, localization = build.LOCAL_ENG):

	with open(source_j_path, "rb") as file:
		source_j = json.load(file)

	#source_dir = str(Path(source_j_path).parent) + "\\"

	# check if a folder exists
	export_dir = str(Path(export_path).parent) + "\\"
	if not os.path.exists(export_dir):
		os.mkdir(export_dir)

	if "asset_type" not in source_j or source_j["asset_type"] != build.ASSET_TYPE_TEXT :
		print(f'export_text ERROR: asset_type != "{build.ASSET_TYPE_TEXT}", path: {source_j_path}')
		print("Stop export")
		exit(1) 

	source_name = common.path_to_basename(source_j_path)
	asm = ""

	asm = f"__RAM_DISK_S_{source_name.upper()} = RAM_DISK_S\n"
	asm += f"__RAM_DISK_M_{source_name.upper()} = RAM_DISK_M\n"
	asm += "\n"

	for comment in source_j["text"]:
		labels_text = source_j["text"][comment]
		asm += f";===================================================================================\n"
		asm += f"; {comment}\n"
		asm += f";===================================================================================\n"
		for label in labels_text: 
			
			asm += f"{label}:\n"
			
			text_lines = labels_text[label][localization]
			
			lines = len(text_lines)
			for i, text_raw in enumerate(text_lines):
				
				command = ""
				parag_break = text_raw.find(build._PARAG_BREAK_)
				line_break = text_raw.find(build._LINE_BREAK_)
				text = text_raw
				break_line = "\n"
				
				if parag_break >= 0:
					command = ", " + build._PARAG_BREAK_
					text = text_raw[:parag_break]
					
				elif line_break >= 0 or i+1 != lines:
					command = ", " + build._LINE_BREAK_
					break_line = ""
					if line_break >= 0:
						text = text_raw[:line_break]					
				
				asm += f'			TEXT("{text}"{command})\n{break_line}'



	with open(export_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):

	if build.is_file_updated(source_j_path):
		return True
	return False





