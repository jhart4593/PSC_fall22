% lambda (percentage AFR actual over AFR stoich)
% fuel_inj (mm3/cyc)
% p_inman (Pa)
% v_veh (km/h)
% n_eng (rpm)
% time (s)
% eng_trq (Nm)

%vehicle speed, engine torque, lambda comparison, engine speed
figure; clf
%vehicle speed
subplot(3,1,1)
plot(base_v_veh)
title('Vehicle Speed')
xlabel('Time (sec)')
ylabel('Speed (km/h)')
hold on
plot(v_veh)
legend('Desired','True') 
grid on
xlim([20 27]);

%engine torque
subplot(3,1,2)
plot(base_eng_trq)
title('Engine Torque')
xlabel('Time (sec)')
ylabel('Torque (Nm)')
hold on
plot(eng_trq)
legend('Desired','True')
grid on
xlim([20 27]);

%lambda
subplot(3,1,3)
plot(base_lambda)
title('Lambda')
xlabel('Time (sec)')
ylabel('Percent Ratio')
hold on
plot(lambda)
legend('Desired','True')
grid on
xlim([20 27]);

%intake manifold pressure and fuel injection quantity
figure; clf
%fuel injection
subplot(2,1,1)
plot(base_fuel_inj)
title('Fuel Injection')
xlabel('Time (sec)')
ylabel('Volume (mm3/cyc)')
hold on
plot(fuel_inj)
legend('Base Amount','Cont. Amount')
grid on
xlim([20 27]);

%intake manifold pressure
subplot(2,1,2)
plot(base_p_inman)
title('Intake Manifold Pressure')
xlabel('Time (sec)')
ylabel('Pressure (Pa)')
hold on
plot(p_inman)
legend('Base Pressure','Cont. Pressure')
grid on
xlim([20 27]);
