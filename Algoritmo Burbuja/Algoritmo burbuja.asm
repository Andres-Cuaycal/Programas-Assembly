/*
 * Algoritmo_burbuja.asm
 *
 *  Created: 01/06/2015 18:00:29
 *   Author: ANDRES
 */ 

 .def tempo1 = R16
 .def tempo2 = R17
 .def contador1 = R18
 .def contador2 = R19
 .def aux=r20  

 .equ n_elementos = 10

 .dseg

 lista: .byte n_elementos

 .cseg
 .org   0x00

 ; Paso de tabla a la RAM

    ldi     zh,high(tabla<<1)
    ldi     zl,low(tabla<<1)
    ldi     xh,high(lista)
    ldi     xl,low(lista)

    ldi     contador1,n_elementos
 lazo:
    lpm     tempo1,z+
    st      x+,tempo1
    dec     contador1
    brne    lazo

    ;====================================
    ; Ordenamiento de datos
    ;====================================
       
    ldi     contador1,n_elementos-1
 lazo1:
    ldi     xh,high(lista)      ; puntero indice 0
    ldi     xl,low(lista)
    ldi     yh,high(lista)      ; puntero indice 1
    ldi     yl,low(lista)
    adiw    yl,1

    ; con n-1 pasadas
    ;ldi     contador2,n_elementos-1

    ; con n-contador1 pasadas
    ; tomando en cuenta que el ultimo elemento
    ; ya esta en su posicion correcta
    ldi     tempo1,9
    sub     tempo1,contador1
    ldi     contador2,9
    sub     contador2,tempo1    ; contador2 = 9 - contador1
    
 lazo2:
    ld      tempo1,x+
    ld      tempo2,y+
    cp      tempo1,tempo2
                                ; brsh tempo1>=tempo2   // orden de menor a mayor
                                ; brlo tempo1< tempo2   // orden de mayor a menor
    brlo    intercambio         
    rjmp    no_intercambio
    intercambio:
    st      -x,tempo2
    st      -y,tempo1
    ; actualizacion de punteros
    adiw    xl,1
    adiw    yl,1

    no_intercambio:
    dec     contador2
    brne    lazo2 
    dec     contador1
    brne    lazo1

loop:
    rjmp    loop

tabla:
 .db 9,7,8,6,2,1,5,4,0,3 