/*
 * bin_to_bcd.asm
 *
 *  Created: 01/06/2015 16:39:37
 *   Author: ANDRES
 */ 

 ; Programa que muestra transforma a 7 segmentos
 ; lo que se ingresa por el PUERTO B
 ;
 ; Parte alta en el PUERTO A
 ; Parte baja en el PUERTO C

 .def tempo1=r16
 .def tempo2=r17
 .def aux=r18


 ; Configuracion de puertos

 clr    tempo1
 out    ddrb,tempo1         ;entrada puerto b
 out    ddrd,tempo1         ;entrada puerto d
 com    tempo1
 out    portb,tempo1        ; pull-up puerto b
 out    portd,tempo1        ; pull-up puerto d
 ldi    tempo1,0b01111111
 out    ddra,tempo1
 out    ddrc,tempo1
 com    tempo1
 out    porta,tempo1
 out    portc,tempo1

 ; Configuracion de stack pointer
 ldi    tempo1,high(RAMEND)
 out    sph,tempo1
 ldi    tempo1,low(RAMEND)
 out    spl,tempo1

 ; lazo principal de programa
 loop:

        in      tempo1,pinb             ; leo los dip-switch
        mov     tempo2,tempo1
        andi    tempo1,0b00001111       ; mascara para los 4 bits

        call    bin_to_bcd
        out     portc,tempo1             ; muestro la parte baja

        swap    tempo2
        andi    tempo2,0b00001111       
        mov     tempo1,tempo2

        call    bin_to_bcd
        out     porta,tempo1            ; muestro la parte alta       

        rjmp    loop
 
 ; ==========================================================
 ; Subrutina de conversion de un numero de 4 bits
 ; a 7 segmentos
 ; Entrada ==> R16 = numero a convertir
 ;             Bandera T para indicar si se quiere el punto               
 ; Salida ==> R16 = numero convertido
 ; Temporal ==> R17
 ; ===========================================================
 bin_to_bcd:
        
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

