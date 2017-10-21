; Elizabeth Wanic
; 5 February 2017
; CS 3140 - Assignment 3 Part 2
; Command line for assembly : 
;    nasm -f elf32 -g assign3_part2.asm
; Command line for gcc :
;    gcc -o assign3_part2 -m32 assign3_part2.o
; 
; User must enter ./assign3_part2 to run the program
; Whatever is entered after the program name will be 
; output as the command line arguments
; 


bits 32         ; 32 bit program
section .text   ; section declaration

global main     ; let gcc find function
extern printf   ; declare use of external functions
extern exit     ; ditto

main:
        mov     ebp, [esp + 8]          ; eax holds address to argv 
        xor     eax, eax                ; eax is 0
        mov     [offset], eax           ; offset is set to 0

print_argv_loop:
        mov     ebx, [offset]              ; ebx holds the current offset amount
        mov     eax, [ebp + ebx * 4]   ; edx holds address of argv element pointer
        cmp     eax, 0                     ; check if null
        je      print_envp_setup           ; if null move to envp section     

        push    eax                        ; push address of text
        push    format                     ; push the format string
        call    printf                     ; call printf
        add     esp, 8                     ; clear the stack

        mov     eax, [offset]        ; current offset value
        inc  	eax                  ; increment offset
        mov     [offset], eax        ; return value to offset

        jmp     print_argv_loop      ; jump to deal with next 

print_envp_setup:
        mov     ebp, [esp + 12]          ; eax holds address to envp
        xor     eax, eax                ; eax is 0
        mov     [offset], eax           ; offset is set to 0

print_envp_loop:
        mov     ebx, [offset]              ; ebx holds the current offset amount
        mov     eax, [ebp + ebx * 4]       ; eax holds address of envp element pointer
        cmp     eax, 0                     ; check if null
        je      myexit                     ; if null, exit

        push    eax                        ; push address of text
        push    format                     ; push the format string
        call    printf                     ; call printf
        add     esp, 8                     ; clear the stack

        mov     eax, [offset]              ; current offset value
        inc     eax                        ; increment offset
        mov     [offset], eax              ; return value to offset

        jmp     print_envp_loop            ; jump to deal with next

myexit:
        xor     eax, eax        ; eax hold 0 - exit will return this
        push    eax             ; push the parameter for exit
        call    exit


section .data   ; section declaration

format  db  "%s",0x0A,0        ; string formatting, including new line and null

section .bss    ; section declaration

offset: resd 1    ; counter for offset on stack for pointer to pointer




