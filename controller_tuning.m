%set controller gains
%fuel inj controller
Ki_fuel = .009;
Kp_fuel = .07;
Kd_fuel = .0002;

%intake manifold pressure
Ki_pres = 100;
Kp_pres = 600;
Kd_pres = 1.5;

%%
%plots of all controller contributions
%fuel inj controller
subplot(2,1,1)
plot(PID_out_fuel_inj)
title('Fuel Inj Controller')
xlabel('Time (sec)')
ylabel('Fuel Inj (mm3/cyc)')
hold on
plot(Kp_fuel_data)
hold on
plot(Ki_fuel_data)
hold on
plot(Kd_fuel_data)
hold on
plot(ff_fuel_cont)
hold on
plot(fuel_error)
legend('total input','Kp','Ki','Kd','FF','error') 
grid on
xlim([20 27]);

%intake manifold pressure controller
subplot(2,1,2)
plot(PID_out_p_inman)
title('Intake Man. Pres. Controller')
xlabel('Time (sec)')
ylabel('Pressure (Pa)')
hold on
plot(Kp_pres_data)
hold on
plot(Ki_pres_data)
hold on
plot(Kd_pres_data)
hold on
plot(ff_pres_cont)
hold on
plot(pres_error)
legend('total input','Kp','Ki','Kd','FF','error') 
grid on
xlim([20 27]);

%%