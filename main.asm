;Removed functions
;	printGameScreenReal
;Added Functions
;	printLevelOne
;	titleScreen (TO DO)
;	readKeystroke (TO DO)
;REVAMPED Functions
;	printGameScreen

;ADDED PAGE Flipping to Reduce Flicker


include macro.inc

.model small
.386
.stack 0100h

.data
	;Too smoothen the flickering/Blinking/FPS/Refresh Rate i used a technique to print screen on another page and switch pages back and forth
	;Generate Pixels on bufferPage to comply with this technique
	current_page db 4
	buffer_page db 0
	
	; 165 is the lowest value at which mario touches the ground (Bottom of the window)
	mario_X db  15
	mario_Y db 163
	enemy_x db  80
	enemy_y db  163
	enemy_x1 db  60
	enemy_y1 db  63
	
	current_Level db 0  
	;Level 0 means Game paused and At start menu.
	;Level 1 means Current Level is 1
	;Level 2 means Current Level is 2
	;Level 3 means current Level is 3
	
	
	
.code

	mov ax, @data
	mov ds, ax
	mov ax, 0
	jmp main
	

	; BX for Row(Y axis). AX for collumn(x axis)  
	;Dont Ask
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
		
		mPrintPixelinRow bx,ax,7,4,buffer_page
		inc bx
		mPrintPixelinRow bx,ax,7,4, buffer_page
		
		inc bx
		mov ax, 0
		mov al, mario_X
		sub al, 7			; moving ax back to hat position
		
		mPrintPixelinRow bx,ax,15,4,buffer_page	; HAT is 16 cols
		inc bx
		mPrintPixelinRow bx,ax,15,4,buffer_page
		inc bx
		mPrintPixelinRow bx,ax,15,4,buffer_page
		inc bx

		push bx
		
		mov cx, 9
		marioGen_L1:
		
			mPrintPixelinRow bx,ax,11,6,buffer_page
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
			mPrintPixelinRow bx,ax,dx,6,buffer_page
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
			mPrintPixelinRow bx,ax,3,2	,buffer_page	;Generating Eyes
			inc bx
		loop marioGen_L3
		
		pop bx
		pop ax
		pop dx
		add bx, 10
		
		mov cx, 8	;fff
		
		marioGen_L4:
			mPrintPixelinRow bx,ax,12,4,buffer_page
			inc bx
		loop marioGen_L4
		 ; Add arms here
		 
		 mov cx, 2
		 sub ax, 2
		
		marioGen_L5:
		
			push ax
			mPrintPixelinRow bx,ax,3,4,buffer_page
			
			add ax, 12
			
			mPrintPixelinRow bx,ax,3,4,buffer_page
			pop ax
			inc bx
			
		loop marioGen_L5
		
		sub ax, 2
		mov cx, 3
		marioGen_L6:
			
			push ax
			mPrintPixelinRow bx,ax,4,2,buffer_page
			
			add ax, 15
			
			mPrintPixelinRow bx,ax,4,2,buffer_page
			pop ax
			inc bx

		loop marioGen_L6
		
		sub ax, 2
		mov cx, 3
		;Boots
		marioGen_L7:
		
			push ax
			mPrintPixelinRow bx,ax,4,2,buffer_page
			
			add ax, 19
			
			mPrintPixelinRow bx,ax,4,2,buffer_page
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
			mPrintPixelinRow bx,ax,4, 4,buffer_page
			add ax, 16
			mPrintPixelinRow bx,ax,4, 4,buffer_page
			pop ax
			inc bx
			
		loop marioGen_L8
		
		mov cx, 5
		;Arms
		marioGen_L9:
		
			push ax
			mPrintPixelinRow bx,ax,3, 6,buffer_page
			add ax, 17
			mPrintPixelinRow bx,ax,3, 6,buffer_page
			pop ax
			inc bx
			
		loop marioGen_L9
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		ret
	marioGen endp
	
	;Used to clear the screen
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
	
	;Please implement the keyboard methords here. Ideally you want to follow the template.
	;Code first checks which level the game is in. Then checks for keypress
	readKeystroke proc
	
		.if(current_Level == 0)
		
			;Keypress conditions for level 0
			mov ah,0
			int 16h
			cmp ah,48h   	 ;scan code for up
			je up
			cmp ah,4Bh  	 ;scan code for left
			je left
			cmp ah,4Dh   	 ; scan code for right
			je right
			cmp ah,50h   	 ;scan code for down
			je down
			
			left:
			mov al, mario_X
			sub al, 5
			right:
			mov al, mario_X
			add al, 5
			up:		
			mov al, mario_Y
			add al, 5
			down:
			mov al, mario_Y
			sub al, 5
			 
			
		.elseif (current_Level == 1)
		
			;Keypress conditions for level 1
			mov ah,0
			int 16h
			cmp ah,48h   	 ;scan code for up
			je up1
			cmp ah,4Bh  	 ;scan code for left
			je left1
			cmp ah,4Dh   	 ; scan code for right
			je right1
			cmp ah,50h   	 ;scan code for down
			je down1
			
			left1:
			mov al, mario_X
			sub al, 10
			right1:
			mov al, mario_X
			add al, 10
			up1:		
			mov bl, mario_Y
			add bl, 10
			down1:
			mov bl, mario_Y
			sub bl, 10
				
		.else
		
			;random
			
		.endif
	
	readKeystroke endp
	

	;Will check which level the user is on and will call a function to  print Screen
	printGameScreen proc
	
		
	
		.if(current_Level == 0)
		
			call printTitleScreen
			
		.elseif (current_Level == 1)
		
			call printLevelOne
			
		.else
		
			;random
			
		.endif

		
		ret
	
	printGameScreen endp
	;Is called when VARIABLE current_Level is 1
	;All visual features Exclusive to Level One Go here
	printLevelOne proc
	
	;	mPrintRectangle 0,400, 320, 5, 10111111b 	,buffer_page	;grass
		
		;	left_x, left_y, len x, len y, color, buffer_pages
		;mPrintRectangle 65,170, 15, 30, 0Eh	
		
		;mPrintRectangle 60,60, 20, 20, 0Eh 	,buffer_page	;hurdle 1
		
		mPrintRectangle 65,170, 15, 30, 0Eh, buffer_page		    ;Hurdle 2
		mPrintRectangle 65,170, 10, 22, 11001110b, buffer_page		;Hurdle 2
		mPrintRectangle 65,170, 5, 16, 01001010b, buffer_page		;Hurdle 2
		
		mPrintRectangle 220,145, 15, 55, 0Eh,buffer_page	   		;Hurdle 3
		mPrintRectangle 220,145, 10, 45, 11001110b,buffer_page		;Hurdle 3
		mPrintRectangle 220,145, 5, 40, 01001010b,buffer_page		;Hurdle 3
		
		mPrintRectangle 315,10, 5, 190, 10001011b	, buffer_page	;Flag Pole
		
	    mPrintRectangle 0,400, 320, 5, 10111111b,buffer_page		;grass
		call drawFlag
		
		ret
	printLevelOne endp
	
	;IS called at the start of Game.
	;Just a title Screen
	;Called when VARIABLE current_Level is 0
	printTitleScreen proc 
		push ax
		push bx
		push cx
		
		mov ah, 09h
		mov al, 'B'
		mov bh, 0
		mov bl, 0Eh
		mov cx, 2
		int 10h
		
		
		mov al, 1
		mov current_Level, al
		pop cx
		pop bx
		pop ax
		
		ret
	printTitleScreen endp
	
	;This function will draw the flag
	drawFlag proc
	
		push ax
		push bx
	    ;flag
		mPrintRectangle 235,10, 80, 40, 0AH,buffer_page
		;Have to draw a moon/ Star / Special char here
		;star
		mPrintRectangle 270,23, 11, 11, 63H,buffer_page
		mPrintRectangle 274,19, 3, 18, 63H,buffer_page      ;vertical
		mPrintRectangle 266,27, 19, 3, 63H,buffer_page      ;horizontal
		
		;mPrintPixelinRow
		
		pop bx
		pop ax
	
	drawFlag endp
	;for level 2
	enemy proc
	        ;body
			mPrintRectangle 135,180, 25, 25,01111101b, buffer_page	
			;hat
			mPrintRectangle 140,177, 14, 3, 01001010b, buffer_page	
			mPrintRectangle 142,175, 10, 2, 01001011b, buffer_page	
			mPrintRectangle 144,173, 6, 2, 01001011b, buffer_page				
			;eyebrows
			mPrintPixelinRow 183,140,4,5	,buffer_page
			mPrintPixelinRow 183,150,4,5	,buffer_page
			;eyes
			mPrintPixelinRow 186,141,2,2	,buffer_page
			mPrintPixelinRow 186,151,2,2	,buffer_page
			;lips
			mPrintPixelinRow 190,145,4,4	,buffer_page
			mPrintPixelinRow 191,145,4,4	,buffer_page
			
	enemy endp
	;for level 3
	enemy1 proc
		;body
	  	mPrintRectangle 60,60, 20, 20, 85h 	,buffer_page	 
		mPrintRectangle 62,62, 15, 15,71h ,buffer_page	
        mPrintRectangle 65,65, 9, 9,66h ,buffer_page
		;eyes
		mPrintRectangle 67,66, 2, 2,69h ,buffer_page
		mPrintRectangle 70,66, 2, 2,69h ,buffer_page
		;hat
         mPrintRectangle 65,57, 9, 3, 15h 	,buffer_page	
		 mPrintRectangle 67,54, 5, 3, 15h 	,buffer_page	
	enemy1 endp
	delay proc
		push ax
		push bx
		push cx
		push dx

		mov cx,210
		mydelay:
		mov bx,220      ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.
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
	
	
	switchPage proc
	
		push ax
		mov al, current_page
		mov ah, buffer_page
		
		mov current_page, ah
		mov buffer_page, al
		
		pop ax
		call setPage
		ret
		
	
	switchPage endp
	
	
	setPage proc
	
		mov ah, 05h
		mov al, current_page
		int 10h
		ret
	setPage endp
	

	main proc
		
	BPF:	
		mov cx, 1
		mov ax,0
		call clearScreen
		call setPage
		back:
			push cx
			mov al, mario_X
			;add al, 5
			
			mov mario_X, al
			
			call marioGen
			
			call enemy
			call enemy1
		
			call printGameScreen
			call switchPage
			
			mov al, mario_X
			mov bl,enemy_x
			mov bh,enemy_x1
		;	add al, 2
			
			;mov mario_X, al
			
			call printGameScreen
			mov ah,0
			call readKeystroke
			call switchPage


		
			pop cx
		loop back	
	jmp BPF 
		;^^^^^^^^^Starts an infinite loop. Uncomment this to see movement :D. 
		
	main endp
	
	
	
	mov ah, 4ch
	int 21h
	end 