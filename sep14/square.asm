;;; Professor Bailey
;;; Fall 2022
;;; September 14, 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

square PROC
	;; AX = value to square
	;; returns square in AX
	
	pushf
	push	dx
	
	imul	ax		; DX:AX = AX * AX

	pop	dx
	popf
	ret
square ENDP

.data
	prompt BYTE "Enter a number to square: ", 0
	result BYTE "The square is ", 0
.code

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	;; 	Ask for input
	mov	dx, OFFSET prompt
	call	WriteString
	call	ReadUInt	; DX = input
	
	mov	ax, dx
	call	square		; AX = square of AX

	mov	dx, OFFSET result
	call	WriteString
	mov	dx, ax
	call	WriteUInt	; Write DX
	call	NewLine
	call	DumpRegs
	
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
