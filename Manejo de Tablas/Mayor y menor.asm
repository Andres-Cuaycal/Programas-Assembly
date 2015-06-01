/*
 * Mayor_y_menor.asm
 *
 *  Created: 28/05/2015 17:18:49
 *   Author: ANDRES
 */ 


 .def temp=r16
 .def contador=r17
 .def maxi = r18
 .def mini = r19

 ;.equ n_elementos = (fin_tabla - tabla)<<1
 .equ n_elementos = 10

 .dseg 
     maximo: .byte 1
     minimo: .byte 1
     copia:  .byte n_elementos 

 .cseg
 .org 0x00 

 ; copiar de la flash a la ram

 ldi    zh,high(tabla<<1)
 ldi    zl,low(tabla<<1)
 ldi    xh,high(copia)
 ldi    xl,low(copia)
 
 ldi    contador,n_elementos

 lazo1:
        lpm temp,z+
        st  x+,temp
        dec contador
        brne lazo1

 ; Encontrar maximo
 
 ldi    contador,n_elementos
 clr    maxi ; 0
 ser    mini ; 255

 lazo2: 
        ld      temp,-x    
        cp      maxi,temp
        brcc    otra
        mov     maxi,temp

        otra:
        cp      mini,temp
        brcs    otra1  
        mov     mini,temp
        
        otra1:
        dec     contador
        brne    lazo2

        sts     maximo,maxi
        sts     minimo,mini

 lazo: rjmp lazo

 tabla:
 .db 1,2,3,20,5,6,7,8,9,10
 fin_tabla: