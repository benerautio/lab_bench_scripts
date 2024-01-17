% CW Sweep IMS 2020 PA Comp
% Will Sear

%% Setup
close all; clear all;
dirPath = 'C:\Users\Batman 2.0\Documents\Research\Testing\Matlab_Bench_Controllers'; %TODO: automatically set if possible
%addpath(strcat(dirPath,'\Calibration')) %Not used in current script
%addpath(strcat(dirPath,'\EquipmentConfiguration')) %Not used in current script
addpath(strcat(dirPath,'\EquipmentTools'))
%addpath(strcat(dirPath,'\PlottingTools')) %Not used in current script
addpath(strcat(dirPath,'\RSTools'))

%% User Set Parameters
%Fo = [2e9:0.05e9:2.5e9]; %Center Frequency (Hz)
Fo = [2.4e9];
Pdes = [15:1:36]; %power applied to input (dBm)

%% Calibration Values
OutputAtten = 34.78; %output attenuator value (dB)
InputAtten = 30.15; %input attenuator value (dB)
GainDriver = 32.3; %Driver Gain (dB)

%% Configure Instrument Settings
%Power Settings
Pavs = repmat(Pdes,length(Fo),1)'-(GainDriver);%power at VSA (dBm) 

% N6705 Settings
Gate = 2; %channel
Drain = 3; %channel

% VSA Settings
%N/A

% E4419B Settings
ChannelIn = 1;
ChannelOut = 1; % More channels for meter with multiple 

%% Setup Bench Equipment
GPIBBoard = 7;
E4419B_input_meter = E4419B_Setup(GPIBBoard,13) %Power Meter
E4419B_output_meter = E4419B_Setup(GPIBBoard,15) %Power Meter
N6705A = N6705A_Setup(GPIBBoard,5) %DC Power Supply
SMJ100A = SMJ100A_Setup(GPIBBoard,28) %Vector Signal Generator

%% Prepare Engineering Datasets
size_eng = [length(Pavs), length(Fo)];
Vd_eng = zeros(size_eng);
Vg_eng = zeros(size_eng);
Id_eng = zeros(size_eng);
Ig_eng = zeros(size_eng);
FundToneOut_eng = zeros(size_eng);
FundToneIn_eng = zeros(size_eng);

%% Conduct Sweeps
idx = 0; %temp value for recording progress on waitbar
h = waitbar(0, 'Testing Sweep in Progress...')
SMJ100A_OnOff(SMJ100A, 'on')
for j = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(j))
for i = 1:1:length(Pavs)
    SMJ100A_PowerSet(SMJ100A, Pavs(end-i+1,j))
    pause(3)%thermal steady state % 5 second wait
    %RECORD RESULTS
    FundToneOut_eng(i,j) = E4419B_ReadPower(E4419B_output_meter, Fo(j), ChannelOut);
    FundToneIn_eng(i,j) = E4419B_ReadPower(E4419B_input_meter, Fo(j), ChannelIn);
    Vd_eng(i,j) = N6705A_GetVal(N6705A, Drain, 'voltage');
    Vg_eng(i,j) = N6705A_GetVal(N6705A, Gate, 'voltage');
    Id_eng(i,j) = N6705A_GetVal(N6705A, Drain, 'current');
    Ig_eng(i,j) = N6705A_GetVal(N6705A, Gate, 'current');
    % UPDATE WAITBAR
    waitbar(idx./prod(size_eng),h,'Testing Sweep in Progress...')
    idx = idx + 1;
end %Pavs
end %Fo
close(h) %close waitbar
SMJ100A_OnOff(SMJ100A, 'off')

%% Safe Bench Equipment
N6705A_Close( N6705A ) %DC Supply
E4419B_Close( E4419B_input_meter ) %Power Meter
E4419B_Close( E4419B_output_meter ) %Power Meter
SMJ100A_Close( SMJ100A ) %Vector Signal Generator

%% Plotting Calculations
Pout = flip(FundToneOut_eng)+OutputAtten; %dBm
Pout_watts = 10.^(Pout./10)./1000; % Watts

Pin = flip(FundToneIn_eng)+InputAtten; %dBm
Pin_watts = 10.^(Pin./10)./1000; % Watts

Pdc_Drain = flip(Vd_eng).*flip(Id_eng); % Watts
Pdc_Gate = flip(Vg_eng).*flip(Ig_eng); % Watts
Pdc_tot = Pdc_Drain + Pdc_Gate; % Watts

DE = Pout_watts./Pdc_tot.*100;% [%]
PAE = (Pout_watts-Pin_watts)./Pdc_tot.*100; % [%]
nD = (Pout_watts)./Pdc_tot.*100;

Gain = Pout - Pin; %dB

%% Plotting
set(0,'DefaultAxesFontName', 'TimesNewRoman');
set(0,'DefaultAxesFontSize', 18);
set(0,'DefaultTextFontname', 'TimesNewRoman');
set(0,'DefaultTextFontSize', 18);
set(0,'DefaultLineLineWidth', 2)

plot(Pout, Gain, '-r')
ylabel('Gain (dB)')
%xlim([12 39])
%xticks([0:3:39])
%ylim([14 16.5])
%yticks([12.4:0.2:13.6])
yyaxis right
%ylim([0 45])
%yticks([0:9:45])
plot(Pout, PAE, '-b')
ylabel('Efficiency (%)')
%plot([36.02 36.02], [0 40], 'k--')

grid on
xlabel('Pout (dBm)')
legend('Gain', 'PAE')

ax = gca;
ax.YColor = 'k'

Fo
maxPout = max(Pout)
maxPAE = max(PAE)

figure
hold on
plot(Pin,Gain)
plot(Pin,Pout)
yyaxis right
plot(Pin,nD)
hold off



% EOF