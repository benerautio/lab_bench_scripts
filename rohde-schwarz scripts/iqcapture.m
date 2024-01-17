function [signal, fVec, tVec] = iqcapture(Resource, fCenter, nSamples, samplingRate)
%%IQCAPTURE Captures raw IQ data from a signal analyser, using VISA_Instrument class.
%   Returns values as time domain, complex value pairs.
%
%   Example: [tIQ, fVec, tVec] = iqcapture(rscFSW,1e9,10000,61.44e6);
%   where rscFSW can be:
%    - a VISA resource string e.g. rscFSW = 'TCPIP::10.202.0.146::INSTR'
%    - an existing VISA_Instrument object created by e.g. rscFSW = VISA_Instrument('TCPIP::10.202.0.146::INSTR');
%   The example returns 10k sample pairs at a sample rate of 61.44MHz
%
%   Thus...
%   plot(fVec, 20*log10(abs(fftshift(fft(tIQ)))));
%   ... returns a magnitude spectrum plot of the captured signal
% 
%   An instance of an IQ window is checked for, if none, then one is created.
%   The IQ measurement window is selected automatically
%   Also returns the frequency vector and time vector for the capture
%   Naehring and Macko did the clever bits.
%   Lloyd 2018/11
%   (C) Rohde & Schwarz

%% set up instrument
    if (ischar(Resource))
        myFSW = VISA_Instrument(Resource);
        openClose = true;
    elseif (isa(Resource, 'VISA_Instrument'))
        myFSW = Resource;
        openClose = false;
    else
        error('"Resource" parameter must be either ResourceName string or "VISA_Instrument" object');
    end
    
    %% get IQ

    % go to IQ mode
    mode = 'IQ';
    Channels = strsplit(myFSW.QueryString('INST:LIST?'),',');
    ChIdx = strfind(cell2mat(Channels),mode);
    if ~isempty(ChIdx) %length(ChIdx) > 0
      myFSW.Write('INST:SEL %s', mode);
    else
      myFSW.Write('INST:CRE %s, ''%s''', mode, mode);
      myFSW.Write('INST:SEL %s', mode);
    end
    clear Channels mode;

    % set parameters
    myFSW.Write('FREQ:CENT %d', fCenter);
    myFSW.QueryInteger('INIT:CONT OFF;:TRAC:IQ:SRAT %d;:TRAC:IQ:RLEN %d;*OPC?', samplingRate, nSamples);

    % single run acquisition + querying the data
    iqData = myFSW.QueryBinaryFloatData('TRAC:IQ:DATA:FORM IQPair;:FORM REAL,32;:TRAC:IQ:DATA?');
    
    if (openClose)
        myFSW.Close();
    end
    
    iData = iqData(1:2:end-1);
    qData = iqData(2:2:end);
    signal = iData + 1i*qData;
    
    fVec = fCenter + linspace(-samplingRate/2, samplingRate/2, nSamples);
    tVec = 0:1/samplingRate:(nSamples-1)/samplingRate;

end