include macro.inc

.model small
.386
.stack 0100h

.data
	
	; 165 is the lowest value at which mario touches the ground (Bottom of the window)
	mario_X db 120
	mario_Y db 50
	;To Do
	
.code

	mov ax, @data
	mov ds, ax
	mov ax, 0
	jmp main
	

	; BX for Row(Y axis). AX for collumn(x axis)  
	;Please Dont touch anything here. I cant go through the tourture of fixing this
	marioGen proc
	
		push ax
		push bx
		push cx
		push dx
		
		
	
		mov ax, 0
		mov al, mario_X
		sub ax, 5
		
		mov bx, 0
		mov bl, mario_Y
		
		mPrintPixelinRow bx,ax,7,4
		inc bx
		mPrintPixelinRow bx,ax,7,4
		
		inc bx
		mov ax, 0
		mov al, mario_X
		sub al, 7			; moving ax back to hat position
		
		mPrintPixelinRow bx,ax,15,4	; HAT is 16 cols
		inc bx
		mPrintPixelinRow bx,ax,15,4
		inc bx
		mPrintPixelinRow bx,ax,15,4
		inc bx

		push bx
		
		mov cx, 9
		marioGen_L1:
		
			mPrintPixelinRow bx,ax,11,6
			inc bx
		
		loop marioGen_L1
		sub bx, 7
		push ax
		
		add ax, 11
		mov cx, 3
		push dx
		mov dx, 2
		
		;sub dx, 2
		
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
		
		mov cx, 2
		
		mov ax, 0
		mov al, mario_X
		sub ax, 1
		
		marioGen_L3:
			mPrintPixelinRow bx,ax,3,2		;Generating Eyes
			inc bx
		loop marioGen_L3
		
		pop bx
		pop ax
		pop dx
		add bx, 10
		
		mov cx, 8	;fff
		
		marioGen_L4:
			mPrintPixelinRow bx,ax,12,4
			inc bx
		loop marioGen_L4
		 ; Add arms here
		 
		 mov cx, 2
		 sub ax, 2
		
		marioGen_L5:
		
			push ax
			mPrintPixelinRow bx,ax,3,4
			
			add ax, 12
			
			mPrintPixelinRow bx,ax,3,4
			pop ax
			inc bx
			
		loop marioGen_L5
		
		sub ax, 2
		mov cx, 3
		marioGen_L6:
			
			push ax
			mPrintPixelinRow bx,ax,4,2
			
			add ax, 15
			
			mPrintPixelinRow bx,ax,4,2
			pop ax
			inc bx

		loop marioGen_L6
		
		sub ax, 2
		mov cx, 3
		;Boots
		marioGen_L7:
		
			push ax
			mPrintPixelinRow bx,ax,4,2
			
			add ax, 19
			
			mPrintPixelinRow bx,ax,4,2
			pop ax
			inc bx
		
		
		loop marioGen_L7
		
		mov ax, 0
		mov bx, 0
		
		mov al, mario_X
		mov bl, mario_Y
		
		sub ax, 11
		add bl, 16
		mov cx, 2
		;Shoulders
		marioGen_L8:
		
			push ax
			mPrintPixelinRow bx,ax,4, 4
			add ax, 16
			mPrintPixelinRow bx,ax,4, 4
			pop ax
			inc bx
			
		loop marioGen_L8
		
		mov cx, 5
		;Arms
		marioGen_L9:
		
			push ax
			mPrintPixelinRow bx,ax,3, 6
			add ax, 17
			mPrintPixelinRow bx,ax,3, 6
			pop ax
			inc bx
			
		loop marioGen_L9
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		ret
	marioGen endp
	
	
	clearScreen proc
	
		call delay
		
		push ax
	;	mov ax, 03h
	;	int 10h
		
		mov ah, 00h
		mov al, 13h
		int 10h	
		
		
		pop ax
		ret
	clearScreen endp
	
	;Probabaly will have to remove and redo this function
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
	
	printGameScreenReal proc
		;	left_x, left_y, len x, len y, color
		;mPrintRectangle 65,170, 15, 30, 0Eh	
		
		mPrintRectangle 60,60, 20, 20, 0Eh 		;hurdle 1
		
		mPrintRectangle 65,170, 15, 30, 0Eh		;Hurdle 2
		
		mPrintRectangle 220,145, 15, 55, 0Eh	;Hurdle 3
		
		
		mPrintRectangle 315,10, 5, 190, 0Eh		;Flag Pole
		

		call drawFlag
		
		ret
	printGameScreenReal endp
	
	
	drawFlag proc
	
		push ax
		push bx
	
		mPrintRectangle 235,10, 80, 40, 0AH
		
		;Have to draw a moon/ Star / Special char here
		;mPrintPixelinRow
		
		pop bx
		pop ax
	
	drawFlag endp
	
	
	delay proc


		push ax
		push bx
		push cx
		push dx

		mov cx,500
		mydelay:
		mov bx,450      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
		mydelay1:
		dec bx
		jnz mydelay1
		loop mydelay


		pop dx
		pop cx
		pop bx
		pop ax

		ret
	delay endp
	
	


	main proc
		call clearScreen
	
		back:
			mov al, mario_X
			add al, 5
			
			mov mario_X, al
			
			call marioGen
			
			mov ah, 09h
			mov al, 'B'
			mov bh, 0
			mov bl, 0Eh
			mov cx, 2
			int 10h

			call printGameScreenReal
			;call clearScreen
		
		;jmp back 
		;^^^^^^^^^Starts an infinite loop. Uncomment this to see movement :D. 
		
	main endp
	
	
	
	mov ah, 4ch
	int 21h
	end
