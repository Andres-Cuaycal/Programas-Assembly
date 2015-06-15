/*
 * Teclado_1.asm
 *
 *  Created: 11/06/2015 16:00:44
 *   Author: ANDRES
 */ 

 .include "teclado.inc"
 .include "BarridoDisplay.inc"

 .def tempo=r16   


 .cseg
 .org 0x00

 ; inicializacion de stack pointer
ldi		tempo,high(ramend)
out		sph,tempo
ldi		tempo,low(ramend)
out		spl,tempo	

call    barrido_init
call    teclado_init

loop:
        ;valor anterior 
		lds		r16,tecla
		call	teclado
		;valor actual de tecla
		lds		r20,tecla
		;comparo para ver si el valor de tecla cambio (si no cambia es porque continua presionada)
		cp		r16,r20
		breq	continuar
		cpi		r20,0   ; codido de tecla no pulsada
		breq	continuar
		;sumo lo que tenia acumulado con el valor de tecla
		
        ; en r20 tengo tecla , y cargo para barrido de display
        sts     binario,r20
						
        continuar:
		call	bin_bcd
		call	bcd_7seg
		call	barrido	       

rjmp    loop     



 .include "teclado.asm"
 .include "binBCD.asm"
 .include "BCD7seg.asm"
 .include "BarridoDisplay.asm"
