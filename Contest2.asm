INCLUDE Irvine32.inc

.data
rulesMsg BYTE "Press SPACE to spin ($10) or E to exit ",0
balanceMsg BYTE "Current Balance: $",0
outOfMoneyMsg BYTE "You are out of money! Game Over.", 0
symbolList BYTE "AKQJT"
spinRandom BYTE 5 DUP(?)
spinResult BYTE 5 DUP(?)
balance DWORD 100
freq BYTE 5 DUP(0)
pairs BYTE 0
triples BYTE 0
quads BYTE 0
allFive BYTE 0

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
	mov ecx, 5
	mov esi, 0

spinEach:
	mov eax, 5
	call RandomRange
	mov spinRandom[esi], al
	movzx ebx, al
	mov dl, symbolList[ebx]
	mov spinResult[esi], dl
	inc esi
	loop spinEach
	
	mov edx, OFFSET spinResult
	mov ecx, 5

printLoop:
	mov al, [edx]
	call WriteChar
	mov al, ' '
	call WriteChar
	inc edx
	loop printLoop
	call Crlf
	
	mov pairs, 0
	mov triples, 0
	mov quads, 0
	mov allFive, 0
	mov ecx, 5
	mov esi, 0

clearFreq:
	mov freq[esi], 0
	inc esi
	loop clearFreq
	jmp waitKey

exitGame:
    exit
main ENDP
END main