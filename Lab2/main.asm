;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;-------------------------------------------------------------------------------
           	.cdecls C,LIST,"msp430.h"       ; Include device header file
			.def RESET
           	.text                   ; Assemble into program memory
           	.retain                 ; Override ELF conditional linking and retain current section
           	.retainrefs             ; Additionally retain any sections that have references to current section

;Memory allocation of arrays must be done prior to the RESET & StopWDT
ARY1		.set	0x0200			;Memory allocation 	ARY1
ARY1S		.set	0x0210			;Memory allocation 	ARYS
ARY2		.set	0x0220			;Memory allocation 	ARY2
ARY2S		.set	0x0230			;Memory allocation 	AR2S

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
;-----  Your Sorting lab starts here -------------------------------------------



			clr	R4		;Clear Register
			clr	R5		;Clear Register
			clr	R6		;Clear Register

SORT1			mov.w	#ARY1,	R4	;Intialize R4 to poin to ARY1  in the memory
			mov.w	#ARY1S,	R6	;Intialize R6 to poin to ARY1S in the memory where the sorted ARY1 will be stored
			call	#ArraySetup1	;Creat elements are store them in ARY1
			call 	#COPY		;Copy the elements from the ARY1 space to ARY1S space
			call	#SORT		;Calling Subroutine Sort with parameter passing in R4 abd R6

SORT2			mov.w	#ARY2,	R4	;Intialize R4 to poin to ARY2  in the memory
			mov.w	#ARY2S,	R6	;Intialize R6 to poin to ARY2S in the memory where the sorted ARY2 will be stored
			call	#ArraySetup2	;Creat elements are store them in ARY2
			call 	#COPY		;Copy the elements from the ARY2 space to ARY1S space
			call	#SORT		;Calling Subroutine Sort with parameter passing in R4 abd R6

Mainloop		jmp	Mainloop 	;loop in place for ever


;Array element initialization Subroutine
ArraySetup1		mov.b	#10,	0(R4)	;Define the number of elements in the array
			mov.b	#17, 	1(R4)	;store an element
			mov.b	#55, 	2(R4)	;store an element
			mov.b	#-9, 	3(R4)	;store an element
			mov.b	#22, 	4(R4)	;store an element
			mov.b	#36, 	5(R4)	;store an element
			mov.b	#-7, 	6(R4)	;store an element
			mov.b	#37, 	7(R4)	;store an element
			mov.b	#8, 	8(R4)	;store an element
			mov.b	#-77, 	9(R4)	;store an element
			mov.b	#8, 	10(R4)	;store an element
			ret

;Array element initialization Subroutine
ArraySetup2		mov.b	#10, 	0(R4)	;Define the number of elements in the array
			mov.b	#14, 	1(R4)	;store an element
			mov.b	#-74, 	2(R4)	;store an element
			mov.b	#-23, 	3(R4)	;store an element
			mov.b	#19, 	4(R4)	;store an element
			mov.b	#-72, 	5(R4)	;store an element
			mov.b	#-7, 	6(R4)	;store an element
			mov.b	#44, 	7(R4)	;store an element
			mov.b	#60, 	8(R4)	;store an element
			mov.b	#0, 	9(R4)	;store an element
			mov.b	#39, 	10(R4)	;store an element
			ret

;Copy original Array to allocated Array-Sorted space
COPY			mov.b	0(R4), R10	;save n (number of elements) in R10
			inc.b	R10		;increment by 1 to account for the byte n to be copied as well
			mov.w	R4, R5		;copy R4 to R5 so we keep R4 unchanged for later use
			mov.w	R6, R7		;copy R6 to R7 so we keep R6 unchanged for later use
LP			mov.b	@R5+, 0(R7)	;copy elements using R5/R7 as pointers
			inc.w 	R7
			dec	R10
			jnz	LP
			ret

;Sort the copy of Array saved in the allocated Array-Sorted space, while keeping original Array unchanged
;replace the following two lines with your actual sorting algorithm.
SORT			mov.b	0(R4), R10	;save n (number of elements) in R10
			mov.b R10, R9
			dec R10
			dec R9
LP1			mov.w	R6, R7
			inc.w 	R7
LP2			cmp.b	@R7, 1(R7)
			JGE 	skip
			mov.b	0(R7), R8
			mov.b	1(R7), 0(R7)
			mov.b	R8, 1(R7)
skip		inc.w 	R7
			dec R9
			jnz LP2
			dec	R10
			mov.b R10, R9
			jnz	LP1
			ret

;To bubble sort, you need to scan the array n-1 times,
;and in every scan you compare from top down each two consecutive elements,
;and you swap them if they if they are not in ascending order.
;Notice that in the first scan you get the largest element pushed all the way to the bottom,
;so your next scan should be n-1, and then n-2 and so on.
;So every time you come back to the top of the array for a new scan, your n (the number of comparisons) must be decremented by 1.
;In the last scan, you need only one comparison.

;Your sorting algorithm starts with R6 as a pointer to the array
;you need to save n (number of elements) in R8, then decrement it by 1 (n-1) to become the number of comparisons.
;Copy R6 to R7 so you keep R6 unchanged pointing to the top of the array for every new scan.
;Copy n-1 to R9 as a loop counter, while keeping n-1 in R8 for the next scan.
;In the scan loop get an element and auto increment pointer R7, then get next element without changing R7.
;Compare the two elements, if not in ascending order, swap them.
;Repeat the scan from the top (always R6), and every time decrement the number of comparisons (R8).


;-----  Your Sorting lab ends here   -------------------------------------------
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;Stack Pointer definition
            	.global __STACK_END
            	.sect 	.stack
;-------------------------------------------------------------------------------
;Interrupt Vectors
            	.sect   ".reset"    ;MSP430 RESET Vector
            	.short  RESET
