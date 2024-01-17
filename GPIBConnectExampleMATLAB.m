%% Example: connect to lab instruments over GPIB
%  Taylor Barton
%  Last edited: 2014-11-25

%% Define the GPIB addresses of the instruments to connect:
GPIB_SMJ = 28;

%% Create a GPIB object:
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 7, 'PrimaryAddress', GPIB_SMJ, 'Tag', '');
% BoardIndex      7 is the index for the GPIB control board
% PrimaryAddress  sets GPIB address of the instrument (e.g. 28 = SMJ100A)


% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('AGILENT', 7, GPIB_SMJ);
else
    fclose(obj1);
    obj1 = obj1(1)
end

% Connect to instrument object, obj1.
fopen(obj1);

% Communicating with instrument object, obj1.
SMJ_IDN = query(obj1, '*IDN?');

% SMJ_IDN now contains the string returned by the instrument.
% in this example,
display(SMJ_IDN);
% should display:
% Rohde&Schwarz,SMJ100A,1403.4507k02/101159,2.7.15.1-02.20.360.142
