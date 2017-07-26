//***********************************************************************
//******** CDA3331 Intro to Micro class, updated on October 21, 2016
//******** Dr. Bassem Alhalabi, FAU EE512, Boca Raton, Florida
//******** Contributors: Pablo Pastran 2015,
//******** Skeleton Program for Lab 4, in C
//******** Run this program as is to make sure you have correct hardware connections
//******** Explore the program and see the effect of Switches on pins P2.3-5
//******** Lab5 Grade --> Make the appropriate changes to the program per lab manual

#include <msp430.h> 

int main(void) {
    WDTCTL = WDTPW | WDTHOLD;    // Stop watchdog timer

    int R5_SW=0, R6_LED=0, temp=0;

    P1OUT = 0b00000000;  	// mov.b    #00000000b,&P1OUT
    P1DIR = 0b11111111;  	// mov.b    #11111111b,&P1DIR
    P2DIR = 0b00000000;  	// mov.b    #00000000b,&P2DIR

    while (1)
    {
        R5_SW = P2IN;  		//mov.b    &P2IN, R5
        if (!(R5_SW & BIT0))  	//checking P2.0 for read mode
        {
            R6_LED = R5_SW & (BIT3 | BIT4 | BIT5);
            P1OUT = R6_LED;
        }
        else   // display rotation mode
        {
            //you need to modify the toggle line below with pattern rotation based on the value of P2.1
        	if(R5_SW & BIT1)
            {
        		if(R6_LED<8)
        		{
					R6_LED <<=6;
				}
        		R6_LED >>=1;
        	}
        	else
        	{
        		R6_LED <<=1;
        		if(R6_LED>0xFF)
				{
					R6_LED >>=6;
				}
        	}
            R6_LED &= 0xFF;										//mask any excessive bits
            P1OUT = R6_LED;      								//pattern out - display it

            //you need to replace the simple delay line below with slow/fast delay based on P2.2
            __delay_cycles( 400000);					        //fast
            if(R5_SW & BIT2)
            {
            	__delay_cycles( 400000);
            }
         }
    }
}
