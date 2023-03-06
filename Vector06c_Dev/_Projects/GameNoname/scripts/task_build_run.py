import os
import export_ram_disk_data
import build
import common


build.set_assembler_path("..\\..\\retroassembler\\retroassembler.exe -C=8080 -c")
build.set_assembler_labels_cmd(" -x")
build.set_zx0_path("tools\\zx0salvador.exe -v -classic")
build.set_emulator_path("..\\..\\Emu80\\Emu80qt.exe")

source_path = "asm\\main.asm"
rom_dir = "rom\\"

ram_disk_data_path = "source\\code\\ram_disk_data.json"

print(f"ram-disk data export: {ram_disk_data_path}")
export_ram_disk_data.export(ram_disk_data_path)

print("")
######################################################################################
print("build a rom file:")

rom_name = os.path.basename(os.getcwd())
bin_path = rom_dir + rom_name + build.EXT_BIN
rom_path = rom_dir + rom_name + build.EXT_ROM


common.delete_file(bin_path)
common.delete_file(rom_path) 

common.run_command(f"{build.assembler_path} {source_path} {bin_path}", "", source_path)

if not os.path.exists(bin_path):
	print(f'ERROR: compilation error, path: {source_path}')
	print("Stop export")
	exit(1)

common.run_command(f"ren {bin_path} {rom_name + build.EXT_ROM}")    
common.run_command(f"{build.emulator_path} {rom_path}", "", rom_path)
