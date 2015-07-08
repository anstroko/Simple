//+------------------------------------------------------------------+
//|                                                 SimpleExpert.mq4 |
//|                                    strokovalexander.fx@gmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "strokovalexander.fx@gmail.com"
#property link      ""
#property version   "1.00"
#property strict
#include <WinUser32.mqh>
//--- input parameters
extern int Hours=23;
extern int Minutes=25;
extern double TP_points=0;
extern double SL_points=1.3000;
extern double CancellPrice=1.3100;
extern double VirtualDepo=1200;
extern double RiskOnTreid=1;
extern bool MM=true;
extern string   Type="true=buy,false=sell";
extern bool     BuyOrSell=true;
extern string   Order="0=buy/sell,1=limit,2=stop";
extern int OrderTyp=0;
extern int Otstup=5;
extern string FilterDirection="true=More,false=Less";
extern bool MoreOrLess=true;
extern double Filter=1.5;
extern double Lot=0.01;
extern int Magic_Number=12345;
extern string Comments="Default";
extern bool CloseTerminal=true;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string OrderT;
string OrderTT;
string OrderTTT;
string OrderTTTT;
int CurrentMinute;
int CurrentHour;
bool OpenOrder=false;
double Koef=1;
double CurSum;
double RiskSumm;

int k;
int kk;
double S;
int init(){
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   if (Digits==2){kk=100;}
     if (Digits==3){kk=1000;}
       if (Digits==4){kk=10000;}
          if (Digits==5){kk=10000;}
   StoimPunkt();
   
   
   return(0);}



int start()
  {

CurrentHour=Hour();
CurrentMinute=Minute();

    
    
    
 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Выставление нового ордера "+Hours+":"+Minutes,12,"Arial",Blue);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","Направление ордера-"+OrderT+" ;Тип ордера-"+OrderTT,12,"Arial",Blue);
   

ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","Ждем закрытие-"+OrderTTT+" ;Фильтр-"+ NormalizeDouble(Filter,5),12,"Arial",Blue);


ObjectCreate("label_object4",OBJ_LABEL,0,0,0);
ObjectSet("label_object4",OBJPROP_CORNER,4);
ObjectSet("label_object4",OBJPROP_XDISTANCE,10);
ObjectSet("label_object4",OBJPROP_YDISTANCE,70);
ObjectSetText("label_object4",OrderTTTT,16,"Arial",Green);

ObjectCreate("label_object5",OBJ_LABEL,0,0,0);
ObjectSet("label_object5",OBJPROP_CORNER,4);
ObjectSet("label_object5",OBJPROP_XDISTANCE,10);
ObjectSet("label_object5",OBJPROP_YDISTANCE,90);
ObjectSetText("label_object5","Стоимость пункта "+Symbol()+"="+DoubleToString(S,2)+"; Риск в сделке "+DoubleToString(RiskSumm,2)+"("+RiskOnTreid+"%)",18,"Arial",Green);

 OpenOrder=false;
   for(int inn=0;inn<OrdersTotal();inn++)
     {      if(OrderSelect(inn,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
           OpenOrder=true;
           
    
           }
        }
     }


RiskSumm=(AccountBalance()+VirtualDepo)*RiskOnTreid/100;
if (BuyOrSell==true){OrderT="buy";} else {OrderT="sell";}
if (OrderTyp==0){OrderTT="С рынка";} 
if (OrderTyp==1){OrderTT="Лимит";} 
if (OrderTyp==2){OrderTT="Стоп";} 
if (MoreOrLess==true){OrderTTT="Выше фильтра";} else {OrderTTT="Ниже фильтра";}
if ((Hours<=CurrentHour)&&(Minutes<CurrentMinute)&& (OpenOrder==false)){ OrderTTTT="Назначенное время прошло,ордер не открыт!"; if (CloseTerminal==true){PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
if ((Hours<=CurrentHour)&&(Minutes<CurrentMinute)&& (OpenOrder==true)){ OrderTTTT="Назначенное время прошло,ордер открыт!";}
if ((Hours>=CurrentHour)&&(Minutes>CurrentMinute)&& (OpenOrder==false)){ OrderTTTT="Назначенное время еще не настало,ордер не открыт!";}
if ((Hours>=CurrentHour)&&(Minutes>CurrentMinute)&& (OpenOrder==true)){ OrderTTTT="Назначенное время еще не настало,ордер открыт!";}

RefreshRates();
if ((Hours==Hour())&&(Minutes==Minute())&&(OpenOrder==false))
{ Print("Назначенное время наступило");
  
   if ((MoreOrLess==true)&&(Bid>NormalizeDouble(Filter,5))){
     
      Print("Цена ",Bid+" больше фильтра ",+Filter+" Открываем ордер в зависимости от условий");
   if ((Bid>CancellPrice)&&(CancellPrice!=0)){Print("Цена превышает CancellPrice ",CancellPrice+" Ордер не открываем");Sleep (6000);}

      if ((BuyOrSell==true)&&((Bid<CancellPrice)||(CancellPrice==0))&&(OrderTyp==0)){ 
      
      if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();}
      if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot*Koef,Ask,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 

      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&((Bid<CancellPrice)||(CancellPrice==0))&&(OrderTyp==1)){ 
       if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();}
      if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot*Koef,Ask-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
       if ((BuyOrSell==true)&&((Bid<CancellPrice)||(CancellPrice==0))&&(OrderTyp==2)){
        if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot*Koef,Ask+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }                                           
      if ((BuyOrSell==false)&&((Bid<CancellPrice)||(CancellPrice!=0))&&(OrderTyp==0)){ 
       if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();}if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot*Koef,Bid,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==false)&&((Bid<CancellPrice)||(CancellPrice==0))&&(OrderTyp==1)){
         if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot*Koef,Bid+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
       if ((BuyOrSell==false)&&((Bid<CancellPrice)||(CancellPrice==0))&&(OrderTyp==2)){
          if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot*Koef,Bid-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            } 
                                            Sleep (3000);                                          
                                       }
                                   
                                   
   if ((MoreOrLess==false)&&(Bid<NormalizeDouble(Filter,5))){

      Print("Цена ",Bid+" меньше фильтра ",+Filter+" Открываем ордер в зависимости от условий");
               if ((Bid<CancellPrice)&&(CancellPrice!=0)){Print("Цена меньше CancellPrice ",CancellPrice+" Ордер не открываем"); Sleep (6000);}
      if ((BuyOrSell==true)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==0)){
        if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot*Koef,Ask,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 

      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==1)){ 
        if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();}if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot*Koef,Ask-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==2)){
         if ((MM==true)&&(SL_points!=0)){MMTrueFunctionBuy();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot*Koef,Ask+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }                                            
      if ((BuyOrSell==false)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==0)){
         if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot*Koef,Bid,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==false)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==1)){
         if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();} if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot*Koef,Bid+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }       
      if ((BuyOrSell==false)&&((Bid>CancellPrice)||(CancellPrice==0))&&(OrderTyp==2)){ 
         if ((MM==true)&&(SL_points!=0)){MMTrueFunctionSell();}if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot*Koef,Bid-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      } 
     else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}
      
      }}
    

Sleep (3000);

}Sleep (2000);
}

  if(!isNewBar())return(0);
 
 
   
   
return(0);}   



//------------------------------------------------------
double MMTrueFunctionBuy ()
{ RiskSumm=(AccountBalance()+VirtualDepo)*RiskOnTreid/100;

CurSum=0;
Koef=1;
while (RiskSumm>CurSum)
{CurSum=(Bid-SL_points)*kk*Koef*Lot*S*10;
Koef=Koef+0.1;
Print(Koef);
}


return (Koef);}


double MMTrueFunctionSell ()
{ RiskSumm=(AccountBalance()+VirtualDepo)*RiskOnTreid/100;

CurSum=0;
Koef=1;
while (RiskSumm>CurSum)
{CurSum=(SL_points-Bid)*kk*Koef*Lot*S*10;
Koef=Koef+0.1;
Print(Koef);
}


return (Koef);}


double StoimPunkt()
{RefreshRates();
if(MarketInfo(Symbol(),MODE_TICKVALUE)!=0&&MarketInfo(Symbol(),MODE_TICKSIZE)!=0&&MarketInfo(Symbol(),MODE_POINT)!=0){
S = MarketInfo(Symbol(),MODE_TICKVALUE)/(MarketInfo(Symbol(),MODE_TICKSIZE)/MarketInfo(Symbol(),MODE_POINT));}
return(S);}
//

   bool isNewBar()
  {
  static datetime BarTime;  
   bool res=false;
    
   if (BarTime!=Time[0]) 
      {
         BarTime=Time[0];  
         res=true;
      } 
   return(res);
  }