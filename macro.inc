

mTest macro
	mov ax, 25
endm

mHP macro v1
	mov ax, v1
endm
	;;ALL VARIABLES ARE WORD SIZED (AX)
	;;Give coordinate of top Left of the square/Rectangle. Give lenght in X axis direction and lenght in Y axis direction. Give color.
	mPrintRectangle macro topLeft_x,topLeft_y,lenght_X,lenght_Y,color, page
		local ract
		
		mov cx, lenght_Y
		mov bx, topLeft_y
		
		ract:
		
			mPrintPixelinRow bx, topLeft_x, lenght_X, color, page
			inc bx
		
		loop ract
		
	
	
	
	endm

	;;ALL VARIABLES ARE WORD SIZED (AX)
	;;Prints multiple pixels in same row(Y coordinate).
	mPrintPixelinRow macro row,col,number_Pixels,color,page
	
		local pixL1
	
	
		push cx
		push dx
	
		mov cx, number_Pixels
		mov dx, col
		
		pixL1:
		

			mPrintSinglePixel row, dx, color,page
			inc dx

		
		loop pixL1
		
		pop dx
		pop cx
	
	endm
	;;ALL VARIABLES ARE WORD SIZED (AX)
	mPrintSinglePixel macro row, col, color, page
	
		push ax
		push cx
		push dx
		;mov bh, page ;new
		mov ah, 0ch	
		mov al, color
		mov cx, col
		mov dx, row
		int 10h
		
		pop dx
		pop cx
		pop ax
	
	endm
	

	mDelay macro val
	

		push bx
		push cx


		mov cx,val
		mydelay:

		mov bx,val   ;; increase this number if you want to add more delay, and decrease this number if you want to reduce delay.

		mydelay1:
		dec bx
		jnz mydelay1
		loop mydelay



		pop cx
		pop bx

	
	endm
	;Macro moves cursor postion
	mMoveCursor macro X, Y, pageNum
	
		push dx
		push bx
		push ax
		
		mov dh, Y
		mov dl, x
		mov bh, pageNum
		mov ah, 02
		int 10h
		
		pop ax
		pop bx
		pop dx
	
	endm
	;Prints Single Char AT CURSOR POSITION
	mWriteCharAtCursor macro char,color,pageNum
	
		push ax
		push bx
		push cx
	
		mov ah, 09h
		mov al, char
		mov bh, pageNum
		mov bl, color
		mov cx, 1
		int 10h
	
		pop cx
		pop bx
		pop ax
	
	endm
	
	;;Prints string of fixed lenght
	;;parameters are x,y, offset of string, lenght of string, Color, buffer_page
	;;NOTE: move si, offset stringVar
	;;Then use si as offsetString
	mWriteStringAtPos macro x,y, offsetString, stringLen, color ,page_Num
		
		local stringLA
		
		mov cx, stringLen
		mov si, offsetString
		mov dl, x	;DL USED FOR X
		
		
		
		stringLA:
		
			mMoveCursor dl,y, page_Num
			mWriteCharAtCursor [si], color, page_Num
			inc si
			inc dl
			
		loop stringLA
		
	endm
