function dxdt = booston(t,x)
%x1 = iLout
%x2 = iLoutdot
%x3 = iL

%parameter
R_L = 0.01;         %Inductor Series Resistance (Ohm)
L = 50e-6;          %inductance (H)
C = 10e-6;         %capacitance (F)
Lout = 10e-6;       %filter inductance (H)
Rload = 195;        %load resistance (Ohm)
Vin = 12;           %input voltage (Volt)
Vd = 0.7;           %diode voltage drop (Volt)

A  = [0 1 0;
      -1/(C*Lout) -Rload/Lout 0;
      0 0  (-R_L/L) ];
B1 = [0; 0; (1/L)];
B2 = [0; 0; 0];
dxdt = A*x + B1*Vin + B2*Vd ;  
