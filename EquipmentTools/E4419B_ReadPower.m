function [Power] = E4419B_ReadPower( E4419B, F, Channel )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%message = sprintf('SENS2:FREQ %.2fHz', F);
%fprintf(E4419B, message);
%fprintf(E4419B, 'CONF2 DEF, DEF, (@2)');
%fprintf(E4419B, 'INIT2');

message =  sprintf('FETC%d?',Channel);
Power = str2num(query(E4419B, message));
end

