import os

def split_file(input_file, output_prefix, chunk_size):
    with open(input_file, 'rb') as infile:
        part_num = 1
        while True:
            chunk = infile.read(chunk_size)
            if not chunk:
                break

            output_file = f"{output_prefix}_part{part_num}.dat"
            with open(output_file, 'wb') as outfile:
                outfile.write(chunk)

            part_num += 1


def run_command(command, comment = "", check_path = ""):
	if comment != "" : 
		print(comment)
	if check_path == "" or os.path.isfile(check_path):
		os.system(command)
	else:
		print(f"run_command ERROR: command: {command} is failed. file {check_path} doesn't exist")
		exit(1)


if __name__ == "__main__":
    input_file = "rom\\GameNoname.rom"  # Replace with your input file name
    output_prefix = "temp\\code_compression\\output"  # Prefix for output files
    chunk_size = 16985  # Chunk size in bytes (e.g., 1 MB)

    split_file(input_file, output_prefix, chunk_size)

    #source_path = "temp\\code_compression\\output_part1.dat"
    bin_path = "temp\\code_compression\\output_part1.dat"
    bin_packed_path = bin_path + ".packed"

    assembler_path = "..\\..\\retroassembler\\retroassembler.exe -C=8080 -c"
    packer_path = "tools\\zx0salvador.exe -v -classic"
    
    run_command(f"{packer_path} {bin_path} {bin_packed_path}")

#..\\..\\tools\\zx0salvador.exe -v -classic level_all_dict.bin.zx0s level_all_dict.bin.zx0s.zx0s