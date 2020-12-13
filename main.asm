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
	;variables for title page
	count db 0
	Row_poistion db 0
	Column_poistion db 0
	lives db 3
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

		push ax
		push bx
		push cx
		push dx
		;Reccord KEYSTROKE from USER here. PLS DONT HAVE MORE THEN ONE.
		
		xor ax, ax
		
		mov ah,01h
		int 16h
		
	jz NO_IN
		
		mov ah,00h
		int 16h
		
		.if(current_Level == 0)
		COMMENT @
			;Keypress conditions for level 0		

				cmp ah,48h
				je u
				cmp ah,4Bh
				je l
				cmp ah,4Dh
				je r
				cmp ah,50h
				je d


				l:
					mov al,mario_X
					sub al,5
					mov mario_X,al
					jmp exit

				r:
					mov al,mario_X
					add al,5
					mov mario_X,al

			
					jmp exit

				u:
					mov al,mario_Y
					add al,10
					mov mario_Y,al
					jmp exit

				d:
					mov al,mario_Y
					sub al,10
					mov mario_Y,al
					jmp exit
				 
				 exit:

			@
		.elseif (current_Level == 1)
		
			
			cmp ah,48h
				je u2
				cmp ah,4Bh
				je l2
				cmp ah,4Dh
				je r2
				cmp ah,50h
				je d2


				l2:
					mov al,mario_X
					sub al,5
					mov mario_X,al
					jmp exit2

				r2:
					mov al,mario_X
					add al,5
					mov mario_X,al
			
					jmp exit2

				u2:
					mov al,mario_Y
					sub al,10
					mov mario_Y,al
					jmp exit2

				d2:
					mov al,mario_Y
					add al,10
					mov mario_Y,al
					jmp exit2
				 
				 exit2:
		.else
		
			;random
			
			
			cmp ah,48h
				je u3
				cmp ah,4Bh
				je l3
				cmp ah,4Dh
				je r3
				cmp ah,50h
				je d3


				l3:
					mov al,mario_X
					sub al,10
					mov mario_X,al
					jmp exit3

				r3:
					mov al,mario_X
					add al,10
					mov mario_X,al
			
					jmp exit3

				u3:
					mov al,mario_Y
					add al,10
					mov mario_Y,al
					jmp exit3

				d3:
					mov al,mario_Y
					sub al,10
					mov mario_Y,al
					jmp exit3
				 
				 exit3:

		.endif
		
		NO_IN:
		
		pop dx
		pop cx
		pop bx
		pop ax
	
		ret
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
	
		mPrintRectangle 0,400, 320, 5, 10111111b 	,buffer_page	;grass
		
		;left_x, left_y, len x, len y, color, buffer_pages
		mPrintRectangle 65,170, 15, 30, 0Eh	
		
		mPrintRectangle 60,60, 20, 20, 0Eh 	,buffer_page	;hurdle 1
		
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
	mov al,12
	mov ah,06
	int 10h
;------background---------

	;mov cx,0
 mov ah,6
 mov al,0
 mov bh,66h
 mov cl,0  ;left
 mov ch,50 ;up control
 mov dh,200
 mov dl,90  ;right control 
 int 10h 

;-------top side-----------

mov Row_poistion, 8
mov Column_poistion, 27

mov count,0
top:
inc count
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion     ;SET ROW 
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS
	
	
	
	mov ah,09h
	mov al,'-'
	mov bh,0
	mov bl,49h
	mov cx,1
	int 10h
	add Column_poistion,1
	
	cmp	count,22
	jbe top

;-------bottom side----------

mov Row_poistion, 15
mov Column_poistion, 28

mov count,0

bottom:
	inc count
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion     ;SET ROW 
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'-'
	mov bh,0
	mov bl,49h
	mov cx,1
	int 10h
	add Column_poistion,1
	
	cmp	count,21
	jbe bottom

;--------------------------------------
;-------Name_Display----------

mov Row_poistion, 10
mov Column_poistion,35
mov count,0


	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'M'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'A'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'R'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS
	
	mov ah,09h
	mov al,'I'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'O'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	
;-------press ----------

mov Row_poistion, 13
mov Column_poistion,31
mov count,0


	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'P'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'R'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'E'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS
	
	mov ah,09h
	mov al,'S'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'S'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	;-------space ----------

mov Row_poistion, 13
mov Column_poistion,38
mov count,0


	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'S'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'P'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'A'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS
	
	mov ah,09h
	mov al,'C'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	MOV AH,2                ;SET CURSOR POSITION                 
	MOV DH,Row_poistion   ;SET ROW 
	inc Column_poistion
	MOV DL,Column_poistion  ;SET COLUMN
	INT 10H                 ;CALLING BIOS

	mov ah,09h
	mov al,'E'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
		
		
		
		;mov al, 1
		;mov current_Level, al
		pop cx
		pop bx
		pop ax
		
		ret
	printTitleScreen endp
	
	progress proc
		push ax
		push bx
		push cx
		push dx

	mov ah,09h
	mov al,'L:'
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	inc bx
	
	mov ah,09h
	mov al,lives
	mov bh,0
	mov bl,0Eh
	mov cx,1
	int 10h
	
	pop dx
	pop cx
	pop bx
	pop ax

	progress endp
	
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
	     push ax
	push bx
	mov ax,0
	mov bx,0
	mov bl,enemy_y
	mov al,enemy_x
	        ;body
			mPrintRectangle ax,bx, 25, 20,01111101b, buffer_page	;ax 135 bx 180
			
			;hat
			add ax,5
			sub bx,3
			mPrintRectangle 140,177, 14, 3, 01001010b, buffer_page	 ;ax 140  bx 177
			add ax,2
			sub bx 2
			mPrintRectangle 142,175, 10, 2, 01001011b, buffer_page	 ;ax 142  bx 175
			add ax,2
			sub bx 2
			mPrintRectangle 144,173, 6, 2, 01001011b, buffer_page	 ;ax 144  bx 173		
			
			;eyebrows
			add ax,39
			sub bx 33
			mPrintPixelinRow 183,140,4,5	,buffer_page			 ;ax 183 bx 140
			add bx,10
			mPrintPixelinRow 183,150,4,5	,buffer_page             ;ax183 bx 150
			
			;eyes
			add ax,3
			sub bx 0
			mPrintPixelinRow 186,141,2,2	,buffer_page             ;ax 186 bx 141
			add bx,10
			mPrintPixelinRow 186,151,2,2	,buffer_page			;ax 186 bx 151
			
			;lips
			add ax,4
			sub bx,6
			mPrintPixelinRow 190,145,4,4	,buffer_page			;ax 190 bx 145
			add ax,1
			mPrintPixelinRow 191,145,4,4	,buffer_page			;ax 191 bx 145
		pop bx
        pop ax		  
	enemy endp
	
	;for level 3
	enemy1 proc
				push ax
	push bx
	mov ax,0
	mov bx,0
	mov bl,enemy_y1
	mov al,enemy_x1
	
		;body
	  	mPrintRectangle ax,bx, 20, 20, 85h 	,buffer_page	     ;ax 60 bx 60
		add ax,2
		add bx,2
		mPrintRectangle 62,62, 15, 15,71h ,buffer_page			 ;ax 62 bx 62
		add ax,3
		add bx,3
        mPrintRectangle 65,65, 9, 9,66h ,buffer_page			 ;ax 65 bx 65
		
		;eyes
		add ax,2
		add bx,1
		mPrintRectangle 67,66, 2, 2,69h ,buffer_page			 ;ax 67 bx 66
		add ax,3
		mPrintRectangle 70,66, 2, 2,69h ,buffer_page			 ;ax 70 bx 66
		
		;hat
		sub ax,5
		sub bx,9
        mPrintRectangle 65,57, 9, 3, 15h 	,buffer_page		 ;ax 65 bx 57
		add ax,2
		sub bx,3
		mPrintRectangle 67,54, 5, 3, 15h 	,buffer_page		 ;ax 67 bx 54
		pop bx
		pop ax
	enemy1 endp
	
	delay proc
		push ax
		push bx
		push cx
		push dx

		mov cx,250
		mydelay:

		mov bx,250   ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.

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

			;mov al, mario_X

			;add al, 5
			
	

			
			call readKeystroke
			call marioGen

			call printGameScreen
			call switchPage

			call progress
			call readKeystroke
			;mov al, mario_X
			;add al, 2
			;call readKeystroke
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
