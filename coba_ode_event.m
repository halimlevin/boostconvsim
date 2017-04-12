function main
clear all; close all; clc

k = 0.23;
Cao = 2.3;
tspan = [0 10];

% create an options variable
options = odeset('Events',@event_function);

% note the extra outputs
[t,Ca,TE,VE] = ode45(@myode,tspan,Cao,options);
TE % this is the time value where the event occurred
VE % this is the value of Ca where the event occurred

sprintf('At t = %1.2f seconds the concentration of A is %1.2f mol/L.', TE,VE)

plot(t,Ca)
xlabel('Time (sec)')
ylabel('C_A (mol/L)')
% you can see the integration terminated at Ca = 1

'done'

function dCadt = myode(t,Ca)
k = 0.23;
dCadt = -k*Ca^2;

function [value,isterminal,direction] = event_function(t,Ca)
% when value is equal to zero, an event is triggered.
% set isterminal to 1 to stop the solver at the first event, or 0 to
% get all the events.
%  direction=0 if all zeros are to be computed (the default), +1 if
%  only zeros where the event function is increasing, and -1 if only
%  zeros where the event function is decreasing.
value = Ca - 1.4;  % when value = 0, an event is triggered
isterminal = 1; % terminate after the first event
direction = 0;  % get all the zeros
% categories: ODEs
% tags: reaction engineering