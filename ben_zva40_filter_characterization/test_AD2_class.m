daqreset
devices = daqlist;
dq = daq(devices.VendorID(1));
ad2 = AD2_ctl(dq, devices.DeviceID(1));
ad2.setCorners(550, 19);
pause(0.01)

resourcelist = visadevlist;
vna = visadev(resourcelist{1,1});
zva40 = ZVA40_ctl(vna);
pdat = zva40.readPhase(200)
mdat = zva40.readMag(200)
pdat = zva40.readPhase(100)
mdat = zva40.readMag(100)

clear vna
clear zva40