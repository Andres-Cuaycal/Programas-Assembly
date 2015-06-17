/*
 * Identificacion_Clave.asm
 *
 *  Created: 14/06/2015 20:27:45
 *   Author: ANDRES
 */ 


 ; Programa que reconoce una contrasenia
 ; si la contrasenia es correcta se enciende un led verde por aprox 1s
 ; si la contrasenia es incorrecta se enciende un led rojo por aprox 1s

 ; El usuario debe ingresar una contrasenia de 4 digitos
 ; La quinta pulsacion debe ser la TECLA (=), para reconocer
 ; correcta o incorrecta.
 ; Caso contrario los numeros ingresados se borraran 
 ; y se debera ingresar de nuevo la contrasenia


 .include "teclado.inc"
 .include "BarridoDisplay.inc"

 .def tempo=r16   
 .def contador=r18

 .dseg
 clave: .byte 4

 .cseg
 .org 0x00

 ; inicializacion de stack pointer
ldi		tempo,high(ramend)
out		sph,tempo
ldi		tempo,low(ramend)
out		spl,tempo	

call    barrido_init    ; inicializacion de barrido
call    teclado_init    ; inicializacion de teclado

ldi     tempo,0b00000011    ; salidas para led verde y rojo
out     ddrb,tempo
com     tempo
out     portb,tempo

loop:
        lds     r16,tecla       ; leo tecla anterior
        call    teclado         ; realizo el barrido de teclado
        lds     r17,tecla       ; leo tecla actual
        cp      r16,r17         ; comparo tecla actual con anterior
        breq    mostrar_0       ; si son iguales tecla todavia pulsada saltar a mostar
        cpi     r17,16          ; comparo con codigo de tecla no pulsada
        breq    mostrar_0       ; si es asi ir a mostrar
        rjmp    ingreso_contrasenia
        
        ; se usa rjmp porque breq no puede saltar a mostrar directamente
        ; ya que el salto es muy largo
        mostrar_0:
        rjmp    mostrar         

        ; ingreso de contrasenia
        ingreso_contrasenia:
        cpi     contador,0
        breq    clave_0
        cpi     contador,1
        breq    clave_1
        cpi     contador,2
        breq    clave_2
        cpi     contador,3
        breq    clave_3
        cpi     contador,4
        breq    clave_4
        
        clave_0:
        sts     clave,r17       ; guardar contrasenia
        sts     n_bcd,r17       ; para mostrar en el barrido
        inc     contador        ; para el siguiente digito
        rjmp    mostrar

        clave_1:
        sts     clave+1,r17       ; guardar contrasenia
        lds     tempo,clave       ; para mostrar en el barrido  
        sts     n_bcd+1,tempo
        sts     n_bcd,r17       
        inc     contador        ; para el siguiente digito
        rjmp    mostrar

        clave_2:
        sts     clave+2,r17       ; guardar contrasenia
        lds     tempo,clave       ; para mostrar en el barrido  
        sts     n_bcd+2,tempo
        lds     tempo,clave+1
        sts     n_bcd+1,tempo   
        sts     n_bcd,r17       
        inc     contador        ; para el siguiente digito
        rjmp    mostrar

        clave_3:
        sts     clave+3,r17       ; guardar contrasenia
        lds     tempo,clave       ; para mostrar en el barrido  
        sts     n_bcd+3,tempo
        lds     tempo,clave+1
        sts     n_bcd+2,tempo
        lds     tempo,clave+2
        sts     n_bcd+1,tempo
        sts     n_bcd,r17       
        inc     contador        ; para identificar
        rjmp    mostrar

        clave_4:
        clr     contador
        cpi     r17,'='         ; testear la tecla de igual (=)
        breq    check_contrasenia   ; si es correcta chequear contrasenia

        ; caso contrario borrar todo
        borrar:                     
        clr     contador
        clr     tempo
        sts     n_bcd,tempo
        sts     n_bcd+1,tempo
        sts     n_bcd+2,tempo
        sts     n_bcd+3,tempo
        rjmp    mostrar

        ; subrutina que identifica la contrasenia
        check_contrasenia:
        ldi     xh,high(clave)
        ldi     xl,low(clave)
        ldi     zh,high(contrasenia<<1)
        ldi     zl,low(contrasenia<<1)

        ldi     contador,4      ; 4 iteraciones de lazo
        check_loop:
            lpm     r16,z+
            ld      r17,x+
            cp      r16,r17
            brne    contra_erronea
            dec     contador
            brne    check_loop
            cbi     portb,1
            sbi     portb,0     ; si llega aqui, la contrasenia es correcta
                                ; enciendo led
            call    retardo_led ; enciendo el led por un tiempo
            cbi     portb,0     ; apago leds
            cbi     portb,1
            rjmp    borrar      ; borro y voy a mostrar
        
        contra_erronea:
            cbi     portb,0
            sbi     portb,1     ; enciendo el led por un tiempo
            call    retardo_led
            cbi     portb,0     ; apago leds
            cbi     portb,1
            rjmp    borrar


        mostrar:
        call    bcd_7seg
        clr     r16             ; para que no aparezca el punto
        call    barrido

        rjmp    loop


; tabla de la contrasenia
 contrasenia:
 .db 4,3,2,1

 retardo_led:
 push   r16
 push   r17
 push   r18

 ldi    r18,4
 ret2:
 ldi    r17,255
 ret0:
 ldi    r16,255
 ret1:
 dec    r16
 brne   ret1
 dec    r17    
 brne   ret0
 dec    r18
 brne   ret2

 pop    r18
 pop    r17
 pop    r16
 ret

 .include "BarridoDisplay.asm"
 .include "teclado.asm"
 .include "binBCD.asm"
 .include "BCD7seg.asm"
 