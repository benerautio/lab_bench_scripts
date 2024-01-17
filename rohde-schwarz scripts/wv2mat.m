function [signal, sr, fvec] = wv2mat( wvFile )
%%WV2MAT Attempts to port a binary .wv file into Matlab(TM)
%   Does not support encrypted .wv file format.
% 
%   Example:
%   [tsig, fs, fvec] = wv2mat('noise.wv');
%
%   start of a wv file:
%   {TYPE: SMU-WV,0}
%   {COMMENT: xxx}
%   {DATE: 2017-12-05;16:03:23}
%   {LEVEL OFFS: 8.6462, 0}
%   {CLOCK: 100000}
%   {SAMPLES: 10000}
%   {WAVEFORM-40001:#
%
%   Critical bits done by Naehring, showpony features added by Lloyd.
%   December 2017.

%% the business end
% read whole file to content array
content = fileread(wvFile);
% read sample rate
try
  sr = regexp(content, '\{CLOCK:(.*?)\}', 'tokens');
  sr = str2double(sr{1}{1});
catch
  sr = 0;
end

% the binary part of the wv file: {WAVEFORM-<length>:#<binary>}
% v1.1 adds try-catch for encrypted detection
try
    tokens = regexp(content, '\{WAVEFORM\-(\d*):\s*#(.*)\}', 'tokens');

    % the output is a 1-by-n cell array, where n is the number of matches.
    % Each cell contains a 1-by-m cell array of matches, where m is the number
    % of tokens in the match. 
    % expect only one match
    tokens = tokens{1};
    % expect two tokens for the match
    bytes = str2double(tokens{1});
    binary = tokens{2};

    if length(binary) ~= bytes-1
      warning('Expected different length');
    end

    % convert binary to I/Q
    % workaround using fread() to convert data type char -> int16
    bytes = length(binary);
    f = fopen('tmp', 'w+');
    fwrite(f, binary);
    fseek(f, 0, 'bof');
    binary = fread(f, bytes/2, '*int16');
    fclose(f);
    delete 'tmp';

    signal = double(binary);
    signal = signal ./ (2^15-1);
    i = signal(1:2:end-1);
    q = signal(2:2:end);
    signal = complex(i, q);

    % v1.1 adds this section
    % return a frequency vector, based on sample clock and signal length
    % to be used with, e.g. 20*log10(abs(fftshift(fft(signal))))
    npts = length(signal);
    fvec = -sr/2:sr/(npts-1):sr/2;

catch
    warning('Unimportable. Potentially encrypted.');
    fvec = [];
    signal = [];
end

end
