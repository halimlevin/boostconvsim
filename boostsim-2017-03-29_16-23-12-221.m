tspan = linspace(0,0.1,35405);
[t,x] = ode45(@boost,tspan',[0; 0]);

plot(t,x(:,1),t,x(:,2))
title('Boost Converter');
xlabel('Time t');
ylabel('Solution y');
legend('iL','vC / vout')

mean(x(:,1))
mean(x(:,2))

fs = 5e3;       %switching frequency
D = 0.964;      %duty cycle

%PWM controller
figure;
xt = linspace(0,0.1,sizet(1));
pwm = t;
Ts = 1/fs;
duty = D*Ts;
pwm = mod(t,Ts);
subplot(211);plot(xt,pwm,'*-');
xlim([0 5*Ts])
sizet=size(t);
for c=1:(sizet(1))
    if pwm(c) > (duty)
        pwm(c)=1;
    else
        pwm(c)=0;
    end
end

subplot(212);plot(xt,pwm,'*-');
xlim([0 5*Ts])