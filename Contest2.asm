INCLUDE Irvine32.inc

.data
rulesMsg BYTE "Press SPACE to spin ($10) or E to exit ",0
balanceMsg BYTE "Current Balance: $",0
outOfMoneyMsg BYTE "You are out of money! Game Over.", 0

winAllFiveMsg BYTE "5 of a Kind! GRAND PRIZE! You win $1000.", 0
winQuadsMsg BYTE "4 of a Kind! You win $50.", 0
winTripleMsg BYTE "3 of a Kind! You win $10.", 0
winFullHouseMsg BYTE "Full House! You win $25.", 0
winTwoPairMsg BYTE "2 Pair! You win $5.", 0
winPairMsg BYTE "1 Pair! You win $1.", 0
loseMsg BYTE "Nothing matches! You lose.", 0

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
	cmp balance, 10
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
	mov ecx, 5
	mov esi, 0

countFreq:
	movzx eax, spinRandom[esi]
	inc freq[eax]
	inc esi
	loop countFreq
	mov ecx, 5
	mov esi, 0

evalLoop:
	mov al, freq[esi]
	cmp al, 2
	je isPair
	cmp al, 3
	je isTriple
	cmp al, 4
	je isQuad
	cmp al, 5
	je isAllFive
	jmp nextEval

isPair:
	inc pairs
	jmp nextEval
isTriple:
	inc triples
	jmp nextEval
isQuad:
	inc quads
	jmp nextEval
isAllFive:
	inc allFive

nextEval:
	inc esi
	loop evalLoop
	cmp allFive, 1
	je payoutAllFive
	cmp quads, 1
	je payoutQuads
	cmp triples, 1
	jne checkPairs
	cmp pairs, 1
	je payoutFullHouse
	jmp payoutTriple

checkPairs:
	cmp pairs, 2
	je payoutTwoPair
	cmp pairs, 1
	je payoutPair
	mov edx, OFFSET loseMsg
	call WriteString
	call Crlf
	call Crlf	
	jmp waitKey

payoutAllFive:
	add balance, 1000
	mov edx, OFFSET winAllFiveMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutQuads:
	add balance, 50
	mov edx, OFFSET winQuadsMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutFullHouse:
	add balance, 25
	mov edx, OFFSET winFullHouseMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutTriple:
	add balance, 10
	mov edx, OFFSET winTripleMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutTwoPair:
	add balance, 5
	mov edx, OFFSET winTwoPairMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutPair:
	add balance, 1
	mov edx, OFFSET winPairMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey

exitGame:
    call Crlf
	call WaitMsg
	exit
main ENDP
END main