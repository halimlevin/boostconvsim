function dxdt = boost(t,x)
%x1 = iL
%x2 = vC = vout

%parameter
R_L = 0.01;         %Inductor Series Resistance (Ohm)
L = 50e-6;          %inductance (H)
C = 10e-6;         %capacitance (F)
Rload = 195;        %load resistance (Ohm)
Vin = 12;           %input voltage (Volt)
Vd = 0.7;           %diode voltage drop (Volt)

A  = [0 0 ;
      0 (-1/(Rload*C)) ];
B1 = [0; 0];
B2 = [0;0];
dxdt = A*x + B1*Vin + B2*Vd ;