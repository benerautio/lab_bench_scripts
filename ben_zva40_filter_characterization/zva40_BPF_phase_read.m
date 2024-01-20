%% Connect to ZVA40 and read phase
% Ben Rautio 1-17-2024

%frequency sweep is already setup
% Start, 10MHz, Stop 1GHz, log sweep 801 pts, 10KHz meas BW

%first collecting phase data at 200MHz, but attenuation here is hoorible.
%Almost 10db? Maybe move it down? 100MHz must better

%get available device info. First make sure that device connection is working
%with keysight connection expert. Also make sure that the preferred VISA is
%set to R&S. 
resourcelist = visadevlist;

%% choose the device resource name to connect to. In my case, it is the first
%one in the list
%create the object used to communicate with the device
zva40 = visadev(resourcelist{1,1});

% data = writeread(zva40,"*IDN?");

write(zva40, "CALCulate1:PARameter:SDEFine 'Trc2', 'S21'", "string")
write(zva40, "CALCulate1:FORMat PHASe", "string")
write(zva40, "DISPlay:WINDow1:TRACe2:FEED 'Trc2'", "string")
write(zva40, "CALCulate1:PARameter:SELect 'Trc2'", "string")
write(zva40, "CALCulate1:MARKer1:STATe ON", "string")
write(zva40, "CALCULATE1:MARKER:COUPLED OFF", "string")

write(zva40, "CALCULATE1:MARKER1:X 200MHZ","string")
phase = writeread(zva40, "CALCULATE1:MARKER1:Y?");

%% Done
clear zva40