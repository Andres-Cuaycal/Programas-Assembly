/*
 * Barrido_de_display_librerias.asm
 *
 *  Created: 11/06/2015 15:35:31
 *   Author: ANDRES CUAYCAL
 */ 

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

 .include "BarridoDisplay.inc"  ; archivo de cabecera 
                                ; con definiciones de puertos para barrido
                                ; y definiciones de localidades de ram 
 .def   tempo1 = r16
 .def   tempo2 = r17

 ; comienzo del codigo de programa
 .cseg
 .org   0x00

 call   barrido_init    ; inicializacion de pines ocupados por el barrido de display
 ser    tempo1          ; pull-up en puertos como entradas
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

.include "binBCD.asm"
.include "BCD7seg.asm"
.include "BarridoDisplay.asm"
