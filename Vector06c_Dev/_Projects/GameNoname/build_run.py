from tools.build import *

RunCommand("del *.lst *.obj *.rom", "del temp files", False)


animSpriteExportUpdated = IsFileUpdated("tools\\animSpriteExport.py")
levelExportUpdated = IsFileUpdated("tools\\levelExport.py")

######################################################################################
# sprites to ramDisk

heroPath = "sprites\\hero"
skeletonPath = "sprites\\skeleton"
burnerPath = "sprites\\burner"
knightPath = "sprites\\knight"
vampirePath = "sprites\\vampire"
scythePath = "sprites\\scythe"

level01Path = "levels\\level01"

anySpritesUpdated = False
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(heroPath, animSpriteExportUpdated)
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(skeletonPath, animSpriteExportUpdated)
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(burnerPath, animSpriteExportUpdated)
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(knightPath, animSpriteExportUpdated)
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(vampirePath, animSpriteExportUpdated)
anySpritesUpdated = anySpritesUpdated | ExportAminSprites(scythePath, animSpriteExportUpdated)

bank0_seg0_path = "ramDiskBank0_addr0"
bank0_seg1_path = "ramDiskBank0_addr8000"

if anySpritesUpdated:
	RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank0_seg0_path + 
			".dasm generated\\bin\\" + bank0_seg0_path + ".bin >" + bank0_seg0_path + "Labels.asm")

	CheckSegmentSize("generated\\bin\\" + bank0_seg0_path + ".bin", SEGMENT_0000_7F00_ADDR)
	
	ExportLabels(bank0_seg0_path + "Labels.asm")

	print(f"retroassembler: {bank0_seg0_path} got compiled.")
	print(f"ExportLabels: {bank0_seg0_path}Labels.asm got compiled.")

	RunCommand("del generated\\bin\\" + bank0_seg0_path + ".bin.zx0")
	RunCommand("tools\zx0 -c generated\\bin\\" + bank0_seg0_path + ".bin generated\\bin\\" + bank0_seg0_path + ".bin.zx0")
else: 
	print(f"retroassembler: {bank0_seg0_path} wasn't updated. No need to export.")
	print(f"ExportLabels: {bank0_seg0_path}Labels.asm wasn't updated. No need to compile.")
	print(f"zx0: {bank0_seg0_path}bin wasn't updated. No need to compress.")

######################################################################################
# levels to ramDisk
anyLevelsUpdated = False
anyLevelsUpdated = anyLevelsUpdated | IsFileUpdated("sources\\levels\\level01_room00.tmj")
anyLevelsUpdated = anyLevelsUpdated | IsFileUpdated("sources\\levels\\level01_room01.tmj")
anyLevelsUpdated = anyLevelsUpdated | IsFileUpdated("sources\\levels\\level01_room02.tmj")

anyLevelsUpdated = ExportLevel(level01Path, levelExportUpdated | anyLevelsUpdated)
anyLevelsUpdated = anyLevelsUpdated | IsFileUpdated(bank0_seg1_path + ".dasm")

if anyLevelsUpdated:
	RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank0_seg1_path + 
			".dasm generated\\bin\\" + bank0_seg1_path + ".bin >" + bank0_seg1_path + "Labels.asm")
	
	CheckSegmentSize("generated\\bin\\" + bank0_seg1_path + ".bin", SEGMENT_8000_0000_ADDR)

	ExportLabels(bank0_seg1_path + "Labels.asm")

	print(f"retroassembler: {bank0_seg1_path} got compiled.")
	print(f"ExportLabels: {bank0_seg1_path}Labels.asm got compiled.")

	RunCommand("del generated\\bin\\" + bank0_seg1_path + ".bin.zx0")
	RunCommand("tools\zx0 -c generated\\bin\\" + bank0_seg1_path + ".bin generated\\bin\\" + bank0_seg1_path + ".bin.zx0")
else: 
	print(f"retroassembler: {bank0_seg1_path} wasn't updated. No need to export.")
	print(f"ExportLabels: {bank0_seg1_path}Labels.asm wasn't updated. No need to compile.")
	print(f"zx0: {bank0_seg1_path}bin wasn't updated. No need to compress.")

######################################################################################
# game rom
mainAsm = "main"
romPath = "rom\\"
romName = os.path.basename(os.getcwd())
romExt = ".rom"
binExt = ".bin"

if os.path.isfile(romPath + romName + romExt):
	os.remove(romPath + romName + romExt)

RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + mainAsm + 
	".asm " + romPath + romName + binExt )

RunCommand(f"ren {romPath}*.bin *.rom")

if os.path.isfile(romPath + romName + romExt):
	RunCommand(f"..\\..\\Emu80\\Emu80qt.exe {romPath + romName + romExt}")