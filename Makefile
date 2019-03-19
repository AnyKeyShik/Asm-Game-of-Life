target := build/game-of-life

assembly_source_files := $(wildcard src/*.asm)
assembly_object_files := $(patsubst src/%.asm, build/obj/%.o, $(assembly_source_files))

.PHONY: all clean run

all: $(target)

clean: 
	@echo "Cleaning all..."
	@rm -r build

run: $(target)
	@echo "Running assembler Game of Life!"
	$(target)

$(target): $(assembly_object_files)
	@ld -n -o $(target) $<

build/obj/%.o: src/%.asm
	@mkdir -p $(shell dirname $@)
	@echo "Compile $< part"
	@nasm -felf64 $< -o $@
