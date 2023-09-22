import os
import export_data
import build  
import common

 
build.set_assembler_path("..\\..\\retroassembler\\retroassembler.exe -C=8080 -c")
build.set_assembler_labels_cmd(" -x")
build.set_packer(build.PACKER_ZX0_SALVADORE)
build.set_emulator_path("..\\..\\Emu80\\Emu80qt.exe")

data_path = "source\\data\\data.json"

print(f"ram-disk data export: {data_path}")
export_data.export(data_path)