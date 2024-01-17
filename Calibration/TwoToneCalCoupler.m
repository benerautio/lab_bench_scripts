function [ Xt, Xc ] = TwoToneCalCoupler( SMJ100A, FSQ26, E4419B, Fo, Pin, SpacingFreq, F1, F2, OS )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Xt = ones(length(Fo.*Pin),4);
Xc = ones(length(Fo.*Pin),4);
idx = 1;
for i = 1:1:length(Fo)
    %Tone Frequencies
    FundToneL = Fo(i)-SpacingFreq/2;
    FundToneH = Fo(i)+SpacingFreq/2;
    IMD3ToneL = 2*FundToneH-FundToneL;
    IMD3ToneH = 2*FundToneL-FundToneH;
    SMJ100A_TwoToneGen(SMJ100A, Fo(i)-(F1+SpacingFreq/2), F1, F2, OS)
    for j = 1:1:length(Pin)
        Xt(idx, 1) = FSQ26_ReadTonePower(FSQ26, FundToneH);
        Xt(idx, 2) = FSQ26_ReadTonePower(FSQ26, FundToneL);
        Xt(idx, 3) = FSQ26_ReadTonePower(FSQ26, IMD3ToneH);
        Xt(idx, 4) = FSQ26_ReadTonePower(FSQ26, IMD3ToneL);
        Xc(idx, 1) = E4419B_ReadPower(E4419B, FundToneH);
        Xc(idx, 2) = E4419B_ReadPower(E4419B, FundToneL);
        Xc(idx, 3) = E4419B_ReadPower(E4419B, IMD3ToneH);
        Xc(idx, 4) = E4419B_ReadPower(E4419B, IMD3ToneL);
        idx = idx+1;
    end %Pin
end %Fo
end

