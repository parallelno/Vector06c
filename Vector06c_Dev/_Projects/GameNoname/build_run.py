from tools.build import *

forceExport = IsFileUpdated("build_run.py")
######################################################################################
print(f"export sprites:")

animForceExport = forceExport | IsFileUpdated("tools\\animSpriteExport.py")
anySpritesUpdated = False 
 
anySpritesUpdated |= ExportAnimSprites("sprites\\hero", animForceExport)
anySpritesUpdated |= ExportAnimSprites("sprites\\skeleton", animForceExport, True)
anySpritesUpdated |= ExportAnimSprites("sprites\\burner", animForceExport, True)
anySpritesUpdated |= ExportAnimSprites("sprites\\knight", animForceExport, True)
anySpritesUpdated |= ExportAnimSprites("sprites\\vampire", animForceExport, True)
anySpritesUpdated |= ExportAnimSprites("sprites\\scythe", animForceExport, True)
anySpritesUpdated |= ExportAnimSprites("sprites\\hero_attack01", animForceExport, True)
print("")
 
ramdisk_seg_path = "ramDiskBank0_addr0"
segmentForceExport = anySpritesUpdated | IsDasmUpdated(ramdisk_seg_path + ".dasm")
ExportSegment(ramdisk_seg_path, segmentForceExport, SEGMENT_0000_7F00_ADDR)

ramdisk_seg_path = "ramDiskBank1_addr0"
segmentForceExport = anySpritesUpdated | IsDasmUpdated(ramdisk_seg_path + ".dasm")
ExportSegment(ramdisk_seg_path, segmentForceExport, SEGMENT_0000_7F00_ADDR) 

print("")
######################################################################################
print(f"export levels:")

levelForceExport = forceExport | IsFileUpdated("tools\\levelExport.py")
levelForceExport = ExportLevel("levels\\level01", levelForceExport)

ramdisk_seg_path = "ramDiskBank0_addr8000"
segmentForceExport = levelForceExport | IsDasmUpdated(ramdisk_seg_path + ".dasm")
ExportSegment(ramdisk_seg_path, segmentForceExport, SEGMENT_8000_0000_ADDR)

print("")
######################################################################################
print(f"export music:")

musicForceExport = forceExport | IsFileUpdated("tools\\musicExport.py")
musicForceExport = ExportMusic("music\\song01", musicForceExport)

ramdisk_seg_path = "ramDiskBank1_addr8000"
segmentForceExport = musicForceExport | IsDasmUpdated(ramdisk_seg_path + ".dasm")
ExportSegment(ramdisk_seg_path, segmentForceExport, SEGMENT_8000_0000_ADDR, True)

print("")
######################################################################################
# codeLib is in the same bank where a backbuffer is
print(f"export code library:")

ramdisk_seg_path = "ramDiskBank2_addr8000"
segmentForceExport = IsDasmUpdated(ramdisk_seg_path + ".dasm")
ExportSegment(ramdisk_seg_path, segmentForceExport, SEGMENT_8000_0000_ADDR, True)

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
