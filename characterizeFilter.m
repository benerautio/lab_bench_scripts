close all
f = 200; %in MHz

%make a daq for the AD2
daqreset
devices = daqlist;
dq = daq(devices.VendorID(1));
ad2 = AD2_ctl(dq, devices.DeviceID(1));

%instantiate object to control zva40 vna
resourcelist = visadevlist;
vna = visadev(resourcelist{1,1});
zva40 = ZVA40_ctl(vna);

%figure out which cutoff frequencies are valid
lc = ad2.LPF_states(ad2.LPF_states > 100);
hc = ad2.HPF_states(ad2.HPF_states < 100);

%for each combo, find phase and mag
filter_data = zeros(numel(hc)*numel(lc), 4);
%get all combos
[n,m] = ndgrid(lc,hc);
out = [m(:),n(:)];
filter_data(:,1:2) = out;

%finally, query the VNA for all of this data
disp("Start Sweep...")
% pause(3)
for i = 1:size(filter_data, 1)
    hpf_corner = filter_data(i,1);
    lpf_corner = filter_data(i,2);
    ad2.setCorners(lpf_corner, hpf_corner);
    pause(0.5)
    pdat = zva40.readPhase(f);
    mdat = zva40.readMag(f);
    phase = double(pdat(2));
    mag = double(mdat(2));
    filter_data(i,3) = phase;
    filter_data(i,4) = mag;
end

clear vna
clear zva40