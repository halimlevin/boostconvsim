function dxdt = boost(t,x)
%x1 = iL
%x2 = vC = vout

fs = 5e3;  %swtiching frequency
Ts = 1/fs;
D = 0.7*Ts;    %duty cycle

%PWM controller
a = mod(t,Ts);
if a > D
    pwm=1;
else
    pwm=0;
end
x(3) = pwm; 
%parameter
R_L = 0.01;         %Inductor Series Resistance (Ohm)
L = 50e-6;          %inductance (H)
C = 100e-6;         %capacitance (F)
Rload = 195;        %load resistance (Ohm)
Vin = 12;           %input voltage (Volt)
Vd = 0.7;           %diode voltage drop (Volt)

A  = [(-R_L/L) (-pwm/L) 0;
      (pwm/C) (-1/(Rload*C)) 0;
      0 0 1];
B1 = [(1/L); 0;0];
B2 = [(-pwm/L);0;0];
dxdt = A*x + B1*Vin + B2*Vd ;

x(3) = pwm;     










