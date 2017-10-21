; Elizabeth Wanic
; 5 February 2017
; CS 3140 - Assignment 3 Part 1
; Command line for assembly : 
;    nasm -f elf32 -g assign3_part1.asm
; Command line for linker :
;    ld -o assign3_part1 -m elf_i386 assign3_part1.o
; 
; User must enter ./assign3_part1 to run the program
; Then they will enter a series of characters followed by 
; a carriage return
; 


bits 32
section .text   ; section declaration
global _start

_start:
        mov     eax, 0x03                ; 3 is sys call for read
        mov     ebx, 0x00                ; fd for stdin is 0
        mov     ecx, inbuff              ; pointer to inbuff
        mov     edx, 200                 ; read 200 bytes maximum
        int     0x80                     ; execute read sys call

        mov     dword [incount], 0x00    ; set index for inbuff to 0
        mov     dword [outcount], 0x00   ; set index for outbuff to 0

inbuff_loop_left:
        mov     ecx, [incount]                  ; move inbuff index to ecx
        cmp     ecx, 200                        ; check if incount is 200
        je      write_output                    ; jump to write_output if at 200 chars
        movzx     eax, byte [inbuff + ecx]             ; move through inbuff one char at a time
        cmp     eax, 0x0A                       ; check for the new line
        je      write_output                    ; jump to write_output if new line
        mov     [temp], al                     ; else, save that char in temp
        shr     al, 4                           ; get left half of byte
        mov     bl, 9                           ; put 9 in bl
        cmp     al, bl                          ; check if left half of byte is digit
        jle     write_digit_left                ; jump to write it in outbuff if digit
        mov     bl, 10                          ; put 10 in bl
        cmp     al, bl                          ; check if left half of byte is letter
        jge     write_letter_left               ; jump to write it in outbuff if letter

write_digit_left:
        mov     ecx, [outcount]                 ; move outbuff index to ecx
        add     al, 48                          ; add 48 to the value in al
        mov     [outbuff + ecx], al             ; put ASCII code for digit in outbuff
        mov     ecx, [outcount]                 ; current outcount value
        inc     ecx                             ; increment outcount
        mov     [outcount], ecx                 ; return value to outcount
        jmp     inbuff_loop_right               ; jump to deal with right half

write_letter_left:
        mov     ecx, [outcount]                 ; move outbuff index to ecx
        add     al, 55                          ; add 55 to the value in al
        mov     [outbuff + ecx], al             ; put ASCII code for letter in outbuff
        mov     ecx, [outcount]                 ; current outcount value
        inc     ecx                             ; increment outcount
        mov     [outcount], ecx                 ; return value to outcount
        jmp     inbuff_loop_right               ; jump to deal with right half

inbuff_loop_right:
        mov     ecx, [incount]                  ; current incount value
        inc     ecx                             ; increment incount
        mov     [incount], ecx                  ; return value to incount
        movzx     eax, byte [temp]                     ; old char value into eax
        and     al, 0x0F                        ; and with 15 to get only second half
        mov     bl, 9                           ; put 9 in bl
        cmp     al, bl                          ; check if second half of byte is digit
        jle     write_digit_right               ; jump to write it in outbuff if digit
        mov     bl, 10                          ; put 10 in bl
        cmp     al, bl                          ; check if second half of byte is letter
        jge     write_letter_right              ; jump to write it in outbuff if letter

write_digit_right:
        mov     ecx, [outcount]                 ; move outbuff index to ecx
        add     al, 48                          ; add 48 to the value in al
        mov     [outbuff + ecx], al             ; put ASCII code for digit in outbuff
        mov     ecx, [outcount]                 ; current outcount value
        inc     ecx                             ; increment outcount
        mov     [outbuff + ecx], byte 32        ; next outbuff item is space 
        inc     ecx                             ; increment outcount
        mov     [outcount], ecx                 ; return value to outcount
        jmp     inbuff_loop_left                ; jump deal with to next char

write_letter_right:
        mov     ecx, [outcount]                 ; move outbuff index to ecx
        add     al, 55                          ; add 31 to the value in al
        mov     [outbuff + ecx], al             ; put ASCII code for letter in outbuff
        mov     ecx, [outcount]                 ; current outcount value
        inc     ecx                             ; increment outcount
        mov     [outbuff + ecx], byte 32        ; next outbuff item is space 
        inc     ecx                             ; increment outcount
        mov     [outcount], ecx                 ; return value to outcount
        jmp     inbuff_loop_left                ; jump to deal with next char


write_output:
        mov     ecx, [outcount]             ; put outbuff index in ecx
        mov     [outbuff + ecx], byte 48    ; add the new line chars 
        inc     ecx                         ; increment outcount
        mov     [outbuff + ecx], byte 65    ; add the new line chars 
        inc     ecx                         ; increment outcount
        mov     [outbuff + ecx], byte 32    ; add the space 
        inc     ecx                         ; increment outcount
        mov     [outcount], ecx             ; return value to outcount
        mov     ecx, [outcount]             ; put outbuff index in ecx
        mov     [outbuff + ecx], byte 0x0A  ; write a newline for last outbuff position 
        inc     ecx                         ; increment outcount
        mov     [outcount], ecx             ; return value to outcount    
        mov     eax, 0x04                   ; 4 sys call for write
        mov     ebx, 0x01                   ; fd for stdout is 1
        mov     ecx, outbuff                ; pointer to outbuff
        mov     edx, [outcount]             ; write [outcount] bytes at most
        int     0x80                        ; execute write sys call

done:
        mov     eax, 0x01       ; 1 is sys call for exit
        int     0x80            ; execute exit sys call


section .data   ; section declaration


section .bss    ; section declaration

outbuff: resb 600   ; outbuff needs 600 bytes max
temp: resb 1        ; need to store the char temporarily
inbuff: resb 200    ; inbuff needs 200 bytes max
incount: resd 1     ; index for inbuff
outcount: resd 1    ; index for outbuff

