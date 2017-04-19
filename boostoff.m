function dxdt = boostoff(t,x)
%x1 = iL
%x2 = iLdot
%x3 = vC = vout
%x4 = vCdot

%parameter
R_L = 0.01;         %Inductor Series Resistance (Ohm)
L = 50e-6;          %inductance (H)
C = 10e-6;         %capacitance (F)
L_out = 10e-6;       %filter inductance (H)
Rload = 195;        %load resistance (Ohm)
Vin = 12;           %input voltage (Volt)
Vd = 0.7;           %diode voltage drop (Volt)

A  = [(-R_L/L) 0 (-1/L) 0;
      0 0 0 0;
      0 0 0 1;
      (-Rload/(L_out*C)) (-1/C)  (1/(L_out*C)) (-Rload/L_out) ];
B1 = [(1/L); 0 ; 0 ;0];
B2 = [0;0;0;0];
dxdt = A*x + B1*Vin + B2*Vd ;  
