%make maneuver type offline manual

%make sure transmission Automatic
MDL.DrivetrainBasic.Sw_Transmission_Mode.v = 2;
MDL.DrivetrainBasic.Sw_Transmission_Mode

%turn off engine EGR valve - set to external mode
MDL.SoftECU.SoftECUDiesel.AirPathControl.EGRRateControl.Sw_EGR_Rate.v = 3;
MDL.SoftECU.SoftECUDiesel.AirPathControl.EGRRateControl.Sw_EGR_Rate

%set fuel injection quantity to external
MDL.SoftECU.SoftECUDiesel.FuelSystemControl.InjectionQuantity.Sw_q_Inj.v = 3;
MDL.SoftECU.SoftECUDiesel.FuelSystemControl.InjectionQuantity.Sw_q_Inj

%set intake manifold pressure to external
MDL.SoftECU.SoftECUDiesel.AirPathControl.TurboControl.Sw_p_In_Throttle.v = 3;
MDL.SoftECU.SoftECUDiesel.AirPathControl.TurboControl.Sw_p_In_Throttle

%start simulation in park, brake at 100%, acc pedal at 0%

%initialize controller gains

%%
%base data timeseries
% base_data = [time lambda fuel_inj p_inman v_veh n_eng eng_trq];
base_lambda = base_data(2);
base_fuel_inj = base_data(3);
base_p_inman = base_data(4);
base_v_veh = base_data(5);
base_n_eng = base_data(6);
base_time = base_data(1);
base_eng_trq = base_data(7);

%base data desired values - data only, not a timeseries
v_veh_d = getdatasamples(base_data(5),[1:base_data(5).TimeInfo.length]);
eng_trq_d = getdatasamples(base_data(7),[1:base_data(7).TimeInfo.length]);
lambda_d = getdatasamples(base_data(2),[1:base_data(2).TimeInfo.length]);
p_inman_d = getdatasamples(base_data(4),[1:base_data(4).TimeInfo.length]);
fuel_inj_d = getdatasamples(base_data(3),[1:base_data(3).TimeInfo.length]);