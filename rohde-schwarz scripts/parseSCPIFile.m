function [instrumentSays] = parseSCPIFile(visaResource, fileToParse, withOPC, withReset)
% PARSESCPIFILE Reads an ASCII file of SCPI commands, parses line-by-line, sends to
% resource.
% Queries are detected, their collective responses are collated,
% and appended to a string, and returned from the function.
% The 'percent' character, as per Matlab usage, denotes a comment in the
% .scpi file.
%
% Example: parseSCPIFile('TCPIP::10.85.0.167::INSTR', 'test.scpi', 1, 0)
% Without an initial reset, parses the content of test.scpi and sends it to
% the resource with IP address 10.85.0.167

%%
% Check if visaResource is already a resource, if not, create it
    if (ischar(visaResource))
        objInstr = VISA_Instrument(visaResource);
        openClose = true;
    elseif (isa(visaResource, 'VISA_Instrument'))
        objInstr = visaResource;
        openClose = false;
    else
        error('"visaResource" parameter must be either ResourceName string or "VISA_Instrument" object');
    end

    
%%
% instance the array for collating data
instrumentSays = [];

if withReset
    objInstr.Write('*RST'); objInstr.QueryString('*OPC?');
end

try
    fid = fopen(fileToParse);
    
    tline = fgetl(fid);

    while ischar(tline)
        %disp(tline);

        if length(tline)>0
            if (tline(1) ~= '%') && (tline(1) ~= ' ') && (tline(1) ~= '#') && (tline(1) ~= '/')

                if strfind(tline,'?')
                    instrumentSays = strcat(instrumentSays, ',', objInstr.QueryString(tline));

                else

                    objInstr.Write(tline);

                    if withOPC
                        objInstr.QueryString('*OPC?');
                    end
                end
            end
        end

        tline = fgetl(fid);

    end

    fclose(fid);
    objInstr.Close();

    if instrumentSays
        instrumentSays = str2num(strrep(instrumentSays(2:end),';',','));
    end

catch
    disp('Could not open SCPI file');
end

end