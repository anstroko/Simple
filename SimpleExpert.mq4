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
int k;
double S;
int init(){
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
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
ObjectSetText("label_object1","����������� ������ ������ "+Hours+":"+Minutes,12,"Arial",Blue);


ObjectCreate("label_object2",OBJ_LABEL,0,0,0);
ObjectSet("label_object2",OBJPROP_CORNER,4);
ObjectSet("label_object2",OBJPROP_XDISTANCE,10);
ObjectSet("label_object2",OBJPROP_YDISTANCE,30);
ObjectSetText("label_object2","����������� ������-"+OrderT+" ;��� ������-"+OrderTT,12,"Arial",Blue);
   

ObjectCreate("label_object3",OBJ_LABEL,0,0,0);
ObjectSet("label_object3",OBJPROP_CORNER,4);
ObjectSet("label_object3",OBJPROP_XDISTANCE,10);
ObjectSet("label_object3",OBJPROP_YDISTANCE,50);
ObjectSetText("label_object3","���� ��������-"+OrderTTT+" ;������-"+ NormalizeDouble(Filter,5),12,"Arial",Blue);

ObjectCreate("label_object4",OBJ_LABEL,0,0,0);
ObjectSet("label_object4",OBJPROP_CORNER,4);
ObjectSet("label_object4",OBJPROP_XDISTANCE,10);
ObjectSet("label_object4",OBJPROP_YDISTANCE,70);
ObjectSetText("label_object4",OrderTTTT,18,"Arial",Green);

ObjectCreate("label_object5",OBJ_LABEL,0,0,0);
ObjectSet("label_object5",OBJPROP_CORNER,4);
ObjectSet("label_object5",OBJPROP_XDISTANCE,10);
ObjectSet("label_object5",OBJPROP_YDISTANCE,90);
ObjectSetText("label_object5","��������� ������ �������� ���� = "+DoubleToString(S,2),18,"Arial",Green);

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
if (OrderTyp==0){OrderTT="� �����";} 
if (OrderTyp==1){OrderTT="�����";} 
if (OrderTyp==2){OrderTT="����";} 
if (MoreOrLess==true){OrderTTT="���� �������";} else {OrderTTT="���� �������";}
if ((Hours<CurrentHour)&&(Minutes<CurrentMinute)&& (OpenOrder==false)){ OrderTTTT="����������� ����� ������,����� �� ������!";}
if ((Hours<CurrentHour)&&(Minutes<CurrentMinute)&& (OpenOrder==true)){ OrderTTTT="����������� ����� ������,����� ������!";}
if ((Hours>CurrentHour)&&(Minutes>CurrentMinute)&& (OpenOrder==false)){ OrderTTTT="����������� ����� ��� �� �������,����� �� ������!";}
if ((Hours>CurrentHour)&&(Minutes>CurrentMinute)&& (OpenOrder==true)){ OrderTTTT="����������� ����� ��� �� �������,����� ������!";}

RefreshRates();
if ((Hours==Hour())&&(Minutes==Minute())&&(OpenOrder==false))
{ Print("����������� ����� ���������");
   
   if ((MoreOrLess==true)&&(Bid>NormalizeDouble(Filter,5))){
     
      Print("���� ",Bid+" ������ ������� ",+Filter+" ��������� ����� � ����������� �� �������");
   if (Bid>CancellPrice){Print("���� ��������� CancellPrice ",CancellPrice+" ����� �� ���������");Sleep (6000);}

      if ((BuyOrSell==true)&&(Bid<CancellPrice)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 

      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot,Ask-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
       if ((BuyOrSell==true)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,Ask+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }                                           
      if ((BuyOrSell==false)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==false)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot,Bid+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
       if ((BuyOrSell==false)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot,Bid-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }                                           
                                       }
                                       
                                       
   if ((MoreOrLess==false)&&(Bid<NormalizeDouble(Filter,5))){

      Print("���� ",Bid+" ������ ������� ",+Filter+" ��������� ����� � ����������� �� �������");
               if (Bid<CancellPrice){Print("���� ������ CancellPrice ",CancellPrice+" ����� �� ���������"); Sleep (6000);}
      if ((BuyOrSell==true)&&(Bid>CancellPrice)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot,Ask,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 

      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYLIMIT,Lot,Ask-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==true)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,Lot,Ask+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Blue) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }                                            
      if ((BuyOrSell==false)&&(OrderTyp==0)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELL,Lot,Bid,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }
      if ((BuyOrSell==false)&&(OrderTyp==1)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLLIMIT,Lot,Bid+Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      }
          else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}}
                                            }       
      if ((BuyOrSell==false)&&(OrderTyp==2)){ if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,Lot,Bid-Otstup*Point*k,3*k,SL_points,TP_points,Comments,Magic_Number,0,Red) < 0) 
      { 
        Alert("������ �������� ������� � ", GetLastError());
      } 
     else{ PostMessageA(WindowHandle(Symbol(),Period()),WM_COMMAND,33050,0);}
      
      }
                                            }    





   }









Sleep (2000);





}


  if(!isNewBar())return(0);
 
 
   
   
return(0);}   



//------------------------------------------------------
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