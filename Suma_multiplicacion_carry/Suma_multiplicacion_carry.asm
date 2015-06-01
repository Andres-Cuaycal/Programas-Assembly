/*
 * Suma_multiplicacion_carry.asm
 *
 *  Created: 01/06/2015 18:08:25
 *   Author: ANDRES
 */ 

 ; Por el puerto A se ingresa un numero
 ; Por el puerto B se ingresa un numero
 ;
 ; Se tiene un LED en PA7 
 ; Se tiene un interruptor en PC7
 ;
 ; Interrupctor abierto ==> Mostrar Suma
 ; Interruptor cerrado  ==> Mostrar Multiplicacion
 ; LED ==> Mostrar Carry

 .def   tempo1 = r16
 .def   tempo2 = r17

 ; Configuracion de puertos

    clr     tempo1
    out     ddrb,tempo1         ;entrada puerto b
    out     ddrd,tempo1         ;entrada puerto d
    com     tempo1
    out     portb,tempo1        ; pull-up puerto b
    out     portd,tempo1        ; pull-up puerto d
    ser     tempo1
    out     ddra,tempo1
    com     tempo1
    out     porta,tempo1  
    ldi     tempo1,0b01111111
    out     ddrc,tempo1
    com     tempo1
    out     portc,tempo1

    ; Configuracion de stack pointer
    ldi     tempo1,high(RAMEND)
    out     sph,tempo1
    ldi     tempo1,low(RAMEND)
    out     spl,tempo1


    ; lazo de programa

 loop:
    
    ; Lectura de dips para multiplicar o sumar
    in      tempo1,pinb
    in      tempo2,pind

    sbic    pinc,7
    rjmp    suma
    rjmp    multiplicacion

    suma:
    add     tempo1,tempo2
    in      tempo2,sreg         ; copio bandera del carry a bandera T
    bst     tempo2,0            ; C esta en posicion 0
    rjmp    mostrar

    multiplicacion:
    mul     tempo1,tempo2
    mov     tempo1,r0           ; parte baja del resultado
    mov     tempo2,r1           ; parte alta del resultado

    cpi     tempo2,0
    breq    mostrar             ; saltar a mostrar si la parte alta es 0
    ; si es diferente de 0 entonces hay carry, poner T=1L
    set

    mostrar:
    mov     tempo2,tempo1
    swap    tempo1
    andi    tempo1,0b00001111
                                ; bandera T activada previamente si hay carry
    call    bin_to_7seg         ; muestro la parte alta
    out     porta,tempo1
    andi    tempo2,0b00001111
    mov     tempo1,tempo2
    set                         ; activo la bandera T para no modificar pull-up
    call    bin_to_7seg
    out     portc,tempo1   

    rjmp    loop

 ; ==========================================================
 ; Subrutina de conversion de un numero de 4 bits
 ; a 7 segmentos
 ; Entrada ==> R16 = numero a convertir
 ;             Bandera T para indicar si se quiere el punto               
 ; Salida ==> R16 = numero convertido
 ; Temporal ==> R17
 ; ===========================================================
 bin_to_7seg:
        
        push    r17         ; enviar al stack el registro r17

        ldi     zh,high(tabla_7seg<<1)
        ldi     zl,low(tabla_7seg<<1)

        add     zl,r16      ; pongo puntero en posicion deseada
        clr     r16
        adc     zh,r16
        lpm     r16,z

        ; Poner o no el punto, de acuerdo a bandera T
        in      r17,SREG
        sbrc    r17,6      
        ori     r16,0b10000000
        sbrs    r17,6
        andi    r16,0b01111111
        
        clt     ; borro bandera T

        pop     r17     ; retornar el valor de r17 del stack
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