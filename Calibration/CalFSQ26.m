function [ Cal, FSQ26 ] = CalFSQ26( SMJ100A, FSQ26, Fo, Pcal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%% Setup Config
h = FSQ26Calibration;
uiwait(h) 

%% Thermal Steady State
SMJ100A_FreqSet(SMJ100A, Fo(1))
SMJ100A_PowerSet(SMJ100A, Pcal(1))
SMJ100A_OnOff(SMJ100A, 'on')

%% Run Calibration
Cal = zeros(length(Fo), length(Pcal));
for i = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(i))
    FSQ26_Close( FSQ26 )
    FSQ26 = FSQ26_Setup(Fo(i))%, bandwidth, measureTime, mechAttenuation) %Vector Signal Analyzer
    for j = 1:1:length(Pcal)
        SMJ100A_PowerSet(SMJ100A, Pcal(j))
        pause(5)%pause(60) %Thermal Steady State
        Cal(i, j) = FSQ26_ReadTonePower(FSQ26, Fo(i));
    end %Pcal
end %Fo
SMJ100A_OnOff(SMJ100A, 'off')
end

