import os
from pathlib import Path
import json
import common
import build

# the string format contains:
#	_EOD_ at the end
#	_LINE_BREAK_ at the end of the line
#	_PARAG_BREAK_ at the end of the peragraph

# the custom RUS charset is described in source\sprites\font_rus.json
rus_charset = {
		"а"	: 1,
		"б"	: 2,
		"в"	: 3,
		"г"	: 4,
		"д"	: 5,
		"е"	: 6,
		"ё"	: 7,
		"ж"	: 8,
		"з"	: 9,
		"и"	: 10,
		"й"	: 11,
		"к"	: 12,
		"л"	: 13,
		"м"	: 14,
		"н"	: 15,
		"о"	: 16,
		"п"	: 17,
		"р"	: 18,
		"с"	: 19,
		"т"	: 20,
		"у"	: 21,
		"ф"	: 22,
		"х"	: 23,
		"ц"	: 24,
		"ч"	: 25,
		"ш"	: 26,
		"щ"	: 27,
		"ъ"	: 28,
		"ы"	: 29,
		"ь"	: 30,
		"э"	: 31,
		"ю"	: 32,
		"я"	: 33,
		"А"	: 34,
		"Б"	: 35,
		"В"	: 36,
		"Г"	: 37,
		"Д"	: 38,
		"Е"	: 39,
		"Ё"	: 40,
		"Ж"	: 41,
		"З"	: 42,
		"И"	: 43,
		"Й"	: 44,
		"К"	: 45,
		"Л"	: 46,
		"М"	: 47,
		"Н"	: 48,
		"О"	: 49,
		"П"	: 50,
		"Р"	: 51,
		"С"	: 52,
		"Т"	: 53,
		"У"	: 54,
		"Ф"	: 55,
		"Х"	: 56,
		"Ц"	: 57,
		"Ч"	: 58,
		"Ш"	: 59,
		"Щ"	: 60,
		"Ъ"	: 61,
		"Ы"	: 62,
		"Ь"	: 63,
		"Э"	: 64,
		"Ю"	: 65,
		"Я"	: 66,
		"0"	: 67,
		"1"	: 68,
		"2"	: 69,
		"3"	: 70,
		"4"	: 71,
		"5"	: 72,
		"6"	: 73,
		"7"	: 74,
		"8"	: 75,
		"9"	: 76,
		"."	: 77,
		","	: 78,
		":"	: 79,
		")"	: 80,
		"("	: 81,
		"'"	: 82,
		"!"	: 83,
		"?"	: 84,
		"-"	: 85,
		"&"	: 86,
		" "	: 87
}

def rus_text_to_data(text, source_j_path):
	result = []
	for char_ in text:
		if char_ not in rus_charset:
			print(f'export_text ERROR: unsupported char: "{char_}", path: {source_j_path}')
			print("Stop export")
			exit(1)

		result.append(rus_charset[char_])

	return result

def bytes_to_asm(data, command):
	asm = "			.byte "
	for byte in data:
		asm += str(byte) + ","

	asm += f" {command}\n" 
	return asm

#=====================================================
def export_if_updated(source_path, generated_dir, force_export, localization_id = build.LOCAL_ENG):
	source_name = common.path_to_basename(source_path)

	export_paths = {"ram_disk" : generated_dir + source_name + "_data" + build.EXT_ASM }

	if force_export or is_source_updated(source_path):
		export_data( source_path, export_paths["ram_disk"], localization_id)
			
		print(f"export_level: {source_path} got exported.")		
		return True, export_paths
	else:
		return False, export_paths
	
def export_data(source_j_path, export_path, localization_id = build.LOCAL_ENG):

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
			if localization_id not in labels_text[label]:
				print(f'export_text ERROR: label {label} does not contain localization_id = {localization_id}.", path: {source_j_path}')
				print("Stop export")
				exit(1)

			text_lines = labels_text[label][localization_id]
			
			lines = len(text_lines)
			for i, text_raw in enumerate(text_lines):
				
				command_eng = ""
				command_rus = build._EOD_
				parag_break = text_raw.find(build._PARAG_BREAK_)
				line_break = text_raw.find(build._LINE_BREAK_)
				text = text_raw
				break_line = "\n"
				
				if parag_break >= 0:
					command_eng = build._PARAG_BREAK_
					command_rus = command_eng
					text = text_raw[:parag_break]
					
				elif line_break >= 0 or i+1 != lines:
					command_eng = build._LINE_BREAK_
					command_rus = command_eng
					break_line = ""
					if line_break >= 0:
						text = text_raw[:line_break]					
				
				if localization_id == build.LOCAL_RUS:
					rus_text_data = rus_text_to_data(text, source_j_path)
					asm += bytes_to_asm(rus_text_data, command_rus) 
				else:
					asm += f'			TEXT("{text}", {command_eng})\n'
				asm += break_line



	with open(export_path, "w") as file:
		file.write(asm)

def is_source_updated(source_j_path):

	if build.is_file_updated(source_j_path):
		return True
	return False





