$onText
CEE 6410 - HW 6
      Example 7.1 in the Bishop et al text
       
      
$offText
Sets src    Which source the water is coming from /res "Reservoir", pump "Pump"/
     seas   Seaon 1 or season 2 /s1*s2/
     cap    Storage in the Reserovoir /cap0, cap1, cap2/;
     

Variables I(src, cap)  Decision to build_use source (1=do 0=don't)
          V(src, seas) Volume of water to take from each source (ac-ft)
          Stor(seas)   How much volume to store in Reservoir (ac-ft)
          Flow(seas)   How much volume to release from river
          Area         How much area to irrigate
          TotalBen     Maximum benefit from both sources;
   
Binary Variables I;

Positive Variables V, Flow, Stor;
   
   
Table CostCap(src, cap) Capital cost to build projects ($ per year))
              cap0   cap1    cap2
      res      0     6000    10000
      pump     0     8000    8000;

   
Parameter CostOpr(src)  Operating Cost of each source ($ per ac-ft)
       /res    0,
       pump    20/ ;
   
Table MaxCap(src, cap) Maximum capacity built (ac-ft per season)
           cap0   cap1   cap2
     res    0     300    700;
   

MaxCap("pump","cap1") = 2.2*365/card(seas);
   
Parameters Inflow(seas) River inflow per season (ac-ft)
                   /s1 600, s2 200/
           Demand(seas) Irrigation demand in time t (ac-ft per acre)
                   /s1 1.0, s2 3.0/
           BaseFlow River baseflow below the reservoir (ac-ft) /730/
           Rev      Revenue of irrigation ($ per year per acre) /300/;

   
   
Equations
    SupplyArea(seas)    How much area to supply (ac)
    NetBen              Objective Function Revenue minus costs
    PumpCap(seas)       Pumping in each season (ac-ft per season)
    ResCap(seas)        Reservoir storage within capacity in each time step (ac-ft)
    RivMassBal(seas)    River mass balance downstream of reservoir in each timestep (ac-ft)
    ResMassBal(seas)    Reservoir mass balance in each time step (ac-ft)
    BuildChoice(src)    Can only implement one project size;
   
   
SupplyArea(seas)..       Area =L= SUM(src,V(src,seas))/Demand(seas);
NetBen..                 TotalBen =E= Rev*Area - SUM(src,SUM(cap,CostCap(src,cap)*I(src,cap)) + SUM(seas,CostOpr(src)*V(src, seas)));
PumpCap(seas)..          V("pump",seas) =L= sum(cap,MaxCap("pump",cap)*I("pump",cap));
ResCap(seas)..           Stor(seas) =L= sum(cap,MaxCap("res",cap)*I("res",cap));
RivMassBal(seas)..       V("pump",seas) =L= Flow(seas) + BaseFlow;
ResMassBal(seas)..       Stor(seas) =E= Inflow(seas) - Flow(seas) - V("res",seas) + stor(seas-1)$(ord(seas) gt 1);
BuildChoice(src)..       sum(Cap,I(src,cap)) =L= 1;
   

Model BuildScenario /ALL/;
   

Solve BuildScenario Using mip Maximizing TotalBen;
   
Display V.L, I.L, TotalBen.L;
  

Execute_Unload "Ex7-1.gdx";

Execute "gdx2xls Ex7-1.gdx"

