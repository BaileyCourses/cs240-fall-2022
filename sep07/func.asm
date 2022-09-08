include cs240.inc

DOSEXIT = 4C00h
DOS = 21h

.8086

.data

gimmeanumber	BYTE "Please enter a number: ", 0
.code

min PROC
	call	DumpRegs
	ret
min ENDP	

main PROC
	mov	ax, @data
	mov	ds, ax

	call	DumpRegs
	
	mov	dx, OFFSET gimmeanumber 
	call	WriteString
	call 	ReadInt
	
	mov	dx, OFFSET gimmeanumber 
	call	WriteString
	call 	ReadInt
	
	call	min
	
	call	WriteInt

	call	DumpRegs


	mov	ax, DOSEXIT
	int	DOS

main ENDP
END main
