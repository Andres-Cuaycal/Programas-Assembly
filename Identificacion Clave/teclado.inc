/*
 * teclado.inc
 *
 *  Created: 11/06/2015 16:01:22
 *   Author: ANDRES
 */ 

.equ teclado_port = portd
.equ teclado_pin = pind
.equ teclado_ddr = ddrd

.dseg
tecla: .byte 1