function [ Cal ] = CalAttenuator( SMJ100A, E4419B, Fo, Pcal )
%CalAttenuator Calibrates an attenuator over frequency and power
%   Detailed explanation goes here

%% Thermal Steady State
SMJ100A_FreqSet(SMJ100A, Fo(1))
SMJ100A_PowerSet(SMJ100A, Pcal(1))
SMJ100A_OnOff(SMJ100A, 'on')

%% Run Calibration
Cal = zeros(length(Fo), length(Pcal));
for i = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(i))
    for j = 1:1:length(Pcal)
        SMJ100A_PowerSet(SMJ100A, Pcal(j))
        pause(5)%pause(60) %Thermal Steady State
        Cal(i, j) = E4419B_ReadPower(E4419B, Fo(i));
    end %Pcal
end %Fo
SMJ100A_OnOff(SMJ100A, 'off')
end