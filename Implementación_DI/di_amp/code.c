/******************************************************************************
 *  FILE		 	: code.c
 *  DESCRIPTION  	: main program
 *  CPU TYPE     	: dsPIC33FJ256MC710
 *  AUTHOR	     	: Antonio Camacho Santiago
 *  PROJECT	     	: DPI2007-61527
 *  COMPANY	     	: Automatic Control Department,
 *  				  Technical University of Catalonia
 *
 *  REVISION HISTORY:
 *			 VERSION: 0.1
 *     		  AUTHOR: Antonio Camacho Santiago
 * 				DATE: April 2010
 * 			COMMENTS:
 *
 *  REVISION HISTORY:
 *			 VERSION: 0.2
 *     		  AUTHOR: Miquel Perello Nieto
 * 				DATE: January 2012
 * 			COMMENTS:
 *****************************************************************************/

/******************************************************************************
 *
 *  SSSS   AAA   M   M  PPPP   L      EEEEE  RRRR           AAA    CCCC  TTTTT
 * S      A   A  MM MM  P   P  L      E      R   R         A   A  C        T
 *  SSS   AAAAA  M M M  PPPP   L      EEE    RRRR  ======= AAAAA  C        T
 *     S  A   A  M   M  P      L      E      R  R          A   A  C        T
 * SSSS   A   A  M   M  P      LLLLL  EEEEE  R   R         A   A   CCCC    T
 *
 *****************************************************************************/

/******************************************************************************
 * SAMPLER-ACTUATOR BOARD
 *****************************************************************************/

/******************************************************************************
 * Identifiers:
 * ID=ID_PLANT-->Sensor to Controller message
 * ID=ID_PLANT+1-->Controller to Actuator message
 * ID=ID_PLANT+2-->Reference update
 *****************************************************************************/
#include "ee.h"
#include "cpu/pic30/inc/ee_irqstub.h"
#include "setup.h"
#include "uart_dma.h"
//#include "e_can1.h"


_FOSCSEL(FNOSC_PRIPLL);	// Primary (XT, HS, EC) Oscillator with PLL
_FOSC(OSCIOFNC_ON & POSCMD_XT); // OSC2 Pin Function: OSC2 is Clock Output
								// Primary Oscillator Mode: XT Crystal
_FWDT(FWDTEN_OFF);		// Watchdog Timer Enabled/disabled by user software
_FGS(GCP_OFF);			// Disable Code Protection

static float v_max=3.3;  //dsPIC voltage reference
static float offset=0.0;//0.06;//OPAMP offset

static float r=-0.5;
static float x[3]={0,0,0};
static float u=0;

/******** TODO Controller gains and tracking matrices ********/
/* static float Nu =??;
static float Nx[2] ={?,?};
static float k[2]={?,?}; */

/* Read RCRC circuit output voltages */
void Read_State(void)
{
	AD1CHS0 = 22; 		   // Input ADC channel selection
	AD1CON1bits.SAMP = 1;  // Start conversion
	while(!IFS0bits.AD1IF);// Wait till the EOC
	IFS0bits.AD1IF = 0;    // Reset ADC interrupt flag
	x[0]=(ADC1BUF0*v_max/4096)-v_max/2-offset;// Acquire data and scale

	AD1CHS0 = 23; 		   // Input ADC channel selection
	AD1CON1bits.SAMP = 1;  // Start conversion
	while(!IFS0bits.AD1IF);// Wait till the EOC
	IFS0bits.AD1IF = 0;    // Reset ADC interrupt flag
	x[1]=(ADC1BUF0*v_max/4096)-v_max/2-offset;// Acquire data and scale
}

/* Send data using the UART port 1 via RS-232 to the PC
 * Note: This Task takes less than 0.0002 seconds */

TASK(TaskSupervision)
{
	static unsigned char *p_r = (unsigned char *)&r;
	static unsigned char *p_x0= (unsigned char *)&x[0];
	static unsigned char *p_x1= (unsigned char *)&x[1];
	static unsigned char *p_u = (unsigned char *)&u;

	static unsigned long sys_time=0;

	LATBbits.LATB10 = 1; //To get time with the oscilloscope

	sys_time=GetTime();  //Get system time (EDF Scheduler)

	Read_State();        //Before sending state, read it

	OutBuffer[0]=0x01;//header;
	OutBuffer[1]=(unsigned char)(sys_time>>24);//4th byte of unsigned long
	OutBuffer[2]=(unsigned char)(sys_time>>16);//3rd byte of unsigned long
	OutBuffer[3]=(unsigned char)(sys_time>>8); //2nd byte of unsigned long
	OutBuffer[4]=(unsigned char)sys_time;      //1st byte of unsigned long
	OutBuffer[5]=*p_r;    //4th byte of float (32bits)
	OutBuffer[6]=*(p_r+1);//3rd byte of float (32bits)
	OutBuffer[7]=*(p_r+2);//2nd byte of float (32bits)
	OutBuffer[8]=*(p_r+3);//1st byte of float (32bits)
	OutBuffer[9]=*p_x0;
	OutBuffer[10]=*(p_x0+1);
	OutBuffer[11]=*(p_x0+2);
	OutBuffer[12]=*(p_x0+3);
	OutBuffer[13]=*p_x1;
	OutBuffer[14]=*(p_x1+1);
	OutBuffer[15]=*(p_x1+2);
	OutBuffer[16]=*(p_x1+3);
	OutBuffer[17]=*p_u;
	OutBuffer[18]=*(p_u+1);
	OutBuffer[19]=*(p_u+2);
	OutBuffer[20]=*(p_u+3);

	//Force sending data
	DMA4CONbits.CHEN  = 1;			// Re-enable DMA4 Channel
	DMA4REQbits.FORCE = 1;			// Manual mode: Kick-start the first transfer

	LATBbits.LATB10 = 0; //To get time with the oscilloscope
}

/* Change the reference value between -0.5 and 0.5V*/
TASK(TaskReferenceChange)
{
	if (r == -0.5)
	{
		r=0.5;
		LATBbits.LATB14 = 1;//Orange led switch on
	}else{
		r=-0.5;
		LATBbits.LATB14 = 0;//Orange led switch off
	}


}


/* Controller Task */
static float z=0;
static float uf=0;
static float K[3]={0.2297,-0.9001 ,0.2691};
TASK(TaskController)
{
		Read_State();
		//Controller
		uf=(K[0]*(r-x[0])- K[1]*x[1]-K[2]*x[2]); // En lazo cerrado.

		/* Check for saturation */
		if (uf>v_max/2) uf=v_max/2;
		if (uf<-v_max/2) uf=-v_max/2;
		x[2]=uf;

}

TASK(TaskActuator)
{
		//Last Control Lae
		u=uf;
		PDC1=((u)/v_max)*0x7fff+0x3FFF;
}

/* main function, only to initialize software and hardware,
 * fire alarms, and implement background activities */
int main(void)
{
	Sys_init();//Initialize clock, devices and periphericals
    SetRelAlarm(AlarmReferenceChange,1000,1000);
	SetRelAlarm(AlarmController,1000,50);//Sensor activates every 50ms
	SetRelAlarm(AlarmActuator,1030,50);
	SetRelAlarm(AlarmSupervision, 1000, 10);//Data is sent to the PC every 10ms


	/* Forever loop: background activities (if any) should go here */
	for (;;);

	return 0;
}

