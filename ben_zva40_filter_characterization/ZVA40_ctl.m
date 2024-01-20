classdef ZVA40_ctl
    %ZVA40_CTL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        visa
    end
    
    methods
        function obj = ZVA40_ctl(visa)
            %ZVA40_CTL Construct an instance of this class
            %   Detailed explanation goes here
            obj.visa = visa;
            write(visa, "CALCulate1:PARameter:SDEFine 'Trc2', 'S21'", "string")
            write(visa, "CALCulate1:FORMat PHASe", "string")
            write(visa, "DISPlay:WINDow1:TRACe2:FEED 'Trc2'", "string")
            write(visa, "CALCulate1:PARameter:SELect 'Trc2'", "string")
            write(visa, "CALCulate1:MARKer1:STATe ON", "string")
            write(visa, "CALCULATE1:MARKER:COUPLED OFF", "string")
        end
        
        function phaseDat = readPhase(obj,freq)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            freq_req = string(freq) + "MHZ";
            write(obj.visa, "CALCulate1:PARameter:SELect 'Trc2'", "string")
            write(obj.visa, "CALCULATE1:MARKER1:X " + freq_req,"string")
            phase = writeread(obj.visa, "CALCULATE1:MARKER1:Y?");
            freq = writeread(obj.visa, "CALCULATE1:MARKER1:X?");
            phaseDat = [freq, phase];
        end

        function magDat = readMag(obj, freq)
            freq_req = string(freq) + "MHZ";
            write(obj.visa, "CALCulate1:PARameter:SELect 'Trc1'", "string")
            write(obj.visa, "CALCULATE1:MARKER1:X " + freq_req,"string")
            mag = writeread(obj.visa, "CALCULATE1:MARKER1:Y?");
            freq = writeread(obj.visa, "CALCULATE1:MARKER1:X?");
            magDat = [freq, mag];
        end

        % function delete()
        % end
    end
end

