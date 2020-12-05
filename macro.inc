
;------------------------------------------------------
mWriteSpace MACRO count:=<1>
;
; Writes one or more spaces to the console window.
; Receives: an integer specifying the number of spaces.
; Default value of count is 1.
;------------------------------------------------------
LOCAL spaces
.data
spaces BYTE count DUP(' '),0
.code
push edx
mov edx,OFFSET spaces
call WriteString
pop edx
ENDM


;------------------------------------------------------
mWriteString MACRO buffer:REQ
;
; Writes a string variable to standard output.
; Receives: string variable name.
;------------------------------------------------------
push edx
mov edx,OFFSET buffer
10.2 Macros 419
call WriteString
pop edx
ENDM




mTest macro
	mov ax, 25
endm

mHP macro v1
	mov ax, v1
endm