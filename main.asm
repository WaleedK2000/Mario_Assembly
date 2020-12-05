include macro.inc

.model small
.386
.stack 0100h

.data

.code

	mov ax, @data
	mov ds, ax
	mov ax, 0
	jmp main
	
	
	
	
	main proc
	
		mov ax, 253
		
		mTest
	
	main endp
	
	mov ah, 4ch
	int 21h
	end