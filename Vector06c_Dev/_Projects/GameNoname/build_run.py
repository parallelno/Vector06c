from tools.build import *

forceExport = IsFileUpdated("build_run.py")
######################################################################################
# sprites to ramDisk
print(f"sprites:")
bank0_seg0_path = "ramDiskBank0_addr0"

heroPath = "sprites\\hero"
skeletonPath = "sprites\\skeleton"
burnerPath = "sprites\\burner"
knightPath = "sprites\\knight"
vampirePath = "sprites\\vampire"
scythePath = "sprites\\scythe"
heroAttack01Path = "sprites\\hero_attack01"

animForceExport = forceExport | IsFileUpdated("tools\\animSpriteExport.py")

heroSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_hero.png")
skeletonSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_skeleton.png")
burnerSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_burner.png")
knightSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_knight.png")
vampireSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_vampire.png")
projectilesSpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_projectiles.png")
heroAttack01SpriteSourceUpdated = IsFileUpdated("sources\\sprites\\art\\sprites_hero_attack01.png")

anySpritesUpdated = False

print(f"sprite export")

anySpritesUpdated |= ExportAminSprites(heroPath, animForceExport or heroSpriteSourceUpdated)
anySpritesUpdated |= ExportAminSprites(skeletonPath, animForceExport or skeletonSpriteSourceUpdated, True)
anySpritesUpdated |= ExportAminSprites(burnerPath, animForceExport or burnerSpriteSourceUpdated, True)
anySpritesUpdated |= ExportAminSprites(knightPath, animForceExport or knightSpriteSourceUpdated, True)
anySpritesUpdated |= ExportAminSprites(vampirePath, animForceExport or vampireSpriteSourceUpdated, True)
anySpritesUpdated |= ExportAminSprites(scythePath, animForceExport or projectilesSpriteSourceUpdated, True)
anySpritesUpdated |= ExportAminSprites(heroAttack01Path, animForceExport or heroAttack01SpriteSourceUpdated, True)
print("")

anySpritesUpdated |= IsFileUpdated(bank0_seg0_path + ".dasm")

if anySpritesUpdated:
	common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank0_seg0_path +
			".dasm generated\\bin\\" + bank0_seg0_path + ".bin >" + bank0_seg0_path + "Labels.asm")

	CheckSegmentSize("generated\\bin\\" + bank0_seg0_path + ".bin", SEGMENT_0000_7F00_ADDR)

	ExportLabels(bank0_seg0_path + "Labels.asm")

	print(f"retroassembler: {bank0_seg0_path} got compiled.")
	print(f"ExportLabels: {bank0_seg0_path}Labels.asm got compiled.\n")

	common.DeleteFile("generated\\bin\\" + bank0_seg0_path + ".bin.zx0")
	common.RunCommand("tools\zx0 -c generated\\bin\\" + bank0_seg0_path + ".bin generated\\bin\\" + bank0_seg0_path + ".bin.zx0")
else:
	print(f"retroassembler: {bank0_seg0_path} wasn't updated. No need to export.")
	print(f"ExportLabels: {bank0_seg0_path}Labels.asm wasn't updated. No need to compile.")
	print(f"zx0: {bank0_seg0_path}bin wasn't updated. No need to compress.\n")

print(f"")
bank1_seg0_path = "ramDiskBank1_addr0"
anySpritesUpdated |= IsFileUpdated(bank1_seg0_path + ".dasm")

if anySpritesUpdated:
	common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank1_seg0_path +
			".dasm generated\\bin\\" + bank1_seg0_path + ".bin >" + bank1_seg0_path + "Labels.asm")

	CheckSegmentSize("generated\\bin\\" + bank1_seg0_path + ".bin", SEGMENT_0000_7F00_ADDR)

	ExportLabels(bank1_seg0_path + "Labels.asm")

	print(f"retroassembler: {bank1_seg0_path} got compiled.")
	print(f"ExportLabels: {bank1_seg0_path}Labels.asm got compiled.\n")

	common.DeleteFile("generated\\bin\\" + bank1_seg0_path + ".bin.zx0")
	common.RunCommand("tools\zx0 -c generated\\bin\\" + bank1_seg0_path + ".bin generated\\bin\\" + bank1_seg0_path + ".bin.zx0")
else:
	print(f"retroassembler: {bank1_seg0_path} wasn't updated. No need to export.")
	print(f"ExportLabels: {bank1_seg0_path}Labels.asm wasn't updated. No need to compile.")
	print(f"zx0: {bank1_seg0_path}bin wasn't updated. No need to compress.\n")

print(f"")
######################################################################################
# levels to the ramDisk
print(f"levels:")
bank0_seg1_path = "ramDiskBank0_addr8000"


level01Path = "levels\\level01"

levelForceExport = forceExport | IsFileUpdated("tools\\levelExport.py")

anyLevelsUpdated = False
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room00.tmj")
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room01.tmj")
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room02.tmj")

print(f"level export for {bank0_seg1_path}")
anyLevelsUpdated = ExportLevel(level01Path, levelForceExport | anyLevelsUpdated)
anyLevelsUpdated |= IsFileUpdated(bank0_seg1_path + ".dasm")

if anyLevelsUpdated:
	common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank0_seg1_path +
			".dasm generated\\bin\\" + bank0_seg1_path + ".bin >" + bank0_seg1_path + "Labels.asm")

	CheckSegmentSize("generated\\bin\\" + bank0_seg1_path + ".bin", SEGMENT_8000_0000_ADDR)

	ExportLabels(bank0_seg1_path + "Labels.asm")

	print(f"retroassembler: {bank0_seg1_path} got compiled.")
	print(f"ExportLabels: {bank0_seg1_path}Labels.asm got compiled.\n")

	common.DeleteFile("generated\\bin\\" + bank0_seg1_path + ".bin.zx0")
	common.RunCommand("tools\zx0 -c generated\\bin\\" + bank0_seg1_path + ".bin generated\\bin\\" + bank0_seg1_path + ".bin.zx0")
else:
	print(f"retroassembler: {bank0_seg1_path} wasn't updated. No need to export.")
	print(f"ExportLabels: {bank0_seg1_path}Labels.asm wasn't updated. No need to compile.")
	print(f"zx0: {bank0_seg1_path}bin wasn't updated. No need to compress.\n")

print(f"")
######################################################################################
# music to the ram-disk
print(f"music:")
bank1_screen_path = "ramDiskBank1_addr8000"

musicForceExport = forceExport | IsFileUpdated("tools\\ay6Export.py")

song01 = "song01"
musicInFolder = "sources\\music\\"
musicOutFolder = "generated\\music\\"

anyMusicUpdated = False
anyMusicUpdated |= IsFileUpdated(musicInFolder + song01 + ".ym")
anyMusicUpdated |= IsFileUpdated(bank1_screen_path + ".dasm")

playerUpdated = IsFileUpdated("gigachad16PlayerRD.asm")

if musicForceExport or anyMusicUpdated or playerUpdated:
	common.RunCommand(f"tools\\ay6Export.py -i " + musicInFolder + song01 + ".ym" + " -o " + musicOutFolder + song01 + ".dasm")
	# compile dasm to get a bin + labels
	common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank1_screen_path +
			".dasm generated\\bin\\" + bank1_screen_path + ".bin >" + bank1_screen_path + "Labels.asm")

	ExportLabels(bank1_screen_path + "Labels.asm", True)

	print(f"retroassembler: {bank1_screen_path} got compiled.")
	print(f"ExportLabels: {bank1_screen_path}Labels.asm got compiled.\n")

	# compress music bin
	common.RunCommand("del generated\\bin\\" + bank1_screen_path + ".bin.zx0")
	common.RunCommand("tools\zx0 -c generated\\bin\\" + bank1_screen_path + ".bin generated\\bin\\" + bank1_screen_path + ".bin.zx0")

print(f"")
######################################################################################
# codeLib is in the same bank where a backbuffer is
print(f"code:")
bank2_seg1_path = "ramDiskBank2_addr8000"

codeLibForceExport = forceExport

codeLibOutFolder = "generated\\code\\"

anyCodeUpdated = False
anyCodeUpdated |= IsFileUpdated("utilsRD.asm")
anyCodeUpdated |= IsFileUpdated("spriteRD.asm")
anyCodeUpdated |= IsFileUpdated("drawSpriteRD.asm")
anyCodeUpdated |= IsFileUpdated(bank2_seg1_path + ".asm")

if codeLibForceExport or anyCodeUpdated:
	# compile asm to get a bin + labels
	common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank2_seg1_path +
			".asm generated\\bin\\" + bank2_seg1_path + ".bin >" + bank2_seg1_path + "Labels.asm")

	ExportLabels(bank2_seg1_path + "Labels.asm", True)

	print(f"retroassembler: {bank2_seg1_path} got compiled.")
	print(f"ExportLabels: {bank2_seg1_path}Labels.asm got compiled.\n")

	# compress codeLib bin
	common.RunCommand("del generated\\bin\\" + bank2_seg1_path + ".bin.zx0")
	common.RunCommand("tools\zx0 -c generated\\bin\\" + bank2_seg1_path + ".bin generated\\bin\\" + bank2_seg1_path + ".bin.zx0")

print(f"")
######################################################################################
# game rom
print(f"game rome:")

mainAsm = "main"
romPath = "rom\\"
romName = os.path.basename(os.getcwd())
romExt = ".rom"
binExt = ".bin"

common.DeleteFile(romPath + romName + romExt)

common.RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + mainAsm +
	".asm " + romPath + romName + binExt )

common.RunCommand(f"ren {romPath}*.bin *.rom")

if os.path.isfile(romPath + romName + romExt):
	common.RunCommand(f"..\\..\\Emu80\\Emu80qt.exe {romPath + romName + romExt}")
