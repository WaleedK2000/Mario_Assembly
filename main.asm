include macro.inc
.model small
.386
.stack 0100h

.data
	
	; 165 is the lowest value at which mario touches the ground
	mario_X db 20
	mario_Y db 165
	
	
.code

	mov ax, @data
	mov ds, ax
	mov ax, 0
	jmp main
	
	; BX for Row(Y axis). AX for collumn(x axis)  
	;Dont touch anything. It works perfectly fine. Thanks
	marioGen proc
	
		mov ax, 0
		mov al, mario_X
		sub ax, 5
		
		mov bx, 0
		mov bl, mario_Y
		
		mPrintPixelinRow bx,ax,8,4
		inc bx
		mPrintPixelinRow bx,ax,8,4
		
		inc bx
		mov ax, 0
		mov al, mario_X
		sub al, 7			; moving ax back to hat position
		
		mPrintPixelinRow bx,ax,16,4	; HAT is 16 cols
		inc bx
		mPrintPixelinRow bx,ax,16,4
		inc bx
		mPrintPixelinRow bx,ax,16,4
		inc bx

		push bx
		
		mov cx, 10
		marioGen_L1:
		
			mPrintPixelinRow bx,ax,12,6
			inc bx
		
		loop marioGen_L1
		sub bx, 7
		push ax
		
		add ax, 11
		mov cx, 3
		push dx
		mov dx, 3
		
		marioGen_L2:
			mPrintPixelinRow bx,ax,dx,6
			inc bx
			inc dx
		loop marioGen_L2
		
		pop dx
		pop ax
		pop bx
		
		push dx
		push ax
		push bx
		
		mov cx, 3
		
		mov ax, 0
		mov al, mario_X
		sub ax, 1
		
		marioGen_L3:
			mPrintPixelinRow bx,ax,4,2		;Generating Eyes
			inc bx
		loop marioGen_L3
		
		pop bx
		pop ax
		pop dx
		add bx, 10
		
		mov cx, 10
		
		marioGen_L4:
			mPrintPixelinRow bx,ax,13,4
			inc bx
		loop marioGen_L4
		 ; Add arms here
		 
		 mov cx, 3
		 sub ax, 2
		
		marioGen_L5:
		
			push ax
			mPrintPixelinRow bx,ax,6,4
			
			add ax, 11
			
			mPrintPixelinRow bx,ax,6,4
			pop ax
			inc bx
			
		loop marioGen_L5
		
		sub ax, 2
		mov cx, 4
		marioGen_L6:
			
			push ax
			mPrintPixelinRow bx,ax,6,2
			
			add ax, 16
			
			mPrintPixelinRow bx,ax,6,2
			pop ax
			inc bx

		loop marioGen_L6
		
		sub ax, 2
		mov cx, 4
		
		marioGen_L7:
		
			push ax
			mPrintPixelinRow bx,ax,6,2
			
			add ax, 20
			
			mPrintPixelinRow bx,ax,6,2
			pop ax
			inc bx
		
		
		loop marioGen_L7
		
		mov ax, 0
		mov bx, 0
		
		mov al, mario_X
		mov bl, mario_Y
		
		sub ax, 14
		add bl, 16
		mov cx, 3
		
		marioGen_L8:
		
			push ax
			mPrintPixelinRow bx,ax,8, 4
			add ax, 20
			mPrintPixelinRow bx,ax,8, 4
			pop ax
			inc bx
		loop marioGen_L8
		
		mov cx, 6
		
		marioGen_L9:
		
			push ax
			mPrintPixelinRow bx,ax,6, 6
			add ax, 21
			mPrintPixelinRow bx,ax,7, 6
			pop ax
			inc bx
			
		loop marioGen_L9
		ret
	marioGen endp
	
	
	
	
	clearScreen proc
	
		push ax
		
		mov ax, 03h
		int 10h
		
		pop ax
		ret
	clearScreen endp
	
	printGameScreen proc
	
	
		mov ah, 00h
		mov al, 03h
		int 10h
	
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
	
		mov ah, 00h
		mov al, 13h
		int 10h
		
		call marioGen
		

	
	;	mov ah, 0ch
	;	mov al, 0Eh
	;	mov bh, 00h
	;	mov cx, 10
	;	mov dx, 30
	;	int 10h
		
		
		

		;mPrintPixelinRow 25,25,210, 0Eh

		;	L1_mario:
		;	
		;		mPrintPixelinRow 25, 25, 16
		;	
		;	loop L1_mario
			;mPrintPixelinRow 11,35,80


		
		
		;call printGameScreen
		
		;call printGameScreen
		
		;	mov ah, 0ch
		;	mov al, 04h
		;	mov cx, 5
		;	mov dx, 5
		;	int 10h
		

		
	main endp
	
	
	
	mov ah, 4ch
	int 21h
	end