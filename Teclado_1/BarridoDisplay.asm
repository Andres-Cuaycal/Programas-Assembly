/*
 * BarridoDisplay.asm
 *
 *  Created: 11/06/2015 15:37:29
 *   Author: ANDRES
 */
 
 ; Subrutina que configura los puertos a usarse para el display
 barrido_init:

 ldi    r16,0b01111111
 out    seg_ddr,r16
 com    r16
 out    seg_port,r16
 ldi    r16,0b00001111
 out    ctr_ddr,r16
 com    r16
 out    ctr_port,r16

 ret
 
  
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