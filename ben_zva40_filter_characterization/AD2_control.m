%% Program to control filter bank cutoff frequency using the AD2
%Ben Rautio 1-19-24

%must install the matlab DAQ toolbox and the Digilent Analog Discovery
%toolbox

%list devices
daqreset
devices = daqlist;

%create daq object from available devices
dq = daq(devices.VendorID(1));

%map cutoff freq of LPF to switch states
LPF_states = [28
    29
    30
    31
    32
    33
    35
    36
    43
    46
    49
    53
    65
    73
    89
    112
    141
    145
    149
    153
    163
    168
    174
    180
    213
    224
    239
    254
    318
    357
    439
    550];

HPF_states = [19
    19
    20
    20
    23
    23
    24
    25
    35
    36
    38
    39
    50
    53
    64
    76
    100
    100
    103
    105
    121
    124
    131
    136
    193
    196
    209
    215
    260
    272
    316
    355];

HPF_bits = ['10000'
    '10001'
    '10010'
    '10011'
    '10100'
    '10101'
    '10110'
    '10111'
    '11000'
    '11001'
    '11010'
    '11011'
    '11100'
    '11101'
    '11110'
    '11111'
    '00000'
    '00001'
    '00010'
    '00011'
    '00100'
    '00101'
    '00110'
    '00111'
    '01000'
    '01001'
    '01010'
    '01011'
    '01100'
    '01101'
    '01110'
    '01111'];
% HPF_bits=string(HPF_bits);

%create digital io
%For LPF, switch A is dio04, switch E is dio00
addoutput(dq, devices.DeviceID(1), "dio00", "Digital")
addoutput(dq, devices.DeviceID(1), "dio01", "Digital")
addoutput(dq, devices.DeviceID(1), "dio02", "Digital")
addoutput(dq, devices.DeviceID(1), "dio03", "Digital")
addoutput(dq, devices.DeviceID(1), "dio04", "Digital")
%For HPF, switch A is dio05, switch E is dio09
addoutput(dq, devices.DeviceID(1), "dio05", "Digital")
addoutput(dq, devices.DeviceID(1), "dio06", "Digital")
addoutput(dq, devices.DeviceID(1), "dio07", "Digital")
addoutput(dq, devices.DeviceID(1), "dio08", "Digital")
addoutput(dq, devices.DeviceID(1), "dio09", "Digital")

%create 5 bit array to write to digital output
%for example, for 89MHz cutoff...
index = find(LPF_states==89);
bits = dec2bin(index-1,5) == '1';
index2 = find(HPF_states == 19);
bits2 = flip(HPF_bits(index2(1),:) == '1');


% write to output
write(dq, [bits bits2])