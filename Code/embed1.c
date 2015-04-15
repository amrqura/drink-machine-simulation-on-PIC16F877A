void welcomeScreen();
  int coldDrink();
   void delay();
   void handlePayment(int amount);
    int hotDrink();
    void returnAllMoney();
    char* strConstCpy(const char* ctxt);
//  char* strConstCpy(const char* ctxt);

       sbit LCD_RS at RB0_bit;
       sbit LCD_EN at RB1_bit;
       sbit LCD_D4 at RB2_bit;
       sbit LCD_D5 at RB3_bit;
       sbit LCD_D6 at RB4_bit;
       sbit LCD_D7 at RB5_bit;
       // Pin direction
       sbit LCD_RS_Direction at TRISB0_bit;
       sbit LCD_EN_Direction at TRISB1_bit;
       sbit LCD_D4_Direction at TRISB2_bit;
       sbit LCD_D5_Direction at TRISB3_bit;
       sbit LCD_D6_Direction at TRISB4_bit;
       sbit LCD_D7_Direction at TRISB5_bit;

char returnMoneyTimeOutTotalCount = 0;
char returnMoneyFlag=0;
char returnMoneyTimeOut=0;

char paymentFlag=0;    // flag to inform the interrupt that looking for payment
char PaymentTimeOut=0; // show if the payment timeout or not
char totalPaymentTimeOutCounter=0;

char DrinkDispensedMsgFlag=0;
char DrinkDispensedMsgTimeOut=0;
char totalDrinkDispensedMsgTimeOutCounter=0;


void interrupt () // TMR0 overflow has caused an interrupt
{


  if(INTCON.T0IF)
  {
   // ask for payment time out: 5 second
   if(paymentFlag==1)
   {
    // payment timeout
    if(totalPaymentTimeOutCounter>=100)
    {
       TMR0=0x00; // reset the Timer
       totalPaymentTimeOutCounter=0;
       PaymentTimeOut=1;
       return;
    }
   INTCON.T0IF=0;
   totalPaymentTimeOutCounter++;
   return;
   }


   else if(returnMoneyFlag==1)
   {
    if(returnMoneyTimeOutTotalCount>=100)
    {

      // reset the timer
      TMR0=0x00; // reset the Timer
      returnMoneyTimeOutTotalCount=0;
      returnMoneyTimeOut=1;
      return;
    }
    INTCON.T0IF=0;
    returnMoneyTimeOutTotalCount++;
    return;
  }

  else if(DrinkDispensedMsgFlag==1)
   {
    if(totalDrinkDispensedMsgTimeOutCounter>=60)
    {

      // reset the timer
      TMR0=0x00; // reset the Timer
      totalDrinkDispensedMsgTimeOutCounter=0;
      DrinkDispensedMsgTimeOut=1;
      return;
    }
    INTCON.T0IF=0;
    totalDrinkDispensedMsgTimeOutCounter++;
    return;
  }


  }


}
// delay function
 void delay()
 {
    Delay_ms(300);
    //unsigned int i;
    //for(i=0; i<32000;i++); // wait for a while
    //return;
 }


int accessReturnLoop;
int loopVar;
int totalAccumulatedPayment=0;
// handle payment
const char *paymentFinishMsg="payment finish";
const char *returnAccessMsg="return excess";
const char *thankYouMsg="Drink dispensed";

char * totalVal;
void handlePayment(int amount)
{



 paymentFlag=1;
 totalAccumulatedPayment=0;
 PaymentTimeOut=0;
  TMR0=0x00; // start the Timer
  INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
  OPTION_REG = 0x07; // set prescaler to 256: for timer
  while(PaymentTimeOut==0)
  {
    //delay();
    Delay_ms(200);
   // 5 Penny is paied
   if (PORTD.B0==0)
   {
    delay();
    totalAccumulatedPayment+=5;
   }
   // 10 penny is paied
   else if (PORTD.B1==0)
   {
    delay();
    totalAccumulatedPayment+=10;
   }
   // 20 penny is paied
   else if (PORTD.B2==0)
   {
    delay();
    totalAccumulatedPayment+=20;
   }
   // 50 penny is paied
   else if (PORTD.B3==0)
   {
    delay();
    totalAccumulatedPayment+=50;
   }
   // 100 penny is paied
   else if (PORTD.B4==0)
   {
    delay();
    totalAccumulatedPayment+=100;
   }

    if(totalAccumulatedPayment>=amount) // get all money
    {
         Lcd_Cmd(_LCD_CLEAR);
         Lcd_Out(1, 1, strConstCpy(returnAccessMsg));
         Lcd_Out(2, 1, strConstCpy(paymentFinishMsg));

         // return back rest of money

         //IntToStr(totalAccumulatedPayment, totalVal);
         //delay(); delay(); delay();

         for(loopVar=amount;loopVar<totalAccumulatedPayment;loopVar+=5)
         {

                PORTD.B7 = 1;
                delay();delay();delay();
                PORTD.B7 = 0;
                delay();delay();delay();

         }
         Lcd_Cmd(_LCD_CLEAR);
         Lcd_Out(1, 1, strConstCpy(thankYouMsg));
         //delay();
         paymentFlag=0;
         PaymentTimeOut=0;

         DrinkDispensedMsgFlag=1;
         DrinkDispensedMsgTimeOut=0;
         totalDrinkDispensedMsgTimeOutCounter=0;

         TMR0=0x00; // start the Timer
         INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
         OPTION_REG = 0x07; // set prescaler to 256: for timer
         while(DrinkDispensedMsgTimeOut==0)
         {
            delay();
         }
         return;
    }
  }
  // time out with no money
  paymentFlag=0;  // reset flag
  PaymentTimeOut=0; // reset counter
  // reset timer
  INTCON=0x00;
  OPTION_REG = 0x00;
  //TMR0=0x00; // start the Timer
  returnAllMoney();
  if(returnMoneyTimeOut!=0)
  {
     returnMoneyTimeOut=0;

  }
  //Lcd_Cmd(_LCD_CLEAR);
  //Lcd_Out(1, 1, "Amoor");
//  delay(); delay(); delay(); delay(); delay(); delay();delay(); delay();delay(); delay();
  return; // return from handlePayment to welcome screen because of time out
}




 char* strConstCpy(const char* ctxt){
  static char txt[20];
  char i;
  for(i =0; txt[i] = ctxt[i]; i++);

  return txt;
}


const char *insertCoinMsg="Insert Money";
 // handle cold Drink
  int coldDrink()
 {
      int currentColdDrink=1;
      const char *orange = "Orange juice";
      const char *Fizzy = "Fizzy drink";
      const char *waterMsg = "water";
      const char *orangePriceMsg="Orange juice=50 P";
      const char *fizzyPriceMsg="Fizzy drink=50 P";
      const char *waterPriceMsg="Water=75 P";

      Lcd_Cmd(_LCD_CLEAR);
      Lcd_Out(1, 1, strConstCpy(orange));
      Lcd_Out(2, 1, strConstCpy(Fizzy));
      Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
      Lcd_Cmd(_LCD_FIRST_ROW);
      do
      {
       // press up
       if (PORTD.B0==0)
       {
        delay();
        // go up
        if(currentColdDrink==3)
        {
          // redraw screen
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(orange));
          Lcd_Out(2, 1, strConstCpy(Fizzy));
          // go to second
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentColdDrink=2;
        }
        else if(currentColdDrink==2)
        {
          // go to first
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentColdDrink=1;
        }

        else if(currentColdDrink==1)
        {
          // redraw screen, go to fourth
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(waterMsg));
          // go to second
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentColdDrink=3;
        }


       }
       // end if

       // press down
       else if (PORTD.B1==0)
       {

        delay();
        // go down

         if(currentColdDrink==3)
        {
          // redraw screen
          // go to first

          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(orange));
          Lcd_Out(2, 1, strConstCpy(Fizzy));
          // go to first
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentColdDrink=1;
        }
        else if(currentColdDrink==2)
        {
          // redraw screen, go to third
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(waterMsg));
          // go to first
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentColdDrink=3;
        }

        else if(currentColdDrink==1)
        {
          // go to second
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentColdDrink=2;
        }
       }
       // end if

       else if (PORTD.B2==0)
      {
       // selection button
          int cost=0;
         if(currentColdDrink==1)
         {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, strConstCpy(orangePriceMsg));
            Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
            return 50;
         }
         else if(currentColdDrink==2)
         {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, strConstCpy(fizzyPriceMsg));
            Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
            return 50;
         }

        else if(currentColdDrink==3)
        {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, strConstCpy(waterPriceMsg));
            Lcd_Out(2, 1, strConstCpy(insertCoinMsg));

            return 75;
         }
      }
      }while(1);


 }



 int hotDrink()
 {
     int currentHotDrink=1;

      const char *Tea = "Tea";
      const char *Coffee = "Coffee";
      const char *Chocolate = "Chocolate";
      const char *Soup = "Soup";


     const char *teaPriceMsg="Tea=80 P";
     const char *coffeePriceMsg="Coffee=90 P";
     const char *ChocolatePriceMsg="Chocolate=65 P";
     const char *soupPriceMsg="Soup=70 P";


      Lcd_Cmd(_LCD_CLEAR);

      Lcd_Out(1, 1, strConstCpy(Tea));
      Lcd_Out(2, 1, strConstCpy(Coffee));
      Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
      Lcd_Cmd(_LCD_FIRST_ROW);
      do
      {
          // press up
       if (PORTD.B0==0)
       {
        delay();
        // go up
        if(currentHotDrink==4)
        {
          // go to third
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentHotDrink=3;
        }
        else if(currentHotDrink==3)
        {
          // redraw screen
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(Tea));
          Lcd_Out(2, 1, strConstCpy(Coffee));
          // go to second
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentHotDrink=2;
        }
        else if(currentHotDrink==2)
        {
          // go to first
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentHotDrink=1;
        }

        else if(currentHotDrink==1)
        {
          // redraw screen, go to fourth
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(Chocolate));
          Lcd_Out(2, 1, strConstCpy(Soup));
          // go to second
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentHotDrink=4;
        }


       }
       // end if
       else if (PORTD.B1==0)
       {
       // press down
        delay();
        // go down
        if(currentHotDrink==4)
        {
          // redraw , go to one
          // go to third
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(Tea));
          Lcd_Out(2, 1, strConstCpy(Coffee));
          // go to first
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentHotDrink=1;
        }
        else if(currentHotDrink==3)
        {

          // go to fourth
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentHotDrink=4;
        }
        else if(currentHotDrink==2)
        {
          // redraw screen, go to third
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(Chocolate));
          Lcd_Out(2, 1, strConstCpy(Soup));
          // go to second
          Lcd_Cmd(_LCD_FIRST_ROW);
          currentHotDrink=3;
        }

        else if(currentHotDrink==1)
        {
          // go to second
          Lcd_Cmd(_LCD_SECOND_ROW);
          currentHotDrink=2;
        }
       }
       // end if

      else if (PORTD.B2==0)
      {
       // selection button
         if(currentHotDrink==1)
         {
         //tea
         Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(teaPriceMsg));
          Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
          return 80;
         }
         else if(currentHotDrink==2)
         {
             // coffee
           Lcd_Cmd(_LCD_CLEAR);
           Lcd_Out(1, 1, strConstCpy(coffeePriceMsg));
           Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
           return 90;
         }

        else if(currentHotDrink==3)
        {
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1, 1, strConstCpy(ChocolatePriceMsg));
          Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
          return 65;
        }

        else if(currentHotDrink==4)
          {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, strConstCpy(soupPriceMsg));
            Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
            return 70;
          }

      }

      }while(1);
 }
  int totalCost=0;
 // for welcome screen
 // return money
const char *timeOutMsg="Time Out";
const char *returnMoneyMsg="return Money";

void returnAllMoney()
{
   // should keep the LED open for 5 seconds
   //const char *timeOutMsg = "Time Out";
   //const char *returnMoneyMsg = "return money";

   TMR0=0x00; // start the Timer
  INTCON=0xa0; // configure interrupts 1010 0000, ensable GIE,T0IE
  OPTION_REG = 0x07; // set prescaler to 256: for timer
   Lcd_Cmd(_LCD_CLEAR);
   Lcd_Out(1, 1, strConstCpy(timeOutMsg));
   Lcd_Out(2, 1, strConstCpy(returnMoneyMsg));
   PORTD.B7 = 1; //enable the LED
   returnMoneyTimeOut=0;
   returnMoneyFlag=1;
   while(returnMoneyTimeOut==0)
   {
       Delay_ms(1000);   // wait for someTime
   }

   // after finish, turn the LED off
   PORTD.B7 = 0;
   returnMoneyFlag=0;
   returnMoneyTimeOut=0;
   TMR0=0x00;
   INTCON=0x00;
   OPTION_REG = 0x00;

   //goto jump;
}
   int currentCursor=1;
   const char *ColdDrinkMsg = "Cold drink";
   const char *HotDrinkMsg = "Hot drink";
void main()
 {
       Lcd_Init();
       //Note that 0 indicates an output and 1 indicates an input.
       TRISD=0x1F;

       PORTD.B7 = 0;

       Lcd_Out(1, 1, strConstCpy(ColdDrinkMsg));
       Lcd_Out(2, 1, strConstCpy(HotDrinkMsg));


       Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
       Lcd_Cmd(_LCD_FIRST_ROW);
       TRISD=0x1F;

      do
      {
         if (PORTD.B0==0)
         {

           Lcd_Cmd(_LCD_FIRST_ROW);
           currentCursor=1;
           delay();

         }
         else if (PORTD.B1==0)
         {
          // move down

          Lcd_Cmd(_LCD_SECOND_ROW);
          currentCursor=2;
          delay();

         }

         else if (PORTD.B2==0)
         {
         delay();



             if(currentCursor!=1)
                  totalCost=hotDrink();
             else
                 totalCost=coldDrink();
             handlePayment(totalCost);
             // after return back from handlePayment , make welcome screen again
             currentCursor=1;

             Lcd_Cmd(_LCD_CLEAR);
             Lcd_Out(1, 1, strConstCpy(ColdDrinkMsg));
             Lcd_Out(2, 1, strConstCpy(HotDrinkMsg));


             //Lcd_Cmd(_LCD_BLINK_CURSOR_ON);
             Lcd_Cmd(_LCD_FIRST_ROW);
               //TRISD=0x1F;
         }


      }while(1);




 }