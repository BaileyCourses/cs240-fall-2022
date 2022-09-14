;;; Professor Bailey
;;; Fall 2022
;;; September 14, 2022

include cs240.inc		; Include CS 240 library definitions
	
.8086				; Restrict instructions to 8086

.data
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

;;; Entry point for the program

Doit PROC
	;; Doit of DOS program...

	call	DumpRegs	; Seem to always need this
	ret
Doit ENDP
END
