#line 1 "C:/Users/amr koura/Desktop/assignment/Code/embed1.c"
void welcomeScreen();
 int coldDrink();
 void delay();
 void handlePayment(int amount);
 int hotDrink();
 void returnAllMoney();
 char* strConstCpy(const char* ctxt);


 sbit LCD_RS at RB0_bit;
 sbit LCD_EN at RB1_bit;
 sbit LCD_D4 at RB2_bit;
 sbit LCD_D5 at RB3_bit;
 sbit LCD_D6 at RB4_bit;
 sbit LCD_D7 at RB5_bit;

 sbit LCD_RS_Direction at TRISB0_bit;
 sbit LCD_EN_Direction at TRISB1_bit;
 sbit LCD_D4_Direction at TRISB2_bit;
 sbit LCD_D5_Direction at TRISB3_bit;
 sbit LCD_D6_Direction at TRISB4_bit;
 sbit LCD_D7_Direction at TRISB5_bit;

char returnMoneyTimeOutTotalCount = 0;
char returnMoneyFlag=0;
char returnMoneyTimeOut=0;

char paymentFlag=0;
char PaymentTimeOut=0;
char totalPaymentTimeOutCounter=0;

char DrinkDispensedMsgFlag=0;
char DrinkDispensedMsgTimeOut=0;
char totalDrinkDispensedMsgTimeOutCounter=0;


void interrupt ()
{


 if(INTCON.T0IF)
 {

 if(paymentFlag==1)
 {

 if(totalPaymentTimeOutCounter>=100)
 {
 TMR0=0x00;
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


 TMR0=0x00;
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


 TMR0=0x00;
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

 void delay()
 {
 Delay_ms(300);



 }


int accessReturnLoop;
int loopVar;
int totalAccumulatedPayment=0;

const char *paymentFinishMsg="payment finish";
const char *returnAccessMsg="return excess";
const char *thankYouMsg="Drink dispensed";

char * totalVal;
void handlePayment(int amount)
{



 paymentFlag=1;
 totalAccumulatedPayment=0;
 PaymentTimeOut=0;
 TMR0=0x00;
 INTCON=0xa0;
 OPTION_REG = 0x07;
 while(PaymentTimeOut==0)
 {

 Delay_ms(200);

 if (PORTD.B0==0)
 {
 delay();
 totalAccumulatedPayment+=5;
 }

 else if (PORTD.B1==0)
 {
 delay();
 totalAccumulatedPayment+=10;
 }

 else if (PORTD.B2==0)
 {
 delay();
 totalAccumulatedPayment+=20;
 }

 else if (PORTD.B3==0)
 {
 delay();
 totalAccumulatedPayment+=50;
 }

 else if (PORTD.B4==0)
 {
 delay();
 totalAccumulatedPayment+=100;
 }

 if(totalAccumulatedPayment>=amount)
 {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(returnAccessMsg));
 Lcd_Out(2, 1, strConstCpy(paymentFinishMsg));






 for(loopVar=amount;loopVar<totalAccumulatedPayment;loopVar+=5)
 {

 PORTD.B7 = 1;
 delay();delay();delay();
 PORTD.B7 = 0;
 delay();delay();delay();

 }
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(thankYouMsg));

 paymentFlag=0;
 PaymentTimeOut=0;

 DrinkDispensedMsgFlag=1;
 DrinkDispensedMsgTimeOut=0;
 totalDrinkDispensedMsgTimeOutCounter=0;

 TMR0=0x00;
 INTCON=0xa0;
 OPTION_REG = 0x07;
 while(DrinkDispensedMsgTimeOut==0)
 {
 delay();
 }
 return;
 }
 }

 paymentFlag=0;
 PaymentTimeOut=0;

 INTCON=0x00;
 OPTION_REG = 0x00;

 returnAllMoney();
 if(returnMoneyTimeOut!=0)
 {
 returnMoneyTimeOut=0;

 }



 return;
}




 char* strConstCpy(const char* ctxt){
 static char txt[20];
 char i;
 for(i =0; txt[i] = ctxt[i]; i++);

 return txt;
}


const char *insertCoinMsg="Insert Money";

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

 if (PORTD.B0==0)
 {
 delay();

 if(currentColdDrink==3)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(orange));
 Lcd_Out(2, 1, strConstCpy(Fizzy));

 Lcd_Cmd(_LCD_SECOND_ROW);
 currentColdDrink=2;
 }
 else if(currentColdDrink==2)
 {

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentColdDrink=1;
 }

 else if(currentColdDrink==1)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(waterMsg));

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentColdDrink=3;
 }


 }



 else if (PORTD.B1==0)
 {

 delay();


 if(currentColdDrink==3)
 {



 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(orange));
 Lcd_Out(2, 1, strConstCpy(Fizzy));

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentColdDrink=1;
 }
 else if(currentColdDrink==2)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(waterMsg));

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentColdDrink=3;
 }

 else if(currentColdDrink==1)
 {

 Lcd_Cmd(_LCD_SECOND_ROW);
 currentColdDrink=2;
 }
 }


 else if (PORTD.B2==0)
 {

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

 if (PORTD.B0==0)
 {
 delay();

 if(currentHotDrink==4)
 {

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentHotDrink=3;
 }
 else if(currentHotDrink==3)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(Tea));
 Lcd_Out(2, 1, strConstCpy(Coffee));

 Lcd_Cmd(_LCD_SECOND_ROW);
 currentHotDrink=2;
 }
 else if(currentHotDrink==2)
 {

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentHotDrink=1;
 }

 else if(currentHotDrink==1)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(Chocolate));
 Lcd_Out(2, 1, strConstCpy(Soup));

 Lcd_Cmd(_LCD_SECOND_ROW);
 currentHotDrink=4;
 }


 }

 else if (PORTD.B1==0)
 {

 delay();

 if(currentHotDrink==4)
 {


 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(Tea));
 Lcd_Out(2, 1, strConstCpy(Coffee));

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentHotDrink=1;
 }
 else if(currentHotDrink==3)
 {


 Lcd_Cmd(_LCD_SECOND_ROW);
 currentHotDrink=4;
 }
 else if(currentHotDrink==2)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(Chocolate));
 Lcd_Out(2, 1, strConstCpy(Soup));

 Lcd_Cmd(_LCD_FIRST_ROW);
 currentHotDrink=3;
 }

 else if(currentHotDrink==1)
 {

 Lcd_Cmd(_LCD_SECOND_ROW);
 currentHotDrink=2;
 }
 }


 else if (PORTD.B2==0)
 {

 if(currentHotDrink==1)
 {

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(teaPriceMsg));
 Lcd_Out(2, 1, strConstCpy(insertCoinMsg));
 return 80;
 }
 else if(currentHotDrink==2)
 {

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


const char *timeOutMsg="Time Out";
const char *returnMoneyMsg="return Money";

void returnAllMoney()
{




 TMR0=0x00;
 INTCON=0xa0;
 OPTION_REG = 0x07;
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(timeOutMsg));
 Lcd_Out(2, 1, strConstCpy(returnMoneyMsg));
 PORTD.B7 = 1;
 returnMoneyTimeOut=0;
 returnMoneyFlag=1;
 while(returnMoneyTimeOut==0)
 {
 Delay_ms(1000);
 }


 PORTD.B7 = 0;
 returnMoneyFlag=0;
 returnMoneyTimeOut=0;
 TMR0=0x00;
 INTCON=0x00;
 OPTION_REG = 0x00;


}
 int currentCursor=1;
 const char *ColdDrinkMsg = "Cold drink";
 const char *HotDrinkMsg = "Hot drink";
void main()
 {
 Lcd_Init();

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

 currentCursor=1;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, strConstCpy(ColdDrinkMsg));
 Lcd_Out(2, 1, strConstCpy(HotDrinkMsg));



 Lcd_Cmd(_LCD_FIRST_ROW);

 }


 }while(1);




 }
