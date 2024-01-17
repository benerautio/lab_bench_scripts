function [ Xin ] = TwoToneCalFSQ26Atten( SMJ100A, FSQ26, Fo, Pin, SpacingFreq, F1, F2, OS )
%TwoToneCalFSQ26Atten Summary of this function goes here
%   Detailed explanation goes here
Xin = ones(length(Fo.*Pin),4);
idx = 1;
for i = 1:1:length(Fo)
    %Tone Frequencies
    FundToneL = Fo(i)-SpacingFreq/2;
    FundToneH = Fo(i)+SpacingFreq/2;
    IMD3ToneL = 2*FundToneH-FundToneL;
    IMD3ToneH = 2*FundToneL-FundToneH;
    SMJ100A_TwoToneGen(SMJ100A, Fo(i)-(F1+SpacingFreq/2), F1, F2, OS)
    for j = 1:1:length(Pin)
        Xin(idx, 1) = FSQ26_ReadTonePower(FSQ26, FundToneH);
        Xin(idx, 2) = FSQ26_ReadTonePower(FSQ26, FundToneL);
        Xin(idx, 3) = FSQ26_ReadTonePower(FSQ26, IMD3ToneH);
        Xin(idx, 4) = FSQ26_ReadTonePower(FSQ26, IMD3ToneL);
        idx = idx+1;
    end %Pin
end %Fo

end

