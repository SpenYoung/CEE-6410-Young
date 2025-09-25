$ontext
CEE 6410 - Water Resources Systems Analysis
HW 4 GAMS solution for vehicle production problem

THE PROBLEM:

Deciding how vehicle parts should be allocated to different vehicles.  Data are as fol-lows:


                        Truck           Sedan
Fuel Tanks           2 per veh        1 per veh               14,000 fuel tanks
Rows of Seats        1 per veh        2 per veh               18,000 rows of seats
4WD                  1 per veh        0 per veh               6,000 4wd parts
Total Vehicles       1                1                       10,000 vehicles
Return $/acre        $100             $110

                Determine the optimal vehicle production for both vehicle types.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Spencer Young
a02307423@aggies.usu.edu
September 24, 2025
$offtext

* 1. DEFINE the SETS
SETS veh crops growing /Truck, Sedan/
     resources available resources /Fuel, Seats, 4WD, Total/;

* 2. DEFINE input data
PARAMETERS
   c(veh) Objective function coefficients ($ per vehicle)
         /Truck 100,
         Sedan 110/
   b(resources) Right hand constraint values (per resource)
          /Fuel 14000,
           Seats  18000,
           4WD  6000,
           Total 10000/;

TABLE A(veh,resources) Left hand side constraint coefficients
                 Fuel    Seats    4WD    Total
 Truck             2        1       1      1
 Sedan             1        2       0      1;


* 3. DEFINE the variables
VARIABLES X(veh) Vehicles Produced (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RESOURCE_CONSTRAINT(resources) Resource constraint;

PROFIT..                 VPROFIT =E= SUM(veh, c(veh)*X(veh));
RESOURCE_CONSTRAINT(resources) ..    SUM(veh, A(veh,resources)*X(veh)) =L= b(resources);


* 5. DEFINE the MODEL from the EQUATIONS
MODEL PRODUCTION /PROFIT, RESOURCE_CONSTRAINT/;
*Altnerative way to write (include all previously defined equations)


* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PRODUCTION USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file
