//+------------------------------------------------------------------+

//|                                                Strategy: ATR.mq5 |

//|                                       Created By Lucas Pedroso   |

//|                                      https://wa.me/5511975964800 |

//+------------------------------------------------------------------+

#property copyright "Created by Lucas Pedroso"

#property link      ""

#property version   "1.00"

#property description ""

#include <Trade\Trade.mqh>

// Bibliotecas de Negociação
#include <Trade\Trade.mqh>             // Funções para negociação
#include <Trade\PositionInfo.mqh>      // Informações sobre posições abertas
#include <Trade\OrderInfo.mqh>         // Informações sobre ordens

// Bibliotecas para Indicadores
#include <Indicators\Indicators.mqh>   // Funções para trabalhar com indicadores

// Bibliotecas para Gráficos
#include <ChartObjects\ChartObjectsTxtControls.mqh>   // Para trabalhar com objetos gráficos



// Bibliotecas para Arrays e Classes
#include <Arrays\ArrayObj.mqh>      // Para trabalhar com arrays de objetos
#include <Arrays\ArrayDouble.mqh>   // Para arrays de números double
#include <Arrays\ArrayLong.mqh>     // Para arrays de números long

// Outras Bibliotecas Úteis
#include <Files\File.mqh>    // Funções para manipulação de arquivos





input group "Configurações Gerais"

    input int MagicNumber = 1422057;  // MagicNumber
    int LotDigits;  // Quantidade de dígitos no tamanho do lote, inicializado em OnInit
    input double MaxSpread = 0;  // Spread máximo aceitável para negociação
    input int MaxSlippage = 3;  // Deslizamento máximo aceitável, ajustado em OnInit


input group "Gestão de Dinheiro (Money Management)"

    input double MM_Percent = 1;  // Percentual do saldo a ser arriscado por negociação
    input double MM_Martingale_ProfitFactor = 1;  // Fator de lucro Martingale
    input double MM_Martingale_LossFactor = 2;  // Fator de perda Martingale
    input bool MM_Martingale_RestartProfit = true;  // Reiniciar Martingale após lucro
    input bool MM_Martingale_RestartLoss = false;  // Reiniciar Martingale após perda
    input int MM_Martingale_RestartLosses = 1000;  // Reiniciar Martingale após n perdas
    input int MM_Martingale_RestartProfits = 1000;  // Reiniciar Martingale após n lucros


input group "Configurações de Negociação (Trading Settings)"

    input bool Hedging = true;  // Permitir ou não a cobertura
    input int MaxLongTrades = 1;  // Número máximo de negociações Buy simultâneas
    input int MaxShortTrades = 1;  // Número máximo de negociações Sell simultâneas
    double MinSL;      
    double MinSL_;
    
input group "Configurações de Dias de Negociação (Trading Days Settings)"

    input bool TradeMonday = true;  // Negociar na segunda-feira
    input bool TradeTuesday = true;  // Negociar na terça-feira
    input bool TradeWednesday = true;  // Negociar na quarta-feira
    input bool TradeThursday = true;  // Negociar na quinta-feira
    input bool TradeFriday = true;  // Negociar na sexta-feira
    bool TradeSaturday = false;  // Negociar no sábado
    bool TradeSunday = false;  // Negociar no domingo


input group "Configurações de Tempo (Time Settings)"

    input int TOD_Start_Hour = 00;  // Hora de início da negociação
    input int TOD_Start_Min = 05;  // Minuto de início da negociação
    input int TOD_Start_Intervalo_Hour = 01;  // Hora de início do intervalo
    input int TOD_Start_Intervalo_Min = 30;  // Minuto de início do intervalo
    input int TOD_End_Intervalo_Hour = 03;  // Hora de término do intervalo
    input int TOD_End_Intervalo_Min = 00;  // Minuto de término do intervalo
    input int TOD_End_Hour = 22;  // Hora de término
    input int TOD_End_Min = 00;  // Minuto de término
    input int Time_HoursFridayClose = 00;  // Hora de Término Sexta
    input int Time_MinFridayClose = 00;  // Minuto término Sexta


input group "Configurações de Compra (Buy Settings)"

    input ENUM_TIMEFRAMES TimeFrameBuyCandle = PERIOD_CURRENT;  // Período de tempo para análise Resistencia
    input ENUM_TIMEFRAMES TimeFrameATRBuyEntrada = PERIOD_CURRENT;  // Período de tempo para ATR na entrada de compra
    input ENUM_TIMEFRAMES TimeFrameATRBuyStop = PERIOD_CURRENT;  // Período de tempo para ATR no stop de compra
    input ENUM_TIMEFRAMES TimeFrameATRBuyTrail = PERIOD_CURRENT;  // Período de tempo para ATR no trailing stop de compra
    input int PeriodoATRBUY = 14;  // Período do ATR para compra
    input int Resistencia = 1;  // Numero de velas para Resistencia 
    input int ShiftATRBuy = 0;  // Deslocamento do ATR para compra
    input double DistanciaBuy = 1;  // Distância para entrada de compra
    input int PeriodoATRBUYStop = 14;  // Período do ATR para stop de compra
    input int Shiftatrbuystop = 0;  // Deslocamento do ATR para stop de compra
    input double StopBuy = 3;  // Nível de stop para compra
    input int ShiftTrailBuy = 0;  // Deslocamento para trailing stop de compra
    input double TrailBuy = 5;  // Nível de trailing stop para compra


input group "Configurações de Venda (Sell Settings)"

    input ENUM_TIMEFRAMES TimeFrameSellCandle = PERIOD_CURRENT;  // Período de tempo para análise de Suporte
    input ENUM_TIMEFRAMES TimeFrameATRSellEntrada = PERIOD_CURRENT;  // Período de tempo para ATR na entrada de venda
    input ENUM_TIMEFRAMES TimeFrameATRSellStop = PERIOD_CURRENT;  // Período de tempo para ATR no stop de venda
    input ENUM_TIMEFRAMES TimeFrameATRSellTrail = PERIOD_CURRENT;  // Período de tempo para ATR no trailing stop de venda
    input int Suporte = 1;  // Numero de velas para Suporte
    input int PeriodoATRSell = 14;  // Período do ATR para venda
    input int ShiftSell = 0;  // Deslocamento do ATR para venda
    input double DistanciaSell = 1;  // Distância para entrada de venda
    input int PeriodoatrSellStop = 14;  // Período do ATR para stop de venda
    input int ShfitStopatrSell = 0;  // Deslocamento do ATR para stop de venda
    input double StopSell = 3;  // Nível de stop para venda
    input int ShiftTrailSell = 0;  // Deslocamento para trailing stop de venda
    input double TrailSell = 5;  // Nível de trailing stop para venda



int MaxSlippage_;

datetime NextTime[2]; //initialized to 0, used in function TimeSignal

int MaxOpenTrades = 1000;

int MaxPendingOrders = 1000;

int MaxLongPendingOrders = 1000;

int MaxShortPendingOrders = 1000;

int OrderRetry = 5; //# of retries if sending order returns error

int OrderWait = 5; //# of seconds to wait if sending order returns error

double Close[];

int ATR_handle;

double ATR[];

int ATR_handle2;

double ATR2[];

double Close2[];

int ATR_handle3;

double ATR3[];

int ATR_handle4;

double ATR4[];

int ATR_handle5;

double ATR5[];

int ATR_handle6;

double ATR6[];



bool inTimeInterval(datetime t, int Start_Hour, int Start_Min, int Start_Intervalo_Hour, int Start_Intervalo_Min, int End_Intervalo_Hour, int End_Intervalo_Min, int End_Hour, int End_Min)

{

   string TOD = TimeToString(t, TIME_MINUTES);

   string TOD_Start = StringFormat("%02d", Start_Hour) + ":" + StringFormat("%02d", Start_Min);

   string TOD_Start_Intervalo = StringFormat("%02d", Start_Intervalo_Hour) + ":" + StringFormat("%02d", Start_Intervalo_Min);

   string TOD_End_Intervalo = StringFormat("%02d", End_Intervalo_Hour) + ":" + StringFormat("%02d", End_Intervalo_Min);

   string TOD_End = StringFormat("%02d", End_Hour) + ":" + StringFormat("%02d", End_Min);



   if (StringCompare(TOD_Start_Intervalo, TOD_End_Intervalo) > 0)

   {

       // Intervalo cruza a meia-noite

       return ((StringCompare(TOD, "00:00") >= 0 && StringCompare(TOD, TOD_End_Intervalo) <= 0) ||

               (StringCompare(TOD, TOD_Start_Intervalo) >= 0 && StringCompare(TOD, "23:59") <= 0));

   }

   else

   {

       // Intervalo não cruza a meia-noite

       return (StringCompare(TOD, TOD_Start_Intervalo) >= 0 && StringCompare(TOD, TOD_End_Intervalo) <= 0);

   }

}











// Função para obter o ticket da última ordem de compra do histórico
ulong LastBuyOrderTicket() {
    int totalDeals = HistoryDealsTotal();
    for(int i = totalDeals - 1; i >= 0; i--) {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_TYPE) == DEAL_TYPE_BUY) {
            return ticket;
        }
    }
    return 0;  // Retornar 0 se nenhuma ordem de compra for encontrada
}

// Função para obter o ticket da última ordem de venda do histórico
ulong LastSellOrderTicket() {
    int totalDeals = HistoryDealsTotal();
    for(int i = totalDeals - 1; i >= 0; i--) {
        ulong ticket = HistoryDealGetTicket(i);
        if(HistoryDealGetInteger(ticket, DEAL_TYPE) == DEAL_TYPE_SELL) {
            return ticket;
        }
    }
    return 0;  // Retornar 0 se nenhuma ordem de venda for encontrada
}

    double MM_Size(double SL) {
      double MaxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
      double MinLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
      double tickvalue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
      double ticksize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
      double lots = MM_Percent * 1.0 / 100 * AccountInfoDouble(ACCOUNT_BALANCE) / (SL / ticksize * tickvalue);
      Print("Initial Lots: ", lots);

      ulong LastSellOrderTicketValue = LastSellOrderTicket();
      ulong LastBuyOrderTicketValue = LastBuyOrderTicket();
      Print("Last Buy Order Ticket: ", LastBuyOrderTicketValue);
      Print("Last Sell Order Ticket: ", LastSellOrderTicketValue);

      double accumulatedProfitBuy = 0;
      double accumulatedLossBuy = 0;
      double accumulatedProfitSell = 0;
      double accumulatedLossSell = 0;
      double accumulatedProfitLoopBuy = 0;
      double accumulatedLossLoopBuy = 0;
      double accumulatedProfitLoopSell = 0;
      double accumulatedLossLoopSell = 0;

      int buyMagicNumber = 1;
      int sellMagicNumber = 2;
      int lastBuyMagicNumber = -1;
      int lastSellMagicNumber = -1;

      int total = HistoryDealsTotal();
    for (int i = total - 1; i >= 0; i--) {
        ulong ticket = HistoryDealGetTicket(i);
        if (ticket > 0) {
            if (HistoryDealGetInteger(ticket, DEAL_TYPE) == ORDER_TYPE_BUY) {
                double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                double loss = HistoryDealGetDouble(ticket, DEAL_COMMISSION) + HistoryDealGetDouble(ticket, DEAL_SWAP);
                accumulatedProfitBuy += profit;
                accumulatedLossBuy += loss;
                accumulatedProfitLoopBuy += profit;
                accumulatedLossLoopBuy += loss;
                long magicNumber = HistoryDealGetInteger(ticket, DEAL_MAGIC);
                if (magicNumber == buyMagicNumber) {
                    if (lastBuyMagicNumber != buyMagicNumber) {
                    Print("Novo ciclo Martingale detectado para Buy");
                        accumulatedProfitLoopBuy = 0;
                        accumulatedLossLoopBuy = 0;
                        lastBuyMagicNumber = buyMagicNumber;
                    }
                    accumulatedProfitLoopBuy += profit;
                    accumulatedLossLoopBuy += loss;
                    ApplyMartingaleLogicForBuyOrder(lots, LastBuyOrderTicketValue, accumulatedLossLoopBuy);
                }
            } else if (HistoryDealGetInteger(ticket, DEAL_TYPE) == ORDER_TYPE_SELL) {
                double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                double loss = HistoryDealGetDouble(ticket, DEAL_COMMISSION) + HistoryDealGetDouble(ticket, DEAL_SWAP);
                accumulatedProfitSell += profit;
                accumulatedLossSell += loss;
                long magicNumber = HistoryDealGetInteger(ticket, DEAL_MAGIC);
                if (magicNumber == sellMagicNumber) {
                    if (lastSellMagicNumber != sellMagicNumber) {
                    Print("Novo ciclo Martingale detectado para Sell");
                        accumulatedProfitLoopSell = 0;
                        accumulatedLossLoopSell = 0;
                        lastSellMagicNumber = sellMagicNumber;
                    }
                    accumulatedProfitLoopSell += profit;
                    accumulatedLossLoopSell += loss;
                    ApplyMartingaleLogicForSellOrder(lots, LastSellOrderTicketValue, accumulatedLossLoopSell);
            }
          }
        }
      }

      if (LastBuyOrderTicketValue > 0) {
        accumulatedProfitLoopBuy = HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_PROFIT);
        accumulatedLossLoopBuy = HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_COMMISSION) + HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_SWAP);
      }
      if (LastSellOrderTicketValue > 0) {
        accumulatedProfitLoopSell = HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_PROFIT);
        accumulatedLossLoopSell = HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_COMMISSION) + HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_SWAP);
      }

      if (ConsecutivePL(false, MM_Martingale_RestartLosses, accumulatedProfitLoopBuy, accumulatedLossLoopBuy, accumulatedProfitLoopSell, accumulatedLossLoopSell, buyMagicNumber, sellMagicNumber)) {
        lots = MM_Percent * 1.0 / 100 * AccountInfoDouble(ACCOUNT_BALANCE) / (SL / ticksize * tickvalue);
      }
      if (ConsecutivePL(true, MM_Martingale_RestartProfits, accumulatedProfitLoopBuy, accumulatedLossLoopBuy, accumulatedProfitLoopSell, accumulatedLossLoopSell, buyMagicNumber, sellMagicNumber)) {
        lots = MM_Percent * 1.0 / 100 * AccountInfoDouble(ACCOUNT_BALANCE) / (SL / ticksize * tickvalue);
      }
      if (lots > MaxLot) lots = MaxLot;
      if (lots < MinLot) lots = MinLot;
      Print("Final Lots: ", lots);
      Print("Final accumulatedProfitLoopBuy: ", accumulatedProfitLoopBuy);
      Print("Final accumulatedLossLoopBuy: ", accumulatedLossLoopBuy);
      Print("Final accumulatedProfitLoopSell: ", accumulatedProfitLoopSell);
      Print("Final accumulatedLossLoopSell: ", accumulatedLossLoopSell);
      return lots;
    }

    void ApplyMartingaleLogicForBuyOrder(double &lots, ulong LastBuyOrderTicketValue, double lastBuyVolume) {
      Print("Applying Martingale Logic for Buy Order");
      if (HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_PROFIT) > 0 && !MM_Martingale_RestartProfit) {
        Print("Martingale Profit Logic Triggered for Buy Order");
        lots = HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_VOLUME) * MM_Martingale_ProfitFactor;
      } else if (HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_PROFIT) < 0 && !MM_Martingale_RestartLoss) {
        Print("Martingale Loss Logic Triggered for Buy Order");
        lots = lastBuyVolume * MM_Martingale_LossFactor;
      } else if (HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_PROFIT) == 0) {
        Print("No Profit No Loss Logic Triggered for Buy Order");
        lots = HistoryDealGetDouble(LastBuyOrderTicketValue, DEAL_VOLUME);
      }
    }

    void ApplyMartingaleLogicForSellOrder(double &lots, ulong LastSellOrderTicketValue, double lastSellVolume) {
      Print("Applying Martingale Logic for Sell Order");
      if (HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_PROFIT) > 0 && !MM_Martingale_RestartProfit) {
        Print("Martingale Profit Logic Triggered for Sell Order");
        lots = HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_VOLUME) * MM_Martingale_ProfitFactor;
      } else if (HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_PROFIT) < 0 && !MM_Martingale_RestartLoss) {
        Print("Martingale Loss Logic Triggered for Sell Order");
        lots = lastSellVolume * MM_Martingale_LossFactor;
      } else if (HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_PROFIT) == 0) {
        Print("No Profit No Loss Logic Triggered for Sell Order");
        lots = HistoryDealGetDouble(LastSellOrderTicketValue, DEAL_VOLUME);
      }
    }
   

   

 



bool TradeDayOfWeek()

  {

   MqlDateTime tm;

   TimeCurrent(tm);

   int day = tm.day_of_week;

   return((TradeMonday && day == 1)

   || (TradeTuesday && day == 2)

   || (TradeWednesday && day == 3)

   || (TradeThursday && day == 4)

   || (TradeFriday && day == 5)

   || (TradeSaturday && day == 6)

   || (TradeSunday && day == 0));

  }



bool TimeSignal(int i, int hh, int mm, int ss, bool time_repeat, int repeat_interval)

  {

   bool ret = false;

   if(!time_repeat)

      repeat_interval = 86400; //24 hours

   datetime ct = TimeCurrent();

   datetime dt = StringToTime(IntegerToString(hh)+":"+IntegerToString(mm))+ss;

   if(ct > dt)

      dt += (datetime)MathCeil((ct - dt) * 1.0 / repeat_interval) * repeat_interval; //move dt to the future

   if(ct == dt)

      dt += repeat_interval;

   if(NextTime[i] == 0)

      NextTime[i] = dt; //set NextTime to the future at first run

   if(ct >= NextTime[i] && NextTime[i] > 0) //reached NextTime

     {

      if(ct - NextTime[i] < 3600) //not too far

         ret = true;

      NextTime[i] = dt; //move NextTime to the future again

     }

   return(ret);

  }



void myAlert(string type, string message)

  {

   if(type == "print")

      Print(message);

   else if(type == "error")

     {

      Print(type+" | ATR @ "+Symbol()+","+IntegerToString(Period())+" | "+message);

     }

   else if(type == "order")

     {

     }

   else if(type == "modify")

     {

     }

  }



int TradesCount(ENUM_ORDER_TYPE type) //returns # of open trades for order type, current symbol and magic number

  {

   if(type <= 1)

     {

      int result = 0;

      int total = PositionsTotal();

      for(int i = 0; i < total; i++)

        {

         if(PositionGetTicket(i) <= 0) continue;

         if(PositionGetInteger(POSITION_MAGIC) != MagicNumber || PositionGetString(POSITION_SYMBOL) != Symbol() || PositionGetInteger(POSITION_TYPE) != type) continue;

         result++;

        }

      return(result);

     }

   else

     {

      int result = 0;

      int total = OrdersTotal();

      for(int i = 0; i < total; i++)

        {

         if(OrderGetTicket(i) <= 0) continue;

         if(OrderGetInteger(ORDER_MAGIC) != MagicNumber || OrderGetString(ORDER_SYMBOL) != Symbol() || OrderGetInteger(ORDER_TYPE) != type) continue;

         result++;

        }

      return(result);

     }

  }



ulong LastHistoryTradeTicket(int deal_io)

  {

   HistorySelect(0, TimeCurrent());

   int total = HistoryDealsTotal();

   ulong ticket = 0;

   for(int i = total-1; i >= 0; i--)

     {

      if((ticket = HistoryDealGetTicket(i)) <= 0) continue;

      if(HistoryDealGetString(ticket, DEAL_SYMBOL) == Symbol()

      && HistoryDealGetInteger(ticket, DEAL_MAGIC) == MagicNumber

      && HistoryDealGetInteger(ticket, DEAL_TYPE) <= 1 && HistoryDealGetInteger(ticket, DEAL_ENTRY) == deal_io)

         return(ticket);

     } 

   return(0);

  }



bool ConsecutivePL(bool profits, int n, double buyAccumulatedProfit, double buyAccumulatedLoss, double sellAccumulatedProfit, double sellAccumulatedLoss, int buyMagicNumber, int sellMagicNumber) {
    int buyCount = 0;
    int sellCount = 0;
    ulong ticket;
    int total = HistoryDealsTotal();

    int lastBuyMagicNumber = -1;
    int lastSellMagicNumber = -1;

    for(int i = total-1; i >= 0; i--) {
        if((ticket = HistoryDealGetTicket(i)) <= 0) continue;
        if(HistoryDealGetString(ticket, DEAL_SYMBOL) == Symbol() && HistoryDealGetInteger(ticket, DEAL_TYPE) <= 1 && HistoryDealGetInteger(ticket, DEAL_ENTRY) == DEAL_ENTRY_OUT) {
            if((!profits && HistoryDealGetDouble(ticket, DEAL_PROFIT) >= 0) || (profits && HistoryDealGetDouble(ticket, DEAL_PROFIT) <= 0)) {
                break;
            }
            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            double loss = HistoryDealGetDouble(ticket, DEAL_COMMISSION) + HistoryDealGetDouble(ticket, DEAL_SWAP);
            long magicNumber = HistoryDealGetInteger(ticket, DEAL_MAGIC);

            if (magicNumber == buyMagicNumber) {
                if (lastBuyMagicNumber != buyMagicNumber) {
                Print("Novo ciclo Martingale detectado em ConsecutivePL para Buy");
                    buyAccumulatedProfit = 0;
                    buyAccumulatedLoss = 0;
                    lastBuyMagicNumber = buyMagicNumber;
                }
                buyAccumulatedProfit += profit;
                buyAccumulatedLoss += loss;
                if (buyAccumulatedProfit > buyAccumulatedLoss) {
                    buyAccumulatedProfit = 0;
                    buyAccumulatedLoss = 0;
                    buyCount++;
                    sellCount = 0;
                    buyMagicNumber++;
                }
            } else if (magicNumber == sellMagicNumber) {
                if (lastSellMagicNumber != sellMagicNumber) {
                Print("Novo ciclo Martingale detectado em ConsecutivePL para Sell");
                    sellAccumulatedProfit = 0;
                    sellAccumulatedLoss = 0;
                    lastSellMagicNumber = sellMagicNumber;
                }
                sellAccumulatedProfit += profit;
                sellAccumulatedLoss += loss;
                if (sellAccumulatedProfit > sellAccumulatedLoss) {
                    sellAccumulatedProfit = 0;
                    sellAccumulatedLoss = 0;
                    sellCount++;
                    buyCount = 0;
                    sellMagicNumber++;
                }
            }
        }
    }
    if (buyCount >= n || sellCount >= n) {
        return true;
    } else {
        return false;
    }
}

ulong myOrderSend(ENUM_ORDER_TYPE type, double price, double volume, string ordername) //send order, return ticket ("price" is irrelevant for market orders)

  {
  
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) return(0);

   int retries = 0;

   int long_trades = TradesCount(ORDER_TYPE_BUY);

   int short_trades = TradesCount(ORDER_TYPE_SELL);

   int long_pending = TradesCount(ORDER_TYPE_BUY_LIMIT) + TradesCount(ORDER_TYPE_BUY_STOP) + TradesCount(ORDER_TYPE_BUY_STOP_LIMIT);

   int short_pending = TradesCount(ORDER_TYPE_SELL_LIMIT) + TradesCount(ORDER_TYPE_SELL_STOP) + TradesCount(ORDER_TYPE_SELL_STOP_LIMIT);

   string ordername_ = ordername;

   if(ordername != "")

      ordername_ = "("+ordername+")";

   //test Hedging

   if(!Hedging && ((type % 2 == 0 && short_trades + short_pending > 0) || (type % 2 == 1 && long_trades + long_pending > 0)))

     {

      myAlert("print", "Order"+ordername_+" not sent, hedging not allowed");

      return(0);

     }

   //test maximum trades

   if((type % 2 == 0 && long_trades >= MaxLongTrades)

   || (type % 2 == 1 && short_trades >= MaxShortTrades)

   || (long_trades + short_trades >= MaxOpenTrades)

   || (type > 1 && type % 2 == 0 && long_pending >= MaxLongPendingOrders)

   || (type > 1 && type % 2 == 1 && short_pending >= MaxShortPendingOrders)

   || (type > 1 && long_pending + short_pending >= MaxPendingOrders)

   )

     {

      myAlert("print", "Order"+ordername_+" not sent, maximum reached");

      return(0);

     }

   //prepare to send order

   MqlTradeRequest request;

   ZeroMemory(request);

   request.action = (type <= 1) ? TRADE_ACTION_DEAL : TRADE_ACTION_PENDING;

   

   //set allowed filling type

   int filling = (int)SymbolInfoInteger(Symbol(),SYMBOL_FILLING_MODE);

   if(request.action == TRADE_ACTION_DEAL && (filling & 1) != 1)

      request.type_filling = ORDER_FILLING_IOC;



   request.magic = MagicNumber;

   request.symbol = Symbol();

   request.volume = NormalizeDouble(volume, LotDigits);

   request.sl = 0;

   request.tp = 0;

   request.deviation = MaxSlippage_;

   request.type = type;

   request.comment = ordername;



   int expiration=(int)SymbolInfoInteger(Symbol(), SYMBOL_EXPIRATION_MODE);

   if((expiration & SYMBOL_EXPIRATION_GTC) != SYMBOL_EXPIRATION_GTC)

     {

      request.type_time = ORDER_TIME_DAY;  

      request.type_filling = ORDER_FILLING_RETURN;

     }



   MqlTradeResult result;

   MqlTick last_tick;

   SymbolInfoTick(Symbol(), last_tick);

   if(MaxSpread > 0 && last_tick.ask - last_tick.bid > MaxSpread * Point())

     {

      myAlert("order", "Order"+ordername_+" not sent, maximum spread "+DoubleToString(MaxSpread * Point(), Digits())+" exceeded");

      return(0);

     }

   ZeroMemory(result);

   while(!OrderSuccess(result.retcode) && retries < OrderRetry+1)

     {

      //refresh price before sending order

      

      SymbolInfoTick(Symbol(), last_tick);

      if(type == ORDER_TYPE_BUY)

         price = last_tick.ask;

      else if(type == ORDER_TYPE_SELL)

         price = last_tick.bid;

      else if(price < 0) //invalid price for pending order

        {
        

         myAlert("order", "Order"+ordername_+" not sent, invalid price for pending order");

	      return(0);

        }

      request.price = NormalizeDouble(price, Digits());     

      if(!OrderSend(request, result) || !OrderSuccess(result.retcode))

        {

         myAlert("print", "OrderSend"+ordername_+" error: "+result.comment);

         Sleep(OrderWait*1000);

        }

      retries++;

     }

   if(!OrderSuccess(result.retcode))

     {

      myAlert("error", "OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error: "+result.comment);

      return(0);

     }

   string typestr[8] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop", "Buy Stop Limit", "Sell Stop Limit"};

   myAlert("order", "Order sent"+ordername_+": "+typestr[type]+" "+Symbol()+" Magic #"+IntegerToString(MagicNumber));

   return(result.order);

  }



int myOrderModify(ENUM_ORDER_TYPE type, ulong ticket, double SL, double TP) //modify SL and TP (absolute price), zero targets do not modify

  {

   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) return(-1);

   bool netting = AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;

   int retries = 0;

   int err = 0;

   SL = NormalizeDouble(SL, Digits());

   TP = NormalizeDouble(TP, Digits());

   if(SL < 0) SL = 0;

   if(TP < 0) TP = 0;

   //prepare to select order

   Sleep(10);

   if((type <= 1 && ((netting && !PositionSelect(Symbol())) || (!netting && !PositionSelectByTicket(ticket)))) || (type > 1 && !OrderSelect(ticket)))

     {

      err = GetLastError();

      myAlert("error", "PositionSelect / OrderSelect failed; error #"+IntegerToString(err));

      return(-1);

     }

   //ignore open positions other than "type"

   if (type <= 1 && PositionGetInteger(POSITION_TYPE) != type) return(0);

   //prepare to modify order

   double currentSL = (type <= 1) ? PositionGetDouble(POSITION_SL) : OrderGetDouble(ORDER_SL);

   double currentTP = (type <= 1) ? PositionGetDouble(POSITION_TP) : OrderGetDouble(ORDER_TP);

   if(NormalizeDouble(SL, Digits()) == 0) SL = currentSL; //not to modify

   if(NormalizeDouble(TP, Digits()) == 0) TP = currentTP; //not to modify

   if(NormalizeDouble(SL - currentSL, Digits()) == 0

   && NormalizeDouble(TP - currentTP, Digits()) == 0)

      return(0); //nothing to do

   MqlTradeRequest request;

   ZeroMemory(request);

   request.action = (type <= 1) ? TRADE_ACTION_SLTP : TRADE_ACTION_MODIFY;

   if (type > 1)

      request.order = ticket;

   else

      request.position = PositionGetInteger(POSITION_TICKET);

   request.symbol = Symbol();

   request.price = (type <= 1) ? PositionGetDouble(POSITION_PRICE_OPEN) : OrderGetDouble(ORDER_PRICE_OPEN);

   request.sl = NormalizeDouble(SL, Digits());

   request.tp = NormalizeDouble(TP, Digits());

   request.deviation = MaxSlippage_;

   MqlTradeResult result;

   ZeroMemory(result);

   while(!OrderSuccess(result.retcode) && retries < OrderRetry+1)

     {

      if(!OrderSend(request, result) || !OrderSuccess(result.retcode))

        {

         err = GetLastError();

         myAlert("print", "OrderModify error #"+IntegerToString(err));

         Sleep(OrderWait*1000);

        }

      retries++;

     }

   if(!OrderSuccess(result.retcode))

     {

      myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err));

      return(-1);

     }

   string alertstr = "Order modify: ticket="+IntegerToString(ticket);

   if(NormalizeDouble(SL, Digits()) != 0) alertstr = alertstr+" SL="+DoubleToString(SL);

   if(NormalizeDouble(TP, Digits()) != 0) alertstr = alertstr+" TP="+DoubleToString(TP);

   myAlert("modify", alertstr);

   return(0);

  }



int myOrderModifyRel(ENUM_ORDER_TYPE type, ulong ticket, double SL, double TP) //works for positions and orders, modify SL and TP (relative to open price), zero targets do not modify, ticket is irrelevant for open positions

  {

   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) return(-1);

   bool netting = AccountInfoInteger(ACCOUNT_MARGIN_MODE) != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING;

   int retries = 0;

   int err = 0;

   SL = NormalizeDouble(SL, Digits());

   TP = NormalizeDouble(TP, Digits());

   if(SL < 0) SL = 0;

   if(TP < 0) TP = 0;

   //prepare to select order

   Sleep(10);

   if((type <= 1 && ((netting && !PositionSelect(Symbol())) || (!netting && !PositionSelectByTicket(ticket)))) || (type > 1 && !OrderSelect(ticket)))

     {

      err = GetLastError();

      myAlert("error", "PositionSelect / OrderSelect failed; error #"+IntegerToString(err));

      return(-1);

     }

   //ignore open positions other than "type"

   if (type <= 1 && PositionGetInteger(POSITION_TYPE) != type) return(0);

   //prepare to modify order, convert relative to absolute

   double openprice = (type <= 1) ? PositionGetDouble(POSITION_PRICE_OPEN) : OrderGetDouble(ORDER_PRICE_OPEN);

   if(((type <= 1) ? PositionGetInteger(POSITION_TYPE) : OrderGetInteger(ORDER_TYPE)) % 2 == 0) //buy

     {

      if(NormalizeDouble(SL, Digits()) != 0)

         SL = openprice - SL;

      if(NormalizeDouble(TP, Digits()) != 0)

         TP = openprice + TP;

     }

   else //sell

     {

      if(NormalizeDouble(SL, Digits()) != 0)

         SL = openprice + SL;

      if(NormalizeDouble(TP, Digits()) != 0)

         TP = openprice - TP;

     }

   double currentSL = (type <= 1) ? PositionGetDouble(POSITION_SL) : OrderGetDouble(ORDER_SL);

   double currentTP = (type <= 1) ? PositionGetDouble(POSITION_TP) : OrderGetDouble(ORDER_TP);

   if(NormalizeDouble(SL, Digits()) == 0) SL = currentSL; //not to modify

   if(NormalizeDouble(TP, Digits()) == 0) TP = currentTP; //not to modify

   if(NormalizeDouble(SL - currentSL, Digits()) == 0

   && NormalizeDouble(TP - currentTP, Digits()) == 0)

      return(0); //nothing to do

   MqlTradeRequest request;

   ZeroMemory(request);

   request.action = (type <= 1) ? TRADE_ACTION_SLTP : TRADE_ACTION_MODIFY;

   if (type > 1)

      request.order = ticket;

   else

      request.position = PositionGetInteger(POSITION_TICKET);

   request.symbol = Symbol();

   request.price = (type <= 1) ? PositionGetDouble(POSITION_PRICE_OPEN) : OrderGetDouble(ORDER_PRICE_OPEN);

   request.sl = NormalizeDouble(SL, Digits());

   request.tp = NormalizeDouble(TP, Digits());

   request.deviation = MaxSlippage_;

   MqlTradeResult result;

   ZeroMemory(result);

   while(!OrderSuccess(result.retcode) && retries < OrderRetry+1)

     {

      if(!OrderSend(request, result) || !OrderSuccess(result.retcode))

        {

         err = GetLastError();

         myAlert("print", "OrderModify error #"+IntegerToString(err));

         Sleep(OrderWait*1000);

        }

      retries++;

     }

   if(!OrderSuccess(result.retcode))

     {

      myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err));

      return(-1);

     }

   string alertstr = "Order modify: ticket="+IntegerToString(ticket);

   if(NormalizeDouble(SL, Digits()) != 0) alertstr = alertstr+" SL="+DoubleToString(SL);

   if(NormalizeDouble(TP, Digits()) != 0) alertstr = alertstr+" TP="+DoubleToString(TP);

   myAlert("modify", alertstr);

   return(0);

  }



void myOrderClose(ENUM_ORDER_TYPE type, double volumepercent, string ordername) //close open orders for current symbol, magic number and "type" (ORDER_TYPE_BUY or ORDER_TYPE_SELL)

  {

   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) return;

   if (type > 1)

     {

      myAlert("error", "Invalid type in myOrderClose");

      return;

     }

   bool success = false;

   string ordername_ = ordername;

   if(ordername != "")

      ordername_ = "("+ordername+")";

   int total = PositionsTotal();

   ulong orderList[][2];

   int orderCount = 0;

   for(int i = 0; i < total; i++)

     {

      if(PositionGetTicket(i) <= 0) continue;

      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber || PositionGetString(POSITION_SYMBOL) != Symbol() || PositionGetInteger(POSITION_TYPE) != type) continue;

      orderCount++;

      ArrayResize(orderList, orderCount);

      orderList[orderCount - 1][0] = PositionGetInteger(POSITION_TIME);

      orderList[orderCount - 1][1] = PositionGetInteger(POSITION_TICKET);

     }

   if(orderCount > 0)

      ArraySort(orderList);

   for(int i = 0; i < orderCount; i++)

     {

      int retries = 0;

      MqlTradeResult result;

      ZeroMemory(result);

      

      while(!OrderSuccess(result.retcode) && retries < OrderRetry+1)

        {

         if(!PositionSelectByTicket(orderList[i][1])) continue;

         MqlTick last_tick;

         SymbolInfoTick(Symbol(), last_tick);

         double price = (type == ORDER_TYPE_SELL) ? last_tick.ask : last_tick.bid;

         MqlTradeRequest request;

         ZeroMemory(request);

         request.action = TRADE_ACTION_DEAL;

         request.position = PositionGetInteger(POSITION_TICKET);

      

         //set allowed filling type

         int filling = (int)SymbolInfoInteger(Symbol(),SYMBOL_FILLING_MODE);

         if(request.action == TRADE_ACTION_DEAL && (filling & 1) != 1)

            request.type_filling = ORDER_FILLING_IOC;

   

         request.magic = MagicNumber;

         request.symbol = Symbol();

         request.volume = NormalizeDouble(PositionGetDouble(POSITION_VOLUME)*volumepercent * 1.0 / 100, LotDigits);

         if (NormalizeDouble(request.volume, LotDigits) == 0) return;

         request.price = NormalizeDouble(price, Digits());

         request.sl = 0;

         request.tp = 0;

         request.deviation = MaxSlippage_;

         request.type = (ENUM_ORDER_TYPE)(1-type); //opposite type

         request.comment = ordername;

         

         success = OrderSend(request, result) && OrderSuccess(result.retcode);

         if(!success)

           {

            myAlert("error", "OrderClose"+ordername_+" failed; error: "+result.comment);

            Sleep(OrderWait*1000);

           }

         retries++;

        }



      if(!OrderSuccess(result.retcode))

        {

         myAlert("error", "OrderClose"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error: "+result.comment);

        }



     }

   string typestr[8] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop", "Buy Stop Limit", "Sell Stop Limit"};

   if (success) myAlert("order", "Orders closed"+ordername_+": "+typestr[type]+" "+Symbol()+" Magic #"+IntegerToString(MagicNumber));

  }



void TrailingStopSet(ENUM_ORDER_TYPE type, double price) //set Stop Loss at "price"

  {

   int total = PositionsTotal();

   for(int i = total-1; i >= 0; i--)

     {

      if(PositionGetTicket(i) <= 0) continue;

      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber || PositionGetString(POSITION_SYMBOL) != Symbol() || PositionGetInteger(POSITION_TYPE) != type) continue;

      double SL = PositionGetDouble(POSITION_SL);

      ulong ticket = PositionGetInteger(POSITION_TICKET);

      if(SL == 0

      || (type == ORDER_TYPE_BUY && (NormalizeDouble(SL, Digits()) <= 0 || price > SL))

      || (type == ORDER_TYPE_SELL && (NormalizeDouble(SL, Digits()) <= 0 || price < SL)))

         myOrderModify(type, ticket, price, 0);

     }

  }



bool NewBar()

  {

   datetime cTime[];

   ArraySetAsSeries(cTime, true);

   CopyTime(Symbol(), Period(), 0, 1, cTime);

   static datetime LastTime = 0;

   bool ret = cTime[0] > LastTime && LastTime > 0;

   LastTime = cTime[0];

   return(ret);

  }



bool OrderSuccess(uint retcode)

  {

   return(retcode == TRADE_RETCODE_PLACED || retcode == TRADE_RETCODE_DONE

      || retcode == TRADE_RETCODE_DONE_PARTIAL || retcode == TRADE_RETCODE_NO_CHANGES);

  }



double getBid()

  {

   MqlTick last_tick;

   SymbolInfoTick(Symbol(), last_tick);

   return(last_tick.bid);

  }



double getAsk()

  {

   MqlTick last_tick;

   SymbolInfoTick(Symbol(), last_tick);

   return(last_tick.ask);

  }



//+------------------------------------------------------------------+

//| Expert initialization function                                   |

//+------------------------------------------------------------------+

int OnInit()

  {  
   long stopsLevel;
if(!SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL, stopsLevel)) {
    Print("Erro ao obter SYMBOL_TRADE_STOPS_LEVEL: ", GetLastError());
    return(INIT_FAILED);
}

// Recuperando o Stop Level do símbolo
stopsLevel = SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL);
MinSL_ = stopsLevel * Point();


   MaxSlippage_ = MaxSlippage;

   //initialize LotDigits

   double LotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);

   if(NormalizeDouble(LotStep, 3) == round(LotStep))

      LotDigits = 0;

   else if(NormalizeDouble(10*LotStep, 3) == round(10*LotStep))

      LotDigits = 1;

   else if(NormalizeDouble(100*LotStep, 3) == round(100*LotStep))

      LotDigits = 2;

   else LotDigits = 3;
    
     MinSL_ = MinSL * Point();
    
   int i;

   //initialize NextTime

   for (i = 0; i < ArraySize(NextTime); i++)

      NextTime[i] = 0;

   ATR_handle = iATR(NULL, TimeFrameATRBuyEntrada, PeriodoATRBUY);

   if(ATR_handle < 0)

     {

      Print("The creation of iATR has failed: ATR_handle=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   ATR_handle2 = iATR(NULL, TimeFrameATRBuyStop, PeriodoATRBUYStop);

   if(ATR_handle2 < 0)

     {

      Print("The creation of iATR has failed: ATR_handle2=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   ATR_handle3 = iATR(NULL, TimeFrameATRSellEntrada, PeriodoATRSell);

   if(ATR_handle3 < 0)

     {

      Print("The creation of iATR has failed: ATR_handle3=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   ATR_handle4 = iATR(NULL, TimeFrameATRSellStop, PeriodoatrSellStop);

   if(ATR_handle4 < 0)

     {

      Print("The creation of iATR has failed: ATR_handle4=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   ATR_handle5 = iATR(NULL, TimeFrameATRBuyTrail, PeriodoATRBUYStop);

   if(ATR_handle5 < 0)

     {

      Print("The creation of iATR has failed: ATR_handle5=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   ATR_handle6 = iATR(NULL, TimeFrameATRSellTrail, PeriodoatrSellStop);

   if(ATR_handle6 < 0)

     {

      Print("The creation of iATR has failed: ATR_handle6=", INVALID_HANDLE);

      Print("Runtime error = ", GetLastError());

      return(INIT_FAILED);

     }

   

   return(INIT_SUCCEEDED);

  }



//+------------------------------------------------------------------+

//| Expert deinitialization function                                 |

//+------------------------------------------------------------------+

void OnDeinit(const int reason)

  {

  }







//+------------------------------------------------------------------+

//| Expert tick function                                             |

//+------------------------------------------------------------------+

void OnTick()

  {
 
  if (!inTimeInterval(TimeCurrent(), TOD_Start_Hour, TOD_Start_Min, TOD_Start_Intervalo_Hour, TOD_Start_Intervalo_Min, TOD_End_Intervalo_Hour, TOD_End_Intervalo_Min, TOD_End_Hour, TOD_End_Min))

        return; // Abre negociações apenas em horários específicos do dia

   ulong ticket = 0;
   double price;
   double TradeSize;   
   double SL;
   bool isNewBar = NewBar();

   
   if(CopyClose(Symbol(), TimeFrameBuyCandle, 0, 200, Close) <= 0) return;

   ArraySetAsSeries(Close, true);

   if(CopyBuffer(ATR_handle, 0, 0, 200, ATR) <= 0) return;

   ArraySetAsSeries(ATR, true);

   if(CopyBuffer(ATR_handle2, 0, 0, 200, ATR2) <= 0) return;

   ArraySetAsSeries(ATR2, true);

   if(CopyClose(Symbol(), TimeFrameSellCandle, 0, 200, Close2) <= 0) return;

   ArraySetAsSeries(Close2, true);

   if(CopyBuffer(ATR_handle3, 0, 0, 200, ATR3) <= 0) return;

   ArraySetAsSeries(ATR3, true);

   if(CopyBuffer(ATR_handle4, 0, 0, 200, ATR4) <= 0) return;

   ArraySetAsSeries(ATR4, true);

   if(CopyBuffer(ATR_handle5, 0, 0, 200, ATR5) <= 0) return;

   ArraySetAsSeries(ATR5, true);

   if(CopyBuffer(ATR_handle6, 0, 0, 200, ATR6) <= 0) return;

   ArraySetAsSeries(ATR6, true);

   if(isNewBar) TrailingStopSet(ORDER_TYPE_BUY, getAsk() - ATR5[ShiftTrailBuy] * TrailBuy); //Trailing Stop = Price - Average True Range * fixed value

   if(isNewBar) TrailingStopSet(ORDER_TYPE_SELL, getBid() + ATR6[ShiftTrailSell] * TrailSell); //Trailing Stop = Price + Average True Range * fixed value

  
   // Close Long Positions
if (TimeSignal(1, Time_HoursFridayClose, Time_MinFridayClose, 00, false, 12 * 3600) && FRIDAY) {
    Print("Evaluating condition for Close Long: TimeSignal(1,...) && FRIDAY");
    if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && MQLInfoInteger(MQL_TRADE_ALLOWED))
        myOrderClose(ORDER_TYPE_BUY, 100, "");
    else
        myAlert("order", "");
}

// Close Short Positions
if (TimeSignal(0, Time_HoursFridayClose, Time_MinFridayClose, 00, false, 12 * 3600) && FRIDAY) {
    Print("Evaluating condition for Close Short: TimeSignal(0,...) && FRIDAY");
    if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && MQLInfoInteger(MQL_TRADE_ALLOWED))
        myOrderClose(ORDER_TYPE_SELL, 100, "");
    else
        myAlert("order", "");
}

// Open Buy Order
//Print(StringFormat("Evaluating condition for Buy Order: isNewBar=%s, getAsk()=%.5f, Close[Resistencia]=%.5f, ATR[ShiftATRBuy]=%.5f, DistanciaBuy=%.5f",
                   //(isNewBar ? "True" : "False"),
                   // getAsk(),
                   // Close[Resistencia],
                   // ATR[ShiftATRBuy],
                   //DistanciaBuy));
if (isNewBar && getAsk() > Close[Resistencia] + ATR[ShiftATRBuy] * DistanciaBuy) {
    MqlTick last_tick;
    SymbolInfoTick(Symbol(), last_tick);
    price = last_tick.ask;
    SL = 0 * Point() + ATR2[Shiftatrbuystop] * StopBuy;
    if(SL < MinSL_) SL = MinSL_;
    TradeSize = MM_Size(SL);
    if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && MQLInfoInteger(MQL_TRADE_ALLOWED)) {
        ticket = myOrderSend(ORDER_TYPE_BUY, price, TradeSize, "");
        if (ticket == 0) return;
    } else {
        myAlert("order", "");
    }
    myOrderModifyRel(ORDER_TYPE_BUY, ticket, SL, 0);
}

// Open Sell Order
//Print(StringFormat("Evaluating condition for Sell Order: isNewBar=%s, getBid()=%.5f, Close2[Suporte]=%.5f, ATR3[ShiftSell]=%.5f, DistanciaSell=%.5f",
                  // (isNewBar ? "True" : "False"),
                  // getBid(),
                  // Close2[Suporte],
                   //ATR3[ShiftSell],
                  // DistanciaSell));
if (isNewBar && getBid() < Close2[Suporte] - ATR3[ShiftSell] * DistanciaSell) {
    MqlTick last_tick;
    SymbolInfoTick(Symbol(), last_tick);
    price = last_tick.bid;
    SL = 0 * Point() + ATR4[ShfitStopatrSell] * StopSell;
    if(SL < MinSL_) SL = MinSL_;
    TradeSize = MM_Size(SL);
    if (TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) && MQLInfoInteger(MQL_TRADE_ALLOWED)) {
        ticket = myOrderSend(ORDER_TYPE_SELL, price, TradeSize, "");
        if (ticket == 0) return;
    } else {
        myAlert("order", "");
    }
    myOrderModifyRel(ORDER_TYPE_SELL, ticket, SL, 0);
    }

   }