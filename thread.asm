	; Create a thread in assembler - March 20, 2019
	;
	;      (C) 2019 - Michael K. Pellegrino
	;
	; 64bit Assembler Library Written for MacOSX
	;

section .data
	time_val dq 0,0
	time_val2 dq 0,0
	pid    dq 0
	pid2   dq 0

	
	msg1L  dq msg1.msg1end - msg1
	msg1   db "Process 1", 0x0A, 0x00
.msg1end:
	msg2L  dq msg2.msg2end - msg2
	msg2   db "Process 2", 0x0A, 0x00
.msg2end:
	msg3L  dq msg3.msg3end - msg1
	msg3   db "Thread is terminated.", 0x0A, 0x00
.msg3end:


section .text
global _thread

_thread:

	mov rdx, time_val
	mov [rdx], rdi 		; same the pointer to the time_val struct
	
	mov rax, 0x2000014 ; get pid
	syscall
	mov rdi, pid
	mov [rdi], rax
	mov r9, rax
	
	mov rax, 0x2000002 ; fork
	syscall		   ; everything after here is in the forked process up until skipfork:

	mov rax, 0x2000014 ; get pid
	syscall
	mov rdi, pid2
	mov [rdi], rax

	cmp r9, rax
	je skipfork

	; This will happen in the forked process
	;
forkedprocess:

	; Display Message
	mov rax, 0x2000004 ; write
	mov rdi, 0x01	
	mov rdx, msg2
	mov rsi, rdx
	mov rbx, msg2L
	mov rdx, [rbx]	
	syscall

	mov rax, 0x2000074 ; systime
	mov rdx, time_val
	lea rdi, [rel rdx]
	xor esi, esi		
	syscall

forkloop:

	mov rax, 0x2000074 ; systime
	mov rdx, time_val2
	lea rdi, [rel rdx]
	xor esi, esi
	syscall

	mov rdx, time_val
	mov rbx, [rdx]

	mov rdx, time_val2
	mov rax, [rdx]

	sub rax, rbx
	mov rbx, 0xE56C8FC7	; a few seconds later
	cmp rax, rbx
	jge stoplooping

	jmp forkloop

stoplooping:
	mov rax, 0x2000004 ; write
	mov rdi, 0x01	
	mov rdx, msg3
	mov rsi, rdx
	mov rbx, msg3L
	mov rdx, [rbx]	
	syscall
	
	mov rax, 0x2000001 ; exit (kill the forked process)
	syscall

skipfork:
	; This will happen in the main process
	;
	mov rax, 0x2000004 ; write
	mov rdi, 0x01	
	mov rdx, msg1
	mov rsi, rdx
	mov rbx, msg1L
	mov rdx, [rbx]	
	syscall

	ret

_end_of_code:
