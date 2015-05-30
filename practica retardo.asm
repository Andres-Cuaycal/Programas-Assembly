/*
 * practica_retardo.asm
 *
 *  Created: 29/05/2015 14:31:26
 *   Author: ANDRES
 */ 


 sbi    ddrb,0
 ser    r16
 out    porta,r16

 main:
        in  r20,pina
        cpi r20,0xFF
        breq frec_2KHz
        rjmp frec_1Hz

frec_2KHz:
        call f_2KHz
        rjmp main

frec_1Hz:
        call f_1Hz
        rjmp main


f_2Khz:
    sbi pinb,0
    call retardo1
    ret
    
f_1Hz:
    sbi pinb,0
    call retardo2
    ret     


        

; Retardo de 500000 ciclos de maquina
        
retardo2:
        ldi     r17,249
 lazo1: ldi     r16,249
 lazo2: dec     r16
        nop
        nop
        nop
        nop
        nop
        brne    lazo2
        nop
        nop
        nop
        nop
        nop
        dec     r17
        brne    lazo1
        ret

; retardo de 250 ciclos de maquina

retardo1:
        ldi     r16,80
lazo:   dec     r16
        brne    lazo
        nop
        nop
        ret