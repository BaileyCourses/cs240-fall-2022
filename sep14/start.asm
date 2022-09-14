;;; Professor Bailey
;;; Fall 2022
;;; September 14, 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

Doit PROTO

.data
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

;;; Entry point for the program

start PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	Doit
	
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
start ENDP
END start
