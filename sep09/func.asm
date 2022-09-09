include cs240.inc

DOSEXIT = 4C00h
DOS = 21h

.8086

.data

gimmeanumber	BYTE "Please enter a number: ", 0
.code

WriteAX PROC
	push	dx
	mov	dx, ax
	call	WriteInt
	pop	dx
	ret
WriteAX ENDP	

main PROC
	mov	ax, @data
	mov	ds, ax

	call	DumpRegs
	
	mov	dx, OFFSET gimmeanumber 
	call	WriteString
	call 	ReadInt
	
	mov	ax, dx

	mov	dx, OFFSET gimmeanumber 
	call	WriteString
	call 	ReadInt
	
	call	DumpRegs
	
	call	WriteAx
	
	call	WriteInt



	mov	ax, DOSEXIT
	int	DOS

main ENDP
END main
