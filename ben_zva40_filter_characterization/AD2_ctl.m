classdef AD2_ctl
    %AD2_CTL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        LC
        HC
        dq
        deviceID
        bits
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
    end
    
    methods
        function obj = AD2_ctl(dq, deviceID)
            %AD2_CTL Construct an instance of this class
            %   Detailed explanation goes here
            obj.dq = dq;
            obj.deviceID=deviceID;
            %create digital io
            %For LPF, switch A is dio04, switch E is dio00
            addoutput(dq, deviceID, "dio00", "Digital")
            addoutput(dq, deviceID, "dio01", "Digital")
            addoutput(dq, deviceID, "dio02", "Digital")
            addoutput(dq, deviceID, "dio03", "Digital")
            addoutput(dq, deviceID, "dio04", "Digital")
            %For HPF, switch A is dio05, switch E is dio09
            addoutput(dq, deviceID, "dio05", "Digital")
            addoutput(dq, deviceID, "dio06", "Digital")
            addoutput(dq, deviceID, "dio07", "Digital")
            addoutput(dq, deviceID, "dio08", "Digital")
            addoutput(dq, deviceID, "dio09", "Digital")
            write(dq, [0 0 0 0 0 0 0 0 0 1])
            obj.bits = [0 0 0 0 0 0 0 0 0 1];
            obj.LC = 28;
            obj.HC = 19;
        end
        
        function obj = setLower(obj, lower)
            if (any(obj.LPF_states == lower))
                obj.LC=lower;
            else
                warning("Provided lower corner doesn't exist")
            end
        end
        function obj = setUpper(obj, upper)
            if (any(obj.HPF_states == upper))
                obj.HC=upper;
            else
                warning("Provided upper corner doesn't exist")
            end
        end
        function obj = setBits(obj)
            index = find(obj.LPF_states==obj.LC);
            bitslpf = dec2bin(index-1,5) == '1';

            index2 = find(obj.HPF_states == obj.HC);
            bitshpf = flip(obj.HPF_bits(index2(1),:) == '1');

            obj.bits = [bitslpf bitshpf];
            write(obj.dq, obj.bits)
        end
        function obj = setCorners(obj, lower, upper)
            if upper>lower
                warning("Provided upper corner frequency larger than lower, not changing corner frequencies")
                return
            end
            obj = obj.setLower(lower);
            obj = obj.setUpper(upper);
            obj = obj.setBits();
        end
    end
    methods(Static)
    end

end

