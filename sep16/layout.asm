;;; Professor Bailey
;;; Fall 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	beg	LABEL	BYTE
	values	BYTE	0h, 10h, 20h
		BYTE	30h, 40h, 50h
	bigval	WORD	5060h, 6070h
	twents	BYTE	10 DUP(20h)
	negs	SWORD	1, -1, 2, -2
	bcds	TBYTE	010203040506070809h
	sizeMem = $ - beg
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	dx, OFFSET beg
	mov	cx, sizeMem
	call	DumpMem	
	
	call	DumpRegs	; Seem to always need this
	
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
