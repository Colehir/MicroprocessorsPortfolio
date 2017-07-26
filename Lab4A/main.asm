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

            mov.b	#00000000b,&P1OUT
			mov.b	#11111111b,&P1DIR
			mov.b	#00000000b,&P2DIR

InfLoop		mov.b	&P2IN, R5

			bit.b	#BIT0, R5
			jnz		rotate
read		mov.b	R5, R6			; copy switches value to R6
			and.b	#00111000b,R6   ; mask desired LED pattern from P2 pins 3-5
			mov.b	R6, &P1OUT		; display the pattern on P1
			jmp		InfLoop

rotate		mov.b	&P2IN, R5
			bit.b	#BIT1, R5
			jnz		left
			clrc
			rrc		R6
			jnc		patout
			bis		#BIT7,R6
			jmp 	patout
left		clrc
			rlc.b	R6
			jnc		patout
			bis		#BIT0,R6


patout		mov.b 	R6, &P1OUT		; display the rotated pattern
			call	#Delay			; call subroutine delay
			jmp		InfLoop

Delay		mov.w 	#50000, R7		; modify your delay to have slow and fast bassed on pin P2.2
dloop		dec.w	R7
			jnz		dloop
			mov.b	&P2IN, R5
			bit.b	#BIT2, R5
			jnz		fastdelay
			mov.w 	#50000, R7
sloop		dec.w	R7
			jnz		sloop
fastdelay	ret

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
            
