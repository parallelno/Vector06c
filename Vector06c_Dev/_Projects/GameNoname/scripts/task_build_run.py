import os
import export_ram_disk_data
import common
          
print(f"ram-disk data export:")
export_ram_disk_data.Export("source\\code\\ram_disk_data.json")

print("")
######################################################################################
print(f"build a game rom:")
 
mainAsm = "asm\\main"
romPath = "rom\\"
romName = os.path.basename(os.getcwd())
romExt = ".rom"
binExt = ".bin"

common.DeleteFile(romPath + romName + romExt)
common.DeleteFile(romPath + romName + binExt)

common.RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 {mainAsm}.asm {romPath + romName + binExt}", "", f"{mainAsm}.asm")
common.RunCommand(f"ren {romPath}*.bin *" + romExt)
common.RunCommand(f"..\\..\\Emu80\\Emu80qt.exe {romPath + romName + romExt}", "", romPath + romName + romExt)
