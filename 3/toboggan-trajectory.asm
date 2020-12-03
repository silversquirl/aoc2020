%define COLS 31
%define ROWS 323

default rel
section .text

extern getchar
extern printf
extern atoi

global main
main:
	push r12
	push r13
	push r14
	push r15
	push rbp
	mov rbp, rsp

	; Push args for later
	push rdi
	push rsi
	
	xor r12, r12  ; col
	xor r13, r13  ; row
	; Parse input
.parse:
	call getchar
	cmp eax, 0
	jl .parse_end

	cmp eax, 0xa  ; if ch == '\n'
	jne .set_cell
	xor r12, r12  ; Zero col
	inc r13       ; Increment row

	jmp .parse
.set_cell:
	; cell = ch == '#'
	cmp eax, '#'
	sete dl
	; array[row*COLS + col] = cell
	imul rdi, r13, COLS
	mov byte [array + rdi + r12], dl
	; col++
	inc r12

	jmp .parse
.parse_end:

	; Default steps
	mov r14, 3
	mov r15, 1
	
	; Parse args
	pop r13
	pop r12
	cmp r12, 3
	jne .args_end
	; step_col = atoi(argv[1])
	mov rdi, [r13+8*1]
	call atoi
	mov r14, rax
	; step_row = atoi(argv[2])
	mov rdi, [r13+8*2]
	call atoi
	mov r15, rax
.args_end:

	xor rdi, rdi  ; count
	xor r12, r12  ; col
	xor r13, r13  ; row
.loop:
	; col = (col + step_col) % COLS
	mov rax, r12  ; Add 3 to col
	add rax, r14
	xor rdx, rdx  ; Set up division
	mov rsi, COLS
	div rsi
	mov r12, rdx  ; Save remainder
	; row += step_row
	add r13, r15

	cmp r13, ROWS ; If we've passed the end of the table, exit the loop
	jge .loop_end

	; cell = array[row*COLS + col]
	imul rsi, r13, COLS
	xor rax, rax
	mov al, byte [array + rsi + r12]
	; count += cell
	add rdi, rax

	jmp .loop
.loop_end:

	mov rsi, rdi
	lea rdi, [format]
	call printf

	xor rax, rax
	leave
	pop r15
	pop r14
	pop r13
	pop r12
	ret

section .data
format:	db '%lu',0xa,0

section .bss
array:	resb COLS*ROWS
