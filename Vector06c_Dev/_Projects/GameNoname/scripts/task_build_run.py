import os
import export_ram_disk_data
import common
          
print(f"ram-disk data export:")
export_ram_disk_data.export("source\\code\\ram_disk_data.json")

print("")
######################################################################################
print("build a rom file:")
 
source_path = "asm\\main.asm"
romDir = "rom\\"
romName = os.path.basename(os.getcwd())
bin_path = romDir + romName + export_ram_disk_data.build.EXT_BIN
romPath = romDir + romName + export_ram_disk_data.build.EXT_ROM

common.delete_file(bin_path)
common.delete_file(romPath)

common.run_command(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 {source_path} {bin_path}", "", source_path)

if not os.path.exists(bin_path):
	print(f'ERROR: compilation error, path: {source_path}')
	print("Stop export")
	exit(1)

common.run_command(f"ren {bin_path} {romPath}")    
common.run_command(f"..\\..\\Emu80\\Emu80qt.exe {romPath}", "", romPath)
