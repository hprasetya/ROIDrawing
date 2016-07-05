function varargout = ROIDrawing_32(varargin)
% ROIDRAWING_32 MATLAB code for ROIDrawing_32.fig
%      ROIDRAWING_32, by itself, creates a new ROIDRAWING_32 or raises the existing
%      singleton*.
%
%      H = ROIDRAWING_32 returns the handle to a new ROIDRAWING_32 or the handle to
%      the existing singleton*.
%
%      ROIDRAWING_32('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROIDRAWING_32.M with the given input arguments.
%
%      ROIDRAWING_32('Property','Value',...) creates a new ROIDRAWING_32 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ROIDrawing_32_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ROIDrawing_32_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ROIDrawing_32

% Last Modified by GUIDE v2.5 24-Jun-2016 16:13:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ROIDrawing_32_OpeningFcn, ...
                   'gui_OutputFcn',  @ROIDrawing_32_OutputFcn, ...
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


% --- Executes just before ROIDrawing_32 is made visible.
function ROIDrawing_32_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ROIDrawing_32 (see VARARGIN)

% Choose default command line output for ROIDrawing_32
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ROIDrawing_32 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ROIDrawing_32_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
current_fig=gcf;
[handles.FileName,handles.PathName] = uigetfile('*.AVI','Select the video file');
file=strcat(handles.PathName,handles.FileName);
cd(handles.PathName)

% Extract dicom information
vidObj=VideoReader(file);
i=1;
FullFrame=read(vidObj);
while i<=vidObj.NumberOfFrames
    m(:,:,i)=rgb2gray(FullFrame(:,:,:,i));
    i=i+1;
end
tot_frame=vidObj.NumberOfFrames;

figure,handles.f2p = imshow3dim(m, []);

if isempty(handles.f2p)
    handles.f2p=round(size(m,3)/2);
end

FOR = m(:,:,handles.f2p);

handles.h=figure;
ROIdata=manualDrawROI(m,handles.f2p,tot_frame);

% polygon formation
[handles.xdata, handles.ydata, handles.BW, handles.xp, handles.yp] = roipoly;
hold on
plot(handles.xp,handles.yp)
figure(current_fig)
guidata(gcbo, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
part_PathName=strsplit(handles.PathName,'\');
currentDir=part_PathName{1};
currentFolder=strcat(currentDir,'\ROIDATA\');
desiredFolder=strrep(upper([strcat(currentFolder,handles.FileName) '\']),'.AVI','');
if ~exist(desiredFolder, 'dir')
    mkdir(desiredFolder);
end
xdata=handles.xdata;ydata=handles.ydata;BW=handles.BW;xp=handles.xp;yp=handles.yp;
f2p=handles.f2p;
fullFileName = fullfile(desiredFolder, 'ROI.mat');
save(fullFileName,'xdata','ydata','BW','xp','yp','f2p')
set(handles.output, 'HandleVisibility', 'off');
close all;
set(handles.output, 'HandleVisibility', 'on');