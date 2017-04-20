function stateout = main();

clear all;
close all;

Kp = 3;             % Kp Controller

fs = 5e3;           %switching frequency
Ts=1/fs;
fref = 50;          % reference frequency
%Vref = 311.127;    % reference Voltage
Vref = 220;         % reference Voltage

siklus=40e-3/Ts;    % total cycle
duty=0.5;           % duty cycle

D1 = linspace(duty, duty, siklus);
cycles = numel(D1);


x = [0; 0; 0];
t = [0];
n = [];
Rload = 195;        %load resistance (Ohm)
m_state=[];

options = odeset('Events',@iL_empty);
sineref = [];
errorplot=[];
for cc = 1:cycles
  sprintf('Iterasi ke %d dari %d',cc,cycles)
  % ON portion
  [tode, xode] = ode45(@booston, [0 D1(cc)*Ts], x(:,end));
  t = horzcat(t, tode(2:end)'+((cc-1)*Ts));
  x = horzcat(x, xode(2:end,:)');
  n(cc) = numel(tode);
  m_state=horzcat(m_state,ones(1,numel(tode)-1));
  tsine = tode(2:end)'+((cc-1)*Ts);
  sinerefode = Vref*sin(2*pi*fref*tsine);
  sineref = horzcat(sineref, abs(sinerefode));

  % OFF portion
  [tode,xode,tOFF,xoff] = ode45(@boostoff,[D1(cc)*Ts Ts],x(:,end),options);
  %ii = x(:,1) < 0;
  t = horzcat(t, tode(2:end)'+((cc-1)*Ts));
  x = horzcat(x, xode(2:end,:)');
  n(cc) = n(cc) + numel(tode);
  m_state=horzcat(m_state,zeros(1,numel(tode)-1));
  tsine = tode(2:end)'+((cc-1)*Ts);
  sinerefode = Vref*sin(2*pi*fref*tsine);
  sineref = horzcat(sineref, abs(sinerefode));

  if (~isempty(tOFF))
    [tode, xode] = ode45(@boostdcm, [tOFF Ts], x(:,end));
    n(cc) = n(cc) + numel(tode);
    t = horzcat(t, tode(2:end)'+(cc-1)*Ts);
    x = horzcat(x, xode(2:end,:)');
    m_state=horzcat(m_state,zeros(1,numel(tode)-1));
    tsine = tode(2:end)'+((cc-1)*Ts);
    sinerefode = Vref*sin(2*pi*fref*tsine);
    sineref = horzcat(sineref, abs(sinerefode));
  end;

  %Controller
  
  sineref(end) - x(1,end)*Rload;
  error = max(0,(sineref(end) - x(1,end)*Rload))/sineref(end)*ones(1, n(cc)-3);
  errorplot = horzcat(errorplot,error);
 
  errorInput = max(0.001, min(0.98, ( (sineref(end) - x(1, end)*Rload)/sineref(end)*Kp )));
  D1(cc+1) = errorInput;
  
end;
m_state=horzcat(m_state,ones(1,1));
sineref=horzcat(sineref,ones(1,1));
errorplot=horzcat(errorplot,ones(1,1));
%m_state=m_state(1:end-1);
cc
%size(errorplot)
size(t)
iLout = x(1,:);
iL = x(3,:);

vLoad = iLout*Rload;

plot(t,iLout); hold on;
plot(t,iL); 
plot(t,m_state*30); 
plot(t,vLoad);grid on;

plot(t,sineref);
%plot(t,errorplot*100);
title('Boost Converter');
xlabel('Time t');
legend('iLout','iL','MOSFET state','vLoad','Vref');
%legend('iLout', 'iL', 'MOSFET state','vLoad');


%sprintf('At t = %1.5f seconds the iL is %1.3f A.',tOFF/Ts,iLoff)

stateout = [t;x];

end


function [value,isterminal,direction] = iL_empty(t,x)
% when value is equal to zero, an event is triggered.
% set isterminal to 1 to stop the solver at the first event, or 0 to
% get all the events.
%  direction=0 if all zeros are to be computed (the default), +1 if
%  only zeros where the event function is increasing, and -1 if only
%  zeros where the event function is decreasing.
value = x(3);  % when value = 0, an event is triggered
isterminal = 1; % terminate after the first event
direction = -1;  % get all the zeros
% categories: ODEs
% tags: power electronic
end