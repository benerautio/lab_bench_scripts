function [ Pavs, FSQ26 ] = DriverCal( SMJ100A, FSQ26, Fo, Pavs_desired, Pcal, Atten )
%DriverCal Summary of this function goes here
%   Detailed explanation goes here
% %% Setup Config
% h = DriverCalibration;
% uiwait(h)

%% Thermal Steady State
SMJ100A_FreqSet(SMJ100A, Fo(1))
SMJ100A_PowerSet(SMJ100A, Pcal(1))
SMJ100A_OnOff(SMJ100A, 'on')

%% Run Calibration
Pavs = zeros(length(Fo), length(Pcal));
h = waitbar(0, 'Driver Input Power Calibration in Progress...')
idx =1; %temp value for recording progress on waitbar
for i = 1:1:length(Fo)
    SMJ100A_FreqSet(SMJ100A, Fo(i))
    for j = 1:1:length(Pcal)
%         pset = Pcal(j);
%         error = 1;
%         while abs(error) > 0.1 
%             SMJ100A_PowerSet(SMJ100A, pset)
%             pause(10)
%             meas = FSQ26_ReadTonePower( FSQ26, Fo(i) )-Atten;
%             error = Pavs_desired(j)-meas;
%             pset = pset + error;
%             if abs(error) < 0.1
%                 pset = pset - error;
%             end
%         end
%         Pavs(i,j) = pset;
%         % UPDATE WAITBAR
%         waitbar(idx./(length(Fo)*length(Pcal)),h,'Driver Input Power Calibration in Progress...')
%         idx = idx + 1;
%         
        pinc = 5;
        pset = Pcal(j);
        while pinc > 0.1 %0.1 dB accuracy
            SMJ100A_PowerSet(SMJ100A, pset)
            pause(5)%pause(60) %Thermal Steady State
            %meas = (E4419B_ReadPower(E4419B, Fo(i)) - Atten);
            meas = FSQ26_ReadTonePower( FSQ26, Fo(i) )-Atten;
            if (meas > Pavs_desired(j))
                %SMJ100A_PowerSet(SMJ100A, pset - pinc)
                pset = pset - pinc;
                pinc = pinc./2;
            end
            pset = pset + pinc;
        end
        Pavs(i,j) = pset;
        % UPDATE WAITBAR
        waitbar(idx./(length(Fo)*length(Pcal)),h,'Driver Input Power Calibration in Progress...')
        idx = idx + 1;
    end %Pcal
end %Fo
SMJ100A_OnOff(SMJ100A, 'off')
close(h) %close waitbar

end
