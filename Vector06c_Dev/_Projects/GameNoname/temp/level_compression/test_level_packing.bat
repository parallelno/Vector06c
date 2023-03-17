..\\..\\..\\..\\retroassembler\\retroassembler.exe -C=8080 -c level_tmp1.asm
..\\..\\..\\..\\retroassembler\\retroassembler.exe -C=8080 -c level_tmp2.asm
..\\..\\..\\..\\retroassembler\\retroassembler.exe -C=8080 -c level_tmp3.asm

..\\test\\lz77.py -i level_tmp1.bin -o level_tmp1.bin.rle -c 0
..\\test\\lz77.py -i level_tmp2.bin -o level_tmp2.bin.rle -c 0
..\\test\\lz77.py -i level_tmp3.bin -o level_tmp3.bin.rle -c 0

..\\..\\tools\\zx0salvador.exe -v -classic level_tmp1.bin level_tmp1.bin.zx0s
..\\..\\tools\\zx0salvador.exe -v -classic level_tmp2.bin level_tmp2.bin.zx0s
..\\..\\tools\\zx0salvador.exe -v -classic level_tmp3.bin level_tmp3.bin.zx0s

..\\..\\tools\\zx0salvador.exe -v -classic -D level_tmp3.bin.zx0s level_tmp1.bin level_tmp1_dict.bin.zx0s
..\\..\\tools\\zx0salvador.exe -v -classic -D level_tmp1.bin.zx0s level_tmp2.bin level_tmp2_dict.bin.zx0s
..\\..\\tools\\zx0salvador.exe -v -classic -D level_tmp2.bin.zx0s level_tmp3.bin level_tmp3_dict.bin.zx0s

copy /b level_tmp1_dict.bin.zx0s+level_tmp2_dict.bin.zx0s+level_tmp3_dict.bin.zx0s level_all_dict.bin.zx0s

..\\..\\tools\\zx0salvador.exe -v -classic level_all_dict.bin.zx0s level_all_dict.bin.zx0s.zx0s