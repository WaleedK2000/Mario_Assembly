

mTest macro
	mov ax, 25
endm

mHP macro v1
	mov ax, v1
endm



	mPrintPixelinRow macro row,col,number_Pixels,color
	
		local pixL1
	
	
		push cx
		push dx
	
		mov cx, number_Pixels
		mov dx, col
		
		pixL1:
		

			mPrintSinglePixel row, dx, color
			inc dx

		
		loop pixL1
		
		pop dx
		pop cx
	
	endm
	
	mPrintSinglePixel macro row, col, color
	
		push ax
		push cx
		push dx
	
		mov ah, 0ch	
		mov al, color
		mov cx, col
		mov dx, row
		int 10h
		
		pop dx
		pop cx
		pop ax
	
	endm