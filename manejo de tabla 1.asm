/*
 * manejo_de_tabla_1.asm
 *
 *  Created: 28/05/2015 17:05:23
 *   Author: ANDRES
 */ 


 ; segmento de memoria en RAM

 .def temp = r16
 .def contador = r17
 
 
 .dseg
 name: .byte 14     ; reservo 14 bytes de memoria


 ; segmento de memoria en flash
 .cseg

    ldi contador,14
    ldi zh,high(nombre<<1)
    ldi zl,low(nombre*2)
    ldi xh,high(name)
    ldi xl,low(name)
 lazo:           
    lpm temp,z+
    st  x+,temp
    dec contador
    brne lazo

 lazo1: rjmp lazo1

 nombre:
 .db "ANDRES CUAYCAL"