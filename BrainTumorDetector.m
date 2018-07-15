function varargout = BrainTumorDetector(varargin)
% BRAINTUMORDETECTOR MATLAB code for BrainTumorDetector.fig
%      BRAINTUMORDETECTOR, by itself, creates a new BRAINTUMORDETECTOR or raises the existing
%      singleton*.
%
%      H = BRAINTUMORDETECTOR returns the handle to a new BRAINTUMORDETECTOR or the handle to
%      the existing singleton*.
%
%      BRAINTUMORDETECTOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BRAINTUMORDETECTOR.M with the given input arguments.
%
%      BRAINTUMORDETECTOR('Property','Value',...) creates a new BRAINTUMORDETECTOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BrainTumorDetector_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BrainTumorDetector_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BrainTumorDetector

% Last Modified by GUIDE v2.5 15-Jul-2018 19:11:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BrainTumorDetector_OpeningFcn, ...
                   'gui_OutputFcn',  @BrainTumorDetector_OutputFcn, ...
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


% --- Executes just before BrainTumorDetector is made visible.
function BrainTumorDetector_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BrainTumorDetector (see VARARGIN)

% Choose default command line output for BrainTumorDetector
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BrainTumorDetector wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BrainTumorDetector_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in upload_image.
function upload_image_Callback(hObject, eventdata, handles)
% hObject    handle to upload_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im im2
[path,user_cancel] = imgetfile();
if user_cancel
    msgbox(sprintf('Invalid Selection'),'Error','Warn');
    return
end
im = imread(path);
im = im2double(im);
im2 = im;
axes(handles.axes1);
imshow(im);
title('\fontsize{18}\color[rgb]{0.635 0.078 0.184} Patient''s Brain')


% --- Executes on button press in detect_tumor.
function detect_tumor_Callback(hObject, eventdata, handles)
% hObject    handle to detect_tumor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im

axes(handles.axes2);
bw = im2bw(im,0.7);
label = bwlabel(bw);
stats = regionprops(label,'Solidity','Area');

density = [stats.Solidity];
area = [stats.Area];
high_dense_area = density > 0.5;
max_area = max(area(high_dense_area));
tumor_label = find(area==max_area);
tumor = ismember(label,tumor_label);

se = strel('square',5);
tumor = imdilate(tumor,se);

[B,L] = bwboundaries(tumor,'noholes');

imshow(im)
hold on
for i=1:length(B)
    plot(B{i}(:,2),B{i}(:,1), 'y' ,'linewidth',1.45);
end
title('\fontsize{18}\color[rgb]{0.635 0.078 0.184} Detected Tumors')
hold off
