
send_request_si30(ep_device_list[i].Num_equipment);
send_request_modbus_device(ep_device_list[i].Num_equipment, 
               ep_device_list[i].special, ep_device_list[i].pnu_list[j]);
get_word_modbus_device(ep_device_list[i].Num_equipment, 
                ep_device_list[i].special, (sensor_data+p_sensor_data));  
                
void add_CRC_normal(char * frame, char lenth)
{
unsigned char i,j;
unsigned int CRC=0xffff;
for(i=0;i<lenth;i++)
 {
 CRC^=*(frame+i);
 for(j=0;j<8;j++)
  {
  if(CRC&1)
    {
    CRC>>=1;
    CRC^=0xa001;
    }
  else  CRC>>=1;
  }//for(j=0;j<8;j++)
 }//for(i=0;i<6;i++)
frame[lenth]=CRC;
frame[lenth+1]=CRC>>8;
return;
}                
                
char check_CRC_normal(char * frame, char len)
{
unsigned char i,j;
unsigned int CRC=0xffff;
for(i=0;i<len;i++)
 {
 CRC^=*(frame+i);
 for(j=0;j<8;j++)
  {
  if(CRC&1)
    {
    CRC>>=1;
    CRC^=0xa001;
    }
  else  CRC>>=1;
  }//for(j=0;j<8;j++)
 }//for(i=0;i<6;i++)
if(CRC) return 1;
return 0;
}

void send_request_modbus_device(char device, char setting, unsigned int pnu)
{
char i;
char frame[8];
//if(setting&0x80) return;
frame[0]=device;
frame[1]=0x03;
frame[2]=pnu>>8;
frame[3]=pnu;
frame[4]=0;
frame[5]=1;
if(setting&1) add_CRC_reverse(frame,6);
else add_CRC_normal(frame,6);
for(i=0;i<8;i++) putchar_modbus(frame[i]);
}

void send_request_si30(char device)
{
char i;
char frame[8];
frame[0]=device;
frame[1]=0x04;
frame[2]=0x00;
frame[3]=0x02;
frame[4]=0x00;
frame[5]=0x02;
add_CRC_normal(frame,6);
for(i=0; i<8; i++) putchar_modbus(frame[i]);
}