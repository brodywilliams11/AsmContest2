;	Brody Williams
;	Slot Machine Game
;	Assembly Contest 2
;	
;	Run game through Visual Studio
;	Given $100 to play with
;	Press space to spin the Slot Machine ($10 per spin)
;	Press E to exit the game

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
main PROC	;prints the game rules at the start of the game
    call Randomize
    mov edx, OFFSET rulesMsg
    call WriteString
    call Crlf
    call Crlf

waitKey:	;checks if balance is enough to do another spin, otherwise prints out of money msg
	cmp balance, 10
	jge canPlay
	mov edx, OFFSET outOfMoneyMsg
	call WriteString
	call Crlf
	jmp exitGame

canPlay:	;if balance is greater than 10 (the spin amount) the game will run
	mov edx, OFFSET balanceMsg
	call WriteString
	mov eax, balance
	call WriteDec
	call Crlf

readInput:	;reads player input for space to spin and e to exit
	call ReadKey
	cmp al, ' '
	je doSpin
	call ReadKey
	cmp al, 'e'
	je exitGame
	jmp readInput

doSpin:		;subtracts 10 from the balance if the player spins (presses space)
	sub balance, 10
	mov ecx, 5
	mov esi, 0

spinEach:	;generates a random symbol for each of the 5 slots in the slot machine
	mov eax, 5
	call RandomRange
	mov spinRandom[esi], al
	movzx ebx, al
	mov dl, symbolList[ebx]
	mov spinResult[esi], dl
	inc esi
	loop spinEach
	mov eax, red + (black * 16)
	call SetTextColor
	mov edx, OFFSET spinResult
	mov ecx, 5

printLoop:	;prints the symbols on the screen based on what was rolled in spinEach
	mov al, [edx]
	call WriteChar
	mov al, ' '
	call WriteChar
	inc edx
	loop printLoop
	mov eax, white + (black * 16)
	call SetTextColor
	call Crlf
	
	mov pairs, 0
	mov triples, 0
	mov quads, 0
	mov allFive, 0
	mov ecx, 5
	mov esi, 0

clearFreq:	;resets freq array from previous spin
	mov freq[esi], 0
	inc esi
	loop clearFreq
	mov ecx, 5
	mov esi, 0

countFreq:	;incremants the randomly generated symbols based on how many of each was found
	movzx eax, spinRandom[esi]
	inc freq[eax]
	inc esi
	loop countFreq
	mov ecx, 5
	mov esi, 0

evalLoop:	;looks at freq array to see if any symbol appeared, 2,3,4, or 5 times in the spin
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

isPair:	;pair logic
	inc pairs
	jmp nextEval
isTriple:	;3 of a kind logic
	inc triples
	jmp nextEval
isQuad:		;4 of a kind logic
	inc quads
	jmp nextEval
isAllFive:	;5 of a kind logic 
	inc allFive

nextEval:	;checks what case happens for each spin the jumps to that cases payout
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

checkPairs:	;logic for 2 pair, 1 pair, and no pair 
	cmp pairs, 2
	je payoutTwoPair
	cmp pairs, 1
	je payoutPair
	mov edx, OFFSET loseMsg		;if no pairs at all lose message is printed
	call WriteString
	call Crlf
	call Crlf	
	jmp waitKey

payoutAllFive:	;5 of a kind payout
	add balance, 1000
	mov edx, OFFSET winAllFiveMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutQuads:	;4 of a kind payout
	add balance, 50
	mov edx, OFFSET winQuadsMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutFullHouse:	;full house payout
	add balance, 25
	mov edx, OFFSET winFullHouseMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutTriple:	;3 of a kind payout
	add balance, 10
	mov edx, OFFSET winTripleMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutTwoPair:	;2 pair payout
	add balance, 5
	mov edx, OFFSET winTwoPairMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey
payoutPair:		;1 pair payout
	add balance, 1
	mov edx, OFFSET winPairMsg
	call WriteString
	call Crlf
	call Crlf
	jmp waitKey

exitGame:	;exits with a wait message so the program doesn't close instantly
    call Crlf
	call WaitMsg
	exit
main ENDP
END main