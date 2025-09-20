$ontext
CEE 6410 - Water Resources Systems Analysis
Example 2.2 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)
Modifies Example to add a labor constraint

THE PROBLEM:

A manufactorer can produce either coupes or minivans.  Data are as fol-lows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
        Coupe        Minivan
Metal        1000 lbs/veh        2000 lbs/veh      4x106 lbs/year
Circuits        4 #/veh        3 #/veh               12000 circuits
Labor         5hr/veh        2.5hr /veh              17,500 hours
Profit/car        $6,000        $7,000

                Determine the optimal production for the two vehicles.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

David E Rosenberg
david.rosenberg@usu.edu
September 15, 2015
$offtext

* 1. DEFINE the SETS
SETS 
* For car production problem
     cars Cars to produce /Coups, Minivans/
     materials resources used to produce vehicles /Metal, CircuitBoards, Labor/
;

* 2. DEFINE input data
PARAMETERS
* For car production problem
    carprofit(cars) Profit per car produced
        /Coups 6000
        Minivans 7000/
    carconstraints(materials) Right hand constraint values for car prod (per material)
        /Metal 4000000
        CircuitBoards 12000
        Labor 17500/
;

TABLE Z(cars,materials) Left hand side constraint coefficients
                 Metal    CircuitBoards   Labor
  Coups           1000          4            5
  Minivans         2000          3           2.5;

* 3. DEFINE the variables
VARIABLES W(cars) cars to produce
          CPROFIT total profit from producing cars;

* Non-negativity constraints
POSITIVE VARIABLES W;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFITCARS Total profit from producing cars ($) the objective funciton value
   MATERIALCONSTRAINTS(materials) Materials constraints;
   
PROFITCARS ..            CPROFIT =E= SUM(cars, carprofit(cars)*W(cars));
MATERIALCONSTRAINTS(materials) ..  SUM(cars, Z(cars, materials) * W(cars)) =L= carconstraints(materials);



* 5. DEFINE the MODEL from the EQUATIONS
*MODEL PLANTING /ALL/;
MODEL PRODUCTION /PROFITCARS, MATERIALCONSTRAINTS/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PRODUCTION USING LP MAXIMIZING CPROFIT;
* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
