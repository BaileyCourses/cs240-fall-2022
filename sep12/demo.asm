;;; Professor Bailey
;;; Fall 2022

;;; Skeleton program

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here


min	PROC
	;; BX = first operand
	;; DX = second operand
	;; returns AX (min of BX and DX)

	pushf

	cmp	bx, dx
	jl	bxisless

	;; bx >= dx
	
	mov	ax, dx
	jmp	over
	
bxisless:	
	mov	ax, bx
	
over:	
	popf
	ret
min	ENDP

.data	
	sayHello BYTE "Hello, world!", 0
.code	
	
bigHello PROC
	;; AX = number of times to say hello
	;; returns: none
	
	mov	cx, ax
top:	
	mov	dx, OFFSET sayHello
	call	WriteString
	call	Newline
	loop	top
	
	ret
bigHello ENDP
	
.data
	prompt BYTE "Enter a number: ", 0
	result BYTE "The minimum number is: ", 0
.code
	
;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	ax, 0
	call	bigHello

	jmp	done
	
	mov	dx, OFFSET prompt
	call	WriteString
	call	ReadInt		; Value left in DX

	mov	ax, dx

	mov	dx, OFFSET prompt
	call	WriteString
	call	ReadInt		; Value left in DX

	mov	bx, ax

	call	min

	mov	dx, OFFSET result
	call	WriteString

	mov	dx, ax
	
	call	WriteInt

;	call	DumpRegs
done:	

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
