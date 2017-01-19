
//----------------------------------------------------------------
// uart1.c

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

//-------------------------------------------------------------------------------
//eeprom.c

#define max_num_modbus_devices 7
#define max_pnu_code_to_read 5
typedef eeprom struct
  {  
  unsigned char     Num_equipment;
  unsigned char     special; // 1 = reverse CRC  (old akron)
                             // 2 = high byte first (DD)
                             // 3 = new akron
                             // bit 7 = controller's data
  unsigned int      max_time2answer; //msec
  unsigned int      pnu_list[max_pnu_code_to_read];
  } modbus_codes_struct;
  
 // #elif Set_of_equipment==16
// ��� ����. ����� � 1 ��������� � 1-� ��������� ���������
eeprom char num_modbus_devices = 3;
  // ������� ����� � ������ - ������ � ����������� !!!
  // ��� ����� ����� ���� � �� �������
eeprom modbus_codes_struct ep_device_list[max_num_modbus_devices]=
{{ 1,0x80,    0,  3, 4, 0xffff, 0xffff, 0xffff},          // ���������� 
 { 2,0x02,  100,  2, 0xffff, 0xffff, 0xffff, 0xffff},  // ������ �������� 
 { 3,0x05,  150,  2, 3, 0xffff, 0xffff, 0xffff}};      // ������� ���������
 // {3, 0x05, 150, 0xC173, 0x8FC2, 0xE69C, 0xffff, 0xffff};     // ������� ��������� ��8
 
 //-------------------------------------------------------------------
 //function.c
 void get_modbus_data(void)
{
char i, j, k;
unsigned int tt;
// ������ � ������ ����� ����� ������ � ��������
*(sensor_data) = size_of_data_frame();
p_sensor_data = 1;
// ������ � ������ ���� � �����
#asm("cli")
tt = present_time.month;
tt <<= 8;
tt += (year - 2000);
*(sensor_data+p_sensor_data) = tt;
p_sensor_data++;
tt = present_time.hour;
tt <<= 8;
tt += present_time.date;
*(sensor_data+p_sensor_data) = tt;
p_sensor_data++;
tt = present_time.second;
tt <<= 8;
tt += present_time.minut;
*(sensor_data+p_sensor_data) = tt;
p_sensor_data++;
#asm("sei")
// �������� ���������� ������� modbus ����
for(i=0; i<num_modbus_devices; i++)
  {
  for(j=0; j<max_pnu_code_to_read ; j++)
    {
    if(ep_device_list[i].pnu_list[j]!=0xffff)
      {
      if(ep_device_list[i].special & 0x80) 
        {        
        *(sensor_data+p_sensor_data) = controller_data[ep_device_list[i].pnu_list[j]];
        p_sensor_data++;
        continue;
        }
      k = Max_try_to_read_modbus_word;
      do{ 
        // �������� ����� ������� ���������� � ��������� ������� ��� ������
        if( i==2 ) delay_ms(150);
        // ������� ����� ������ ������ ������
        rx_rd_index0 = rx_wr_index0;
        rx_counter0 = 0;
        if((ep_device_list[i].special == 0x03) || (ep_device_list[i].special == 0x04))
          {
          send_request_new_akron(ep_device_list[i].Num_equipment);
          }
        else
          {
          if(ep_device_list[i].special == 0x05)
            {
            send_request_si30(ep_device_list[i].Num_equipment);
            }
          else
            {
            send_request_modbus_device(ep_device_list[i].Num_equipment, 
               ep_device_list[i].special, ep_device_list[i].pnu_list[j]);
            }
          }
        delay_ms_or_modbus_frame(ep_device_list[i].max_time2answer);
        k --;
        }
      while( (get_word_modbus_device(ep_device_list[i].Num_equipment, 
                ep_device_list[i].special, (sensor_data+p_sensor_data))) 
             && (k) );
      #asm("wdr");      
      if(!k) *(sensor_data+p_sensor_data) = 0;
      if((ep_device_list[i].special == 0x03) || (ep_device_list[i].special == 0x05))
        {
        p_sensor_data += 2;
        break;
        }
      if(ep_device_list[i].special == 0x04 )
        {
        p_sensor_data += 4;
        break;        
        }
      else p_sensor_data++;
      }
    else break;
    }
  }
}