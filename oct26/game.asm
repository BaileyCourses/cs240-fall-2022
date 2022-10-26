;;; Professor Bailey
;;; Fall 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h
BIOS = 10h
TIMER = 8h
	
.8086				; Restrict instructions to 8086

include lib.asm
	
.data
	
;;; Place data definitions here

.code				; Switch to the code segment

mWrite MACRO text
	LOCAL string
	.data
	string BYTE text, 0
	.code
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	pop	dx
ENDM

WriteLn MACRO text
	LOCAL string
	.data
	string BYTE text, 13, 10, 0
	.code
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	pop	dx
ENDM
	
Error MACRO text
	LOCAL string
	.data
	string BYTE text, 13, 10, 0
	.code
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	pop	dx
	call	RestoreTimerHandler
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
ENDM

ChangeVideoPage PROC
	;; AL = page number (0-3)
	
	mov	ah, 05h
	int	BIOS
	
	ret
ChangeVideoPage ENDP

.data
	;; This is an array of alarms. The first word is the number of clock
	;; ticks, the second is a function "pointer" (offset) to be called when
	;; the alarm reaches 0

EventHandlers	LABEL WORD
		WORD 20 DUP(0)
HandlerCount = ($ - EventHandlers) / 4
.code

RegisterHandler PROC
	;; AX=tick count
	;; DX=Handler offset
	
	pushf
	push	bx
	push	cx

	mov	cx, 0
	mov	bx, OFFSET EventHandlers
	
	;; search for an available slot (first word is )

	jmp	cond
top:
	cmp	WORD PTR [bx], 0
	jne	used
	
	;; Found a slot. Set the first word to the count, the second to offset

	mov	WORD PTR [bx], ax
	inc	WORD PTR [bx]	; Increment the count by 1 (zero means unused)
	mov	WORD PTR [bx + 2], dx
	jmp	done
used:	
	inc	cx
	add	bx, 4
cond:	
	cmp	cx, HandlerCount
	jl	top
	
	;; Hopefully, we don't get here!
	
	WriteLn	"Error, out of handler slots"
	
done:	
	pop	cx
	pop	bx
	popf
	ret
RegisterHandler ENDP

Tick5 PROC
	push	ax
	push	dx
	
	WriteLn	"5 clock tick handler called"
	
	mov	ax, 5
	mov	dx, OFFSET Tick5
	call	RegisterHandler
	
	pop	dx
	pop	ax
	ret
Tick5 ENDP
	
Tick6 PROC
	WriteLn	"6 clock tick handler called"
	ret
Tick6 ENDP
	
ProcessClockTick PROC
	
	pushf
	push	bx
	push	cx
	
	;; for (cx = 0; cx < HandlerCount; cx += 4)...
	mov	cx, 0
	mov	bx, OFFSET EventHandlers ;
	jmp	cond
top:
	cmp	WORD PTR [bx], 0 ; See if this alarm is in use
	je	unused
	dec	WORD PTR [bx]	; Yup. Take a tick away
	cmp	WORD PTR [bx], 0 ; Did it go off?
	ja	running
	call	WORD PTR [bx + 2] ; Yup. Call the alarm code
	
running:	
unused:	
	add	bx, 4		; Skip to the next handler
	inc	cx
cond:	
	cmp	cx, HandlerCount
	jl	top
	
	pop	cx
	pop	bx
	popf
	ret
ProcessClockTick ENDP

GameLoop PROC
	pushf
	push	ax
	
	jmp	cond
top:	
	;; Wait for a clock tick
	cmp	cs:timerTickCount, 0
	je	notick
	
	;; Clock just ticked! Reset the count
	
	mov	cs:timerTickCount, 0
	
	;; Process the clock tick (check for any alarms that have now gone off)

	call	ProcessClockTick
notick:	
	
	;; Check if the user has pressed a key (returns 0 if not, char if so)

	call	KeyPress
cond:
	;; Continue until a space is pressed

	cmp	al, ' '
	jne	top
	
	pop	ax
	popf
	ret
GameLoop ENDP

;;; Note, these data definitions are in the CODE segment (and must be)

OldTimerInterruptVector	DWORD 1234ABCDh

timerTickCount	WORD 0

InterruptHandler PROC
	inc	cs:timerTickCount

	pushf
	call	cs:OldTimerInterruptVector
	iret
InterruptHandler ENDP
	
InstallTimerHandler PROC
	push	ax
	push	bx
	push	dx
	
	;; Save the older vector so we can restore it (and chain it)
	
	mov	al, TIMER		; DOS Timer interrupt
	mov	bx, OFFSET OldTimerInterruptVector
	call	SaveInterruptVector ; AL = interrupt, CS:BX = memory location

	;; Install the new handler
	
	mov	al, TIMER		; DOS Timer interrupt
	mov	dx, OFFSET InterruptHandler
	call	InstallInterruptHandler ; AL = interrupt, CS:DX = handler
	
	pop	dx
	pop	bx
	pop	ax
	ret
InstallTimerHandler ENDP
	
RestoreTimerHandler PROC
	push	ax
	push	bx
	
	mov	al, TIMER		; DOS Timer interrupt
	mov	bx, OFFSET OldTimerInterruptVector
	call	RestoreInterruptVector ; AL = interrupt, CS:BX = mem. loc.
	
	pop	bx
	pop	ax
	ret
RestoreTimerHandler ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax
	
	mov	ax, 5
	mov	dx, OFFSET Tick5
	call	RegisterHandler
	mov	ax, 20
	mov	dx, OFFSET Tick6
	call	RegisterHandler
	
	;; Start of DOS program...

	call	InstallTimerHandler

	WriteLn	"Press a space to exit"
	
	call	GameLoop
	
	call	RestoreTimerHandler

	WriteLn	"Program successfully completed."

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
