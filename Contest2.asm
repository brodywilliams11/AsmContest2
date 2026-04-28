INCLUDE Irvine32.inc

.data
rulesMsg BYTE "Press SPACE to spin ($10) or E to exit ",0
balanceMsg BYTE "Current Balance: $",0
outOfMoneyMsg BYTE "You are out of money! Game Over.", 0
balance DWORD 100

.code
main PROC
    call Randomize
    mov edx, OFFSET rulesMsg
    call WriteString
    call Crlf
    call Crlf

waitKey: 
	cmp balance, 5
	jge canPlay
	mov edx, OFFSET outOfMoneyMsg
	call WriteString
	call Crlf
	jmp exitGame

canPlay:
	mov edx, OFFSET balanceMsg
	call WriteString
	mov eax, balance
	call WriteDec
	call Crlf

readInput: 
	call ReadKey
	cmp al, ' '
	je doSpin
	call ReadKey
	cmp al, 'e'
	je exitGame
	jmp readInput

doSpin: 
	sub balance, 10
	jmp waitKey           ;temp jump to keep the loop alive

exitGame:
    exit
main ENDP
END main