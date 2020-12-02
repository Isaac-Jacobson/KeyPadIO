;*************************************************************** 
; Lab7b.s  
; Programmer:
; Description:  
;***************************************************************	

;*************************************************************** 
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT

GPIO_PORTB_DATA 	EQU 0x400053FC ;Port B data address
GPIO_PORTB_DIR 	EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 	EQU 0x4000551C
IOB 				EQU 0x0F
GPIO_PORTE_DATA 	EQU 0x400243FC ;Port E data address
GPIO_PORTE_DIR 	EQU 0x40024400
GPIO_PORTE_AFSEL 	EQU 0x40024420
GPIO_PORTE_DEN 	EQU 0x4002451C
IOE 				EQU 0x00
SYSCTL_RCGCGPIO 	EQU 0x400FE608	
DELAY_CLOCKS		EQU 0x2C4B40
GPIO_PORTE_PUR_R        EQU   0x40024510
GPIO_PORTE_CR_R         EQU   0x40024524
;***************************************************************
; Data Section in READWRITE
; Values of the data in this section are not properly initialazed, 
; but labels can be used in the program to change the data values.
;***************************************************************
;LABEL          DIRECTIVE       VALUE                           COMMENT
				
;                AREA            |.sdata|, DATA, READWRITE
;                THUMB			
								
;***************************************************************
; Directives - This Data Section is part of the code
; It is in the read only section  so values cannot be changed.
;***************************************************************
;LABEL          DIRECTIVE       VALUE                           COMMENT
                AREA            |.data|, DATA, READONLY
                THUMB
mA				DCB				"A"
				DCB				0x0D
				DCB				0x04
mB				DCB				"B"
				DCB				0x0D
				DCB				0x04
mC				DCB				"C"
				DCB				0x0D
				DCB				0x04
mD				DCB				"D"
				DCB				0x0D
				DCB				0x04
mAsterik		DCB				"*"
				DCB				0x0D
				DCB				0x04
mPound			DCB				"#"
				DCB				0x0D
				DCB				0x04
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXPORT  	__main			; Make available

__main		
			BL      setup
loop		BL		Scan
			BL      Delay
			BL		NextKey
			B		loop


;Code goes here			

forever		B			forever

;******************************************
; Subroutine to create delay, 
; DELAY_CLOCKS is the counter which is 
; decremented to zero
;******************************************	
				AREA    routines, CODE, READONLY
				THUMB
				EXTERN	OutStr
				EXTERN   Out1BSP
Delay	LDR	R2,=DELAY_CLOCKS	; set delay count
del		SUBS 	R2, R2, #1		; decrement count
		BNE	del		; if not at zero, do again
		BX	LR			; return when done

NextKey MOV R7, R6
loop1	LDR R5, =GPIO_PORTE_DATA
		LDR R8, [R5]
		EOR R6, R8, #0xFFFFFFFF
		AND R6, #0x0F
		CMP R6, R7
		BEQ loop1
		BX  LR
		
Scan	PUSH {LR}
		MOV	R3, #0x01 ;R3 is RowPtr
here	LDR	R4, =GPIO_PORTB_DATA
		BL	Eval
		STR R7, [R4]
		NOP
		NOP
		NOP
		NOP
		NOP
		NOP
		LDR R5, =GPIO_PORTE_DATA
		LDR R8, [R5]
		MOV R6, R8
        EOR R6, #0xFFFFFFFF
		AND R6, #0x0F
		CMP R6, #0x01
		BEQ	key
		CMP R6, #0x02
		BEQ key
		CMP R6, #0x04
		BEQ key
		CMP R6, #0x08
		BEQ key
		ADD R3, #0x01
		CMP R3, #0x04
		MOVGT R3, #0x01
		B   here
key		CMP R3, #0x01
		BLEQ rowOne
		CMP R3, #0x02
		BLEQ rowTwo
		CMP R3, #0x03
		BLEQ rowThree
		CMP R3, #0x04
		BLEQ rowFour
		POP {LR}
		BX  LR
		
Eval    CMP R3, #0x01
		BEQ One
		CMP R3, #0x02
		BEQ Two
		CMP R3, #0x03
		BEQ Three
		CMP R4, #0x04
		B   Four
hereE   BX  LR
One     MOV R7, #0xE
		B   hereE
Two		MOV R7, #0x0D
		B   hereE
Three	MOV R7, #0x0B
		B   hereE
Four    MOV R7, #0x07
		B   hereE
		
rowOne  PUSH {LR}
		CMP R6, #0x01
		BEQ key1
		CMP R6, #0x02
		BEQ key2
		CMP R6, #0x04
		BEQ key3
		CMP R6, #0x08
		BEQ keyA
here1	POP {LR}
		BX  LR
keyA    LDR R0, =mA
		BL  OutStr
		B here1
key3    MOV R0, #0x03
		BL  Out1BSP
		B here1
key2    MOV R0, #0x02
		BL  Out1BSP
		B here1
key1    MOV R0, #0x01
		BL  Out1BSP
		B here1		

rowTwo  PUSH {LR}
		CMP R6, #0x01
		BEQ key4
		CMP R6, #0x02
		BEQ key5
		CMP R6, #0x04
		BEQ key6
		CMP R6, #0x08
		BEQ keyB
here2	POP {LR}
		BX  LR
keyB    LDR R0, =mB
		BL  OutStr
		B here2
key6    MOV R0, #0x06
		BL  Out1BSP
		B here2
key5    MOV R0, #0x05
		BL  Out1BSP
		B here2
key4    MOV R0, #0x04
		BL  Out1BSP
		B here2		

rowThree PUSH {LR}
		CMP R6, #0x01
		BEQ key7
		CMP R6, #0x02
		BEQ key8
		CMP R6, #0x04
		BEQ key9
		CMP R6, #0x08
		BEQ keyC
here3	POP {LR}
		BX  LR
keyC    LDR R0, =mC
		BL  OutStr
		B here3
key9    MOV R0, #0x09
		BL  Out1BSP
		B here3
key8    MOV R0, #0x08
		BL  Out1BSP
		B here3
key7    MOV R0, #0x07
		BL  Out1BSP
		B here3		

rowFour PUSH {LR}
		CMP R6, #0x01
		BEQ keyAs
		CMP R6, #0x02
		BEQ key0
		CMP R6, #0x04
		BEQ keyP
		CMP R6, #0x08
		BEQ keyD
here4	POP {LR}
		BX  LR
keyD    LDR R0, =mD
		BL  OutStr
		B here4
keyP    LDR R0, =mPound
		BL  OutStr
		B here4
key0    MOV R0, #0x00
		BL  Out1BSP
		B here4
keyAs   LDR R0, =mAsterik
		BL  OutStr
		B here4		

setup   LDR R1, =SYSCTL_RCGCGPIO
		LDR R0, [R1]
		ORR R0, R0, #0x12
		STR R0, [R1]
		NOP
		NOP
		NOP
		LDR R1, =GPIO_PORTB_DIR
		LDR R0, [R1]
		BIC R0, #0xFF
		ORR R0, #IOB
		STR R0, [R1]
		LDR R1, =GPIO_PORTB_AFSEL
		LDR R0, [R1]
		BIC R0, #0xFF
		STR R0, [R1]
		LDR R1, =GPIO_PORTB_DEN
		LDR R0, [R1]
		ORR R0, #0xFF
		STR R0, [R1]
		MOV R0, #0x00
		LDR R1, =GPIO_PORTE_DIR
		LDR R0, [R1]
		BIC R0, #0xFF
		ORR R0, #IOE
		STR R0, [R1]
		LDR R1, =GPIO_PORTE_AFSEL
		LDR R0, [R1]
		BIC R0, #0xFF
		STR R0, [R1]
		LDR R1, =GPIO_PORTE_DEN
		LDR R0, [R1]
		ORR R0, #0xFF
		STR R0, [R1]
		LDR R1, =GPIO_PORTE_CR_R 
		MOV R0, #0x0F
		STR R0, [R1]
		LDR R1, =GPIO_PORTE_PUR_R 
		MOV R0, #0x0F
		STR R0, [R1]
		BX  LR
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE	VALUE			COMMENT
			ALIGN
			END 
