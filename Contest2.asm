INCLUDE Irvine32.inc

.data
rulesMsg BYTE "Press SPACE to spin ($10) or E to exit ",0
balanceMsg BYTE "Current Balance: $",0
balance DWORD 100

.code
main PROC
    call Randomize
    mov edx, OFFSET rulesMsg
    call WriteString
    call Crlf
    call Crlf

waitKey: 
	mov edx, OFFSET balanceMsg
	call WriteString
	mov eax, balance
	call WriteDec
	call Crlf

readInput: 
	call ReadKey
	cmp al, 'e'
	je exitGame
	jmp readInput

exitGame:
    exit
main ENDP
END main