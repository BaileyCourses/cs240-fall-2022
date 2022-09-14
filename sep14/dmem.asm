;;; Professor Bailey
;;; Fall 2022
;;; September 14, 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	
	begData LABEL BYTE
	prompt BYTE	"This is a prompt", 0
	count WORD 25
	pat WORD 0FEABh
	sizeData = $ - begData

;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	cx, sizeData
	mov	dx, OFFSET begData
	call	DumpMem
	
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
