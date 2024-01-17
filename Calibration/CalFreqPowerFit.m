function [ Freq_Coeff, Power_Coeff ] = CalFreqPowerFit( Fo, Pcal, Cal )
%CalFreqPowerFit Computes linear regressive fitting coefficients.
%   Detailed explanation goes here

%% Setup Calibration
Freq_Coeff = zero(length(Fo), 2);
Power_Coeff = zero(length(Pcal), 2);

%% Calculate Frequency Coefficients
%Not needed as we are not considering wide bandwidths
% for i = 1:1:length(Fo)
%     Freq_Coeff(i, :) = polyfit(Fo, Cal(i,:), 1);
% end %Fo

%% Calculate Power Coefficients
for i = 1:1:length(Pcal)
     Power_Coeff(:, i) = polyfit(Pcal, Cal(:,i), 1);
end %Pcal

end %function