
%           Do do list
% #1
%image combination
%       3 images file selction below the outer two Folder selction separate
%       Operator selection list below the center one (median, average, add,
%       subtract) you "can" select only one image and it will still run you
%       can only select spectra/maxes on center image
% #2 registering images to same slit location
%       match max line y vals of spectra centers to each other for each
%       operation
% #3 pixel value on  mouse point + small adjustable range window of cross
%       section.
%#4
% create full-auto max finder
%       upgraded scoreing system
clear, clc, close all          % clear cmd lines, variables, and figures

%% Define GUI Features
uiSize = [100 10 1800 900];                                                % size of enitre GUI in Pixels adjust freely [start x, start y, length, height]
mainUI = figure('Name','Main UI','position',uiSize);                        % create GUI
fitsData1 = fitsread("C:\Users\avery\Desktop\Research\spex-00099.a.fits");  % read FITS file using fitsread                                                       %
imageSet = {fitsData1};                                                     % define list of Images
spectraSet = {0};                                                           % define list of spectra to plot
featureSets = ["Spectra","Image","Image","Image"];                                          % Order the Images and Spectra on GUI, bottom up, must have one here for every image/spectra you are displaying

%% Create GUI Features
for i = 1:length(featureSets)
        x = 1;
        y = 1;
    if strcmp(featureSets(i),'Image')       % if the current feature is an image
        axes(mainUI,'Tag',featureSets(i),'outerposition',[(i-2)/4+1/8,1/2,1/4,1/2])      % create axes(boxes) where features will go
        im = imshow(imageSet{x}*.05);       % plot image(x) in imageSet on current axes with a 0.05 initial scalar
        im.Tag = 'Image';                   % set image tag
        im.UserData = .05;                  % record the scalar used above as the user data
        x= x+1;                             % advance image in image set
    elseif strcmp(featureSets(i),'Spectra') % if the current feature is a Spectra
        axes(mainUI,'Tag',featureSets(i),'outerposition',[.055,0,7/8,1/2])      % create axes(boxes) where features will go
        spec = plot(spectraSet{y});         % plot spectra(y) in spectra set on current axes
        spec.Tag = 'Spectra';               % set spectra tag
        y= y+1;                             % advance spectra in spectra set
    end
    ax = gca;                               % set current axes
    ax.Toolbar.Visible = 'off';             % turn off toolbars
    ax.Interactions = [zoomInteraction panInteraction dataTipInteraction]; % set axes interactions
    ax.Title.String = featureSets(i);       % set axes titles
    ax.LineWidth = 2;                       % set border thickness
end

%% Define Buttons, Sliders, and Labels
spectraSelectorButtonLabel = uicontrol('style','text','string','Select Spectra Center');
spectraSelectorButton = uicontrol('style','pushbutton','Callback',@selectSpectraPressedFN);
brightnessSilderLabel = uicontrol('style','text','string','Brightness Scalar - 0.05','UserData',.05);
brightnessSlider = uicontrol('style','slider','Value',.05,'Min',0.0001,'Max',.1,'Callback',@brightnessSliderPressedFN);
smoothSilderLabel = uicontrol('style','text','string','Gaussian Pixel Range - 1','UserData',1);
smoothSlider = uicontrol('style','slider','Value',1,'Min',1,'Max',20,'Callback',@smoothSliderPressedFN);
spectraFinderSilderLabel = uicontrol('style','text','string','Auto Spectra Scalar - 10','UserData',.10);
spectraFinderSlider = uicontrol('style','slider','Value',5,'Min',1,'Max',100,'Callback',@spectraFinderSliderPressedFN);
buttonsList = {spectraSelectorButtonLabel,spectraSelectorButton,brightnessSilderLabel,brightnessSlider,smoothSilderLabel,smoothSlider,spectraFinderSilderLabel,spectraFinderSlider};
buttonsNameList = ["spectraSelectorButtonLabel","spectraSelectorButton","brightnessSilderLabel","brightnessSlider","smoothSilderLabel","smoothSlider","spectraFinderSilderLabel","spectraFinderSlider"];

startingY = (uiSize(4)); %height of UI
startingX = 10;    % starting x in pxels from left
BHeight = 50;    % height of buttons
LHeight = 25;    % height of labels
LBLength = 150;   % length of buttons and labels
BCount = 0;     % button count initialization
LCount = 0;     % label count initialization

for i = 1:length(buttonsList)
    switch buttonsList{i}.Style
        case 'text'
            LCount = LCount + 1;
            buttonsList{i}.Position = [startingX, startingY-BCount*BHeight-LCount*LHeight,LBLength,LHeight];
            buttonsList{i}.Tag = buttonsNameList(i);
        case 'pushbutton'
            BCount = BCount + 1;
            buttonsList{i}.Position = [startingX, startingY-BCount*BHeight-LCount*LHeight,LBLength,BHeight];
            buttonsList{i}.Tag = buttonsNameList(i);
        case 'slider'
            BCount = BCount + 1;
            buttonsList{i}.Position = [startingX, startingY-BCount*BHeight-LCount*LHeight,LBLength,BHeight];
            buttonsList{i}.Tag = buttonsNameList(i);
    end
end