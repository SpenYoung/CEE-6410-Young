$onText
Spencer Young
CEE 6410
Final Project

Optimization of the design of Labyrinth Weirs

This model seeks to create a pareto optimal front that will help designers choose the best geometry configuration for given hydraulic/site constraints

Based on Design methods from Crookston & Tullis (2012) "Hydraulics Design and Analysis of Labyrinth weirs. I: Discharge Relationships"

$offText

* Hydraulic inputs (example values are included here)
Scalars 
    Qdes        Design capacity (cfs)                  /1500/
    Hws         Design water surface elevation (ft)    /100/
    Hapron      Lowest elevation for apron floor (ft)  /85/
    Wmax        Max width of apron floor (ft)          /150/
    Bmax        Max Lenth of the apron floor (ft)      /20/
    Vapproach   Reservoir approach velocity (ft_s)     /3/
    tf          Thickness of weir floor (ft)           /1/
    twmin       Weir wall thickness min (ft)           /0.5/
    ;

* Constants    
Scalars
    g           Gravity (ft_s^2)                       /32.2/
    ;

* Cd regression coefficients
Scalars
    a1          /-1.022e-4/
    a2          /4.366e-3/
    a3          /-9.717e-3/
    b1          /-5.025e-3/
    b2          /1.632e-1/
    b3          /-4.509/
    c1          /-2.835e-5/
    c2          /1.59e-3/
    c3          /-1.411e-2/
    c4          /4.280e-1/
    d1          /1.997e-6/
    d2          /-3.682e-4/
    d3          /2.314e-2/
    d4          /6.172e-2/
    ;

Variables
    alpha       Side Wall angle
    B           Length of apron (ft)
    N           Number of cycles (ft)
    wcycle      Cycle wideth (ft)
    P           Crest Height (ft)
    tw          Thickness of weir wall at the crest (ft)
    A           Inside apex width (ft)
    
    Wtotal      Total floor width (ft)
    lcycle      Sidewall centerline length (ft)
    Ltotal      Total centerline length of weir (ft)
    Cd          Labyrinth discharge coeff (-)
    Cd90        Linear weir Cd value (-)
    M           Magnification ratio (-)
    h           Head above crest (ft)
    HT          Total upstream head velocity + piezo (ft)
    Q           Calculated weir discharge (ft^3_s)
    HtPRatio    Ht over P ratio
    aCd         Cd coefficient a
    bCd         Cd coefficient b
    cCd         Cd coefficient c
    dCd         Cd coefficient d

;

Variables
    Vol         Concrete volume (ft^3)
    Effic       Efficiency (-)
    
      ;
      
Positive Variable
    alpha, B, Cd, wcycle, P, tw, A, Wtotal, lcycle, Ltotal, Cd, M, h, HT, Q, N;
    

    
* Multi Objective formulation to find pareto front
Scalars
    EffMax      Max achievable efficiency
    EffMin      Current Min required efficiency
    ;
    
Set pp pareto points /pp1*pp20/;

Parameter
    lambda(pp)      fraction of EffMax to Require
    VolSol(pp)      Optimal volume at each point
    EffSol(pp)      Efficiency at each point
    Qsol(pp)        Discharge at each point
    Nsol(pp)        Number of cycles at each point
    Ltotalsol(pp)   Total centerline length at each point
    Psol(pp)        Crest height at each point
    Wtotalsol(pp)   Total floor width at each point
    Bsol(pp)        Apron Length at each point
    alphasol(pp)    Side wall angle at each point
    Cdsol(pp)       Cd value at each point
    EffMinsol(pp)   Effmin at each point
;
    
lambda(pp) = 0.1 + (ord(pp) - 1) * (0.2 / (card(pp) - 1));

    
* Bounds variables
P.lo        = 0.1;
wcycle.lo   = 0.1;
tw.lo       = twmin;
A.lo        = 0.01;
Ht.lo       = 0.01;
Cd90.lo     = 0.001;
HtPRatio.lo = 0.01;
alpha.lo    = 6;
alpha.up    = 12;
N.lo        = 1;
Cd.lo       = 0.1;

Equations
* State Variables
    Wtotalcalc  Total floor width (ft)
    lcyclecalc  Sidewall centerline length (ft)
    Ltotalcalc  Total centerline length (ft)
    hcalc       Head above crest (ft)
    HTcalc      Total head (ft)
    Mcalc       Magnification ratio (-)
    Qcalc       Weir capacity (ft^3_s)
    HtPRatioDef Ratio of Total head to weir height
    CdAlphaDef  Definition of Cd equation for labyrinth weir
    Cd90Def     Definition of Cd equation for a linear weir

* Objective Functions
    Volcalc     Concrete Volume (ft^3)
    Efficcalc   Efficiency (-)

* Constraints
    wPratiolo   Cycle width ratio low [2 <= w_P]
    wPratiohi   Cycle width ratio high [w_P <=4]
    Awratio     Apex ratio [A_w < 0.08]
    Ptwratiolo  Relative thickness ratio low [7.5 <= P_tw]
    Ptwratiohi  Relative thickness ratio high [P_tw <=8.5]
    HTPratiolo  Total head to weir height ratio low [0.05 <= HT_P]
    HTPratiohi  Total head to weir height ratio high [HT_P <= 2.0]
    Qmin        Minimum capacity [Q >= Qdes] (ft^3_s)
    Wlimit      Maximum apron width [W <= Wmax] (ft)
    Blimit      Maximum apron length [B <= Bmax] (ft)

    
* Cd coefficient equations
    aCdDef      Regression equation of Cd a coeffienct
    bCdDef      Regression equation of Cd b coeffienct
    cCdDef      Regression equation of Cd c coeffienct
    dCdDef      Regression equation of Cd d coeffienct
    
* Multi Objective formulation
    EffConstr   Epsilon-constraint on efficiency    
    
    
    ;
* State Variables
Wtotalcalc..    Wtotal =e= wcycle * N;
lcyclecalc..    lcycle =e= (B - tw) / cos(alpha * pi / 180);
Ltotalcalc..    Ltotal =e= N * (2 * (A + tw * tan((45 - (alpha / 2)) * pi / 180) + lcycle));
hcalc..         h =e= (Hws - Hapron) - P;
HTcalc..        HT =e= h + power(Vapproach, 2) / (2 * g);
Mcalc..         M =e= lcycle / (wcycle * N);
Qcalc..         Q =e= 2 / 3 * Cd * Ltotal * sqrt(2 * g) * HT ** 1.5;
HtPRatioDef..   HtPRatio =e= HT / P;

* Objective Functions
Volcalc..       Vol =e= (Ltotal * P * tw + Wtotal * B * tf);     
Efficcalc..     Effic =e= Cd * M / Cd90;

* Constraints
wPratiolo..     wcycle / P =g= 2;
wPratiohi..     wcycle / P =l= 4;
Awratio..       A / wcycle =l= 0.08;
Ptwratiolo..    P / tw =g= 7.5;
Ptwratiohi..    P / tw =l= 8.5;
HTPratiolo..    HtPRatio =g= 0.05;
HTPratiohi..    HtPRatio =l= 2.0;
Qmin..          Q =g= Qdes;
Wlimit..        Wtotal =l= Wmax;
Blimit..        B =l= Bmax;
*MinEle..        P =l= Hws - Hapron;

* Cd coefficient equations
aCdDef..        aCd =e= a1 * alpha ** 2 + a2 * alpha + a3;
bCdDef..        bCd =e= b1 * alpha ** 2 + b2 * alpha + b3;
cCdDef..        cCd =e= c1 * alpha ** 3 + c2 * alpha ** 2 + c3 * alpha + c4;
dCdDef..        dCd =e= d1 * alpha ** 3 + d2 * alpha ** 2 + d3 * alpha + d4;

CdAlphaDef..    Cd =e= aCd * HtPRatio ** (bCd * (HtPRatio ** cCd)) + dCd;
Cd90Def..       Cd90 =e= -8.609 * HtPRatio ** (22.650 * (HtPRatio ** 1.812)) + 0.638;

EffConstr..     Effic =g= EffMin;



Model EffOnly /all/;

EffMin = 0;

Solve EffOnly using nlp maximizing Effic;

EffMax = Effic.l;
display EffMax;

* Solve for Pareto Front
Model LabWeir /all/;

loop(pp,
    EffMin = lambda(pp)*EffMax;
    
    Solve LabWeir using nlp minimizing Vol;
* Can add any other geometry variables that the designer may want    
    VolSol(pp)      = Vol.l;
    EffSol(pp)      = Effic.l;
    Qsol(pp)        = Q.l;
    Nsol(pp)        = N.l;
    Ltotalsol(pp)   = Ltotal.l;
    Psol(pp)        = P.l;
    Wtotalsol(pp)   = Wtotal.l;
    Bsol(pp)        = B.l;
    alphasol(pp)    = alpha.l;
    Cdsol(pp)       = Cd.l;
    EffMinSol(pp)   = EffMin;
    );


* Export data to a csv file
file fout /'pareto_front.csv'/;
put fout;

put 'pp,lambda,EffMin,Vol,Eff,Q,N,Ltotal,P,Wtotal,B,alpha,Cd', ;
put /;
* Data rows
loop(pp,
    put pp.tl          ','     
        lambda(pp)     ','     
        EffMinSol(pp)  ','    
        VolSol(pp)     ','     
        EffSol(pp)     ','     
        Qsol(pp)       ','     
        Nsol(pp)       ','     
        Ltotalsol(pp)  ','    
        Psol(pp)       ','    
        Wtotalsol(pp)  ','     
        Bsol(pp)       ','    
        alphasol(pp)   ','   
        Cdsol(pp)      /; 
);

putclose fout;
