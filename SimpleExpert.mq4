//+------------------------------------------------------------------+
//|                                                 SimpleExpert.mq4 |
//|                                    strokovalexander.fx@gmail.com |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "strokovalexander.fx@gmail.com"
#property link      ""
#property version   "1.00"
#property strict
//--- input parameters
extern int Hours=23;
extern int Minutes=25;
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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string OrderT;
string OrderTT;
string OrderTTT;
string OrderTTTT;
bool OpenOrder=false;
int k;
int init(){
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);}



int start()
  {

  
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
ObjectSetText("label_object4",OrderTTTT,18,"Arial",Green);

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



if (BuyOrSell==true){OrderT="buy";} else {OrderT="sell";}
if (OrderTyp==0){OrderTT="С рынка";} 
if (OrderTyp==1){OrderTT="Лимит";} 
if (OrderTyp==2){OrderTT="Стоп";} 
if (MoreOrLess==true){OrderTTT="Выше фильтра";} else {OrderTTT="Ниже фильтра";}
if ((Hours<Hour())&&(Minutes<Minute())&& (OpenOrder==false)){ OrderTTTT="Назначенное время прошло,ордер не открыт!";}
if ((Hours<Hour())&&(Minutes<Minute())&& (OpenOrder==true)){ OrderTTTT="Назначенное время прошло,ордер открыт!";}
if ((Hours>Hour())&&(Minutes>Minute())&& (OpenOrder==false)){ OrderTTTT="Назначенное время еще не настало,ордер не открыт!";}
if ((Hours>Hour())&&(Minutes>Minute())&& (OpenOrder==true)){ OrderTTTT="Назначенное время еще не настало,ордер открыт!";}

RefreshRates();
if ((Hours==Hour())&&(Minutes==Minute())&&(OpenOrder==false))
{
   if ((MoreOrLess==true)&&(Ask>NormalizeDouble(Filter,5))){
   Print("!");
      if ((BuyOrSell==true)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot,Ask-Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
       if ((BuyOrSell==true)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,Ask+Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }                                           
      if ((BuyOrSell==false)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
      if ((BuyOrSell==false)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot,Bid+Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
       if ((BuyOrSell==false)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot,Bid-Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }                                           
                                       }
                                       
                                       
   if ((MoreOrLess==false)&&(Ask<NormalizeDouble(Filter,5))){
      if ((BuyOrSell==true)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot,Ask-Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,Ask+Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }                                            
      if ((BuyOrSell==false)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }
      if ((BuyOrSell==false)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot,Bid+Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }       
      if ((BuyOrSell==false)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot,Bid-Otstup*Point*k,3*k,NULL,NULL,NULL,Magic_Number,0,Red) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }}
                                            }    





   }















}


  if(!isNewBar())return(0);
 
 
   
   
return(0);}   
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