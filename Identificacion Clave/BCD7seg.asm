/*
 * BCD7seg.asm
 *
 *  Created: 11/06/2015 15:37:14
 *   Author: ANDRES
 */ 

 ; ==========================================================
 ; Subrutina de conversion de binario a bcd
 ; Entrada ==> byte de (n_bcd) en SRAM
 ; Salida ==> bytes de (n_dig) en SRAM
 ; ==========================================================
 bcd_7seg:
 
        push    r16
        push    r17

        ldi     xh,high(n_bcd)
        ldi     xl,low(n_bcd)
        ldi     yh,high(n_dig)
        ldi     yl,low(n_dig)

        ldi     r17,4           ; contador

 bcd_7seg0:
        ld      r16,x+
        call    bin_to_7seg
        st      y+,r16
        dec     r17
        brne    bcd_7seg0

        pop     r17
        pop     r16

        ret

; ==========================================================
 ; Subrutina de conversion de un numero de 4 bits
 ; a 7 segmentos
 ; Entrada ==> R16 = numero a convertir
 ; Salida ==> R16 = numero convertido
 ; ===========================================================
 bin_to_7seg:
        ldi     zh,high(tabla_7seg<<1)
        ldi     zl,low(tabla_7seg<<1)
        add     zl,r16      ; pongo puntero en posicion deseada
        clr     r16
        adc     zh,r16
        lpm     r16,z
        ret   

 tabla_7seg: ;gfedcba
.db 0b00111111,0b00000110 ;0,1
.db 0b01011011,0b01001111 ;2,3
.db 0b01100110,0b01101101 ;4,5
.db 0b01111101,0b00000111 ;6,7
.db 0b01111111,0b01101111 ;8,9
.db 0b01110111,0b01111100 ;10 (A),11 (b)
.db 0b00111001,0b01011110 ;12 (C),13 (d)
.db 0b01111001,0b01110001 ;14 (E),15 (F)