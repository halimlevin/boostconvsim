function main

clear all;
close all;

fs = 5e3;       %switching frequency
Ts=1/fs;

siklus=300;
soft_start_siklus=50;
duty=0.5;

D1 = [linspace(1e-3, duty, soft_start_siklus), linspace(duty, duty, siklus-soft_start_siklus)];
cycles = numel(D1);

x = [0; 0];
t = [0];
n = [];

m_state=[];

options = odeset('Events',@iL_empty);

for cc = 1:cycles

	% ON portion
	[tode, xode] = ode45(@booston, [0 D1(cc)*Ts], x(:,end));
	t = horzcat(t, tode(2:end)'+((cc-1)*Ts));
	x = horzcat(x, xode(2:end,:)');
	n(cc) = numel(tode);
    m_state=horzcat(m_state,ones(1,numel(tode)-1));
	
	% OFF portion
	[tode,xode,tOFF,xoff] = ode45(@boostoff,[D1(cc)*Ts Ts],x(:,end),options);
	%ii = x(:,1) < 0;
	t = horzcat(t, tode(2:end)'+((cc-1)*Ts));
	x = horzcat(x, xode(2:end,:)');
	n(cc) = n(cc) + numel(tode);
    m_state=horzcat(m_state,zeros(1,numel(tode)-1));
    
    if (~isempty(tOFF))
    [tode, xode] = ode45(@boostdcm, [tOFF Ts], x(:,end));
    n(cc) = n(cc) + numel(tode);
    t = horzcat(t, tode(2:end)'+(cc-1)*Ts);
    x = horzcat(x, xode(2:end,:)');
    m_state=horzcat(m_state,zeros(1,numel(tode)-1));
	end;
    
end;
m_state=horzcat(m_state,ones(1,1));
%m_state=m_state(1:end-1);

iL = x(1,:);
vC = x(2,:);

plot(t,iL); hold on;
plot(t,vC);
plot(t,m_state*30);
title('Boost Converter');
xlabel('Time t');
ylabel('Solution y');
legend('iL','vC / vout','MOSFET state');

sprintf('At t = %1.5f seconds the iL is %1.3f A.',tOFF/Ts,iLoff)


'done'



function [value,isterminal,direction] = iL_empty(t,x)
% when value is equal to zero, an event is triggered.
% set isterminal to 1 to stop the solver at the first event, or 0 to
% get all the events.
%  direction=0 if all zeros are to be computed (the default), +1 if
%  only zeros where the event function is increasing, and -1 if only
%  zeros where the event function is decreasing.
value = x(1);  % when value = 0, an event is triggered
isterminal = 1; % terminate after the first event
direction = -1;  % get all the zeros
% categories: ODEs
% tags: reaction engineering