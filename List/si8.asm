
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _tx_wr_index0=R6
	.DEF _tx_rd_index0=R9
	.DEF _tx_counter0=R8

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0xB0:
	.DB  0x23,0x47,0x4A,0x47,0x4B,0x53,0x48,0x4E
	.DB  0x4A,0x48,0x48,0x4A,0x4D,0x4F,0x50,0x48
	.DB  0x4F,0x4C,0x4D,0x53,0x54,0xD
_0x208005F:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x208005F*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12.10.2010
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega64
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <bcd.h>
;#include <math.h>
;#include <string.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0<256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;
;
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0055 {

	.CSEG
; 0000 0056 char data;
; 0000 0057 while (rx_counter0==0);
;	data -> R17
; 0000 0058 data=rx_buffer0[rx_rd_index0];
; 0000 0059 if (++rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 005A #asm("cli")
; 0000 005B --rx_counter0;
; 0000 005C #asm("sei")
; 0000 005D return data;
; 0000 005E }
;#pragma used-
;#endif
;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0065 {
_usart0_rx_isr:
	CALL SUBOPT_0x0
; 0000 0066 char status,data;
; 0000 0067 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0068 data=UDR0;
	IN   R16,12
; 0000 0069 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x7
; 0000 006A    {
; 0000 006B    rx_buffer0[rx_wr_index0]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 006C    if (++rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x8
	CLR  R5
; 0000 006D    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x8:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x9
; 0000 006E       {
; 0000 006F       rx_counter0=0;
	CLR  R7
; 0000 0070       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0071       };
_0x9:
; 0000 0072    };
_0x7:
; 0000 0073 }
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0xB5
;
; //////////////---------------------------------------------------
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0<256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0088 {
; 0000 0089 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
; 0000 008A #asm("cli")
; 0000 008B if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 008C    {
; 0000 008D    tx_buffer0[tx_wr_index0]=c;
; 0000 008E    if (++tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 008F    ++tx_counter0;
; 0000 0090    }
; 0000 0091 else
; 0000 0092    UDR0=c;
; 0000 0093 #asm("sei")
; 0000 0094 }
;#pragma used-
;#endif
;
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 009B {
_usart0_tx_isr:
	CALL SUBOPT_0x0
; 0000 009C if (tx_counter0)
	TST  R8
	BREQ _0x12
; 0000 009D    {
; 0000 009E    --tx_counter0;
	DEC  R8
; 0000 009F    UDR0=tx_buffer0[tx_rd_index0];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00A0    if (++tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x13
	CLR  R9
; 0000 00A1    };
_0x13:
_0x12:
; 0000 00A2 }
	RJMP _0xB5
;
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 00AB {
_timer0_comp_isr:
	CALL SUBOPT_0x0
; 0000 00AC // Place your code here
; 0000 00AD  OCR1A=OCR1A+0xFA;
	IN   R30,0x2A
	IN   R31,0x2A+1
	SUBI R30,LOW(-250)
	SBCI R31,HIGH(-250)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00AE }
_0xB5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;
;
;//------------------------------------------------------------------------------------
;// Declare your global variables here
;
;
;
;void add_CRC_si8(char * frame, char lenth)
; 0000 00B9 {
; 0000 00BA unsigned char i,j;
; 0000 00BB unsigned int CRC=0x0000;
; 0000 00BC char fr;
; 0000 00BD for(i=0;i<lenth;i++)
;	*frame -> Y+7
;	lenth -> Y+6
;	i -> R17
;	j -> R16
;	CRC -> R18,R19
;	fr -> R21
; 0000 00BE  {fr=frame[i];
; 0000 00BF   for( j=0; j<8; j++,fr<<=1 )
; 0000 00C0      {
; 0000 00C1       if( (fr^(CRC>>8))&0x80 )
; 0000 00C2         {
; 0000 00C3         CRC<<=1;
; 0000 00C4         CRC^=0x8F57;
; 0000 00C5         }
; 0000 00C6       else CRC<<=1;
; 0000 00C7      }
; 0000 00C8  }
; 0000 00C9 frame[lenth]=CRC>>8;
; 0000 00CA frame[lenth+1]=CRC;
; 0000 00CB return;
; 0000 00CC }
;
;char check_CRC_si8(char * frame, char len) //  len - длина без контрольной суммы
; 0000 00CF {
; 0000 00D0 unsigned char i,j;
; 0000 00D1 unsigned int CRC=0x0000;
; 0000 00D2 char fr;
; 0000 00D3 for(i=0;i<len;i++)
;	*frame -> Y+7
;	len -> Y+6
;	i -> R17
;	j -> R16
;	CRC -> R18,R19
;	fr -> R21
; 0000 00D4  {fr=frame[i];
; 0000 00D5   for( j=0; j<8; j++,fr<<=1 )
; 0000 00D6      {
; 0000 00D7        if( (fr^(CRC>>8))&0x80 )
; 0000 00D8          {
; 0000 00D9          CRC<<=1;
; 0000 00DA          CRC^=0x8F57;
; 0000 00DB          }
; 0000 00DC        else {CRC<<=1;};
; 0000 00DD      }
; 0000 00DE  }
; 0000 00DF  if(frame[len]==(CRC>>8))
; 0000 00E0    { if (frame[len+1]==(CRC&0x00ff))
; 0000 00E1         {return 0;}
; 0000 00E2      else {return 1;};
; 0000 00E3    }
; 0000 00E4  else {return 1;};
; 0000 00E5 }
;
;void get_request_ascii_si8(char * frame_ascii, char * frame, char lenth)
; 0000 00E8 { unsigned char i;
; 0000 00E9   char tetrada_up, tetrada_low;
; 0000 00EA   for(i=0;i<lenth;i++)
;	*frame_ascii -> Y+7
;	*frame -> Y+5
;	lenth -> Y+4
;	i -> R17
;	tetrada_up -> R16
;	tetrada_low -> R19
; 0000 00EB    { tetrada_up=(*(frame+i))&0xF0;
; 0000 00EC      tetrada_up>>=4;
; 0000 00ED      tetrada_low=(*(frame+i))&0x0F;
; 0000 00EE 
; 0000 00EF      switch (tetrada_up)
; 0000 00F0      {case 0x0: frame_ascii[i*2]='G';
; 0000 00F1        break;
; 0000 00F2       case 0x1: frame_ascii[i*2]='H';
; 0000 00F3        break;
; 0000 00F4       case 0x2: frame_ascii[i*2]='I';
; 0000 00F5        break;
; 0000 00F6       case 0x3: frame_ascii[i*2]='J';
; 0000 00F7        break;
; 0000 00F8       case 0x4: frame_ascii[i*2]='K';
; 0000 00F9        break;
; 0000 00FA       case 0x5: frame_ascii[i*2]='L';
; 0000 00FB        break;
; 0000 00FC       case 0x6: frame_ascii[i*2]='M';
; 0000 00FD        break;
; 0000 00FE       case 0x7: frame_ascii[i*2]='N';
; 0000 00FF        break;
; 0000 0100       case 0x8: frame_ascii[i*2]='O';
; 0000 0101        break;
; 0000 0102       case 0x9: frame_ascii[i*2]='P';
; 0000 0103        break;
; 0000 0104       case 0xA: frame_ascii[i*2]='Q';
; 0000 0105        break;
; 0000 0106       case 0xB: frame_ascii[i*2]='R';
; 0000 0107        break;
; 0000 0108       case 0xC: frame_ascii[i*2]='S';
; 0000 0109        break;
; 0000 010A       case 0xD: frame_ascii[i*2]='T';
; 0000 010B        break;
; 0000 010C       case 0xE: frame_ascii[i*2]='U';
; 0000 010D        break;
; 0000 010E       case 0xF: frame_ascii[i*2]='V';
; 0000 010F        break;
; 0000 0110       default: break;
; 0000 0111      };
; 0000 0112 
; 0000 0113 
; 0000 0114       switch (tetrada_low)
; 0000 0115      {case 0x0:  frame_ascii[i*2+1]='G';
; 0000 0116        break;
; 0000 0117       case 0x1:  frame_ascii[i*2+1]='H';
; 0000 0118        break;
; 0000 0119       case 0x2:  frame_ascii[i*2+1]='I';
; 0000 011A        break;
; 0000 011B       case 0x3:  frame_ascii[i*2+1]='J';
; 0000 011C        break;
; 0000 011D       case 0x4:  frame_ascii[i*2+1]='K';
; 0000 011E        break;
; 0000 011F       case 0x5:  frame_ascii[i*2+1]='L';
; 0000 0120        break;
; 0000 0121       case 0x6:  frame_ascii[i*2+1]='M';
; 0000 0122        break;
; 0000 0123       case 0x7:  frame_ascii[i*2+1]='N';
; 0000 0124        break;
; 0000 0125       case 0x8:  frame_ascii[i*2+1]='O';
; 0000 0126        break;
; 0000 0127       case 0x9:  frame_ascii[i*2+1]='P';
; 0000 0128        break;
; 0000 0129       case 0xA:  frame_ascii[i*2+1]='Q';
; 0000 012A        break;
; 0000 012B       case 0xB:  frame_ascii[i*2+1]='R';
; 0000 012C        break;
; 0000 012D       case 0xC:  frame_ascii[i*2+1]='S';
; 0000 012E        break;
; 0000 012F       case 0xD:  frame_ascii[i*2+1]='T';
; 0000 0130        break;
; 0000 0131       case 0xE:  frame_ascii[i*2+1]='U';
; 0000 0132        break;
; 0000 0133       case 0xF:  frame_ascii[i*2+1]='V';
; 0000 0134        break;
; 0000 0135       default: break;
; 0000 0136      };
; 0000 0137    }
; 0000 0138 }
;
;char check_dev_adr_si8(char * frame, char device)
; 0000 013B { if(frame[0]!=device) {return 1;}
;	*frame -> Y+1
;	device -> Y+0
; 0000 013C   else{ return 0;};
; 0000 013D }
;
;//void send_request_si8(char device, unsigned int pnu)
;//{
;//char i;
;//char frame[6], frame_ascii[12];
;//frame[0]=device;
;//frame[1]=0x10;
;//frame[2]=pnu>>8;;
;//frame[3]=pnu;
;//add_CRC_si8(frame,4);
;//get_request_ascii_si8(frame_ascii,frame,6);
;//putchar_modbus('#');
;//for(i=0; i<12; i++) putchar_modbus(frame_ascii[i]);
;//putchar_modbus(0x0D);
;//}
;
;char hex_tetrada_from_ascii_char( char ascii_char)
; 0000 014F {
_hex_tetrada_from_ascii_char:
; 0000 0150   switch (ascii_char)
;	ascii_char -> Y+0
	LD   R30,Y
	LDI  R31,0
; 0000 0151      {
; 0000 0152       case 'G':  return 0x00;
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BRNE _0x58
	LDI  R30,LOW(0)
	RJMP _0x20C0007
; 0000 0153        break;
; 0000 0154       case 'H':  return 0x01;
_0x58:
	CPI  R30,LOW(0x48)
	LDI  R26,HIGH(0x48)
	CPC  R31,R26
	BRNE _0x59
	LDI  R30,LOW(1)
	RJMP _0x20C0007
; 0000 0155        break;
; 0000 0156       case 'I':  return 0x02;
_0x59:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BRNE _0x5A
	LDI  R30,LOW(2)
	RJMP _0x20C0007
; 0000 0157        break;
; 0000 0158       case 'J':  return 0x03;
_0x5A:
	CPI  R30,LOW(0x4A)
	LDI  R26,HIGH(0x4A)
	CPC  R31,R26
	BRNE _0x5B
	LDI  R30,LOW(3)
	RJMP _0x20C0007
; 0000 0159        break;
; 0000 015A       case 'K':  return 0x04;
_0x5B:
	CPI  R30,LOW(0x4B)
	LDI  R26,HIGH(0x4B)
	CPC  R31,R26
	BRNE _0x5C
	LDI  R30,LOW(4)
	RJMP _0x20C0007
; 0000 015B        break;
; 0000 015C       case 'L':  return 0x05;
_0x5C:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BRNE _0x5D
	LDI  R30,LOW(5)
	RJMP _0x20C0007
; 0000 015D        break;
; 0000 015E       case 'M':  return 0x06;
_0x5D:
	CPI  R30,LOW(0x4D)
	LDI  R26,HIGH(0x4D)
	CPC  R31,R26
	BRNE _0x5E
	LDI  R30,LOW(6)
	RJMP _0x20C0007
; 0000 015F        break;
; 0000 0160       case 'N':  return 0x07;
_0x5E:
	CPI  R30,LOW(0x4E)
	LDI  R26,HIGH(0x4E)
	CPC  R31,R26
	BRNE _0x5F
	LDI  R30,LOW(7)
	RJMP _0x20C0007
; 0000 0161        break;
; 0000 0162       case 'O':  return 0x08;
_0x5F:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BRNE _0x60
	LDI  R30,LOW(8)
	RJMP _0x20C0007
; 0000 0163        break;
; 0000 0164       case 'P':  return 0x09;
_0x60:
	CPI  R30,LOW(0x50)
	LDI  R26,HIGH(0x50)
	CPC  R31,R26
	BRNE _0x61
	LDI  R30,LOW(9)
	RJMP _0x20C0007
; 0000 0165        break;
; 0000 0166       case 'Q':  return 0x0A;
_0x61:
	CPI  R30,LOW(0x51)
	LDI  R26,HIGH(0x51)
	CPC  R31,R26
	BRNE _0x62
	LDI  R30,LOW(10)
	RJMP _0x20C0007
; 0000 0167        break;
; 0000 0168       case 'R':  return 0x0B;
_0x62:
	CPI  R30,LOW(0x52)
	LDI  R26,HIGH(0x52)
	CPC  R31,R26
	BRNE _0x63
	LDI  R30,LOW(11)
	RJMP _0x20C0007
; 0000 0169        break;
; 0000 016A       case 'S':  return 0x0C;
_0x63:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0x64
	LDI  R30,LOW(12)
	RJMP _0x20C0007
; 0000 016B        break;
; 0000 016C       case 'T':  return 0x0D;
_0x64:
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BRNE _0x65
	LDI  R30,LOW(13)
	RJMP _0x20C0007
; 0000 016D        break;
; 0000 016E       case 'U':  return 0x0E;
_0x65:
	CPI  R30,LOW(0x55)
	LDI  R26,HIGH(0x55)
	CPC  R31,R26
	BRNE _0x66
	LDI  R30,LOW(14)
	RJMP _0x20C0007
; 0000 016F        break;
; 0000 0170       case 'V':  return 0x0F;
_0x66:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BRNE _0x68
	LDI  R30,LOW(15)
; 0000 0171        break;
; 0000 0172       default: break;
_0x68:
; 0000 0173      };
; 0000 0174 }
_0x20C0007:
	ADIW R28,1
	RET
;
;char get_hex_from_ascii_input(char * frame_in, char lenth_frame_in)
; 0000 0177 {  //char *frame_in='#', 'адрес', 'размер','hash-код','данные','сумма','CR';
_get_hex_from_ascii_input:
; 0000 0178    //maxsize(frame_in)= 46 байт
; 0000 0179 char i,j;
; 0000 017A j=0;
	ST   -Y,R17
	ST   -Y,R16
;	*frame_in -> Y+3
;	lenth_frame_in -> Y+2
;	i -> R17
;	j -> R16
	LDI  R16,LOW(0)
; 0000 017B while (lenth_frame_in)
_0x69:
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x6B
; 0000 017C     { if((*(frame_in+j))==0x23 )
	CALL SUBOPT_0x1
	LD   R26,X
	CPI  R26,LOW(0x23)
	BRNE _0x6C
; 0000 017D           { if (lenth_frame_in>46) {return 1;};              // <( (46-2)/2=22 )
	LDD  R26,Y+2
	CPI  R26,LOW(0x2F)
	BRLO _0x6D
	LDI  R30,LOW(1)
	RJMP _0x20C0006
_0x6D:
; 0000 017E             for(i=0; i<lenth_frame_in ; i++)
	LDI  R17,LOW(0)
_0x6F:
	LDD  R30,Y+2
	CP   R17,R30
	BRSH _0x70
; 0000 017F                { *(frame_in+i)=*(frame_in+j+i);
	CALL SUBOPT_0x2
	MOVW R0,R30
	CALL SUBOPT_0x1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0180                };
	SUBI R17,-1
	RJMP _0x6F
_0x70:
; 0000 0181             break;
	RJMP _0x6B
; 0000 0182           }
; 0000 0183           else {j++;
_0x6C:
	SUBI R16,-1
; 0000 0184                 lenth_frame_in--;
	LDD  R30,Y+2
	SUBI R30,LOW(1)
	STD  Y+2,R30
; 0000 0185                };
; 0000 0186     };
	RJMP _0x69
_0x6B:
; 0000 0187 
; 0000 0188 
; 0000 0189 for (i=0; i*2<(lenth_frame_in-2); i++)                       // i<( (46-2)/2=22 )
	LDI  R17,LOW(0)
_0x73:
	LDI  R30,LOW(2)
	MULS R30,R17
	MOVW R30,R0
	MOVW R26,R30
	LDD  R30,Y+2
	LDI  R31,0
	SBIW R30,2
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x74
; 0000 018A      { if( ((*(frame_in+i*2+1))==0x0D)||((*(frame_in+i*2+2))==0x0D) ) //=='CR'
	CALL SUBOPT_0x3
	LDD  R26,Z+1
	CPI  R26,LOW(0xD)
	BREQ _0x76
	LDD  R26,Z+2
	CPI  R26,LOW(0xD)
	BRNE _0x75
_0x76:
; 0000 018B           { break;
	RJMP _0x74
; 0000 018C           }
; 0000 018D        else{
_0x75:
; 0000 018E            *(frame_in+i)=hex_tetrada_from_ascii_char(*(frame_in+i*2+1));
	CALL SUBOPT_0x2
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3
	LDD  R30,Z+1
	ST   -Y,R30
	RCALL _hex_tetrada_from_ascii_char
	POP  R26
	POP  R27
	ST   X,R30
; 0000 018F            *(frame_in+i)<<=4;
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SWAP R30
	ANDI R30,0xF0
	ST   X,R30
; 0000 0190            *(frame_in+i)+=hex_tetrada_from_ascii_char(*(frame_in+i*2+2));
	CALL SUBOPT_0x2
	PUSH R31
	PUSH R30
	LD   R30,Z
	PUSH R30
	CALL SUBOPT_0x3
	LDD  R30,Z+2
	ST   -Y,R30
	RCALL _hex_tetrada_from_ascii_char
	POP  R26
	ADD  R30,R26
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0191            };
; 0000 0192      };
	SUBI R17,-1
	RJMP _0x73
_0x74:
; 0000 0193 return 0;
	LDI  R30,LOW(0)
_0x20C0006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; 0000 0194 }
;
;char get_bin_from_bcd(char * frame_in, char data_size)
; 0000 0197 {
_get_bin_from_bcd:
; 0000 0198    unsigned long int data_d;
; 0000 0199    char work_tetra;
; 0000 019A    char * batte;
; 0000 019B    data_d=0;
	SBIW R28,4
	CALL __SAVELOCR4
;	*frame_in -> Y+9
;	data_size -> Y+8
;	data_d -> Y+4
;	work_tetra -> R17
;	*batte -> R18,R19
	LDI  R30,LOW(0)
	__CLRD1S 4
; 0000 019C    if((data_size)>0){ data_d+= (unsigned long int) bcd2bin( *(frame_in+data_size+4-1) ); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRLO _0x79
	CALL SUBOPT_0x4
	SBIW R30,1
	CALL SUBOPT_0x5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x6
_0x79:
; 0000 019D    if((data_size)>1){ data_d+= (unsigned long int) 100*bcd2bin( *(frame_in+data_size+4-2) ); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x2)
	BRLO _0x7A
	CALL SUBOPT_0x4
	SBIW R30,2
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL SUBOPT_0x6
_0x7A:
; 0000 019E    if((data_size)>2){ data_d+= (unsigned long int) 10000*bcd2bin( *(frame_in+data_size+4-3) ); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRLO _0x7B
	CALL SUBOPT_0x4
	SBIW R30,3
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL SUBOPT_0x6
_0x7B:
; 0000 019F    if((data_size)>3){
	LDD  R26,Y+8
	CPI  R26,LOW(0x4)
	BRLO _0x7C
; 0000 01A0                       work_tetra=(*(frame_in+data_size+4-4))&0xF0;
	CALL SUBOPT_0x4
	SBIW R30,4
	LD   R30,Z
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
; 0000 01A1                       (*(frame_in+data_size+4-4))&=0x0F;
	CALL SUBOPT_0x4
	SBIW R30,4
	MOVW R26,R30
	LD   R30,X
	ANDI R30,LOW(0xF)
	ST   X,R30
; 0000 01A2                       data_d+= (unsigned long int) 1000000*bcd2bin( *(frame_in+data_size+4-4) );
	CALL SUBOPT_0x4
	SBIW R30,4
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	__GETD2N 0xF4240
	CALL __MULD12U
	CALL SUBOPT_0x6
; 0000 01A3                     };
_0x7C:
; 0000 01A4    batte=(char *) &data_d;
	MOVW R30,R28
	ADIW R30,4
	MOVW R18,R30
; 0000 01A5    if((data_size)>0) { *(frame_in+data_size+4-1)=*(batte); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x1)
	BRLO _0x7D
	CALL SUBOPT_0x4
	SBIW R30,1
	MOVW R0,R30
	MOVW R26,R18
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
_0x7D:
; 0000 01A6    if((data_size)>1) { *(frame_in+data_size+4-2)=*(batte+1);};
	LDD  R26,Y+8
	CPI  R26,LOW(0x2)
	BRLO _0x7E
	CALL SUBOPT_0x4
	SBIW R30,2
	MOVW R26,R30
	MOVW R30,R18
	LDD  R30,Z+1
	ST   X,R30
_0x7E:
; 0000 01A7    if((data_size)>2) { *(frame_in+data_size+4-3)=*(batte+2); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x3)
	BRLO _0x7F
	CALL SUBOPT_0x4
	SBIW R30,3
	MOVW R26,R30
	MOVW R30,R18
	LDD  R30,Z+2
	ST   X,R30
_0x7F:
; 0000 01A8    if((data_size)>3) { *(frame_in+data_size+4-4)=*(batte+3); };
	LDD  R26,Y+8
	CPI  R26,LOW(0x4)
	BRLO _0x80
	CALL SUBOPT_0x4
	SBIW R30,4
	MOVW R26,R30
	MOVW R30,R18
	LDD  R30,Z+3
	ST   X,R30
_0x80:
; 0000 01A9 
; 0000 01AA    return  work_tetra;
	MOV  R30,R17
	CALL __LOADLOCR4
	ADIW R28,11
	RET
; 0000 01AB }
;
;void get_bin_from_bcd_to_time(char * frame_in, char data_size)
; 0000 01AE { unsigned long int data_d;
_get_bin_from_bcd_to_time:
; 0000 01AF    char * batte;
; 0000 01B0    if( (data_size)>2 )
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	*frame_in -> Y+7
;	data_size -> Y+6
;	data_d -> Y+2
;	*batte -> R16,R17
	LDD  R26,Y+6
	CPI  R26,LOW(0x3)
	BRLO _0x81
; 0000 01B1            { *(frame_in+data_size+4-4)=bcd2bin( *(frame_in+data_size+4-4) );};  //min
	CALL SUBOPT_0xA
	SBIW R30,4
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X,R30
_0x81:
; 0000 01B2    data_d=0;
	LDI  R30,LOW(0)
	__CLRD1S 2
; 0000 01B3 
; 0000 01B4    if((data_size)>3) { data_d+= (unsigned long int) bcd2bin( *(frame_in+data_size+4-5) ); };
	LDD  R26,Y+6
	CPI  R26,LOW(0x4)
	BRLO _0x82
	CALL SUBOPT_0xA
	SBIW R30,5
	CALL SUBOPT_0x5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xB
_0x82:
; 0000 01B5    if((data_size)>4) { data_d+= (unsigned long int) 100*bcd2bin( *(frame_in+data_size+4-6) ); };
	LDD  R26,Y+6
	CPI  R26,LOW(0x5)
	BRLO _0x83
	CALL SUBOPT_0xA
	SBIW R30,6
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
_0x83:
; 0000 01B6    if((data_size)>5) { data_d+= (unsigned long int) 10000*bcd2bin( *(frame_in+data_size+4-7) ); };
	LDD  R26,Y+6
	CPI  R26,LOW(0x6)
	BRLO _0x84
	CALL SUBOPT_0xA
	SBIW R30,7
	CALL SUBOPT_0x5
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
_0x84:
; 0000 01B7 
; 0000 01B8    batte=(char *) &data_d;
	MOVW R30,R28
	ADIW R30,2
	MOVW R16,R30
; 0000 01B9    if((data_size-1)>3) { *(frame_in+data_size+4-5)=*(batte);};
	CALL SUBOPT_0xC
	SBIW R30,4
	BRLT _0x85
	CALL SUBOPT_0xA
	SBIW R30,5
	MOVW R0,R30
	MOVW R26,R16
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
_0x85:
; 0000 01BA    if((data_size-1)>4) { *(frame_in+data_size+4-6)=*(batte+1);};
	CALL SUBOPT_0xC
	SBIW R30,5
	BRLT _0x86
	CALL SUBOPT_0xA
	SBIW R30,6
	MOVW R26,R30
	MOVW R30,R16
	LDD  R30,Z+1
	ST   X,R30
_0x86:
; 0000 01BB    if((data_size-1)>5) { *(frame_in+data_size+4-7)=*(batte+2);};
	CALL SUBOPT_0xC
	SBIW R30,6
	BRLT _0x87
	CALL SUBOPT_0xA
	SBIW R30,7
	MOVW R26,R30
	MOVW R30,R16
	LDD  R30,Z+2
	ST   X,R30
_0x87:
; 0000 01BC }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,9
	RET
;
;char get_data_if_volum_or_flowrate(unsigned int *data, char * frame_in)
; 0000 01BF {  // если показания объема или расхода
_get_data_if_volum_or_flowrate:
; 0000 01C0 unsigned int *batte;
; 0000 01C1 char ii, jj;
; 0000 01C2 float for_data;
; 0000 01C3 unsigned long int for_data_int;
; 0000 01C4 char data_size=(*(frame_in+1))&0x0F;
; 0000 01C5 char work_tetrada;
; 0000 01C6 work_tetrada=get_bin_from_bcd(frame_in, data_size);
	SBIW R28,8
	CALL __SAVELOCR6
;	*data -> Y+16
;	*frame_in -> Y+14
;	*batte -> R16,R17
;	ii -> R19
;	jj -> R18
;	for_data -> Y+10
;	for_data_int -> Y+6
;	data_size -> R21
;	work_tetrada -> R20
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,1
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOV  R21,R30
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R21
	RCALL _get_bin_from_bcd
	MOV  R20,R30
; 0000 01C7 
; 0000 01C8 if( (work_tetrada & 0x80)==0 )
	SBRC R20,7
	RJMP _0x88
; 0000 01C9     { if( (work_tetrada & 0x70)==0 )
	MOV  R30,R20
	ANDI R30,LOW(0x70)
	BRNE _0x89
; 0000 01CA         { // целое положительное число
; 0000 01CB          for(ii=0, jj=0; (ii<(data_size))&&(jj<2); ii++, jj++)  //младшим байтом вперед
	LDI  R19,LOW(0)
	LDI  R18,LOW(0)
_0x8B:
	CP   R19,R21
	BRSH _0x8D
	CPI  R18,2
	BRLO _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 01CC             {  *(data+jj)=0x0000;
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
; 0000 01CD                *(data+jj)= frame_in[data_size+4-ii-1];
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	CALL SUBOPT_0xF
	MOVW R26,R22
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 01CE                ii++;
	SUBI R19,-1
; 0000 01CF                if(ii<(data_size))
	CP   R19,R21
	BRSH _0x8F
; 0000 01D0                  { *(data+jj)+=( ((unsigned int)frame_in[data_size+4-ii-1])<<8 );  //!!!!!!!!!!!!!!!!!
	CALL SUBOPT_0xD
	ADD  R30,R26
	ADC  R31,R27
	MOVW R24,R30
	LD   R22,Z
	LDD  R23,Z+1
	CALL SUBOPT_0xF
	MOV  R31,R30
	LDI  R30,0
	ADD  R30,R22
	ADC  R31,R23
	MOVW R26,R24
	ST   X+,R30
	ST   X,R31
; 0000 01D1                  };
_0x8F:
; 0000 01D2             };
	SUBI R19,-1
	SUBI R18,-1
	RJMP _0x8B
_0x8C:
; 0000 01D3             return 0;
	LDI  R30,LOW(0)
	RJMP _0x20C0005
; 0000 01D4         }
; 0000 01D5         else {// не целое число
_0x89:
; 0000 01D6                for_data=0;
	LDI  R30,LOW(0)
	__CLRD1S 10
; 0000 01D7                for_data=(*(frame_in+data_size+4-4));
	CALL SUBOPT_0x10
	SBIW R30,4
	LD   R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL SUBOPT_0x11
; 0000 01D8                for_data*=256;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 01D9                for_data+=(*(frame_in+data_size+4-3));
	SBIW R30,3
	LD   R30,Z
	CALL SUBOPT_0x14
; 0000 01DA                for(ii=0, jj=0; (ii<(data_size-2))&&(jj<2); ii++, jj++)
	LDI  R19,LOW(0)
	LDI  R18,LOW(0)
_0x92:
	MOV  R30,R21
	LDI  R31,0
	SBIW R30,2
	MOV  R26,R19
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x94
	CPI  R18,2
	BRLO _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 01DB                   {
; 0000 01DC                    for_data*=256;
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
; 0000 01DD                    for_data+=( *(frame_in+data_size+4-2+jj) );
	SBIW R30,2
	MOVW R26,R30
	CLR  R30
	ADD  R26,R18
	ADC  R27,R30
	LD   R30,X
	CALL SUBOPT_0x14
; 0000 01DE                   };
	SUBI R19,-1
	SUBI R18,-1
	RJMP _0x92
_0x93:
; 0000 01DF                for_data*=pow(10,-( (float) ( (work_tetrada)&(0x70))/16 ));
	__GETD1N 0x41200000
	CALL __PUTPARD1
	MOV  R30,R20
	ANDI R30,LOW(0x70)
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41800000
	CALL __DIVF21
	CALL __ANEGF1
	CALL __PUTPARD1
	CALL _pow
	CALL SUBOPT_0x12
	CALL __MULF12
	CALL SUBOPT_0x11
; 0000 01E0                if((*(frame_in+2)==0xC1)&&(*(frame_in+3)==0x73) )
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0xC1)
	BRNE _0x97
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,3
	LD   R26,X
	CPI  R26,LOW(0x73)
	BREQ _0x98
_0x97:
	RJMP _0x96
_0x98:
; 0000 01E1                     { // если показания объема
; 0000 01E2                      for_data_int=(unsigned long int)for_data;  // округляем до целого
	CALL SUBOPT_0x15
	CALL __CFD1U
	CALL SUBOPT_0x16
; 0000 01E3                      batte=(unsigned int *) &for_data_int;
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x17
; 0000 01E4                      *(data)=*(batte);    // младшим байтом
; 0000 01E5                      *(data+1)=*(batte+1);
; 0000 01E6                      return 0;
	RJMP _0x20C0005
; 0000 01E7                     };
_0x96:
; 0000 01E8                if( (*(frame_in+2)==0x8F)&&(*(frame_in+3)==0xC2) )
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,2
	LD   R26,X
	CPI  R26,LOW(0x8F)
	BRNE _0x9A
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,3
	LD   R26,X
	CPI  R26,LOW(0xC2)
	BREQ _0x9B
_0x9A:
	RJMP _0x99
_0x9B:
; 0000 01E9                     { // если показания расхода
; 0000 01EA                       batte=(unsigned int *) &for_data;
	MOVW R30,R28
	ADIW R30,10
	CALL SUBOPT_0x17
; 0000 01EB                       *(data)=*(batte);    // младшим байтом
; 0000 01EC                       *(data+1)=*(batte+1);
; 0000 01ED                       return 0;
	RJMP _0x20C0005
; 0000 01EE                     };
_0x99:
; 0000 01EF              };
; 0000 01F0     }
; 0000 01F1     else {//отрицательное число
	RJMP _0x9C
_0x88:
; 0000 01F2        for( jj=0;jj<2; jj++)  //младшим байтом вперед
	LDI  R18,LOW(0)
_0x9E:
	CPI  R18,2
	BRSH _0x9F
; 0000 01F3             {  *(data+jj)=0x0000;};
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	SUBI R18,-1
	RJMP _0x9E
_0x9F:
; 0000 01F4        return 2;
	LDI  R30,LOW(2)
; 0000 01F5        };
_0x9C:
; 0000 01F6 }
_0x20C0005:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;
;
;char get_data_if_time(unsigned int *data, char * frame_in)
; 0000 01FA { // если показания времени наработки
_get_data_if_time:
; 0000 01FB unsigned int *batte;
; 0000 01FC unsigned long int time_min;
; 0000 01FD char data_size=(*(frame_in+1))&0x0F;
; 0000 01FE 
; 0000 01FF  if ( ( (*(frame_in+data_size+4-1))&0x0F )==0x00)   // время преобразуем к минутам
	SBIW R28,4
	CALL __SAVELOCR4
;	*data -> Y+10
;	*frame_in -> Y+8
;	*batte -> R16,R17
;	time_min -> Y+4
;	data_size -> R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOV  R19,R30
	MOV  R30,R19
	LDI  R31,0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,4
	SBIW R30,1
	LD   R30,Z
	ANDI R30,LOW(0xF)
	BREQ PC+3
	JMP _0xA0
; 0000 0200     {
; 0000 0201      get_bin_from_bcd_to_time(frame_in, data_size);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	RCALL _get_bin_from_bcd_to_time
; 0000 0202      time_min=0;
	LDI  R30,LOW(0)
	__CLRD1S 4
; 0000 0203 //     time_min+=( (*(frame_in+4))&0x0F ); //считывает часы (2,5 байта)
; 0000 0204      time_min+=( *(frame_in+4)); //считывает часы (3 байта)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,4
	CALL SUBOPT_0x18
; 0000 0205      time_min<<=8;
; 0000 0206      time_min+=*(frame_in+5);
	ADIW R26,5
	CALL SUBOPT_0x18
; 0000 0207      time_min<<=8;
; 0000 0208      time_min+=*(frame_in+6);
	ADIW R26,6
	CALL SUBOPT_0x19
; 0000 0209      time_min*=60;
	CALL SUBOPT_0x1A
	__GETD2N 0x3C
	CALL __MULD12U
	__PUTD1S 4
; 0000 020A      time_min+=*(frame_in+7); // прибавляем минуты
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,7
	CALL SUBOPT_0x19
; 0000 020B      batte=(unsigned int *) &time_min;
	MOVW R30,R28
	ADIW R30,4
	MOVW R16,R30
; 0000 020C 
; 0000 020D      *(data)=*(batte);       //!!!!!!!!!!!!!!!!!!
	MOVW R26,R16
	CALL __GETW1P
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	ST   X+,R30
	ST   X,R31
; 0000 020E      *(data+1)=*(batte+1);    // младшим байтом
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1SNS 10,2
; 0000 020F      return 0;
	LDI  R30,LOW(0)
	CALL __LOADLOCR4
	JMP  _0x20C0001
; 0000 0210      }
; 0000 0211   else {return 7;}; // другая цена времени
_0xA0:
	LDI  R30,LOW(7)
	CALL __LOADLOCR4
	JMP  _0x20C0001
; 0000 0212 }
;
;char get_word_si8(unsigned int *data, char * frame_in)
; 0000 0215 { //data -размер 2 слова(4 байта)
_get_word_si8:
; 0000 0216   if( (*(frame_in+4)&0xF0)==0xF0 )
;	*data -> Y+2
;	*frame_in -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,4
	LD   R30,X
	ANDI R30,LOW(0xF0)
	CPI  R30,LOW(0xF0)
	BRNE _0xA2
; 0000 0217   {
; 0000 0218 //        delay_ms( 1000 );
; 0000 0219         return 5;  // исключительная ситуация
	LDI  R30,LOW(5)
	JMP  _0x20C0004
; 0000 021A   }
; 0000 021B   else{
_0xA2:
; 0000 021C       if( ((*(frame_in+2)==0xC1)&&(*(frame_in+3)==0x73))||((*(frame_in+2)==0x8F)&&(*(frame_in+3)==0xC2)) )
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0xC1)
	BRNE _0xA5
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x73)
	BREQ _0xA7
_0xA5:
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x8F)
	BRNE _0xA8
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0xC2)
	BREQ _0xA7
_0xA8:
	RJMP _0xA4
_0xA7:
; 0000 021D         { // объем или расход
; 0000 021E           return get_data_if_volum_or_flowrate(data, frame_in);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	RCALL _get_data_if_volum_or_flowrate
	JMP  _0x20C0004
; 0000 021F         }
; 0000 0220       else {
_0xA4:
; 0000 0221             if( ((*(frame_in+2)==0xE6)&&(*(frame_in+3)==0x9C)) )    // время
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0xE6)
	BRNE _0xAD
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x9C)
	BREQ _0xAE
_0xAD:
	RJMP _0xAC
_0xAE:
; 0000 0222                { // время
; 0000 0223                  return get_data_if_time(data, frame_in);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	RCALL _get_data_if_time
	JMP  _0x20C0004
; 0000 0224                }
; 0000 0225             else
_0xAC:
; 0000 0226             {
; 0000 0227 //             delay_ms( 1000 );
; 0000 0228               return 6;
	LDI  R30,LOW(6)
	JMP  _0x20C0004
; 0000 0229             }; // сетевая ошибка.
; 0000 022A            };
; 0000 022B       };
; 0000 022C 
; 0000 022D return 0;
; 0000 022E }
;
;void main(void)
; 0000 0231 {
_main:
; 0000 0232 // Declare your local variables here
; 0000 0233 //char  frame_in[24]={'#', 'G', 'K', 'G', 'L', 'S', 'H', 'N', 'J',
; 0000 0234 //                    'H', 'G','G', 'G', 'G', 'G', 'G', 'K', 'H', 'N',
; 0000 0235 //                   'J', 'J', 'O', 'I', 0x0D};
; 0000 0236 //char lenth_frame_in=24;
; 0000 0237 unsigned int data[2];
; 0000 0238 //char  frame_in[28]={'#', 0x47, 0x4A, 0x47, 0x4E, 0x55, 0x4D, 0x50, 0x53,
; 0000 0239 //                    0x47, 0x47, 0x47, 0x47, 0x47, 0x4B, 0x4C, 0x48, 0x49, 0x4D, 0x4C, 0x4F, 0x4B, 0x47,
; 0000 023A //                    0x48, 0x56, 0x55, 0x50, 0x0D };
; 0000 023B //
; 0000 023C //char lenth_frame_in=28;
; 0000 023D 
; 0000 023E char  frame_in[22]={ 0x23, 0x47, 0x4A, 0x47, 0x4B, 0x53, 0x48, 0x4E, 0x4A,
; 0000 023F                      0x48, 0x48, 0x4A, 0x4D, 0x4F, 0x50, 0x48, 0x4F,
; 0000 0240                      0x4C, 0x4D, 0x53, 0x54, 0x0D };
; 0000 0241 char lenth_frame_in=22;
; 0000 0242 //
; 0000 0243 //char  frame_in[28]={ 0x23, 0x47, 0x4A, 0x47, 0x4E, 0x55, 0x4D, 0x50, 0x53,
; 0000 0244 //                     0x50, 0x49, 0x4A, 0x4B, 0x4B, 0x4F, 0x4B, 0x50, 0x4A, 0x4C, 0x4E, 0x48, 0x4B, 0x47,
; 0000 0245 //                     0x52, 0x51, 0x4C, 0x4D, 0x0D};
; 0000 0246 //char lenth_frame_in=28;
; 0000 0247 
; 0000 0248 
; 0000 0249 // ---------- для отладки --------------------------------------------
; 0000 024A 
; 0000 024B //unsigned int pnu_list[5]={0xC173, 0x8FC2, 0xE69C, 0xffff, 0xffff};
; 0000 024C 
; 0000 024D //------------------------------------------------------------------------------
; 0000 024E 
; 0000 024F 
; 0000 0250 // Input/Output Ports initialization
; 0000 0251 // Port A initialization
; 0000 0252 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0253 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0254 PORTA=0x00;
	SBIW R28,26
	LDI  R24,22
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xB0*2)
	LDI  R31,HIGH(_0xB0*2)
	CALL __INITLOCB
;	data -> Y+22
;	frame_in -> Y+0
;	lenth_frame_in -> R17
	LDI  R17,22
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0255 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0256 
; 0000 0257 // Port B initialization
; 0000 0258 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0259 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 025A PORTB=0x00;
	OUT  0x18,R30
; 0000 025B DDRB=0x00;
	OUT  0x17,R30
; 0000 025C 
; 0000 025D // Port C initialization
; 0000 025E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 025F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0260 PORTC=0x00;
	OUT  0x15,R30
; 0000 0261 DDRC=0x00;
	OUT  0x14,R30
; 0000 0262 
; 0000 0263 // Port D initialization
; 0000 0264 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0265 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0266 PORTD=0x00;
	OUT  0x12,R30
; 0000 0267 DDRD=0x00;
	OUT  0x11,R30
; 0000 0268 
; 0000 0269 // Port E initialization
; 0000 026A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 026B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 026C PORTE=0x00;
	OUT  0x3,R30
; 0000 026D DDRE=0x00;
	OUT  0x2,R30
; 0000 026E 
; 0000 026F // Port F initialization
; 0000 0270 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0271 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0272 PORTF=0x00;
	STS  98,R30
; 0000 0273 DDRF=0x00;
	STS  97,R30
; 0000 0274 
; 0000 0275 // Port G initialization
; 0000 0276 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0277 // State4=T State3=T State2=T State1=T State0=T
; 0000 0278 PORTG=0x00;
	STS  101,R30
; 0000 0279 DDRG=0x00;
	STS  100,R30
; 0000 027A 
; 0000 027B // Timer/Counter 0 initialization
; 0000 027C // Clock source: System Clock
; 0000 027D // Clock value: 250,000 kHz
; 0000 027E // Mode: Normal top=FFh
; 0000 027F // OC0 output: Disconnected
; 0000 0280 ASSR=0x00;
	OUT  0x30,R30
; 0000 0281 TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0282 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0283 OCR0=0xFA;
	LDI  R30,LOW(250)
	OUT  0x31,R30
; 0000 0284 
; 0000 0285 // Timer/Counter 1 initialization
; 0000 0286 // Clock source: System Clock
; 0000 0287 // Clock value: Timer1 Stopped
; 0000 0288 // Mode: Normal top=FFFFh
; 0000 0289 // OC1A output: Discon.
; 0000 028A // OC1B output: Discon.
; 0000 028B // OC1C output: Discon.
; 0000 028C // Noise Canceler: Off
; 0000 028D // Input Capture on Falling Edge
; 0000 028E // Timer1 Overflow Interrupt: Off
; 0000 028F // Input Capture Interrupt: Off
; 0000 0290 // Compare A Match Interrupt: Off
; 0000 0291 // Compare B Match Interrupt: Off
; 0000 0292 // Compare C Match Interrupt: Off
; 0000 0293 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0294 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0295 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0296 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0297 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0298 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0299 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 029A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 029B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 029C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 029D OCR1CH=0x00;
	STS  121,R30
; 0000 029E OCR1CL=0x00;
	STS  120,R30
; 0000 029F 
; 0000 02A0 // Timer/Counter 2 initialization
; 0000 02A1 // Clock source: System Clock
; 0000 02A2 // Clock value: Timer2 Stopped
; 0000 02A3 // Mode: Normal top=FFh
; 0000 02A4 // OC2 output: Disconnected
; 0000 02A5 TCCR2=0x00;
	OUT  0x25,R30
; 0000 02A6 TCNT2=0x00;
	OUT  0x24,R30
; 0000 02A7 OCR2=0x00;
	OUT  0x23,R30
; 0000 02A8 
; 0000 02A9 // Timer/Counter 3 initialization
; 0000 02AA // Clock source: System Clock
; 0000 02AB // Clock value: Timer3 Stopped
; 0000 02AC // Mode: Normal top=FFFFh
; 0000 02AD // OC3A output: Discon.
; 0000 02AE // OC3B output: Discon.
; 0000 02AF // OC3C output: Discon.
; 0000 02B0 // Noise Canceler: Off
; 0000 02B1 // Input Capture on Falling Edge
; 0000 02B2 // Timer3 Overflow Interrupt: Off
; 0000 02B3 // Input Capture Interrupt: Off
; 0000 02B4 // Compare A Match Interrupt: Off
; 0000 02B5 // Compare B Match Interrupt: Off
; 0000 02B6 // Compare C Match Interrupt: Off
; 0000 02B7 TCCR3A=0x00;
	STS  139,R30
; 0000 02B8 TCCR3B=0x00;
	STS  138,R30
; 0000 02B9 TCNT3H=0x00;
	STS  137,R30
; 0000 02BA TCNT3L=0x00;
	STS  136,R30
; 0000 02BB ICR3H=0x00;
	STS  129,R30
; 0000 02BC ICR3L=0x00;
	STS  128,R30
; 0000 02BD OCR3AH=0x00;
	STS  135,R30
; 0000 02BE OCR3AL=0x00;
	STS  134,R30
; 0000 02BF OCR3BH=0x00;
	STS  133,R30
; 0000 02C0 OCR3BL=0x00;
	STS  132,R30
; 0000 02C1 OCR3CH=0x00;
	STS  131,R30
; 0000 02C2 OCR3CL=0x00;
	STS  130,R30
; 0000 02C3 
; 0000 02C4 // External Interrupt(s) initialization
; 0000 02C5 // INT0: Off
; 0000 02C6 // INT1: Off
; 0000 02C7 // INT2: Off
; 0000 02C8 // INT3: Off
; 0000 02C9 // INT4: Off
; 0000 02CA // INT5: Off
; 0000 02CB // INT6: Off
; 0000 02CC // INT7: Off
; 0000 02CD EICRA=0x00;
	STS  106,R30
; 0000 02CE EICRB=0x00;
	OUT  0x3A,R30
; 0000 02CF EIMSK=0x00;
	OUT  0x39,R30
; 0000 02D0 
; 0000 02D1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02D2 TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x37,R30
; 0000 02D3 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 02D4 
; 0000 02D5 // USART0 initialization
; 0000 02D6 // Communication Parameters: 8 Data, 2 Stop, No Parity
; 0000 02D7 // USART0 Receiver: On
; 0000 02D8 // USART0 Transmitter: On
; 0000 02D9 // USART0 Mode: Asynchronous
; 0000 02DA // USART0 Baud Rate: 9600
; 0000 02DB UCSR0A=0x00;
	OUT  0xB,R30
; 0000 02DC UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 02DD UCSR0C=0x0E;
	LDI  R30,LOW(14)
	STS  149,R30
; 0000 02DE UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 02DF UBRR0L=0x67;
	LDI  R30,LOW(103)
	OUT  0x9,R30
; 0000 02E0 
; 0000 02E1 // Analog Comparator initialization
; 0000 02E2 // Analog Comparator: Off
; 0000 02E3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02E4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02E5 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02E6 
; 0000 02E7 // Global enable interrupts
; 0000 02E8 #asm("sei")
	sei
; 0000 02E9 
; 0000 02EA get_hex_from_ascii_input(frame_in, lenth_frame_in);
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	RCALL _get_hex_from_ascii_input
; 0000 02EB 
; 0000 02EC //get_data_if_volum_or_flowrate( data,  frame_in);
; 0000 02ED 
; 0000 02EE //get_data_if_time(data, frame_in);
; 0000 02EF 
; 0000 02F0 get_word_si8(data, frame_in);
	MOVW R30,R28
	ADIW R30,22
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	RCALL _get_word_si8
; 0000 02F1 
; 0000 02F2 while (1)
_0xB1:
; 0000 02F3       {
; 0000 02F4       // Place your code here
; 0000 02F5 
; 0000 02F6       };
	RJMP _0xB1
; 0000 02F7 }
_0xB4:
	RJMP _0xB4

	.CSEG
_bcd2bin:
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	CALL _ftrunc
	CALL __PUTD1S0
    brne __floor1
__floor0:
	CALL SUBOPT_0x1E
	RJMP _0x20C0004
__floor1:
    brtc __floor0
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
_0x20C0004:
	ADIW R28,4
	RET
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x20
	CALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20C0003
_0x202000C:
	CALL SUBOPT_0x21
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x16
	CALL SUBOPT_0x20
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x202000D
	CALL SUBOPT_0x22
	CALL __ADDF12
	CALL SUBOPT_0x16
	__SUBWRN 16,17,1
_0x202000D:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x21
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x16
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x24
	CALL SUBOPT_0x20
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x25
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_exp:
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x12
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x202000F
	CALL SUBOPT_0x26
	RJMP _0x20C0002
_0x202000F:
	CALL SUBOPT_0x15
	CALL __CPD10
	BRNE _0x2020010
	__GETD1N 0x3F800000
	RJMP _0x20C0002
_0x2020010:
	CALL SUBOPT_0x12
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20C0002
_0x2020011:
	CALL SUBOPT_0x12
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	MOVW R30,R16
	CALL SUBOPT_0x12
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x24
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x24
	CALL SUBOPT_0x16
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x20
	CALL __MULF12
	CALL SUBOPT_0x16
	CALL SUBOPT_0x25
	__GETD2N 0x41A68D28
	CALL __ADDF12
	__PUTD1S 2
	CALL SUBOPT_0x21
	__GETD2S 2
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x25
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	ST   -Y,R17
	ST   -Y,R16
	CALL _ldexp
_0x20C0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
_pow:
	SBIW R28,4
	CALL SUBOPT_0x27
	CALL __CPD10
	BRNE _0x2020012
	CALL SUBOPT_0x26
	RJMP _0x20C0001
_0x2020012:
	__GETD2S 8
	CALL __CPD02
	BRGE _0x2020013
	CALL SUBOPT_0x1A
	CALL __CPD10
	BRNE _0x2020014
	__GETD1N 0x3F800000
	RJMP _0x20C0001
_0x2020014:
	CALL SUBOPT_0x27
	CALL SUBOPT_0x28
	RJMP _0x20C0001
_0x2020013:
	CALL SUBOPT_0x1A
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0x1E
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x1A
	CALL __CPD12
	BREQ _0x2020015
	CALL SUBOPT_0x26
	RJMP _0x20C0001
_0x2020015:
	CALL SUBOPT_0x27
	CALL __ANEGF1
	CALL SUBOPT_0x28
	__PUTD1S 8
	CALL SUBOPT_0x1E
	ANDI R30,LOW(0x1)
	BRNE _0x2020016
	CALL SUBOPT_0x27
	RJMP _0x20C0001
_0x2020016:
	CALL SUBOPT_0x27
	CALL __ANEGF1
_0x20C0001:
	ADIW R28,12
	RET

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOV  R30,R16
	LDI  R31,0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	MOV  R30,R17
	LDI  R31,0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	MULS R30,R17
	MOVW R30,R0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x4:
	LDD  R30,Y+8
	LDI  R31,0
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	LD   R30,Z
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	__GETD2S 4
	CALL __ADDD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R31,0
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD2N 0x64
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD2N 0x2710
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0xA:
	LDD  R30,Y+6
	LDI  R31,0
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	__GETD2S 2
	CALL __ADDD12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDD  R30,Y+6
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD:
	MOV  R30,R18
	LDI  R31,0
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xF:
	MOV  R30,R21
	LDI  R31,0
	ADIW R30,4
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x10:
	MOV  R30,R21
	LDI  R31,0
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADD  R30,R26
	ADC  R31,R27
	ADIW R30,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x12:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	__GETD1N 0x43800000
	CALL __MULF12
	RCALL SUBOPT_0x11
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	LDI  R31,0
	RCALL SUBOPT_0x12
	CALL __CWD1
	CALL __CDF1
	CALL __ADDF12
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	MOVW R16,R30
	MOVW R26,R16
	CALL __GETW1P
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ST   X+,R30
	ST   X,R31
	MOVW R26,R16
	ADIW R26,2
	CALL __GETW1P
	__PUTW1SNS 16,2
	LDI  R30,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x18:
	LD   R30,X
	LDI  R31,0
	__GETD2S 4
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 4
	__GETD2S 4
	LDI  R30,LOW(8)
	CALL __LSLD12
	__PUTD1S 4
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x19:
	LD   R30,X
	LDI  R31,0
	__GETD2S 4
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,2
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LD   R26,Y
	LDD  R27,Y+1
	ADIW R26,3
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	__GETD2N 0x3F800000
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x20:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0x21
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	CALL __PUTPARD1
	CALL _log
	__GETD2S 4
	CALL __MULF12
	CALL __PUTPARD1
	JMP  _exp


	.CSEG
_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
