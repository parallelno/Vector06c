import os
import tools.ramDiskDataExport as ramDiskDataExport
import tools.common as common
          
print(f"ram-disk data export:")
ramDiskDataExport.Export("code\\ramDiskData")

print("")
######################################################################################
print(f"build a game rom:") 
 
mainAsm = "main"
romPath = "rom\\"
romName = os.path.basename(os.getcwd())
romExt = ".rom"
binExt = ".bin"

common.DeleteFile(romPath + romName + romExt)
common.DeleteFile(romPath + romName + binExt)

common.RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 {mainAsm}.asm {romPath + romName + binExt}", "", f"{mainAsm}.asm")
common.RunCommand(f"ren {romPath}*.bin *" + romExt)

common.RunCommand(f"..\\..\\Emu80\\Emu80qt.exe {romPath + romName + romExt}", "", romPath + romName + romExt)
