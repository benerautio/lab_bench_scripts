function varargout = PowerMeterSetup(varargin)
% POWERMETERSETUP MATLAB code for PowerMeterSetup.fig
%      POWERMETERSETUP, by itself, creates a new POWERMETERSETUP or raises the existing
%      singleton*.
%
%      H = POWERMETERSETUP returns the handle to a new POWERMETERSETUP or the handle to
%      the existing singleton*.
%
%      POWERMETERSETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POWERMETERSETUP.M with the given input arguments.
%
%      POWERMETERSETUP('Property','Value',...) creates a new POWERMETERSETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PowerMeterSetup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PowerMeterSetup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PowerMeterSetup

% Last Modified by GUIDE v2.5 30-Apr-2018 19:51:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PowerMeterSetup_OpeningFcn, ...
                   'gui_OutputFcn',  @PowerMeterSetup_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PowerMeterSetup is made visible.
function PowerMeterSetup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PowerMeterSetup (see VARARGIN)

% Choose default command line output for PowerMeterSetup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PowerMeterSetup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PowerMeterSetup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
