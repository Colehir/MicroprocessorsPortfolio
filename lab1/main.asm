;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
Setup		clr 	R4
		clr		R5
		clr		R6
		clr		R7
		clr		R10
		mov.w 	#04,R4
		mov.w 	#03,R5
		mov.w 	#10,R6
		mov.w 	#15,R10
		clr.w	&0200h
		clr.w	&0202h
		clr.w	&0204h
		clr.w	&0206h
		clr.w	&0208h

Addition 		add.b 	R4,R7
			add.b 	R5,R7
			add.b 	R6,R7

Subtraction 	sub.b 	R10, R7

Store 	mov.w 	R4, &0200h
		mov.w 	R5, &0202h
		mov.w 	R6, &0204h
		mov.w 	R10, &0206h
		mov.w 	R7, &0208h

Mainloop	jmp     Mainloop        ;Infinite Loop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
