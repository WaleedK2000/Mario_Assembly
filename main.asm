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
	
	;Clears the screen. I think we will have to call this function in a loop along with printGameScreen. Otherwise movement will not happen. Also We need another function to draw mario
	clearScreen proc
	
		push ax
		mov ax, 03h
		int 10h
		pop ax
		ret
	clearScreen endp
	
	printGameScreen proc
	
		mov ah, 06h
		mov al, 0
		mov bh, 14h ;background colour
		
		mov ch, 20	;upper row number
		mov cl, 15	;Left column
		
		mov dh, 25	;lower row number
		mov dl, 20	;right column number
		int 10h
		;--------------------------------------------
		
		mov ch, 10	;upper row number
		mov cl, 25	;Left column
		
		mov dh, 13	;lower row number
		mov dl, 30	;right column number
		int 10h
		;-------------------------------------------
		
		mov ch, 20	;upper row number
		mov cl, 50	;Left column
		
		mov dh, 25	;lower row number
		mov dl, 55	;right column number
		int 10h
		
		;----------------------------------------
		;Flag
		
		mov ch, 3	;upper row number
		mov cl, 60	;Left column
		
		mov dh, 7	;lower row number
		mov dl, 75	;right column number
		int 10h
		
		;---------------------------------------
		
		
		mov ch, 3	;upper row number
		mov cl, 77	;Left column
		
		mov dh, 25	;lower row number
		mov dl, 78	;right column number
		int 10h

		ret
	printGameScreen endp
	
	
	
	
	
	
	
	main proc
	
		mov ax, 253
		
		mTest
	
	main endp
	
	mov ah, 4ch
	int 21h
	end