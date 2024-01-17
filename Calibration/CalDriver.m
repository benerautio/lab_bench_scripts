function [ Cal_T, Cal_C ] = CalDriver( SMJ100A, E4419B, FSQ26, Fo, Pcal, bandwidth, measureTime, mechAttenuation )
%CalCoupler Calibrates the Power In at the Input plane of the DUT
%   Detailed explanation goes here

%% Setup Config
h = DriverCalibration;
uiwait(h) 

%% Thermal Steady State
SMJ100A_FreqSet(SMJ100A, Fo(1))
SMJ100A_PowerSet(SMJ100A, Pcal(1))
SMJ100A_OnOff(SMJ100A, 'on')
pause(60)

%% Run Calibration
Cal_T = zero(length(Fo), length(Pcal));
Cal_C = zero(length(Fo), length(Pcal));
for i = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(i))
    FSQ26_Close( FSQ26 )
    FSQ26 = FSQ26_Setup(Fo(i), bandwidth, measureTime, mechAttenuation)
    for j = 1:1:length(Pcal)
        SMJ100A_PowerSet(SMJ100A, Pcal(j))
        pause(5) %Thermal Steady State
        Pstp = 1;
        while Pstp > 0.1
            Pstp = Pstp - 0.1;
        end %Pstp
        Cal_C(i, j) = E4419B_ReadPower(E4419B, Fo(i));
        Cal_T(i, j) = FSQ26_ReadTonePower(FSQ26, Fo(i));
    end %Pcal
end %Fo
SMJ100A_OnOff(SMJ100A, 'off')
end

