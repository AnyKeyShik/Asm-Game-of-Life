%macro print 2
	mov eax, sys_write
	mov edi, 1
	mov rsi, %1
	mov edx, %2
	syscall
%endmacro

global start


section .data

row_cells: equ 32
column_cells: equ 128
array_length: equ row_cells * column_cells + row_cells ; cells are mapped to bytes in the array and a new line char ends each row

cells1: times array_length db new_line
cells2: times array_length db new_line

live: equ 111 ; ascii code for live cells
dead: equ 32 ; ascii code for dead cells
new_line: equ 10

timespec:
	tv_sec dq 0
	tv_nsec dq 200000000

clear: db 27, "[2J", 27, "[H"
clear_length: equ $-clear

sys_write: equ 1
sys_nanosleep: equ 35
sys_time: equ 201


section .text

start:
	print clear, clear_length
	
	call first_generation

	mov r9, cells1
	mov r8, cells2
.generate_cells:
	xchg r8, r9				; exchange current and next generation
	print r8, array_length	; print current generation

	mov eax, sys_nanosleep
	mov rdi, timespec
	xor esi, esi
	syscall

	print clear, clear_length

	jmp next_generation

; array cells1 is initialised with pseudorandom cells using a middle-square Weyl sequence RNG
first_generation:
	mov eax, sys_time
	xor edi, edi
	syscall

	mov r8w, ax				; r8w stores seed, must be odd
	and ax, 1
	dec ax
	sub r8w, ax				; make seed odd
	xor cx, cx
	xor r9w, r9w
	mov rbx, column_cells	; rbx stores index of next new_line

.init_cells:
	mov ax, cx
	mul cx
	
	add r9w, r8w			; calculate next iteration of Weyl sequence
	add ax, r9w				; add Weyl sequence
	
	mov al, ah				; create random number
	mov ah, dl				; --//--
	mov cx, ax				; store generated random number
	
	and rax, 1				; test whether even or odd
	jz .add_dead
	
	add rax, live - dead - 1

.add_dead: add rax, dead

	mov [cells1 + rdi], al	; move ascii to array
	inc rdi
	cmp rdi, rbx
	jne .init_next

	inc rdi
	add rbx, column_cells + 1

.init_next:
	cmp rdi, array_length
	jne .init_cells

	ret

; r8: current generation
; r9: next generation
next_generation:
	xor ebx, ebx

.process_cell:
	cmp byte [r8 + rbx], new_line
	je .next_cell			; not count neighbours if cell is at the end of the line

	xor eax, eax
.lower_index_neighbour:
	mov rdx, rbx
	dec rdx
	js .higher_index_neighbour

	mov cl, [r8 + rdx]
	and cl, 1				; 0 if new line or dead
	add al, cl
	sub rdx, column_cells - 1
	js .higher_index_neighbour
	
	mov cl, [r8 + rdx]
	and cl, 1				; 0 if new line or dead
	add al, cl
	sub rdx, column_cells - 1
	js .higher_index_neighbour
	
	mov cl, [r8 + rdx]
	and cl, 1				; 0 if new line or dead
	add al, cl
	sub rdx, column_cells - 1
	js .higher_index_neighbour

	mov cl, [r8 + rdx]
	and cl, 1
	add al, cl

.higher_index_neighbour:
	mov rdx, rbx
	dec rdx
	cmp rdx, array_length - 1
	jge .assign_cells

	mov cl, [r8 + rdx]
	and cl, 1
	add al, cl
	add rdx, column_cells - 1
	cmp rdx, array_length - 1
	jge .assign_cells


	mov cl, [r8 + rdx]
	and cl, 1
	add al, cl
	inc rdx
	add rdx, column_cells - 1
	cmp rdx, array_length - 1
	jge .assign_cells
	
	mov cl, [r8 + rdx]
	and cl, 1
	add al, cl
	inc rdx
	add rdx, column_cells - 1
	cmp rdx, array_length - 1
	jge .assign_cells
	
	mov cl, [r8 + rdx]
	and cl, 1
	add al, cl

.assign_cells:
	cmp al, 2
	je .keep_current

	mov byte [r9 + rbx], dead
	cmp al, 3
	jne .next_cell

	mov byte[r9 + rbx], live
	jmp .next_cell

.keep_current:
	mov cl, [r8 + rbx]
	mov [r9 + rbx], cl

.next_cell:
	inc rbx
	cmp rbx, array_length

	jne .process_cell

	jmp start.generate_cells
