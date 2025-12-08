$ontext
CEE 6410 - Water Resources Systems Analysis
HW 6 GAMS Dual solution for irrigation problem

THE PROBLEM:

Deciding how water should be allocated to different crops.  Data are as fol-lows:

Seasonal Resource
Inputs for Profit        Crops        Resource
Availability
                Hay        Grain
June          2 acft/acre        1 acft/acre               14,000 acft
July          1 acft/acre        2 acft/acre               18,000 acft
August        1 acft/acre        0 acft/acre               6,000 acft
Total Plants  1 acre             1 acre                    10,000 acres
Return $/acre        $100        $120

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Spencer Young
a02307423@aggies.usu.edu
October 22, 2025
$offtext

* 1. DEFINE the SETS
SETS plant crops growing /Hay, Grain/
     month months /June, July, August, Total/;

* 2. DEFINE input data
PARAMETERS
   c(plant) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(month) Right hand constraint values (per resource)
          /June 14000,
           July  18000,
           August  6000,
           Total 10000/;

TABLE A(plant,month) Left hand side constraint coefficients
                 June    July    August    Total
 Hay             2        1        1         1
 Grain           1        2        0         1;


* 3. DEFINE the variables
VARIABLES X(plant) plants planted (Number)
          VPROFIT  total profit ($)
          Y(month) planting months
          VRED Reduce Acerage used;

* Non-negativity constraints
POSITIVE VARIABLES X, Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT_PRIMAL Total profit ($) and objective function value
   WATER_CONSTRAINT_PRIMAL(month) Water Constraint by month
   REDUCE_DUAL Reduce the acerage used each month
   PLANT_CONSTRAINT_DUAL(plant) Constraint of the value of the plant

;

* Primal
PROFIT_PRIMAL..                 VPROFIT =E= SUM(plant, c(plant)*X(plant));
WATER_CONSTRAINT_PRIMAL(month) ..    SUM(plant, A(plant,month)*X(plant)) =L= b(month);

*Dual
REDUCE_DUAL  ..                 VRED =E= SUM(month, b(month)*Y(month));
PLANT_CONSTRAINT_DUAL(plant)  ..             SUM(month, A(plant,month)*Y(month)) =G= c(plant);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /REDUCE_DUAL, PLANT_CONSTRAINT_DUAL/;



* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MINIMIZING VRED;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
