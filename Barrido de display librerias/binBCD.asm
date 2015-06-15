/*
 * binarioBCD.asm
 *
 *  Created: 11/06/2015 15:36:46
 *   Author: ANDRES
 */ 


; ==========================================================
 ; Subrutina de conversion de binario a bcd
 ; Entrada ==> byte de (binario) en SRAM
 ; Salida ==> bytes de (n_bcd) en SRAM
 ; ==========================================================
 bin_bcd:
        
        push    r16
        push    r17
        push    r18
        push    r19
        push    r20
        push    r21

        ldi     zh,high(tabla_div<<1)
        ldi     zl,low(tabla_div<<1)
        ldi     xh,high(n_bcd)
        ldi     xl,low(n_bcd)
                
        lds     r16,binario
        lds     r17,binario+1
        ldi     r20,3                   ; iteraciones del lazo
        clr     r21                     ; contador de unidades

 bin_bcd0:
        lpm     r18,z+
        lpm     r19,z+
 
 bin_bcd1:
        sub     r16,r18
        sbc     r17,r19
        brcs    bin_bcd2
        inc     r21
        rjmp    bin_bcd1

 bin_bcd2:                      ; guardo miles, centenas, decenas
        add     r16,r18
        adc     r17,r19
        st      x+,r21
        clr     r21
        dec     r20
        brne    bin_bcd0
        st      x,r16           ; guardo las unidades

        pop     r21
        pop     r20
        pop     r19
        pop     r18
        pop     r17
        pop     r16

        ret

 tabla_div:
 .dw    1000,100,10
