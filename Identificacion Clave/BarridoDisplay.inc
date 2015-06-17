/*
 * Barrido_Display.inc
 *
 *  Created: 11/06/2015 15:47:22
 *   Author: ANDRES
 */ 

 .equ   seg_port = porta
 .equ   ctr_port = portc

 .equ   seg_ddr = ddra
 .equ   ctr_ddr = ddrc

  .dseg
 binario:   .byte 2
 n_bcd:     .byte 4
 n_dig:     .byte 4