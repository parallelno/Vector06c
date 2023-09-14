import os


source_path = "asm\\build_data_compression_data.asm"
bin_path = "asm\\build_data_compression_data.bin"
bin_packed_path = bin_path + ".packed"

assembler_path = "..\\..\\retroassembler\\retroassembler.exe -C=8080 -c"
packer_path = "tools\\zx0salvador.exe -v -classic"


os.system(f"{assembler_path} {source_path} {bin_path}")
os.system(f"{packer_path} {bin_path} {bin_packed_path}")
