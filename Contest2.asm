INCLUDE Irvine32.inc

.data
rulesMsg BYTE "Press SPACE to spin ($10) or E to exit ",0

.code
main PROC
    call Randomize
    mov edx, OFFSET rulesMsg
    call WriteString
    call Crlf
    call Crlf

exitGame:
    exit
main ENDP
END main