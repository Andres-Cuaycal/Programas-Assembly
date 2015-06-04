/*
 * Barrido_de_display.asm
 *
 *  Created: 01/06/2015 20:33:22
 *   Author: ANDRES
 */ 

 ; Programa que muestra el numero ingresado por el puerto
 ; en display de 7 segmentos, utilizando barrido

 ; Puerto B ==> Numero (byte bajo)
 ; Puerto D ==> Numero (byte alto)
 ; Puerto A ==> Segmentos
 ; Puerto C ==> Lineas de control


 .def   tempo1 = r16
 .def   tempo2 = r17
 .equ   seg_port = porta
 .equ   ctr_port = portc

 .dseg
 binario:   .byte 2
 n_bcd:     .byte 4
 n_dig:     .byte 4


 .cseg
 .org   0x00

 ser    tempo1
 out    ddra,tempo1
 out    ddrc,tempo1
 out    portb,tempo1
 out    portd,tempo1

 loop:

        in      tempo1,pinb
        in      tempo2,pind
        sts     binario,tempo1
        sts     binario+1,tempo2
        call    bin_bcd
        call    bcd_7seg
        ldi     r16,0           ; sin punto
        call    barrido    

        rjmp    loop

 ; ==========================================================
 ; Subrutina de conversion de binario a bcd
 ; Entrada ==> byte de (n_dig) en SRAM
 ;         ==> R16 posicion del punto (posicion 0, punto apagado)
 ; Salida ==> ninguna
 ; ==========================================================
 
 barrido:

        push    r17
        push    r18
        push    r19

        ldi     xh,high(n_dig)
        ldi     xl,low(n_dig)

        ldi     r17,4           ; contador
        ldi     r18,0b11111110  ; enciendo con 0L, apago con 1L
 
 barrido0:
        ldi     r19,0b11111111
        out     ctr_port,r19
        ld      r19,x+ 
        cp      r16,r17
        brne    barrido1
        ori     r19,0b10000000

 barrido1:
        out     seg_port,r19    ; pongo el dato en los segmentos
        out     ctr_port,r18    ; activo display         
        call    ret_barrido
        sec                     ; pongo 1L en el Carry
        rol     r18             ; desplazo hacia la izquierda con carry
        dec     r17             
        brne    barrido0

        ldi     r19,0b11111111  ; dejo apagando los displays
        out     ctr_port,r19

        pop     r19
        pop     r18
        pop     r17
        ret

 ; Subrutina para retardo del barrido
 ; Entrada ==> ninguna
 ; Salida == ninguna

 ret_barrido:
        push    r16
        ldi     r16,255
 ret_barrido0:
        dec     r16
        brne    ret_barrido0
        pop     r16
        ret   
 
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