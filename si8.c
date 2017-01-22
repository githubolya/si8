/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12.10.2010
Author  : NeVaDa
Company : 
Comments: 


Chip type               : ATmega64
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega64.h>
#include <bcd.h>
#include <math.h>
#include <string.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0<256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;





#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0];
if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif


// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0]=data;
   if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      };
   };
}

 //////////////---------------------------------------------------

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0<256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif



#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0]=c;
   if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif 
 
 
// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0];
   if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
   };
}



// Standard Input/Output functions
#include <stdio.h>

// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
// Place your code here
 OCR1A=OCR1A+0xFA;
}




//------------------------------------------------------------------------------------
// Declare your global variables here



void add_CRC_si8(char * frame, char lenth)
{
unsigned char i,j;
unsigned int CRC=0x0000;        
char fr;
for(i=0;i<lenth;i++)
 {fr=frame[i];
  for( j=0; j<8; j++,fr<<=1 )
     {
      if( (fr^(CRC>>8))&0x80 )          
        {
        CRC<<=1;         
        CRC^=0x8F57;
        }
      else CRC<<=1;     
     }
 }
frame[lenth]=CRC>>8;
frame[lenth+1]=CRC;
return;
}
 
char check_CRC_si8(char * frame, char len) //  len - ����� ��� ����������� �����
{
unsigned char i,j;
unsigned int CRC=0x0000;        
char fr;
for(i=0;i<len;i++)
 {fr=frame[i];
  for( j=0; j<8; j++,fr<<=1 )
     {
       if( (fr^(CRC>>8))&0x80 )          
         {
         CRC<<=1;         
         CRC^=0x8F57;
         }
       else {CRC<<=1;};     
     }
 }  
 if(frame[len]==(CRC>>8))
   { if (frame[len+1]==(CRC&0x00ff))  
        {return 0;}  
     else {return 1;};   
   }    
 else {return 1;};
}

void get_request_ascii_si8(char * frame_ascii, char * frame, char lenth)
{ unsigned char i;
  char tetrada_up, tetrada_low;  
  for(i=0;i<lenth;i++)
   { tetrada_up=(*(frame+i))&0xF0; 
     tetrada_up>>=4; 
     tetrada_low=(*(frame+i))&0x0F;
     
     switch (tetrada_up) 
     {case 0x0: frame_ascii[i*2]='G';
       break;
      case 0x1: frame_ascii[i*2]='H';
       break;
      case 0x2: frame_ascii[i*2]='I';
       break;
      case 0x3: frame_ascii[i*2]='J';
       break;
      case 0x4: frame_ascii[i*2]='K';
       break;
      case 0x5: frame_ascii[i*2]='L';
       break;
      case 0x6: frame_ascii[i*2]='M';
       break; 
      case 0x7: frame_ascii[i*2]='N';
       break;
      case 0x8: frame_ascii[i*2]='O';
       break;
      case 0x9: frame_ascii[i*2]='P';
       break;
      case 0xA: frame_ascii[i*2]='Q';
       break;
      case 0xB: frame_ascii[i*2]='R';
       break;                       
      case 0xC: frame_ascii[i*2]='S';
       break;
      case 0xD: frame_ascii[i*2]='T';
       break; 
      case 0xE: frame_ascii[i*2]='U';
       break;  
      case 0xF: frame_ascii[i*2]='V';
       break;
      default: break;
     };
       
     
      switch (tetrada_low) 
     {case 0x0:  frame_ascii[i*2+1]='G';
       break;
      case 0x1:  frame_ascii[i*2+1]='H';
       break;
      case 0x2:  frame_ascii[i*2+1]='I';
       break;
      case 0x3:  frame_ascii[i*2+1]='J';
       break;
      case 0x4:  frame_ascii[i*2+1]='K';
       break;
      case 0x5:  frame_ascii[i*2+1]='L';
       break;
      case 0x6:  frame_ascii[i*2+1]='M';
       break; 
      case 0x7:  frame_ascii[i*2+1]='N';
       break;
      case 0x8:  frame_ascii[i*2+1]='O';
       break;
      case 0x9:  frame_ascii[i*2+1]='P';
       break;
      case 0xA:  frame_ascii[i*2+1]='Q';
       break;
      case 0xB:  frame_ascii[i*2+1]='R';
       break;
      case 0xC:  frame_ascii[i*2+1]='S';
       break;
      case 0xD:  frame_ascii[i*2+1]='T';
       break; 
      case 0xE:  frame_ascii[i*2+1]='U';
       break;  
      case 0xF:  frame_ascii[i*2+1]='V';
       break; 
      default: break;
     };    
   }
}

char check_dev_adr_si8(char * frame, char device)
{ if(frame[0]!=device) {return 1;}
  else{ return 0;};
}

void send_request_si8(char device, unsigned int pnu)
{
char i;
char frame[6], frame_ascii[12];
frame[0]=device;
frame[1]=0x10;
frame[2]=pnu>>8;;
frame[3]=pnu;
add_CRC_si8(frame,4);
get_request_ascii_si8(frame_ascii,frame,6);
//putchar_modbus('#');
//for(i=0; i<12; i++) putchar_modbus(frame_ascii[i]);
//putchar_modbus(0x0D);
}

char hex_tetrada_from_ascii_char( char ascii_char)
{
  switch (ascii_char) 
     {
      case 'G':  return 0x00;
       break;
      case 'H':  return 0x01;
       break;
      case 'I':  return 0x02;
       break;
      case 'J':  return 0x03;
       break;
      case 'K':  return 0x04;
       break;
      case 'L':  return 0x05;
       break;
      case 'M':  return 0x06;
       break; 
      case 'N':  return 0x07;
       break;
      case 'O':  return 0x08;
       break;
      case 'P':  return 0x09;
       break;
      case 'Q':  return 0x0A;
       break;
      case 'R':  return 0x0B;
       break;
      case 'S':  return 0x0C;
       break;
      case 'T':  return 0x0D;
       break; 
      case 'U':  return 0x0E;
       break;  
      case 'V':  return 0x0F;
       break; 
      default: break;
     };   
}

char get_hex_from_ascii_input(char * frame_in, char lenth_frame_in) 
{  //char *frame_in='#', '�����', '������','hash-���','������','�����','CR';
   //maxsize(frame_in)= 46 ����  
char i,j;
j=0;     
while (lenth_frame_in) 
    { if((*(frame_in+j))==0x23 ) 
          { if (lenth_frame_in>46) {return 1;};              // <( (46-2)/2=22 )  
            for(i=0; i<lenth_frame_in ; i++)
               { *(frame_in+i)=*(frame_in+j+i);
               };
            break; 
          }
          else {j++;
                lenth_frame_in--;
               };
    };

 
for (i=0; i*2<(lenth_frame_in-2); i++)                       // i<( (46-2)/2=22 )
     { if( ((*(frame_in+i*2+1))==0x0D)||((*(frame_in+i*2+2))==0x0D) ) //=='CR'
          { break;
          }
       else{
           *(frame_in+i)=hex_tetrada_from_ascii_char(*(frame_in+i*2+1));
           *(frame_in+i)<<=4;
           *(frame_in+i)+=hex_tetrada_from_ascii_char(*(frame_in+i*2+2)); 
           };
     };  
return 0; 
}

char get_bin_from_bcd(char * frame_in, char data_size)
{  
   unsigned long int data_d;
   char work_tetra;
   char * batte;                 
   data_d=0;  
   if((data_size)>0){ data_d+= (unsigned long int) bcd2bin( *(frame_in+data_size+4-1) ); };
   if((data_size)>1){ data_d+= (unsigned long int) 100*bcd2bin( *(frame_in+data_size+4-2) ); };
   if((data_size)>2){ data_d+= (unsigned long int) 10000*bcd2bin( *(frame_in+data_size+4-3) ); };
   if((data_size)>3){ 
                      work_tetra=(*(frame_in+data_size+4-4))&0xF0;
                      (*(frame_in+data_size+4-4))&=0x0F;
                      data_d+= (unsigned long int) 1000000*bcd2bin( *(frame_in+data_size+4-4) );   
                    };
   batte=(char *) &data_d;
   if((data_size)>0) { *(frame_in+data_size+4-1)=*(batte); };
   if((data_size)>1) { *(frame_in+data_size+4-2)=*(batte+1);};
   if((data_size)>2) { *(frame_in+data_size+4-3)=*(batte+2); };
   if((data_size)>3) { *(frame_in+data_size+4-4)=*(batte+3); };    
   
   return  work_tetra;
}

void get_bin_from_bcd_to_time(char * frame_in, char data_size)
{ unsigned long int data_d;
   char * batte;
   if( (data_size)>2 )
           { *(frame_in+data_size+4-4)=bcd2bin( *(frame_in+data_size+4-4) );};  //min   
   data_d=0;       
   
   if((data_size)>3) { data_d+= (unsigned long int) bcd2bin( *(frame_in+data_size+4-5) ); };   
   if((data_size)>4) { data_d+= (unsigned long int) 100*bcd2bin( *(frame_in+data_size+4-6) ); };   
   if((data_size)>5) { data_d+= (unsigned long int) 10000*bcd2bin( *(frame_in+data_size+4-7) ); };   
  
   batte=(char *) &data_d;
   if((data_size-1)>3) { *(frame_in+data_size+4-5)=*(batte);};
   if((data_size-1)>4) { *(frame_in+data_size+4-6)=*(batte+1);};
   if((data_size-1)>5) { *(frame_in+data_size+4-7)=*(batte+2);};
}

char get_data_if_volum_or_flowrate(unsigned int *data, char * frame_in)
{  // ���� ��������� ������ ��� �������
unsigned int *batte;
char ii, jj;
float for_data; 
unsigned long int for_data_int;   
char data_size=(*(frame_in+1))&0x0F;
char work_tetrada;
work_tetrada=get_bin_from_bcd(frame_in, data_size); 

if( (work_tetrada & 0x80)==0 ) 
    { if( (work_tetrada & 0x70)==0 ) 
        { // ����� ������������� ����� 
         for(ii=0, jj=0; (ii<(data_size))&&(jj<2); ii++, jj++)  //������� ������ ������
            {  *(data+jj)=0x0000;
               *(data+jj)= frame_in[data_size+4-ii-1];  
               ii++;
               if(ii<(data_size))
                 { *(data+jj)+=( ((unsigned int)frame_in[data_size+4-ii-1])<<8 );  //!!!!!!!!!!!!!!!!! 
                 };
            };
            return 0;           
        }  
        else {// �� ����� �����
               for_data=0;  
               for_data=(*(frame_in+data_size+4-4));   
               for_data*=256; 
               for_data+=(*(frame_in+data_size+4-3)); 
               for(ii=0, jj=0; (ii<(data_size-2))&&(jj<2); ii++, jj++)
                  {
                   for_data*=256; 
                   for_data+=( *(frame_in+data_size+4-2+jj) );
                  };
               for_data*=pow(10,-( (float) ( (work_tetrada)&(0x70))/16 )); 
               if((*(frame_in+2)==0xC1)&&(*(frame_in+3)==0x73) )
                    { // ���� ��������� ������
                     for_data_int=(unsigned long int)for_data;  // ��������� �� ������ 
                     batte=(unsigned int *) &for_data_int;  
                     *(data)=*(batte);    // ������� ������ 
                     *(data+1)=*(batte+1);   
                     return 0; 
                    };
               if( (*(frame_in+2)==0x8F)&&(*(frame_in+3)==0xC2) )
                    { // ���� ��������� �������  
                      batte=(unsigned int *) &for_data;  
                      *(data)=*(batte);    // ������� ������ 
                      *(data+1)=*(batte+1);   
                      return 0;
                    };
             }; 
    }
    else {//������������� �����
       for( jj=0;jj<2; jj++)  //������� ������ ������
            {  *(data+jj)=0x0000;}; 
       return 2;
       }; 
}


char get_data_if_time(unsigned int *data, char * frame_in)
{ // ���� ��������� ������� ���������
unsigned int *batte;   
unsigned long int time_min;  
char data_size=(*(frame_in+1))&0x0F;

 if ( ( (*(frame_in+data_size+4-1))&0x0F )==0x00)   // ����� ����������� � �������
    { 
     get_bin_from_bcd_to_time(frame_in, data_size);
     time_min=0;   
//     time_min+=( (*(frame_in+4))&0x0F ); //��������� ���� (2,5 �����)
     time_min+=( *(frame_in+4)); //��������� ���� (3 �����)
     time_min<<=8;   
     time_min+=*(frame_in+5);
     time_min<<=8;
     time_min+=*(frame_in+6); 
     time_min*=60;
     time_min+=*(frame_in+7); // ���������� ������  
     batte=(unsigned int *) &time_min;
                               
     *(data)=*(batte);       //!!!!!!!!!!!!!!!!!!
     *(data+1)=*(batte+1);    // ������� ������ 
     return 0;
     }
  else {return 7;}; // ������ ���� ������� 
}

char get_word_si8(unsigned int *data, char * frame_in)
{ //data -������ 2 �����(4 �����)
  if( (*(frame_in+4)&0xF0)==0xF0 )
  { 
        //delay_ms( 1000 ); 
        return 5;  // �������������� ��������
  }      
  else{ 
      if( ((*(frame_in+2)==0xC1)&&(*(frame_in+3)==0x73))||((*(frame_in+2)==0x8F)&&(*(frame_in+3)==0xC2)) )  
        { // ����� ��� ������   
          return get_data_if_volum_or_flowrate(data, frame_in);       
        }
      else { 
            if( ((*(frame_in+2)==0xE6)&&(*(frame_in+3)==0x9C)) )    // ����� 
               { // ����� 
                 return get_data_if_time(data, frame_in);    
               }
            else 
            {
            //delay_ms( 1000 );
              return 6;
            }; // ������� ������.   
           };  
      };         
     
return 0;
}

void main(void)
{
// Declare your local variables here
//char  frame_in[24]={'#', 'G', 'K', 'G', 'L', 'S', 'H', 'N', 'J', 
//                    'H', 'G','G', 'G', 'G', 'G', 'G', 'K', 'H', 'N',
//                   'J', 'J', 'O', 'I', 0x0D}; 
//char lenth_frame_in=24;
unsigned int data[2];
//char  frame_in[28]={'#', 0x47, 0x4A, 0x47, 0x4E, 0x55, 0x4D, 0x50, 0x53,
//                    0x47, 0x47, 0x47, 0x47, 0x47, 0x4B, 0x4C, 0x48, 0x49, 0x4D, 0x4C, 0x4F, 0x4B, 0x47, 
//                    0x48, 0x56, 0x55, 0x50, 0x0D };       
//
//char lenth_frame_in=28;

char  frame_in[22]={ 0x23, 0x47, 0x4A, 0x47, 0x4B, 0x53, 0x48, 0x4E, 0x4A, 
                     0x48, 0x48, 0x4A, 0x4D, 0x4F, 0x50, 0x48, 0x4F, 
                     0x4C, 0x4D, 0x53, 0x54, 0x0D };   
char lenth_frame_in=22;                     
//                           
//char  frame_in[28]={ 0x23, 0x47, 0x4A, 0x47, 0x4E, 0x55, 0x4D, 0x50, 0x53, 
//                     0x50, 0x49, 0x4A, 0x4B, 0x4B, 0x4F, 0x4B, 0x50, 0x4A, 0x4C, 0x4E, 0x48, 0x4B, 0x47,
//                     0x52, 0x51, 0x4C, 0x4D, 0x0D}; 
//char lenth_frame_in=28;


// ---------- ��� ������� --------------------------------------------

//unsigned int pnu_list[5]={0xC173, 0x8FC2, 0xE69C, 0xffff, 0xffff};  

//------------------------------------------------------------------------------

                   
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250,000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x04;
TCNT0=0x00;
OCR0=0xFA;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer3 Stopped
// Mode: Normal top=FFFFh
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: Off
// INT5: Off
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x00;
EIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;
ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 2 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0xD8;
UCSR0C=0x0E;
UBRR0H=0x00;
UBRR0L=0x67;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Global enable interrupts
#asm("sei")

get_hex_from_ascii_input(frame_in, lenth_frame_in);

//get_data_if_volum_or_flowrate( data,  frame_in);

//get_data_if_time(data, frame_in);

get_word_si8(data, frame_in);

while (1)
      {
      // Place your code here

      };
}
