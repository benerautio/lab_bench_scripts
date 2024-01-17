function [ Cal_T, Cal_C, FSQ26 ] = CalCoupler( SMJ100A, E4419B, FSQ26, Fo, Pcal)% bandwidth, measureTime, mechAttenuation )
%CalCoupler Calibrates out the Coupler Losses
%   Detailed explanation goes here

%% Setup Config
h = CouplerCalibration;
uiwait(h) 

%% Thermal Steady State
SMJ100A_FreqSet(SMJ100A, Fo(1))
SMJ100A_PowerSet(SMJ100A, Pcal(1))
SMJ100A_OnOff(SMJ100A, 'on')

%% Run Calibration
Cal_T = zeros(length(Fo), length(Pcal));
Cal_C = zeros(length(Fo), length(Pcal));
for i = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(i))
    FSQ26_Close( FSQ26 )
    FSQ26 = FSQ26_Setup(Fo(i))%, bandwidth, measureTime, mechAttenuation)
    for j = 1:1:length(Pcal)
        SMJ100A_PowerSet(SMJ100A, Pcal(j))
        pause(5)%pause(60) %Thermal Steady State
        Cal_C(i, j) = E4419B_ReadPower(E4419B, Fo(i));
        Cal_T(i, j) = FSQ26_ReadTonePower(FSQ26, Fo(i));
    end %Pcal
end %Fo
SMJ100A_OnOff(SMJ100A, 'off')
end