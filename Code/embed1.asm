
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;embed1.c,37 :: 		void interrupt () // TMR0 overflow has caused an interrupt
;embed1.c,41 :: 		if(INTCON.T0IF)
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;embed1.c,44 :: 		if(paymentFlag==1)
	MOVF       _paymentFlag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt1
;embed1.c,47 :: 		if(totalPaymentTimeOutCounter>=100)
	MOVLW      100
	SUBWF      _totalPaymentTimeOutCounter+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt2
;embed1.c,49 :: 		TMR0=0x00; // reset the Timer
	CLRF       TMR0+0
;embed1.c,50 :: 		totalPaymentTimeOutCounter=0;
	CLRF       _totalPaymentTimeOutCounter+0
;embed1.c,51 :: 		PaymentTimeOut=1;
	MOVLW      1
	MOVWF      _PaymentTimeOut+0
;embed1.c,52 :: 		return;
	GOTO       L__interrupt98
;embed1.c,53 :: 		}
L_interrupt2:
;embed1.c,54 :: 		INTCON.T0IF=0;
	BCF        INTCON+0, 2
;embed1.c,55 :: 		totalPaymentTimeOutCounter++;
	INCF       _totalPaymentTimeOutCounter+0, 1
;embed1.c,56 :: 		return;
	GOTO       L__interrupt98
;embed1.c,57 :: 		}
L_interrupt1:
;embed1.c,60 :: 		else if(returnMoneyFlag==1)
	MOVF       _returnMoneyFlag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt4
;embed1.c,62 :: 		if(returnMoneyTimeOutTotalCount>=100)
	MOVLW      100
	SUBWF      _returnMoneyTimeOutTotalCount+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt5
;embed1.c,66 :: 		TMR0=0x00; // reset the Timer
	CLRF       TMR0+0
;embed1.c,67 :: 		returnMoneyTimeOutTotalCount=0;
	CLRF       _returnMoneyTimeOutTotalCount+0
;embed1.c,68 :: 		returnMoneyTimeOut=1;
	MOVLW      1
	MOVWF      _returnMoneyTimeOut+0
;embed1.c,69 :: 		return;
	GOTO       L__interrupt98
;embed1.c,70 :: 		}
L_interrupt5:
;embed1.c,71 :: 		INTCON.T0IF=0;
	BCF        INTCON+0, 2
;embed1.c,72 :: 		returnMoneyTimeOutTotalCount++;
	INCF       _returnMoneyTimeOutTotalCount+0, 1
;embed1.c,73 :: 		return;
	GOTO       L__interrupt98
;embed1.c,74 :: 		}
L_interrupt4:
;embed1.c,76 :: 		else if(DrinkDispensedMsgFlag==1)
	MOVF       _DrinkDispensedMsgFlag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
;embed1.c,78 :: 		if(totalDrinkDispensedMsgTimeOutCounter>=60)
	MOVLW      60
	SUBWF      _totalDrinkDispensedMsgTimeOutCounter+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt8
;embed1.c,82 :: 		TMR0=0x00; // reset the Timer
	CLRF       TMR0+0
;embed1.c,83 :: 		totalDrinkDispensedMsgTimeOutCounter=0;
	CLRF       _totalDrinkDispensedMsgTimeOutCounter+0
;embed1.c,84 :: 		DrinkDispensedMsgTimeOut=1;
	MOVLW      1
	MOVWF      _DrinkDispensedMsgTimeOut+0
;embed1.c,85 :: 		return;
	GOTO       L__interrupt98
;embed1.c,86 :: 		}
L_interrupt8:
;embed1.c,87 :: 		INTCON.T0IF=0;
	BCF        INTCON+0, 2
;embed1.c,88 :: 		totalDrinkDispensedMsgTimeOutCounter++;
	INCF       _totalDrinkDispensedMsgTimeOutCounter+0, 1
;embed1.c,89 :: 		return;
	GOTO       L__interrupt98
;embed1.c,90 :: 		}
L_interrupt7:
;embed1.c,93 :: 		}
L_interrupt0:
;embed1.c,96 :: 		}
L_end_interrupt:
L__interrupt98:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_delay:

;embed1.c,98 :: 		void delay()
;embed1.c,100 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_delay9:
	DECFSZ     R13+0, 1
	GOTO       L_delay9
	DECFSZ     R12+0, 1
	GOTO       L_delay9
	DECFSZ     R11+0, 1
	GOTO       L_delay9
	NOP
	NOP
;embed1.c,104 :: 		}
L_end_delay:
	RETURN
; end of _delay

_handlePayment:

;embed1.c,116 :: 		void handlePayment(int amount)
;embed1.c,121 :: 		paymentFlag=1;
	MOVLW      1
	MOVWF      _paymentFlag+0
;embed1.c,122 :: 		totalAccumulatedPayment=0;
	CLRF       _totalAccumulatedPayment+0
	CLRF       _totalAccumulatedPayment+1
;embed1.c,123 :: 		PaymentTimeOut=0;
	CLRF       _PaymentTimeOut+0
;embed1.c,124 :: 		TMR0=0x00; // start the Timer
	CLRF       TMR0+0
;embed1.c,125 :: 		INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
	MOVLW      160
	MOVWF      INTCON+0
;embed1.c,126 :: 		OPTION_REG = 0x07; // set prescaler to 256: for timer
	MOVLW      7
	MOVWF      OPTION_REG+0
;embed1.c,127 :: 		while(PaymentTimeOut==0)
L_handlePayment10:
	MOVF       _PaymentTimeOut+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_handlePayment11
;embed1.c,130 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_handlePayment12:
	DECFSZ     R13+0, 1
	GOTO       L_handlePayment12
	DECFSZ     R12+0, 1
	GOTO       L_handlePayment12
	DECFSZ     R11+0, 1
	GOTO       L_handlePayment12
;embed1.c,132 :: 		if (PORTD.B0==0)
	BTFSC      PORTD+0, 0
	GOTO       L_handlePayment13
;embed1.c,134 :: 		delay();
	CALL       _delay+0
;embed1.c,135 :: 		totalAccumulatedPayment+=5;
	MOVLW      5
	ADDWF      _totalAccumulatedPayment+0, 1
	BTFSC      STATUS+0, 0
	INCF       _totalAccumulatedPayment+1, 1
;embed1.c,136 :: 		}
	GOTO       L_handlePayment14
L_handlePayment13:
;embed1.c,138 :: 		else if (PORTD.B1==0)
	BTFSC      PORTD+0, 1
	GOTO       L_handlePayment15
;embed1.c,140 :: 		delay();
	CALL       _delay+0
;embed1.c,141 :: 		totalAccumulatedPayment+=10;
	MOVLW      10
	ADDWF      _totalAccumulatedPayment+0, 1
	BTFSC      STATUS+0, 0
	INCF       _totalAccumulatedPayment+1, 1
;embed1.c,142 :: 		}
	GOTO       L_handlePayment16
L_handlePayment15:
;embed1.c,144 :: 		else if (PORTD.B2==0)
	BTFSC      PORTD+0, 2
	GOTO       L_handlePayment17
;embed1.c,146 :: 		delay();
	CALL       _delay+0
;embed1.c,147 :: 		totalAccumulatedPayment+=20;
	MOVLW      20
	ADDWF      _totalAccumulatedPayment+0, 1
	BTFSC      STATUS+0, 0
	INCF       _totalAccumulatedPayment+1, 1
;embed1.c,148 :: 		}
	GOTO       L_handlePayment18
L_handlePayment17:
;embed1.c,150 :: 		else if (PORTD.B3==0)
	BTFSC      PORTD+0, 3
	GOTO       L_handlePayment19
;embed1.c,152 :: 		delay();
	CALL       _delay+0
;embed1.c,153 :: 		totalAccumulatedPayment+=50;
	MOVLW      50
	ADDWF      _totalAccumulatedPayment+0, 1
	BTFSC      STATUS+0, 0
	INCF       _totalAccumulatedPayment+1, 1
;embed1.c,154 :: 		}
	GOTO       L_handlePayment20
L_handlePayment19:
;embed1.c,156 :: 		else if (PORTD.B4==0)
	BTFSC      PORTD+0, 4
	GOTO       L_handlePayment21
;embed1.c,158 :: 		delay();
	CALL       _delay+0
;embed1.c,159 :: 		totalAccumulatedPayment+=100;
	MOVLW      100
	ADDWF      _totalAccumulatedPayment+0, 1
	BTFSC      STATUS+0, 0
	INCF       _totalAccumulatedPayment+1, 1
;embed1.c,160 :: 		}
L_handlePayment21:
L_handlePayment20:
L_handlePayment18:
L_handlePayment16:
L_handlePayment14:
;embed1.c,162 :: 		if(totalAccumulatedPayment>=amount) // get all money
	MOVLW      128
	XORWF      _totalAccumulatedPayment+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      FARG_handlePayment_amount+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__handlePayment101
	MOVF       FARG_handlePayment_amount+0, 0
	SUBWF      _totalAccumulatedPayment+0, 0
L__handlePayment101:
	BTFSS      STATUS+0, 0
	GOTO       L_handlePayment22
;embed1.c,164 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,165 :: 		Lcd_Out(1, 1, strConstCpy(returnAccessMsg));
	MOVF       _returnAccessMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _returnAccessMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,166 :: 		Lcd_Out(2, 1, strConstCpy(paymentFinishMsg));
	MOVF       _paymentFinishMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _paymentFinishMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,173 :: 		for(loopVar=amount;loopVar<totalAccumulatedPayment;loopVar+=5)
	MOVF       FARG_handlePayment_amount+0, 0
	MOVWF      _loopVar+0
	MOVF       FARG_handlePayment_amount+1, 0
	MOVWF      _loopVar+1
L_handlePayment23:
	MOVLW      128
	XORWF      _loopVar+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _totalAccumulatedPayment+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__handlePayment102
	MOVF       _totalAccumulatedPayment+0, 0
	SUBWF      _loopVar+0, 0
L__handlePayment102:
	BTFSC      STATUS+0, 0
	GOTO       L_handlePayment24
;embed1.c,176 :: 		PORTD.B7 = 1;
	BSF        PORTD+0, 7
;embed1.c,177 :: 		delay();delay();delay();
	CALL       _delay+0
	CALL       _delay+0
	CALL       _delay+0
;embed1.c,178 :: 		PORTD.B7 = 0;
	BCF        PORTD+0, 7
;embed1.c,179 :: 		delay();delay();delay();
	CALL       _delay+0
	CALL       _delay+0
	CALL       _delay+0
;embed1.c,173 :: 		for(loopVar=amount;loopVar<totalAccumulatedPayment;loopVar+=5)
	MOVLW      5
	ADDWF      _loopVar+0, 1
	BTFSC      STATUS+0, 0
	INCF       _loopVar+1, 1
;embed1.c,181 :: 		}
	GOTO       L_handlePayment23
L_handlePayment24:
;embed1.c,182 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,183 :: 		Lcd_Out(1, 1, strConstCpy(thankYouMsg));
	MOVF       _thankYouMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _thankYouMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,185 :: 		paymentFlag=0;
	CLRF       _paymentFlag+0
;embed1.c,186 :: 		PaymentTimeOut=0;
	CLRF       _PaymentTimeOut+0
;embed1.c,188 :: 		DrinkDispensedMsgFlag=1;
	MOVLW      1
	MOVWF      _DrinkDispensedMsgFlag+0
;embed1.c,189 :: 		DrinkDispensedMsgTimeOut=0;
	CLRF       _DrinkDispensedMsgTimeOut+0
;embed1.c,190 :: 		totalDrinkDispensedMsgTimeOutCounter=0;
	CLRF       _totalDrinkDispensedMsgTimeOutCounter+0
;embed1.c,192 :: 		TMR0=0x00; // start the Timer
	CLRF       TMR0+0
;embed1.c,193 :: 		INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
	MOVLW      160
	MOVWF      INTCON+0
;embed1.c,194 :: 		OPTION_REG = 0x07; // set prescaler to 256: for timer
	MOVLW      7
	MOVWF      OPTION_REG+0
;embed1.c,195 :: 		while(DrinkDispensedMsgTimeOut==0)
L_handlePayment26:
	MOVF       _DrinkDispensedMsgTimeOut+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_handlePayment27
;embed1.c,197 :: 		delay();
	CALL       _delay+0
;embed1.c,198 :: 		}
	GOTO       L_handlePayment26
L_handlePayment27:
;embed1.c,199 :: 		return;
	GOTO       L_end_handlePayment
;embed1.c,200 :: 		}
L_handlePayment22:
;embed1.c,201 :: 		}
	GOTO       L_handlePayment10
L_handlePayment11:
;embed1.c,203 :: 		paymentFlag=0;  // reset flag
	CLRF       _paymentFlag+0
;embed1.c,204 :: 		PaymentTimeOut=0; // reset counter
	CLRF       _PaymentTimeOut+0
;embed1.c,206 :: 		INTCON=0x00;
	CLRF       INTCON+0
;embed1.c,207 :: 		OPTION_REG = 0x00;
	CLRF       OPTION_REG+0
;embed1.c,209 :: 		returnAllMoney();
	CALL       _returnAllMoney+0
;embed1.c,210 :: 		if(returnMoneyTimeOut!=0)
	MOVF       _returnMoneyTimeOut+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_handlePayment28
;embed1.c,212 :: 		returnMoneyTimeOut=0;
	CLRF       _returnMoneyTimeOut+0
;embed1.c,214 :: 		}
L_handlePayment28:
;embed1.c,218 :: 		return; // return from handlePayment to welcome screen because of time out
;embed1.c,219 :: 		}
L_end_handlePayment:
	RETURN
; end of _handlePayment

_strConstCpy:

;embed1.c,224 :: 		char* strConstCpy(const char* ctxt){
;embed1.c,227 :: 		for(i =0; txt[i] = ctxt[i]; i++);
	CLRF       R3+0
L_strConstCpy29:
	MOVF       R3+0, 0
	ADDLW      strConstCpy_txt_L0+0
	MOVWF      R2+0
	MOVF       R3+0, 0
	ADDWF      FARG_strConstCpy_ctxt+0, 0
	MOVWF      R0+0
	MOVF       FARG_strConstCpy_ctxt+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       R2+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_strConstCpy30
	INCF       R3+0, 1
	GOTO       L_strConstCpy29
L_strConstCpy30:
;embed1.c,229 :: 		return txt;
	MOVLW      strConstCpy_txt_L0+0
	MOVWF      R0+0
;embed1.c,230 :: 		}
L_end_strConstCpy:
	RETURN
; end of _strConstCpy

_coldDrink:

;embed1.c,235 :: 		int coldDrink()
;embed1.c,237 :: 		int currentColdDrink=1;
	MOVLW      1
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,238 :: 		const char *orange = "Orange juice";
	MOVLW      ?lstr_5_embed1+0
	MOVWF      coldDrink_orange_L0+0
	MOVLW      hi_addr(?lstr_5_embed1+0)
	MOVWF      coldDrink_orange_L0+1
	MOVLW      ?lstr_6_embed1+0
	MOVWF      coldDrink_Fizzy_L0+0
	MOVLW      hi_addr(?lstr_6_embed1+0)
	MOVWF      coldDrink_Fizzy_L0+1
	MOVLW      ?lstr_7_embed1+0
	MOVWF      coldDrink_waterMsg_L0+0
	MOVLW      hi_addr(?lstr_7_embed1+0)
	MOVWF      coldDrink_waterMsg_L0+1
	MOVLW      ?lstr_8_embed1+0
	MOVWF      coldDrink_orangePriceMsg_L0+0
	MOVLW      hi_addr(?lstr_8_embed1+0)
	MOVWF      coldDrink_orangePriceMsg_L0+1
	MOVLW      ?lstr_9_embed1+0
	MOVWF      coldDrink_fizzyPriceMsg_L0+0
	MOVLW      hi_addr(?lstr_9_embed1+0)
	MOVWF      coldDrink_fizzyPriceMsg_L0+1
	MOVLW      ?lstr_10_embed1+0
	MOVWF      coldDrink_waterPriceMsg_L0+0
	MOVLW      hi_addr(?lstr_10_embed1+0)
	MOVWF      coldDrink_waterPriceMsg_L0+1
;embed1.c,245 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,246 :: 		Lcd_Out(1, 1, strConstCpy(orange));
	MOVF       coldDrink_orange_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_orange_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,247 :: 		Lcd_Out(2, 1, strConstCpy(Fizzy));
	MOVF       coldDrink_Fizzy_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_Fizzy_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,248 :: 		Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
	MOVLW      15
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,249 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,250 :: 		do
L_coldDrink32:
;embed1.c,253 :: 		if (PORTD.B0==0)
	BTFSC      PORTD+0, 0
	GOTO       L_coldDrink35
;embed1.c,255 :: 		delay();
	CALL       _delay+0
;embed1.c,257 :: 		if(currentColdDrink==3)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink105
	MOVLW      3
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink105:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink36
;embed1.c,260 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,261 :: 		Lcd_Out(1, 1, strConstCpy(orange));
	MOVF       coldDrink_orange_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_orange_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,262 :: 		Lcd_Out(2, 1, strConstCpy(Fizzy));
	MOVF       coldDrink_Fizzy_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_Fizzy_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,264 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,265 :: 		currentColdDrink=2;
	MOVLW      2
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,266 :: 		}
	GOTO       L_coldDrink37
L_coldDrink36:
;embed1.c,267 :: 		else if(currentColdDrink==2)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink106
	MOVLW      2
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink106:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink38
;embed1.c,270 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,271 :: 		currentColdDrink=1;
	MOVLW      1
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,272 :: 		}
	GOTO       L_coldDrink39
L_coldDrink38:
;embed1.c,274 :: 		else if(currentColdDrink==1)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink107
	MOVLW      1
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink107:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink40
;embed1.c,277 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,278 :: 		Lcd_Out(1, 1, strConstCpy(waterMsg));
	MOVF       coldDrink_waterMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_waterMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,280 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,281 :: 		currentColdDrink=3;
	MOVLW      3
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,282 :: 		}
L_coldDrink40:
L_coldDrink39:
L_coldDrink37:
;embed1.c,285 :: 		}
	GOTO       L_coldDrink41
L_coldDrink35:
;embed1.c,289 :: 		else if (PORTD.B1==0)
	BTFSC      PORTD+0, 1
	GOTO       L_coldDrink42
;embed1.c,292 :: 		delay();
	CALL       _delay+0
;embed1.c,295 :: 		if(currentColdDrink==3)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink108
	MOVLW      3
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink108:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink43
;embed1.c,300 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,301 :: 		Lcd_Out(1, 1, strConstCpy(orange));
	MOVF       coldDrink_orange_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_orange_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,302 :: 		Lcd_Out(2, 1, strConstCpy(Fizzy));
	MOVF       coldDrink_Fizzy_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_Fizzy_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,304 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,305 :: 		currentColdDrink=1;
	MOVLW      1
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,306 :: 		}
	GOTO       L_coldDrink44
L_coldDrink43:
;embed1.c,307 :: 		else if(currentColdDrink==2)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink109
	MOVLW      2
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink109:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink45
;embed1.c,310 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,311 :: 		Lcd_Out(1, 1, strConstCpy(waterMsg));
	MOVF       coldDrink_waterMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_waterMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,313 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,314 :: 		currentColdDrink=3;
	MOVLW      3
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,315 :: 		}
	GOTO       L_coldDrink46
L_coldDrink45:
;embed1.c,317 :: 		else if(currentColdDrink==1)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink110
	MOVLW      1
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink110:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink47
;embed1.c,320 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,321 :: 		currentColdDrink=2;
	MOVLW      2
	MOVWF      coldDrink_currentColdDrink_L0+0
	MOVLW      0
	MOVWF      coldDrink_currentColdDrink_L0+1
;embed1.c,322 :: 		}
L_coldDrink47:
L_coldDrink46:
L_coldDrink44:
;embed1.c,323 :: 		}
	GOTO       L_coldDrink48
L_coldDrink42:
;embed1.c,326 :: 		else if (PORTD.B2==0)
	BTFSC      PORTD+0, 2
	GOTO       L_coldDrink49
;embed1.c,329 :: 		int cost=0;
;embed1.c,330 :: 		if(currentColdDrink==1)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink111
	MOVLW      1
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink111:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink50
;embed1.c,332 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,333 :: 		Lcd_Out(1, 1, strConstCpy(orangePriceMsg));
	MOVF       coldDrink_orangePriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_orangePriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,334 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,335 :: 		return 50;
	MOVLW      50
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_coldDrink
;embed1.c,336 :: 		}
L_coldDrink50:
;embed1.c,337 :: 		else if(currentColdDrink==2)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink112
	MOVLW      2
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink112:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink52
;embed1.c,339 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,340 :: 		Lcd_Out(1, 1, strConstCpy(fizzyPriceMsg));
	MOVF       coldDrink_fizzyPriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_fizzyPriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,341 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,342 :: 		return 50;
	MOVLW      50
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_coldDrink
;embed1.c,343 :: 		}
L_coldDrink52:
;embed1.c,345 :: 		else if(currentColdDrink==3)
	MOVLW      0
	XORWF      coldDrink_currentColdDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coldDrink113
	MOVLW      3
	XORWF      coldDrink_currentColdDrink_L0+0, 0
L__coldDrink113:
	BTFSS      STATUS+0, 2
	GOTO       L_coldDrink54
;embed1.c,347 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,348 :: 		Lcd_Out(1, 1, strConstCpy(waterPriceMsg));
	MOVF       coldDrink_waterPriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       coldDrink_waterPriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,349 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,351 :: 		return 75;
	MOVLW      75
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_coldDrink
;embed1.c,352 :: 		}
L_coldDrink54:
;embed1.c,353 :: 		}
L_coldDrink49:
L_coldDrink48:
L_coldDrink41:
;embed1.c,354 :: 		}while(1);
	GOTO       L_coldDrink32
;embed1.c,357 :: 		}
L_end_coldDrink:
	RETURN
; end of _coldDrink

_hotDrink:

;embed1.c,361 :: 		int hotDrink()
;embed1.c,363 :: 		int currentHotDrink=1;
	MOVLW      1
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,365 :: 		const char *Tea = "Tea";
	MOVLW      ?lstr_11_embed1+0
	MOVWF      hotDrink_Tea_L0+0
	MOVLW      hi_addr(?lstr_11_embed1+0)
	MOVWF      hotDrink_Tea_L0+1
	MOVLW      ?lstr_12_embed1+0
	MOVWF      hotDrink_Coffee_L0+0
	MOVLW      hi_addr(?lstr_12_embed1+0)
	MOVWF      hotDrink_Coffee_L0+1
	MOVLW      ?lstr_13_embed1+0
	MOVWF      hotDrink_Chocolate_L0+0
	MOVLW      hi_addr(?lstr_13_embed1+0)
	MOVWF      hotDrink_Chocolate_L0+1
	MOVLW      ?lstr_14_embed1+0
	MOVWF      hotDrink_Soup_L0+0
	MOVLW      hi_addr(?lstr_14_embed1+0)
	MOVWF      hotDrink_Soup_L0+1
	MOVLW      ?lstr_15_embed1+0
	MOVWF      hotDrink_teaPriceMsg_L0+0
	MOVLW      hi_addr(?lstr_15_embed1+0)
	MOVWF      hotDrink_teaPriceMsg_L0+1
	MOVLW      ?lstr_16_embed1+0
	MOVWF      hotDrink_coffeePriceMsg_L0+0
	MOVLW      hi_addr(?lstr_16_embed1+0)
	MOVWF      hotDrink_coffeePriceMsg_L0+1
	MOVLW      ?lstr_17_embed1+0
	MOVWF      hotDrink_ChocolatePriceMsg_L0+0
	MOVLW      hi_addr(?lstr_17_embed1+0)
	MOVWF      hotDrink_ChocolatePriceMsg_L0+1
	MOVLW      ?lstr_18_embed1+0
	MOVWF      hotDrink_soupPriceMsg_L0+0
	MOVLW      hi_addr(?lstr_18_embed1+0)
	MOVWF      hotDrink_soupPriceMsg_L0+1
;embed1.c,377 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,379 :: 		Lcd_Out(1, 1, strConstCpy(Tea));
	MOVF       hotDrink_Tea_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Tea_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,380 :: 		Lcd_Out(2, 1, strConstCpy(Coffee));
	MOVF       hotDrink_Coffee_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Coffee_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,381 :: 		Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
	MOVLW      15
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,382 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,383 :: 		do
L_hotDrink55:
;embed1.c,386 :: 		if (PORTD.B0==0)
	BTFSC      PORTD+0, 0
	GOTO       L_hotDrink58
;embed1.c,388 :: 		delay();
	CALL       _delay+0
;embed1.c,390 :: 		if(currentHotDrink==4)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink115
	MOVLW      4
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink115:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink59
;embed1.c,393 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,394 :: 		currentHotDrink=3;
	MOVLW      3
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,395 :: 		}
	GOTO       L_hotDrink60
L_hotDrink59:
;embed1.c,396 :: 		else if(currentHotDrink==3)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink116
	MOVLW      3
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink116:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink61
;embed1.c,399 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,400 :: 		Lcd_Out(1, 1, strConstCpy(Tea));
	MOVF       hotDrink_Tea_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Tea_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,401 :: 		Lcd_Out(2, 1, strConstCpy(Coffee));
	MOVF       hotDrink_Coffee_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Coffee_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,403 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,404 :: 		currentHotDrink=2;
	MOVLW      2
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,405 :: 		}
	GOTO       L_hotDrink62
L_hotDrink61:
;embed1.c,406 :: 		else if(currentHotDrink==2)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink117
	MOVLW      2
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink117:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink63
;embed1.c,409 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,410 :: 		currentHotDrink=1;
	MOVLW      1
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,411 :: 		}
	GOTO       L_hotDrink64
L_hotDrink63:
;embed1.c,413 :: 		else if(currentHotDrink==1)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink118
	MOVLW      1
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink118:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink65
;embed1.c,416 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,417 :: 		Lcd_Out(1, 1, strConstCpy(Chocolate));
	MOVF       hotDrink_Chocolate_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Chocolate_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,418 :: 		Lcd_Out(2, 1, strConstCpy(Soup));
	MOVF       hotDrink_Soup_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Soup_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,420 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,421 :: 		currentHotDrink=4;
	MOVLW      4
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,422 :: 		}
L_hotDrink65:
L_hotDrink64:
L_hotDrink62:
L_hotDrink60:
;embed1.c,425 :: 		}
	GOTO       L_hotDrink66
L_hotDrink58:
;embed1.c,427 :: 		else if (PORTD.B1==0)
	BTFSC      PORTD+0, 1
	GOTO       L_hotDrink67
;embed1.c,430 :: 		delay();
	CALL       _delay+0
;embed1.c,432 :: 		if(currentHotDrink==4)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink119
	MOVLW      4
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink119:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink68
;embed1.c,436 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,437 :: 		Lcd_Out(1, 1, strConstCpy(Tea));
	MOVF       hotDrink_Tea_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Tea_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,438 :: 		Lcd_Out(2, 1, strConstCpy(Coffee));
	MOVF       hotDrink_Coffee_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Coffee_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,440 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,441 :: 		currentHotDrink=1;
	MOVLW      1
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,442 :: 		}
	GOTO       L_hotDrink69
L_hotDrink68:
;embed1.c,443 :: 		else if(currentHotDrink==3)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink120
	MOVLW      3
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink120:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink70
;embed1.c,447 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,448 :: 		currentHotDrink=4;
	MOVLW      4
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,449 :: 		}
	GOTO       L_hotDrink71
L_hotDrink70:
;embed1.c,450 :: 		else if(currentHotDrink==2)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink121
	MOVLW      2
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink121:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink72
;embed1.c,453 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,454 :: 		Lcd_Out(1, 1, strConstCpy(Chocolate));
	MOVF       hotDrink_Chocolate_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Chocolate_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,455 :: 		Lcd_Out(2, 1, strConstCpy(Soup));
	MOVF       hotDrink_Soup_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_Soup_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,457 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,458 :: 		currentHotDrink=3;
	MOVLW      3
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,459 :: 		}
	GOTO       L_hotDrink73
L_hotDrink72:
;embed1.c,461 :: 		else if(currentHotDrink==1)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink122
	MOVLW      1
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink122:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink74
;embed1.c,464 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,465 :: 		currentHotDrink=2;
	MOVLW      2
	MOVWF      hotDrink_currentHotDrink_L0+0
	MOVLW      0
	MOVWF      hotDrink_currentHotDrink_L0+1
;embed1.c,466 :: 		}
L_hotDrink74:
L_hotDrink73:
L_hotDrink71:
L_hotDrink69:
;embed1.c,467 :: 		}
	GOTO       L_hotDrink75
L_hotDrink67:
;embed1.c,470 :: 		else if (PORTD.B2==0)
	BTFSC      PORTD+0, 2
	GOTO       L_hotDrink76
;embed1.c,473 :: 		if(currentHotDrink==1)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink123
	MOVLW      1
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink123:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink77
;embed1.c,476 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,477 :: 		Lcd_Out(1, 1, strConstCpy(teaPriceMsg));
	MOVF       hotDrink_teaPriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_teaPriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,478 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,479 :: 		return 80;
	MOVLW      80
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_hotDrink
;embed1.c,480 :: 		}
L_hotDrink77:
;embed1.c,481 :: 		else if(currentHotDrink==2)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink124
	MOVLW      2
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink124:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink79
;embed1.c,484 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,485 :: 		Lcd_Out(1, 1, strConstCpy(coffeePriceMsg));
	MOVF       hotDrink_coffeePriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_coffeePriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,486 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,487 :: 		return 90;
	MOVLW      90
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_hotDrink
;embed1.c,488 :: 		}
L_hotDrink79:
;embed1.c,490 :: 		else if(currentHotDrink==3)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink125
	MOVLW      3
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink125:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink81
;embed1.c,492 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,493 :: 		Lcd_Out(1, 1, strConstCpy(ChocolatePriceMsg));
	MOVF       hotDrink_ChocolatePriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_ChocolatePriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,494 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,495 :: 		return 65;
	MOVLW      65
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_hotDrink
;embed1.c,496 :: 		}
L_hotDrink81:
;embed1.c,498 :: 		else if(currentHotDrink==4)
	MOVLW      0
	XORWF      hotDrink_currentHotDrink_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__hotDrink126
	MOVLW      4
	XORWF      hotDrink_currentHotDrink_L0+0, 0
L__hotDrink126:
	BTFSS      STATUS+0, 2
	GOTO       L_hotDrink83
;embed1.c,500 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,501 :: 		Lcd_Out(1, 1, strConstCpy(soupPriceMsg));
	MOVF       hotDrink_soupPriceMsg_L0+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       hotDrink_soupPriceMsg_L0+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,502 :: 		Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
	MOVF       _insertCoinMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _insertCoinMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,503 :: 		return 70;
	MOVLW      70
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	GOTO       L_end_hotDrink
;embed1.c,504 :: 		}
L_hotDrink83:
;embed1.c,506 :: 		}
L_hotDrink76:
L_hotDrink75:
L_hotDrink66:
;embed1.c,508 :: 		}while(1);
	GOTO       L_hotDrink55
;embed1.c,509 :: 		}
L_end_hotDrink:
	RETURN
; end of _hotDrink

_returnAllMoney:

;embed1.c,516 :: 		void returnAllMoney()
;embed1.c,522 :: 		TMR0=0x00; // start the Timer
	CLRF       TMR0+0
;embed1.c,523 :: 		INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
	MOVLW      160
	MOVWF      INTCON+0
;embed1.c,524 :: 		OPTION_REG = 0x07; // set prescaler to 256: for timer
	MOVLW      7
	MOVWF      OPTION_REG+0
;embed1.c,525 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,526 :: 		Lcd_Out(1, 1, strConstCpy(timeOutMsg));
	MOVF       _timeOutMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _timeOutMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,527 :: 		Lcd_Out(2, 1, strConstCpy(returnMoneyMsg));
	MOVF       _returnMoneyMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _returnMoneyMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,528 :: 		PORTD.B7 = 1; //enable the LED
	BSF        PORTD+0, 7
;embed1.c,529 :: 		returnMoneyTimeOut=0;
	CLRF       _returnMoneyTimeOut+0
;embed1.c,530 :: 		returnMoneyFlag=1;
	MOVLW      1
	MOVWF      _returnMoneyFlag+0
;embed1.c,531 :: 		while(returnMoneyTimeOut==0)
L_returnAllMoney84:
	MOVF       _returnMoneyTimeOut+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_returnAllMoney85
;embed1.c,533 :: 		Delay_ms(1000);   // wait for someTime
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_returnAllMoney86:
	DECFSZ     R13+0, 1
	GOTO       L_returnAllMoney86
	DECFSZ     R12+0, 1
	GOTO       L_returnAllMoney86
	DECFSZ     R11+0, 1
	GOTO       L_returnAllMoney86
	NOP
	NOP
;embed1.c,534 :: 		}
	GOTO       L_returnAllMoney84
L_returnAllMoney85:
;embed1.c,537 :: 		PORTD.B7 = 0;
	BCF        PORTD+0, 7
;embed1.c,538 :: 		returnMoneyFlag=0;
	CLRF       _returnMoneyFlag+0
;embed1.c,539 :: 		returnMoneyTimeOut=0;
	CLRF       _returnMoneyTimeOut+0
;embed1.c,540 :: 		TMR0=0x00;
	CLRF       TMR0+0
;embed1.c,541 :: 		INTCON=0x00;
	CLRF       INTCON+0
;embed1.c,542 :: 		OPTION_REG = 0x00;
	CLRF       OPTION_REG+0
;embed1.c,545 :: 		}
L_end_returnAllMoney:
	RETURN
; end of _returnAllMoney

_main:

;embed1.c,549 :: 		void main()
;embed1.c,551 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;embed1.c,553 :: 		TRISD=0x1F;
	MOVLW      31
	MOVWF      TRISD+0
;embed1.c,555 :: 		PORTD.B7 = 0;
	BCF        PORTD+0, 7
;embed1.c,557 :: 		Lcd_Out(1, 1, strConstCpy(ColdDrinkMsg));
	MOVF       _ColdDrinkMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _ColdDrinkMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,558 :: 		Lcd_Out(2, 1, strConstCpy(HotDrinkMsg));
	MOVF       _HotDrinkMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _HotDrinkMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,561 :: 		Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
	MOVLW      15
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,562 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,563 :: 		TRISD=0x1F;
	MOVLW      31
	MOVWF      TRISD+0
;embed1.c,565 :: 		do
L_main87:
;embed1.c,567 :: 		if (PORTD.B0==0)
	BTFSC      PORTD+0, 0
	GOTO       L_main90
;embed1.c,570 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,571 :: 		currentCursor=1;
	MOVLW      1
	MOVWF      _currentCursor+0
	MOVLW      0
	MOVWF      _currentCursor+1
;embed1.c,572 :: 		delay();
	CALL       _delay+0
;embed1.c,574 :: 		}
	GOTO       L_main91
L_main90:
;embed1.c,575 :: 		else if (PORTD.B1==0)
	BTFSC      PORTD+0, 1
	GOTO       L_main92
;embed1.c,579 :: 		Lcd_Cmd(_LCD_SECOND_ROW);
	MOVLW      192
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,580 :: 		currentCursor=2;
	MOVLW      2
	MOVWF      _currentCursor+0
	MOVLW      0
	MOVWF      _currentCursor+1
;embed1.c,581 :: 		delay();
	CALL       _delay+0
;embed1.c,583 :: 		}
	GOTO       L_main93
L_main92:
;embed1.c,585 :: 		else if (PORTD.B2==0)
	BTFSC      PORTD+0, 2
	GOTO       L_main94
;embed1.c,587 :: 		delay();
	CALL       _delay+0
;embed1.c,591 :: 		if(currentCursor!=1)
	MOVLW      0
	XORWF      _currentCursor+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main129
	MOVLW      1
	XORWF      _currentCursor+0, 0
L__main129:
	BTFSC      STATUS+0, 2
	GOTO       L_main95
;embed1.c,592 :: 		totalCost=hotDrink();
	CALL       _hotDrink+0
	MOVF       R0+0, 0
	MOVWF      _totalCost+0
	MOVF       R0+1, 0
	MOVWF      _totalCost+1
	GOTO       L_main96
L_main95:
;embed1.c,594 :: 		totalCost=coldDrink();
	CALL       _coldDrink+0
	MOVF       R0+0, 0
	MOVWF      _totalCost+0
	MOVF       R0+1, 0
	MOVWF      _totalCost+1
L_main96:
;embed1.c,595 :: 		handlePayment(totalCost);
	MOVF       _totalCost+0, 0
	MOVWF      FARG_handlePayment_amount+0
	MOVF       _totalCost+1, 0
	MOVWF      FARG_handlePayment_amount+1
	CALL       _handlePayment+0
;embed1.c,597 :: 		currentCursor=1;
	MOVLW      1
	MOVWF      _currentCursor+0
	MOVLW      0
	MOVWF      _currentCursor+1
;embed1.c,599 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,600 :: 		Lcd_Out(1, 1, strConstCpy(ColdDrinkMsg));
	MOVF       _ColdDrinkMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _ColdDrinkMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,601 :: 		Lcd_Out(2, 1, strConstCpy(HotDrinkMsg));
	MOVF       _HotDrinkMsg+0, 0
	MOVWF      FARG_strConstCpy_ctxt+0
	MOVF       _HotDrinkMsg+1, 0
	MOVWF      FARG_strConstCpy_ctxt+1
	CALL       _strConstCpy+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;embed1.c,605 :: 		Lcd_Cmd(_LCD_FIRST_ROW);
	MOVLW      128
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;embed1.c,607 :: 		}
L_main94:
L_main93:
L_main91:
;embed1.c,610 :: 		}while(1);
	GOTO       L_main87
;embed1.c,615 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
