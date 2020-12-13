;***NOTICE****
;THERES A BUG WHERE MARIO GLITCHES AFTER X_AXIS IS 250
; IF CURRENT LEVEL IS -50 GAME WILL EXIT. Pressing E will exit game on ALL LEVELS!
;END OF NOTICE
;ADDED EXIT CONDITION. PRESS E TO Exit ON LEVEL 1. PLANNED TO CHANGE TO ANOTHER KEY?
;ADDED condition exit based on current_LEVEL
;Missing Return in function Call FLAG : D
;Added Flag Movement
;Clean up on aisle readKeystroke proc
;Added IF conditions to prevent Mario from Moving Out of Bounds
;ADDED Functions
	;Jumper proc
		;Responsible for smoother jump animation. Uses Variable jump_Maker.
	;motionControl_Xaxis
		;Controls Collisons on X axis. USES AL REGISTER TO DETERMINE DIRECTION OF MOVEMENT ON X AXIS
	;gravitaionalForce
		;What goes up must come down 
	
	;Print hurdle
		;Function introduced to make code reusable
	;Reset 
		;function to reset Mario's position
	;collisionTrac
		;Dectects Collision Between Mario and Enemy A (LEVEL TWO ENEMY)
	;printGameCompleteScreen
		;Will display a game ending message before the game ends
		
;AND A BUNCH MORE I CANT REMEMBER
		
;ENEMEY A CAN MOVE!!!!!!!
	

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
	
	enemy_x db  140
	enemy_y db  175
	enemyVelocity db 5
	
	enemy_x1 db  60
	enemy_y1 db  63
	
	current_Level db 3
	;Level 0 means Game paused and At start menu.
	;Level 1 means Current Level is 1
	;Level 2 means Current Level is 2
	;Level 3 means current Level is 3
	; 10 means end of 1
	;20 means end of Level 2
	;30 means end of level 3 (END OF GAME)
	;WHEN LEVEL 1 IS COMPLETE current_Level = 10. This Starts the level complete Screen
	
	jump_Maker db 0
	allowDJmp db 1 ;0 means allow double jump, 1 Means do not allow double jump or JUMP
	
	flag_Y db 10

	;----------- 200 AT FLOOR OF WINDOW
	
	
	
	;STRINGS
	strTitleScreen1 db 'PRESS ANY KEY TO START'
	strLEVELONE1 db 'E: Exit'
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
		mov ah, 00h
		mov al, 13h
		int 10h	
		pop ax
		ret
		
	clearScreen endp
	
	
	reset proc

		mov mario_X, 15
		mov mario_Y, 163
		mov flag_Y, 10
		
		ret
	reset endp
	
	;Incharge of Tracking collisions of Mario with Enemy in LEVEL 2 ONLY
	collisionTrac proc
		push ax
		mov ax, 0
		mov al, enemy_x
		sub al, 10			;LEFT MOST HIT BOX
		
		.if( al < mario_X)
		
			add al, 40 ;(10 + 20 ) ;RIGHT MOST HIT BOX  (10 is LEFT MOST HITBOX)
			.if( mario_X < al )
			
				.if(  mario_Y > 155 )
				
					call reset		;YES, COLLISION HATH TAKE PLACE
				
				.endif
			
		
			.endif

		.endif
		
		pop ax
		ret
	collisionTrac endp
	;Moves Enemy. LEVEL TWO ONLY!!!
	moveEnemy proc
	
	
		.if( enemy_x < 85 )	;Right Corner of Hurdle 1
			
				.if( enemy_x > 60 )	; Left Corner of Hurdle 2
					;Collision with Hurdle 1. Change Direction
					
						mov enemyVelocity, 2

				.endif
		.elseif( enemy_x < 240 )   ; RIGHT Corner of Hurdle 2 Ground	
				
				.if( enemy_x > 195  ) ; LEFT Corner
					
					
						mov enemyVelocity, -2 ;Collison with hurdle 2. Change Direction
				
	
				.endif
		.endif
	
	
		mov al, enemyVelocity
		add enemy_x, al
		ret
	moveEnemy endp
	
	;Please implement the keyboard methords here. Ideally you want to follow the template.
	;Code first checks which level the game is in. Then checks for keypress
	
	readKeystroke proc
;************************************************ E KEY TO EXIT ON ALL SCREENS ***************************************************************************
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
		
		cmp al, 'e'		;EXIT CONDITION ON ALL GAME STATES
		je BYE
		
		
		
		.if(current_level > 0)

			.if(current_level < 4)
			
				cmp ah,48h
				je move_up
				cmp ah,4Bh
				je move_left
				cmp ah,4Dh
				je move_right
				cmp ah,50h
				je move_down
			
			.endif
		
		.endif
		
		jmp NO_IN
		
		.if(current_Level == 0)
		COMMENT @
			;Keypress conditions for level 0		
			;********************************************COMMENTED OUT
				cmp ah,48h
				je move_up
				cmp ah,4Bh
				je move_left
				cmp ah,4Dh
				je move_right
				cmp ah,50h
				je move_down


				move_left:
					mov al,mario_X
					sub al,5
					mov mario_X,al
					jmp exit

				move_right:
					mov al,mario_X
					add al,5
					mov mario_X,al
					jmp exit

				move_down:
					mov al,mario_Y
					add al,10
					mov mario_Y,al
					jmp exit

				move_up:
					mov al,mario_Y
					sub al,10
					mov mario_Y,al
					jmp exit
				 
				 exit:

			@
		.elseif (current_Level == 1)
										;Key Presses For LEVEL 1
			
				cmp ah,48h
				je move_up
				cmp ah,4Bh
				je move_left
				cmp ah,4Dh
				je move_right
				cmp ah,50h
				je move_down
				

				
		.elseif ( current_level == 2 )
		
				cmp ah,48h
				je move_up
				cmp ah,4Bh
				je move_left
				cmp ah,4Dh
				je move_right
				cmp ah,50h
				je move_down
				
				cmp al, 'e'
				je BYE
				
		.elseif (current_level == 3)
		
				cmp ah,48h
				je move_up
				cmp ah,4Bh
				je move_left
				cmp ah,4Dh
				je move_right
				cmp ah,50h
				je move_down
				
				cmp al, 'e'
				je BYE
				
		
		
		.else
										;NOT IMPLEMENTED
			;random
			COMMENT @
			
			cmp ah,48h
				je u3
				cmp ah,4Bh
				je l3
				cmp ah,4Dh
				je r3
				cmp ah,50h
				je d3


				@

		.endif
		
			jmp NO_IN
				move_left:
						
					.if( mario_X < 16 )
						jmp NO_IN
					.endif
					
					sub mario_X, 3
				;	mov al,mario_X
				;	sub al,5
				;	mov mario_X,al
					;******** PARAMETER PASSED THROUGH AL *******
					push ax
					mov al, 10
					call motionControl_Xaxis
					pop ax
					
					jmp NO_IN

				move_right:
				
					.if( mario_X > 250 )
						jmp NO_IN
					.endif
				
				;	mov al,mario_X
				;	add al,5
				;	mov mario_X,al
					add mario_X, 3
					;******** PARAMETER PASSED THROUGH AL *******
					push ax
					mov al, -10
					call motionControl_Xaxis
					pop ax
					
					jmp NO_IN

				move_down:
					mov al,mario_Y
					add al,10
					mov mario_Y,al
					jmp NO_IN

				move_up:
					
					
					.if( jump_Maker > 0 )
					
						mov allowDJmp, 0 ;Block Double Jump
					
					.endif
					
			;****************************************** TO BE IMPLEMENTED *****************************	
					.if( allowDJmp  == 0 )
						jmp NO_IN
					.else					
					
						mov jump_Maker, 30
						jmp NO_IN
					.endif
				second_Jump:
					add jump_Maker, 5
					jmp NO_IN
					
		
		BYE:
			mov current_Level, -50	;-50 is for EXIT Condition
		
		
		NO_IN:
		
		
		
		
		pop dx
		pop cx
		pop bx
		pop ax

		ret
	readKeystroke endp
	
	jumper proc
	
		.if(jump_Maker > 0)
			dec jump_Maker
			sub mario_Y, 2
		.endif	
	
	
		ret
	jumper endp
	
	
	;Function Introduces Gravity. Also checks if Mario is about to land on a Hurdle. In which case it makes him stand on it
	gravitaionalForce proc
	
		.if(current_level == 3)
			jmp KE
		.endif
		
		.if( current_level == 2 )
			
			
			jmp KE
		.endif
	
	
		.if(current_Level == 1)
			KE:
			.if( mario_X < 95 )	;Right Corner of Hurdle 1
			
				.if( mario_X > 55 )	; Left Corner of Hurdle 2
					;Collision with Hurdle 1. But now we check Y axis
					.if(mario_Y > 130)
						.if(mario_Y < 145)
							mov mario_Y, 135
							mov jump_Maker, 0
							mov allowDJmp, 1
						.endif	
					.endif
			
				.endif
			.elseif( mario_X < 250 )   ; RIGHT Corner of Hurdle 2 Ground	
				
				.if( mario_X > 204  ) ; LEFT Corner
					
					.if(mario_Y > 100)
						.if(mario_Y < 115)
							mov mario_Y, 105
							mov jump_Maker, 0
							mov allowDJmp, 1
						.endif	
					.endif
					
				.endif
			.endif	
		.endif
	
		.if( mario_Y > 157 )
			
			.if( mario_Y < 200)
				mov mario_Y, 163
				mov allowDJmp, 1
			.endif	
			
		.else
			add mario_Y, 5	;5 IS Gravity Value
		.endif
			
		ret
	
	gravitaionalForce endp
	


	
	

	;Will check which level the user is on and will call a function to  print Screen
	printGameScreen proc
	
		.if(current_Level == 0)
			call printTitleScreen
		.elseif (current_Level == 1)
			call printLevelOne
		.elseif (current_Level == 10)
			call printLevelOneEnd
		.elseif (current_Level == 2)
			call moveEnemy
			call collisionTrac
			call printLevelTwo
		.elseif	(current_level == 20)
			call printLevelTwoEnd
		.elseif (current_level == 3)
			call moveEnemy
			call collisionTrac
			call printLevelThree
			
		.elseif(current_level == 30)
			call printGameCompleteScreen
		.else
			;random
		.endif
		ret
	
	printGameScreen endp
	
	printHurdles proc
	
		;mPrintRectangle 0,400, 320, 5, 10111111b 	,buffer_page	;grass
		
		;left_x, left_y, len x, len y, color, buffer_pages
		mPrintRectangle 65,170, 15, 30, 0Eh	
		;mPrintRectangle 75,170, 5, 30, 0Eh	
		
		mPrintRectangle 180,60, 20, 20, 0Eh 	,buffer_page			;hurdle 1 UPPER
		;mPrintRectangle 60,170, 15, 30, 0Eh, buffer_page		    ;Hurdle 2
		
		mPrintRectangle 65,170, 10, 22, 11001110b, buffer_page		;Hurdle 2
		mPrintRectangle 65,170, 5, 16, 01001010b, buffer_page		;Hurdle 2
		
		mPrintRectangle 220,145, 15, 55, 0Eh,buffer_page	   		;Hurdle 3
		mPrintRectangle 220,145, 10, 45, 11001110b,buffer_page		;Hurdle 3
		mPrintRectangle 220,145, 5, 40, 01001010b,buffer_page		;Hurdle 3
		
		mPrintRectangle 315,10, 5, 190, 10001011b	, buffer_page	;Flag Pole
		
		mPrintRectangle 0,400, 320, 5, 10111111b,buffer_page		;grass
		
		ret
	printHurdles endp
	
	
	;HURDLE 1 (65,170)   To    (80,200) 
	;Hurdle 2 ( 220, 145 )   TO (235 , 200  )
	
	;Is called when VARIABLE current_Level is 1
	;All visual features Exclusive to Level One Go here
	
	printLevelOne proc
	

		call printHurdles
		
		mov si, offset strLEVELONE1
		mWriteStringAtPos 0,0, si, 7 , 0Eh, buffer_page ;Prints Exit: E
			
		.if(mario_X > 249)
				
			.if( flag_Y < 150 )
			
				add flag_Y, 2
				call drawFlag
						
			.else
			
				mov current_Level, 10
			
			.endif
			
			
		.endif
			
			
		call drawFlag
		
		ret
	printLevelOne endp
	
	
	printLevelOneEnd proc
		
		
		call clearScreen
		;INSERT MESSAGE HERE USING MACRO AND STRING
		mdelay 1200	;Delay before starting Next Level
		
		mov current_Level, 2  ;Start Level 2

		call reset
		ret
	
	printLevelOneEnd endp
	
	
	printLevelTwo proc
	
		call enemy
		call printHurdles
		
		
		
		.if(mario_X > 249)
				
			.if( flag_Y < 150 )
			
				add flag_Y, 2
				call drawFlag
						
			.else
			
				mov current_Level, 20 ; LEVEL 2 ends
			
			.endif
			
			
		.endif
			
			
		call drawFlag
		ret
	printLevelTwo endp
	;Prints the end of Level 2 after flag reaches bottom 

	printLevelTwoEnd proc
	
	
		call clearScreen
		;INSERT MESSAGE HERE USING MACRO AND STRING
		;Something like LEVEL X COMPLETE
		;Figure it out smh
		mdelay 1200	;Delay before starting Next Level
		
		mov current_Level, 3  ;Start Level 3

		call reset
	
		ret
	printLevelTwoEnd endp
	
	
	printLevelThree proc
	
		call enemy
		call printHurdles
		call enemy1
		
		.if(mario_X > 249)
				
			.if( flag_Y < 150 )
			
				add flag_Y, 2
				call drawFlag
						
			.else
			
				mov current_Level, 30 ;Game Ends
			
			.endif
			
		.endif
			
			
		call drawFlag
	
		
		ret
	printLevelThree endp
	
	
	printGameCompleteScreen proc
	
		; ADD GAME END MESSAGE HERE
		mdelay 1200 ;Delay before exiting
		mov current_LEVEL, -50 ;exit code
		
		ret
	
	printGameCompleteScreen endp
	
	;IS called at the start of Game.
	;Just a title Screen
	;Called when VARIABLE current_Level is 0
	printTitleScreen proc 
	
		push ax
		push bx
		push cx
		
		mov si, offset strTitleScreen1
		mWriteStringAtPos 45,45, si, 22 , 0Eh, buffer_page
	
	;	mMoveCursor 80,80,buffer_page
		
	;	mWriteCharAtCursor 'C', 0AH,buffer_page
	;	mWriteCharAtCursor 'C', 0AH,buffer_page
		
		mdelay 1250
		
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
	
		
		mov ax, 0
		mov al, flag_Y
		
		mPrintRectangle 235,ax, 80, 40, 0AH,buffer_page
		add ax, 13
		;Have to draw a moon/ Star / Special char here
		;star
		mPrintRectangle 270,ax, 11, 11, 63H,buffer_page
		sub ax, 4
		mPrintRectangle 274,ax, 3, 18, 63H,buffer_page      ;vertical
		add ax, 8
		mPrintRectangle 266,ax, 19, 3, 63H,buffer_page 
		

		pop ax
		ret
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
			mPrintRectangle ax,bx, 14, 3, 01001010b, buffer_page	 ;ax 140  bx 177
			add ax,2
			sub bx, 2
			mPrintRectangle ax,bx, 10, 2, 01001011b, buffer_page	 ;ax 142  bx 175
			add ax,2
			sub bx, 2
			mPrintRectangle ax,bx, 6, 2, 01001011b, buffer_page	 ;ax 144  bx 173		
			
			;eyebrows
			add ax,39
			sub bx, 33
			;mPrintPixelinRow ax,bx,4,5	,buffer_page			 ;ax 183 bx 140
			add bx,10
		;	mPrintPixelinRow ax,bx,4,5	,buffer_page             ;ax183 bx 150
			
			;eyes
			add ax,3
			sub bx, 9
		;	mPrintPixelinRow ax,bx,2,2	,buffer_page             ;ax 186 bx 141
			add bx,10
		;	mPrintPixelinRow ax,bx,2,2	,buffer_page			;ax 186 bx 151
			
			;lips
			add ax,4
			sub bx,6
		;	mPrintPixelinRow ax,bx,4,4	,buffer_page			;ax 190 bx 145
			add ax,1
		;	mPrintPixelinRow ax,bx,4,4	,buffer_page			;ax 191 bx 145
			pop bx
			pop ax
			ret
	enemy endp
	
	
	enemyK proc
		push ax
		push bx
	        ;body
			mov ax, 0
			mov bx, 0
			
			mov al, enemy_x ;135 Stored
			mov bl, enemy_y ;180 stored
			
			;mPrintRectangle 135,180, 25, 25,01111101b, buffer_page	OLD
			mPrintRectangle ax,bx, 25, 25,01111101b, buffer_page	;ax = 135, bx = 180
			;hat
			add ax, 5	;ax = 140
			sub bx, 3	;bx = 177
			;mPrintRectangle 140,177, 14, 3, 01001010b, buffer_page	OLD
			
			mPrintRectangle ax,bx, 14, 3, 01001010b, buffer_page	;ax = 140, bx = 177
			
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
		pop bx
		pop ax
		ret
	enemyK endp
	
	;for level 3
	enemy11 proc
	
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
		ret
		
	enemy11 endp
	
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
		mPrintRectangle ax,bx, 15, 15,71h ,buffer_page			 ;ax 62 bx 62
		add ax,3
		add bx,3
        mPrintRectangle ax,bx, 9, 9,66h ,buffer_page			 ;ax 65 bx 65
		
		;eyes
		add ax,2
		add bx,1
		mPrintRectangle ax,bx, 2, 2,69h ,buffer_page			 ;ax 67 bx 66
		add ax,3
		mPrintRectangle ax,bx, 2, 2,69h ,buffer_page			 ;ax 70 bx 66
		
		;hat
		sub ax,5
		sub bx,9
        mPrintRectangle ax,bx, 9, 3, 15h 	,buffer_page		 ;ax 65 bx 57
		add ax,2
		sub bx,3
		mPrintRectangle ax,bx, 5, 3, 15h 	,buffer_page		 ;ax 67 bx 54
		pop bx
		pop ax
	
	
	enemy1 endp
	
	
	
	
	delay proc
		push ax
		push bx
		push cx
		push dx

		mov cx,150
		mydelay:

		mov bx,150   ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.

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
	
	
	;HURDLE 1 (65,170)   To    (80,200)   
	;Hurdle 2 ( 220, 145 )   TO (235 , 200
	
	; ******* PARAMETER PASSING*************
	; USES AL REGISTER TO DETERMINE DIRECTION OF MOVEMENT ON X AXIS
	; ******* CAUTION **********************
	motionControl_Xaxis proc 
	
		.if(current_level == 3)
			jmp KE
		.endif
	
		.if(current_level == 2)
			jmp KE
		.endif
		.if(current_Level == 1)
			KE:
		
			.if( mario_X < 85 )	;Right Corner of Hurdle 1
			
				.if( mario_X > 60 )	; Left Corner of Hurdle 2
					;Collision with Hurdle 1. But now we check Y axis
					.if(mario_Y > 140)
						add mario_X, al
					.endif
			
				.endif
			.elseif( mario_X < 240 )   ; RIGHT Corner of Hurdle 2 Ground	
				
				.if( mario_X > 215  ) ; LEFT Corner
					
					.if(mario_Y > 120)
						add mario_X, al
					.endif
					
				.endif
			.endif	
		.endif
		
		
		
		ret
	motionControl_Xaxis endp
	
	
	
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
		mov cx, 2
		mov ax,0
		
		;call jumper
		
		.if( jump_Maker == 0 )
			call gravitaionalForce
		.endif
		
		
		back:

			push cx
			call clearScreen
			call setPage
			call jumper



			call readKeystroke
			call marioGen

			call printGameScreen
			call switchPage

			
			call readKeystroke
			call jumper

			call printGameScreen
			mov ah,0
			call readKeystroke
			call switchPage
			
			call collisionTrac
		
			pop cx
			
			.if( current_Level == -50 )
				jmp ex
			.endif
			
		loop back	
	jmp BPF 
		;^^^^^^^^^Starts an infinite loop. Uncomment this to see movement :D. 
		
		
		ex:
		
		
	main endp
	
	
	
	mov ah, 4ch
	int 21h
	end 

