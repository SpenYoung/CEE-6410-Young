$ontext
CEE 6410 - Water Resources Systems Analysis
HW 5 GAMS solution for reservoir problem

THE PROBLEM:

Deciding how water should be allocated across a water resource system with a reservoir, turbine, spillway, irrigation field, and stream requirements

Determine the optimal allocation of units of water to maximize profit $

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Spencer Young
a02307423@aggies.usu.edu
September 25, 2025
$offtext

* 1. DEFINE the SETS
SETS spatial points of interest in problem schematic /Reservoir, Turbine, Spill, Irrigation, FlowA/
     month time periods /month1, month2, month3, month4, month5, month6/;
*    /month1*month6/ alternate way t
     
* 2. DEFINE input data
SCALAR
    TurbineCapacity capacity of release turbine (volume) /4/
    MinFlowAtA minimum flow that must be present at point a (volume) /1/
    InitialStorage initial storage in the reservoir /5/
    ReservoirCapacity maximum volume in the reservoir /9/;

PARAMETERS
   HydroBenefits(month) Hydropower benefits per month
        /month1 1.6
        month2 1.7
        month3 1.8
        month4 1.9
        month5 2.0
        month6 2.0/
        
   IrrigationBenefits(month) Irrigation benefits per month
        /month1 1.0,
        month2 1.2
        month3 1.9
        month4 2.0
        month5 2.2
        month6 2.2/
        
    ReservoirInflow(month) Inflow into the reservoir each month
        /month1 2,
        month2 2
        month3 3
        month4 4
        month5 3
        month6 2/;
        


* 3. DEFINE the variables
VARIABLES X(spatial, month) All of volume of water per location per month (arbitrary) except storage which is a volume
          VPROFIT  objective function value ($)
          FINALSTORAGE FInal storage of reservoir;

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
    PROFIT Total profit ($) and objective function value
    TURBINECAP Upper limit of turbine release
    FLOWATA minimum flow at point A
    RESERVOIRMASSBALANCE Reservoir mass balance in each time period 1 to 5
    FINALRESERVOIRMASSBALANCE Month 6 final storage
    INITIALRESERVOIRSTORAGE Month 1 storage
    MAXRESERVOIR Maximum reservoir volume constraint
    POINTCMASSBALANCE The mass balance at point C then divided between point a and irrigation
    ENDINGGREATERTHANFINAL The final storage must be great than or equal to initial
;


PROFIT..                            VPROFIT =E= SUM(month, HydroBenefits(month) * X("Turbine", month) + IrrigationBenefits(month) * X("Irrigation", month)) ;
TURBINECAP(month) ..           X("Turbine", month) =L= TurbineCapacity ;
FLOWATA(month) ..                X("FlowA", month) =G= MinFlowAtA ;
RESERVOIRMASSBALANCE(month)$(ord(month) lt card(month))  ..            X("Reservoir", month) + ReservoirInflow(month) - X("Turbine", month) - X("Spill", month) =E= X("Reservoir", month+1) ;
FINALRESERVOIRMASSBALANCE  ..       FINALSTORAGE =E= ReservoirInflow("month6") + X("Reservoir","month6") - X("Turbine", "month6") - X("Spill", "month6");
INITIALRESERVOIRSTORAGE  ..         X("Reservoir", "month1") =E= InitialStorage ;
MAXRESERVOIR(month)  ..                    X("Reservoir", month) =L= ReservoirCapacity ;
POINTCMASSBALANCE(month)  ..               X("Irrigation", month) + X("FlowA", month) =E= X("Spill", month) + X("Turbine", month) ;
ENDINGGREATERTHANFINAL  ..          FINALSTORAGE =G= InitialStorage
;


* 5. DEFINE the MODEL from the EQUATIONS
MODEL OPERATION /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE OPERATION USING LP MAXIMIZING VPROFIT;
