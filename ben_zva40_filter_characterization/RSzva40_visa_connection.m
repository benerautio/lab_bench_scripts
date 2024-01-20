%% connecting to zva40 using VISA
% Ben Rautio 1-17-2024

%get available device info. First make sure that device connection is working
%with keysight connection expert. Also make sure that the preferred VISA is
%set to R&S. 
resourcelist = visadevlist;

%% choose the device resource name to connect to. In my case, it is the first
%one in the list
%create the object used to communicate with the device
zva40 = visadev(resourcelist{1,1});

%read id string from instrument
data = writeread(zva40,"*IDN?");

%% when done, clear the object
clear zva40