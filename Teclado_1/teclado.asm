/*
 * teclado.asm
 *
 *  Created: 11/06/2015 16:01:10
 *   Author: ANDRES
 */ 


  teclado_init:
  ldi   r16,0b00001111
  out   teclado_ddr,r16
  com   r16
  out   teclado_port,r16
  ret


  teclado:
    push	r16
    push	r17     ; para tecla
    push    zl
    push    zh

    ldi	    r17,16          ; codigo de tecla no pulsada
 
    ldi	    r16,0b11111110  ; Fila 0
    out	    teclado_port,r16
    sbis	teclado_pin,4
    ldi	    r17,0           ; C0         
    sbis	teclado_pin,5
    ldi	    r17,1           ; C1
    sbis	teclado_pin,6
    ldi	    r17,2           ; C2
    sbis	teclado_pin,7
    ldi	    r17,3           ; C3

    ldi	    r16,0b11111101  ; Fila 1
    out	    teclado_port,r16
    sbis	teclado_pin,4          
    ldi	    r17,4           ; C0
    sbis	teclado_pin,5          
    ldi	    r17,5           ; C1
    sbis	teclado_pin,6
    ldi	    r17,6           ; C2
    sbis	teclado_pin,7
    ldi	    r17,7           ; C3

    ldi	    r16,0b1111011   ; Fila 2
    out	    teclado_port,r16
    sbis	teclado_pin,4          
    ldi	    r17,8           ; C0
    sbis	teclado_pin,5
    ldi	    r17,9          ; C1
    sbis	teclado_pin,6
    ldi	    r17,10          ; C2
    sbis	teclado_pin,7
    ldi	    r17,11          ; C3


    ldi	    r16,0b11110111  ; Fila 3
    out	    teclado_port,r16
    sbis	teclado_pin,4          
    ldi	    r17,12          ; C0
    sbis    teclado_pin,5          
    ldi	    r17,13          ; C1
    sbis	teclado_pin,6          
    ldi	    r17,14          ; C2
    sbis	teclado_pin,7          
    ldi	    r17,15          ; C3

    ldi     zh,high(tabla_teclado<<1)
    ldi     zl,low(tabla_teclado<<1)
    add     zl,r17
    clr     r17
    adc     zh,r17
    lpm     r17,z


    sts	    tecla,r17
    
    pop zh
    pop zl
    pop	r17
    pop	r16

    ret

tabla_teclado:
.db 1,2,3,4
.db 5,6,7,8
.db 9,10,11,12
.db 13,14,15,16
.db 0,0             ; codigo de tecla no pulsada

