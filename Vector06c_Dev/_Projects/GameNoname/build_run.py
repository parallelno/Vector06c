from tools.build import *

forceExport = IsFileUpdated("build_run.py")
forceExport |= IsFileUpdated("tools\\build.py")
######################################################################################
print(f"export sprites:")

animForceExport = forceExport | IsFileUpdated("tools\\animSpriteExport.py")
 
animForceExport |= ExportAnimSprites("sprites\\hero", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\skeleton", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\burner", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\knight", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\vampire", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\scythe", animForceExport)
animForceExport |= ExportAnimSprites("sprites\\hero_attack01", animForceExport)
print("")

ExportSegment("ramDiskBank0_addr0.asm" , animForceExport, SEGMENT_0000_7F00_ADDR)
ExportSegment("ramDiskBank1_addr0.asm", animForceExport, SEGMENT_0000_7F00_ADDR) 

print("")
######################################################################################
print(f"export levels:")

levelForceExport = forceExport | IsFileUpdated("tools\\levelExport.py")
levelForceExport = ExportLevel("levels\\level01", levelForceExport)
ExportSegment("ramDiskBank0_addr8000.asm", levelForceExport, SEGMENT_8000_0000_ADDR)

print("")
######################################################################################
print(f"export music:")

musicForceExport = forceExport | IsFileUpdated("tools\\musicExport.py")
musicForceExport = ExportMusic("music\\song01", musicForceExport)
ExportSegment("ramDiskBank1_addr8000.asm", musicForceExport, SEGMENT_8000_0000_ADDR, True)

print("") 
######################################################################################
# codeLib is in the same bank where a backbuffer is
print(f"export code library:")

ExportSegment("ramDiskBank2_addr8000.asm", False, SEGMENT_8000_0000_ADDR, True)

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

common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " +
	"main.asm " + romPath + romName + binExt )

common.RunCommand(f"ren {romPath}*.bin *" + romExt)

if os.path.isfile(romPath + romName + romExt):
	common.RunCommand(f"..\\..\\Emu80\\Emu80qt.exe {romPath + romName + romExt}")
