from tools.build import *

""""
# combine all songs in the order: song0_byte0, song1_byte0, ...., song0_byte1, song1_byte1, etc.
song = "song"
combData= []
allData = []
for i in range(14):
	with open(f"{song}{i:02d}.bin.unpack", "rb") as file:
		data = file.read()
		allData.append(data)
for i in range(len(allData[0])):
	for di in range(len(allData)):
		combData.append(allData[di][i])
with open(f"songComb.bin.unpack", "wb") as file:
	file.write(bytearray(combData))
# compress it with lz77
RunCommand(f"tools\\lz77.py -c 1 -i songComb.bin.unpack -o songComb.bin.lz77")
# compress it with zx0
if os.path.isfile(f"songComb.bin.zx0"):
	os.remove(f"songComb.bin.zx0")
RunCommand(f"tools\zx0.exe -c songComb.bin.lz77 songComb.bin.zx0")

# the result is worse than each regData compressed with lz77, combined into one file, then zx0:
# Lz77: codeType: 0, original data size: 53760, compressed lz77: 37701
# ZX0 v2.2: File compressed from 37701 to 4880 bytes! (delta 2)
"""
"""
song = "song"
unpackedChannelLen = 4000

for i in range(14):
	RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 \
			{song}{i:02d}.asm {song}{i:02d}.bin")
	if os.path.isfile(f"{song}{i:02d}.bin.unpack"):
		os.remove(f"{song}{i:02d}.bin.unpack")
	RunCommand(f"tools\dzx0.exe -c {song}{i:02d}.bin {song}{i:02d}.bin.unpack")
	
	# cutting unpacked song to the range of [0:unpackedChannelLen)
	# if os.path.isfile(f"{song}{i:02d}.bin"):
	# 	os.remove(f"{song}{i:02d}.bin")
	# with open(f"{song}{i:02d}.bin.unpack", "rb") as file:
	# 	data = file.read()
	# 	newData = data[0:unpackedChannelLen]
	#	with open(f"{song}{i:02d}.bin.unpack.cut", "wb") as fBinCut:
	#	 	fBinCut.write(newData)

	# use lz77 compression to support the game song player
	RunCommand(f"tools\lz77.py -c 1 -i {song}{i:02d}.bin.unpack -o {song}{i:02d}.bin.lz77")
# link all lz77 compressed songs and compile
RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 \
		songLz77.asm songLz77.bin")
# then pack them
if os.path.isfile(f"songLz77.bin.zx0"):
	os.remove(f"songLz77.bin.zx0")
RunCommand(f"tools\zx0.exe -c songLz77.bin songLz77.bin.zx0")

# to compare my apprach with double compressed zx0 approach do the next
# link all zx0 compressed songs and compile
RunCommand(f"..\\..\\retroassembler\\retroassembler.exe -C=8080 \
		songZx0.asm songZx0.bin")
# then pack them.
if os.path.isfile(f"songZx0.bin.zx0"):
	os.remove(f"songZx0.bin.zx0")
RunCommand(f"tools\zx0.exe -c songZx0.bin songZx0.bin.zx0")

# result:
# lz77 cccppppp  each regData + zx0
# File compressed from 15147 to 1624 bytes! (delta 2)
# lz77 ccccpppp  each regData + zx0
# File compressed from 13022 to 1368 bytes! (delta 2)
# zx0 -c 256 each regData + zx0
# File compressed from 2310 to 1658 bytes! (delta 2)

exit()

"""
######################################################################################
# sprites to ramDisk
bank0_seg0_path = "ramDiskBank0_addr0"

heroPath = "sprites\\hero"
skeletonPath = "sprites\\skeleton"
burnerPath = "sprites\\burner"
knightPath = "sprites\\knight"
vampirePath = "sprites\\vampire"
scythePath = "sprites\\scythe"

animSpriteExportUpdated = IsFileUpdated("tools\\animSpriteExport.py")

anySpritesUpdated = False
anySpritesUpdated |= ExportAminSprites(heroPath, animSpriteExportUpdated, True)
anySpritesUpdated |= ExportAminSprites(skeletonPath, animSpriteExportUpdated, True)
anySpritesUpdated |= ExportAminSprites(burnerPath, animSpriteExportUpdated, True)
anySpritesUpdated |= ExportAminSprites(knightPath, animSpriteExportUpdated, True)
anySpritesUpdated |= ExportAminSprites(vampirePath, animSpriteExportUpdated, True)
anySpritesUpdated |= ExportAminSprites(scythePath, animSpriteExportUpdated, True)

anySpritesUpdated |= IsFileUpdated(bank0_seg0_path + ".dasm")

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
bank0_seg1_path = "ramDiskBank0_addr8000"

level01Path = "levels\\level01"

levelExportUpdated = IsFileUpdated("tools\\levelExport.py")

anyLevelsUpdated = False
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room00.tmj")
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room01.tmj")
anyLevelsUpdated |= IsFileUpdated("sources\\levels\\level01_room02.tmj")

anyLevelsUpdated = ExportLevel(level01Path, levelExportUpdated | anyLevelsUpdated)
anyLevelsUpdated |= IsFileUpdated(bank0_seg1_path + ".dasm")

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
# music to ram-disk
bank1_screen_path = "ramDiskBank1_addrA000"

musicExportUpdated = IsFileUpdated("tools\\ay6Export.py")

song01 = "song01"
musicInFolder = "sources\\music\\"
musicOutFolder = "generated\\music\\"

anyMusicUpdated = False
anyMusicUpdated |= IsFileUpdated(musicInFolder + song01 + ".ym")
anyMusicUpdated |= IsFileUpdated(bank1_screen_path + ".dasm")

if musicExportUpdated or anyMusicUpdated:
	RunCommand(f"tools\\ay6Export.py -i " + musicInFolder + song01 + ".ym" + " -o " + musicOutFolder + song01 + ".dasm")
	# compile dasm to get bin + labels
	RunCommand("..\\..\\retroassembler\\retroassembler.exe -C=8080 " + bank1_screen_path + 
			".dasm generated\\bin\\" + bank1_screen_path + ".bin >" + bank1_screen_path + "Labels.asm")
	
	ExportLabels(bank1_screen_path + "Labels.asm")

	print(f"retroassembler: {bank1_screen_path} got compiled.")
	print(f"ExportLabels: {bank1_screen_path}Labels.asm got compiled.")

	# compress music bin
	RunCommand("del generated\\bin\\" + bank1_screen_path + ".bin.zx0")
	RunCommand("tools\zx0 -c generated\\bin\\" + bank1_screen_path + ".bin generated\\bin\\" + bank1_screen_path + ".bin.zx0")
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
