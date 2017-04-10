fs = 5e3;       %switching frequency
Ts=1/fs;
tspan = linspace(0,10*Ts,10000);
[t,x] = ode45(@boost,tspan',[0; 0; 0]);

plotyy(t,x(:,1),t,x(:,3));grid on;hold on;
plot(t,x(:,2));grid on;

title('Boost Converter');
xlabel('Time t');
ylabel('Solution y');
legend('iL','vC / vout')

mean(x(:,1))
mean(x(:,2))

D = 0.7;      %duty cycle

%PWM controller
%figure;
sizet=size(t);
xt = linspace(0,10*Ts,sizet(1));
pwm = t;
Ts = 1/fs;
duty = D*Ts;
pwm = mod(t,Ts);
%subplot(211);plot(xt,pwm,'*-');
%xlim([0 5*Ts])

for c=1:(sizet(1))
    if pwm(c) > (duty)
        pwm(c)=0;
    else
        pwm(c)=1;
    end
end

%xlim([0 5*Ts])