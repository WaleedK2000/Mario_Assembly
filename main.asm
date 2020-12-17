;***NOTICE****
;THERES A BUG WHERE MARIO GLITCHES AFTER X_AXIS IS 250
; IF CURRENT LEVEL IS -50 GAME WILL EXIT. Pressing E will exit game on ALL LEVELS!
;END OF NOTICE

	

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

	
	enemy_x db  135
	enemy_y db  175
	enemyVelocity db 5
	
	enemy_x1 db  200
	enemy_y1 db  20
	enemyVelocity1 db 5
	
	bullet_y1 db  45
	bullet_Control db 0	;0 means move, 1 means dont move
	
	current_Level db 0
	;Level 0 means Game paused and At start menu.
	;Level 1 means Current Level is 1
	;Level 2 means Current Level is 2
	;Level 3 means current Level is 3
	;-100 = Gave over (lives = 0)
	; 10 means end of 1
	;20 means end of Level 2
	;30 means end of level 3 (END OF GAME)
	;WHEN LEVEL 1 IS COMPLETE current_Level = 10. This Starts the level complete Screen
	
	jump_Maker db 0
	allowDJmp db 1 ;0 means allow double jump, 1 Means do not allow double jump or JUMP
	
	flag_Y db 10
	
	lives db 3

	;----------- 200 AT FLOOR OF WINDOW
	
	
	scoreTrack db 00         
	;STRINGS
	tTitle db '***~MARIO~***'
	strTitleScreen1 db 'PRESS ANY KEY TO START'
	 strexit db 'Exit:E'
	strprogress1 db 'Level:1'
	strprogress2 db 'Level:2'
	strprogress3 db 'Level:3'
	strLives1 db 'Lives:'
	strgameo db 'GAME OVER!!!'
	strgamem db '~YOU WIN~'
	strl2 db '~LEVEL 2~'
	strl3 db '~LEVEL 3~'
	score1 db 'Score:00'   ;these will only display during game to create an ease for displaying score
	score2 db 'Score:20'
	score3 db 'Score:50'
;this is the score we will print after calculating our score
	scstr  db 'Score:100'
	byeLose1 db 'Game Over!'
	byeLose2 db 'Better Luck Next Time'

.code

	mov ax, @data
	mov ds, ax
	mov ax, 0
	jmp main
	

	; BX for Row(Y axis). AX for collumn(x axis)  

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
	
		;call delay
		
		push ax
		mov ah, 00h
		mov al, 13h
		int 10h	
		pop ax
		ret
		
	clearScreen endp
	
	
	reset proc

		.if(lives < 1)
			mov current_level, -100 ;Game Over
		.endif


		mov mario_X, 15
		mov mario_Y, 163
		mov flag_Y, 10
		
		ret
	reset endp
	
	;Incharge of Tracking collisions of Mario with Enemy in LEVEL 2 ONLY
	; (enemyX1, BulletY)    (enemyX1 + 8, bulletY + 8    )
	collisionTrac proc
		push ax
		
		mov ax, 0
		mov al, enemy_x
		sub al, 10			;LEFT MOST HIT BOX
		
		.if( al < mario_X)
		
			add al, 45 ;(10 + 20 ) ;RIGHT MOST HIT BOX  (10 is LEFT MOST HITBOX)
			.if( mario_X < al )
			
				.if(  mario_Y > 135 )
					dec lives
					call reset		;YES, COLLISION HATH TAKE PLACE
				
				.endif
			
		
			.endif

		.endif
		
		
		pop ax
		ret
	collisionTrac endp
	;Moves Enemy. LEVEL TWO ONLY!!!
	moveEnemy proc
	
	
		.if( enemy_x < 105 )	;Right Corner of Hurdle 1
			
				.if( enemy_x > 80 )	; Left Corner of Hurdle 2
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
				;je move_down
			
			.endif
		
		.endif
		
		jmp NO_IN
		
		
		
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
	
		.if(mario_Y < 80)
			mov jump_Maker, 0
		
		.endif
		
	
		.if(jump_Maker > 0)
			dec jump_Maker
			sub mario_Y, 2
		.endif	
	
	
		ret
	jumper endp
	
	
	;Function Introduces Gravity. Also checks if Mario is about to land on a Hurdle. In which case it makes him stand on it
	gravitaionalForce proc
	

			.if( mario_X > 20 )
			
				.if(mario_X < 55)
				
					.if(mario_Y > 130)
					
						.if(mario_Y < 145)
							mov mario_Y, 135
							mov jump_Maker, 0
							mov allowDJmp, 1
						.endif
					
					.endif
				
				
				.endif
			
			.endif
		
			.if( mario_X < 115 )	;Right Corner of Hurdle 1
			
				.if( mario_X > 75 )	; Left Corner of Hurdle 2
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
				
				.if( mario_X > 205  ) ; LEFT Corner
					
					.if(mario_Y > 100)
						.if(mario_Y < 130)
							mov mario_Y, 110
							
							mov allowDJmp, 1
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
	
		;mdelay 800
	
		.if(current_Level == 0)
		
			call printTitleScreen
		.elseif (current_Level == 1)
		
			call printLevelOne
			call marioGen
		.elseif (current_Level == 10)
			call printLevelOneEnd
		.elseif (current_Level == 2)
		
			call marioGen
			call moveEnemy
			call moveEnemy1
			call collisionTrac
			call printLevelTwo
		.elseif	(current_level == 20)
			call printLevelTwoEnd
			
		.elseif (current_level == 3)
			call marioGen
			call moveEnemy			;COMMENTED FOR DEBUGGING PURPOSE
			call moveEnemy1
			call collisionTrac
			call bulletfun2
			call printLevelThree
			
		.elseif(current_level == 30)
			call printGameCompleteScreen
		.elseif(current_level == -100)
			call printGameOver
		.else
			;random
		.endif
		ret
	
	printGameScreen endp
	
	printHurdles proc
	
		;------left_x, left_y, len x, len y, color, buffer_pages-----

		;mPrintRectangle 75,170, 5, 30, 0Eh	
		;mPrintRectangle 60,170, 15, 30, 0Eh, buffer_page		    ;Hurdle 2
		
		;hurdle 1
		mPrintRectangle 30,170, 11, 25, 0Eh 	,buffer_page
		mPrintRectangle 30,170, 7, 20, 11001110b 	,buffer_page
		mPrintRectangle 30,170, 3, 15, 01001010b 	,buffer_page			
		;;Hurdle 2
		mPrintRectangle 85,170, 15, 30, 0Eh							
		mPrintRectangle 85,170, 10, 22, 11001110b, buffer_page		
		mPrintRectangle 85,170, 5, 16, 01001010b, buffer_page		
		;hurdle 3
		mPrintRectangle 220,145, 15, 55, 0Eh,buffer_page	   		
		mPrintRectangle 220,145, 10, 45, 11001110b,buffer_page		
		mPrintRectangle 220,145, 5, 40, 01001010b,buffer_page		
		
		mPrintRectangle 315,10, 5, 190, 10001011b	, buffer_page	;Flag Pole
		
		mPrintRectangle 0,400, 320, 5, 10111111b,buffer_page		;grass
		
		ret
	printHurdles endp
	
	
	;HURDLE 1 (65,170)   To    (80,200) 
	;Hurdle 2 ( 220, 145 )   TO (235 , 200  )
	
	;Is called when VARIABLE current_Level is 1
	;All visual features Exclusive to Level One Go here
	
	printLevelOne proc
		push ax
		push bx
		push cx
		push dx
		mov si, offset  strexit
		mWriteStringAtPos 0,0, si, 6 , 0Eh, buffer_page ;Prints Exit: E
		mov si, offset strLives1
		mWriteStringAtPos 0,2, si, 6 , 62h, buffer_page ;Prints lives
		
		mMoveCursor 6,2,buffer_page
		mov al, lives
		add al, 48
		mWriteCharAtCursor al,62h, buffer_page
		
		mov si, offset strprogress1
		mWriteStringAtPos 0,4, si, 7 , 62h, buffer_page ;Prints level
		mov si, offset score1
		mWriteStringAtPos 0,6, si, 7 , 62h, buffer_page ;Prints progress/score
		call printHurdles
		
			
		.if(mario_X > 249)
				
			.if( flag_Y < 150 )
			
				add flag_Y, 2
				call drawFlag
						
			.else
			;calculating our score to displayat the end 
			    mov scoreTrack,20
				mov current_Level, 10
			
			.endif
			
			
		.endif
			
			
		call drawFlag
		pop dx
		pop cx
		pop bx
		pop ax
		ret
	printLevelOne endp
	
	
	printLevelOneEnd proc
		push ax
		push bx
		push cx
		push dx
		push si
		call clearScreen
		mPrintRectangle 0,0, 320, 320, 35H,buffer_page
		;INSERT MESSAGE 
		; LEVEL 1 COMPLETE
		mov si, offset strl2
		mWriteStringAtPos 40,40, si, 9 , 45h, buffer_page 
		
		mdelay 1200	;Delay before starting Next Level
		
		mov current_Level, 2  ;Start Level 2

		call reset
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		ret
	
	printLevelOneEnd endp
	
	
	printLevelTwo proc
		push ax
		push bx
		push cx
		push dx
		mov si, offset strexit
		mWriteStringAtPos 0,0, si, 6 , 0Eh, buffer_page ;Prints Exit: E
		mov si, offset strLives1
		mWriteStringAtPos 0,2, si, 6 , 62h, buffer_page ;Prints lives
		
		mMoveCursor 6,2,buffer_page
		mov al, lives
		add al, 48
		mWriteCharAtCursor al,62h, buffer_page
		
		
		mov si, offset strprogress2
		mWriteStringAtPos 0,4, si, 7 , 62h, buffer_page ;Printslevel
		mov si, offset score2
		mWriteStringAtPos 0,6, si, 8 , 62h, buffer_page ;Prints score
		call PrintCloud
		call enemy
		call printHurdles
		
		
		
		.if(mario_X > 249)
				
			.if( flag_Y < 150 )
			
				add flag_Y, 2
				call drawFlag
						
			.else
			;calculating our score to displayat the end 
			    mov scoreTrack,50
				mov current_Level, 20 ; LEVEL 2 ends
			
			.endif
			
			
		.endif
			
			
		call drawFlag
		pop dx
		pop cx
		pop bx
		pop ax
		ret
	printLevelTwo endp
	;Prints the end of Level 2 after flag reaches bottom 

	printLevelTwoEnd proc
		push ax
		push bx
		push cx
		push dx
	
		call clearScreen
		mPrintRectangle 0,0, 320, 320, 35H,buffer_page
		;INSERT MESSAGE 
		; LEVEL 2 COMPLETE
		mov si, offset strl3
		mWriteStringAtPos 40,39, si, 9 , 45h, buffer_page 
		
		mdelay 1200	;Delay before starting Next Level
		
		mov current_Level, 3  ;Start Level 3

		call reset
		pop dx
		pop cx
		pop bx
		pop ax
	
		ret
	printLevelTwoEnd endp
	
	
	printLevelThree proc
		push ax
		push bx
		push cx
		push dx
		mov si, offset strexit
		mWriteStringAtPos 0,0, si, 6 , 0Eh, buffer_page ;Prints Exit: E
		mov si, offset strLives1
		mWriteStringAtPos 0,2, si, 6 , 62h, buffer_page ;Prints lives
		mMoveCursor 6,2,buffer_page
		mov al, lives
		add al, 48
		mWriteCharAtCursor al,62h, buffer_page
		
		mov si, offset strprogress3
		
		mWriteStringAtPos 0,4, si, 7 , 62h, buffer_page ;Prints progress/score
		mov si, offset score3
		mWriteStringAtPos 0,6, si, 8 , 62h, buffer_page ;Prints score
		
		call kingdom
		call enemy
		call printHurdles
		call enemy1
		
		.if(mario_X > 249)
				
			
			  ;calculating our score to displayat the end 
			    mov scoreTrack, 100
				mov current_Level, 30 ;Game Ends
			
			
			
		.endif
			
			
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		ret
	printLevelThree endp
	
	
	printGameCompleteScreen proc
	
		;push ax
		;push bx
		;push cx
		;push dx
		
		mov current_page, 0
		mov buffer_page, 0
		call switchPage
		
		push si
		
	    call clearScreen
		;end game msg
		mPrintRectangle 0,0, 320, 320, 35H,current_page
		;game over msg
		mov si, offset strgameo
		mWriteStringAtPos 45,39, si, 12 , 62h, current_page 
		;you won msg
		mov si, offset strgamem
		mWriteStringAtPos 42,41, si, 9, 49h, current_page 
		;score: msg
		mov si, offset scstr
		mWriteStringAtPos 37,40, si,9, 49h, current_page 
		

		mdelay 2000
		

	

		
		
		mdelay 1200 ;Delay before exiting
		mov current_LEVEL, -50 ;exit code
		pop si
		;pop dx
		;pop cx
		;pop bx
		;pop ax
		ret
	
	printGameCompleteScreen endp
	
	printGameOver proc
	
		push si
		
		mov current_page, 0
		mov buffer_page, 0
		call switchPage
		
		call clearScreen
		mPrintRectangle 0,0, 320, 320, 35H,current_page
		mov si, offset byeLose1
		mWriteStringAtPos 6,39, si, 10 , 62h, current_page 
		mov si, offset byeLose2
		mWriteStringAtPos 0,40, si, 21 , 62h, current_page 
		

		.if (scoreTrack == 0)
			mov si, offset score1
		.elseif ( scoreTrack == 20)
			mov si, offset score2
		.else
			mov si, offset score3
		.endif
		
		mWriteStringAtPos 0,38, si, 8 , 62h, current_page 
		
		mdelay 2000
		mov current_LEVEL, -50 ;exit code
		pop si
		ret
	
	printGameOver endp
	
	
	;IS called at the start of Game.
	;Just a title Screen
	;Called when VARIABLE current_Level is 0
	printTitleScreen proc 
	
		push ax
		push bx
		push cx
		push dx
	
	
	;------background---------
		mPrintRectangle 0,0, 320, 320, 68H,buffer_page
		mPrintRectangle 35,39, 240, 130, 36H,buffer_page
		mPrintRectangle 55,56, 195, 90, 50H,buffer_page
 
		mov si, offset tTitle
		mWriteStringAtPos 44,35, si, 13 , 39h, buffer_page
		mov si, offset strTitleScreen1
		mWriteStringAtPos 40,40, si, 22 , 39h, buffer_page
	
	SOT:
	
		mov ah,01h
		int 16h
		
		jz SOT
	

		;mdelay 2350
		
		;jmp SOT
	
		title_bye:
		
		mov current_level, 1
		
		pop dx
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
	
		;;ALL VARIABLES ARE WORD SIZED (AX)
	;;Give coordinate of top Left of the square/Rectangle. Give lenght in X axis direction and lenght in Y axis direction. Give color.

	
	
	; ************************************************ ENEMIES ******************************************8



	moveEnemy1 proc
	
	
		.if( enemy_x1 < 105 )	;Right Corner of Hurdle 1
			
				.if( enemy_x1 > 80 )	; Left Corner of Hurdle 2
					;Collision with Hurdle 1. Change Direction
					
						mov enemyVelocity1, 2

				.endif
		.elseif( enemy_x1 < 240 )   ; RIGHT Corner of Hurdle 2 Ground	
				
				.if( enemy_x1 > 195  ) ; LEFT Corner
					
					
						mov enemyVelocity1, -2 ;Collison with hurdle 2. Change Direction
				
	
				.endif
		.endif
	
	
		mov al, enemyVelocity1
		add enemy_x1, al
		ret
	moveEnemy1 endp




	enemy proc
			push ax
			push bx
			push cx
			push dx
			push si
			
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
			
			
			mov si, ax
			mov dx, bx
			
			xchg si, dx
			
			;eyebrows
			mov ax, 0
			mov al, enemy_y
			mov si, ax
			add si, 5
			sub dx, 3
			mPrintPixelinRow si,dx,4,5	,buffer_page			 ;ax 183 bx 140
			add dx,10
			mPrintPixelinRow si,dx,4,5	,buffer_page             ;ax183 bx 150
			
			;eyes
			add si,3
			sub dx, 9
			mPrintPixelinRow si,dx,2,2	,buffer_page             ;ax 186 bx 141
			add dx,10
			mPrintPixelinRow si,dx,2,2	,buffer_page			;ax 186 bx 151
			
			;lips
			add si,4
			sub dx,6
			mPrintPixelinRow si,dx,4,4	,buffer_page			;ax 190 bx 145
			add si,1
			mPrintPixelinRow si,dx,4,4	,buffer_page			;ax 191 bx 145
			
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			ret
	enemy endp
	
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
		push cx
		push dx
		push si
		
		mov ax,0
		mov bx,0
		mov bl,enemy_y1
		mov al,enemy_x1
	
		;body
	  	mPrintRectangle ax,bx, 23, 23, 85h 	,buffer_page	     ;ax 60 bx 60
		add ax,2
		sub bx,20
		mPrintRectangle ax,bx, 18, 18,71h ,buffer_page			 ;ax 62 bx 62
		add ax,3
		sub bx,15
        mPrintRectangle ax,bx, 12, 12,66h ,buffer_page			 ;ax 65 bx 65
		
		;eyes
		add ax,3
		sub bx,9
		mPrintRectangle ax,bx, 2, 2,69h ,buffer_page			 ;ax 67 bx 66
		add ax,4
		sub bx,2
		mPrintRectangle ax,bx, 2, 2,69h ,buffer_page			 ;ax 70 bx 66
		
		;hat
		sub ax,5
		sub bx,14
        mPrintRectangle ax,bx, 9, 3, 15h 	,buffer_page		 ;ax 65 bx 57
		add ax,2
		sub bx,6
		mPrintRectangle ax,bx, 5, 3, 15h 	,buffer_page		 ;ax 67 bx 54
		pop si 
		pop dx
		pop cx
		pop bx
		pop ax
	
	
	enemy1 endp
	
	
	
	
	
	;************************* BULLETS **************************************************************
		
	bulletfun2 proc
	
		push ax
		push bx
		
		.if( bullet_y1 > 185 )
			mov bullet_y1, 35
		.endif
		
		mov al, enemy_x1
		mov ah, bullet_y1
		sub al, 5 ;Increase hitbox left on x axis
		.if(  al <  mario_X   )
		
			add al, 25	;Increase hitbox RIGHT on xaxis
			.if( mario_x < al   )
			
				sub ah, 5 ;Increase hitbox Up on yAxis
				.if(  ah < mario_Y  )
				
					add ah, 25 ;Increase hitbox down on Yaxis
					.if( mario_Y < ah  )
					
						dec lives
						call reset
					
					.endif
				
				.endif
			
			
			.endif
		
		
		
		.endif
		
		
		
		.if (bullet_Control > 0)
			dec bullet_Control
			jmp BulletJump
		.else
			mov bullet_Control, 5
		.endif
		
		mov ax,0
		mov bx,0
		mov al,enemy_x1
		mov bl,bullet_y1
		
		.if(bl>80)
			sub al,1
		
			mPrintRectangle ax,bx, 8, 8, 29h ,buffer_page
		
		.elseif(bl<180)
			add al,1
			
			mPrintRectangle ax,bx, 8, 8, 29h ,buffer_page
		
		
		.endif
	
		mov bullet_y1,bl
		
	
	BulletJump:	
		pop bx
		pop ax
		
		ret	
	
	bulletfun2 endp
	

	delay proc
		push ax
		push bx
		push cx
		push dx

		mov cx,15
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
	
		.if( mario_X > 28 )
		
			.if( mario_X < 45 )
			
				.if(mario_Y > 140)
					add mario_X, al
				.endif
			
			.endif
		
		.endif 
	
	
	
		.if( mario_X < 105 )	;Right Corner of Hurdle 1
			
			.if( mario_X > 80 )	; Left Corner of Hurdle 2
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
		push ax
		mov ah, 05h
		mov al, current_page
		int 10h
		pop ax
		ret
	setPage endp
	
	
	kingdom proc
	
		push ax 
		push bx 
		;centre
		mPrintRectangle 240, 130, 70, 60, 15h , buffer_page
		;left wall
		mPrintRectangle 240, 130, 25, 70, 15h , buffer_page
		;right wall
		mPrintRectangle 285, 130, 25, 70, 15h , buffer_page
		;Blocks
		;B1
		mPrintRectangle 240, 120, 7, 75, 15h , buffer_page
		;B3
		mPrintRectangle 289, 120, 7, 75, 15h , buffer_page
		;B2
		mPrintRectangle 254, 120, 7, 75, 15h , buffer_page
		mPrintRectangle 303, 120, 7, 75, 15h , buffer_page
		;Pillars
		mPrintRectangle 269, 90, 12, 40, 15h , buffer_page
		;Top
		mPrintRectangle 267, 90, 16, 5, 29h , buffer_page
		mPrintRectangle 269, 86, 12, 5, 29h , buffer_page
		mPrintRectangle 271, 82, 8, 5, 29h , buffer_page
		mPrintRectangle 273, 78, 4, 5, 29h , buffer_page
		;door
		mPrintRectangle 265, 175, 20, 25, 62h , buffer_page
		mPrintRectangle 267, 187, 4, 2, 11h , buffer_page
		
		
		pop bx
		pop ax
		
		
		ret
	kingdom endp
	
	
	
	PrintCloud proc
	
		
		;right
		mPrintRectangle 60,225, 15, 15, 0Eh	
		mPrintRectangle 68,220, 15, 15, 0Eh	
		mPrintRectangle 57,215, 15, 15, 0Eh	
		
		;center
		mPrintRectangle 50,230, 15, 15, 0Eh	
		mPrintRectangle 50,220, 15, 15, 0Eh	
		mPrintRectangle 47,210, 15, 15, 0Eh	
		
		
		;left
		mPrintRectangle 40,225, 15, 15, 0Eh	
		mPrintRectangle 30,220, 15, 15, 0Eh	
		mPrintRectangle 37,215, 15, 15, 0Eh	
		
		;ExtremeLeft
		mPrintRectangle 23,225, 10, 5, 0Eh	
		
		
		;ExtremeRight
		mPrintRectangle 75,225, 15, 5, 0Eh
		
		
		ret
	PrintCloud endp
	
	
	

	main proc
		
	BPF:	
		
		.if( jump_Maker == 0 )
			call gravitaionalForce
		.endif

			call clearScreen
			;call setPage
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
			
			
			
			.if( current_Level == -50 )
				jmp ex
			.endif
			
		
	jmp BPF 
		;^^^^^^^^^Starts an infinite loop. Uncomment this to see movement :D. 
		
		
		ex:
		
		mov ah, 00
		mov al, 03h
		int 10h
		
		
		
	main endp
	
	
	
	mov ah, 4ch
	int 21h
	end 

