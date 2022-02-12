
%           Do do list
% #1
%image combination (median)
%       3 images file selction below the outer two Folder selction separate
%       Operater selection list below the center one (median, average, add,
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
uiSize = [100 100 1700 800];                                                % size of enitre GUI in Pixels adjust freely [start x, start y, length, height]
mainUI = figure('Name','Main UI','position',uiSize);                        % create GUI
fitsData1 = fitsread("C:\Users\avery\Desktop\Research\spex-00099.a.fits");  % read FITS file using fitsread                                                       %
imageSet = {fitsData1};                                                     % define list of Images
spectraSet = {0};                                                           % define list of spectra to plot
featureSets = ["Spectra","Image"];                                          % Order the Images and Spectra on GUI, bottom up, must have one here for every image/spectra you are displaying

%% Create GUI Features
for i = 1:length(featureSets)
    x = 1;
    y = 1;
    axes(mainUI,'Tag',featureSets(i),'outerposition',[0,(i-1)/length(featureSets),1,1/length(featureSets)])      % create axes(boxes) where features will go
    if strcmp(featureSets(i),'Image')       % if the current feature is an image
        im = imshow(imageSet{x}*.05);       % plot image(x) in imageSet on current axes with a 0.05 initial scalar
        im.Tag = 'Image';                   % set image tag
        im.UserData = .05;                  % record the scalar used above as the user data
        x= x+1;                             % advance image in image set
    elseif strcmp(featureSets(i),'Spectra') % if the current feature is a Spectra
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
brightnessSilderLabel = uicontrol('style','text','string','Brightness Scalar','position',[5 450 200 25]);
brightnessSlider = uicontrol('style','slider','Tag','brightnessSlider','string','Slider','Value',.05,'Min',0.0001,'Max',.1,'Callback',@brightnessSliderPressed,'position',[10 400 200 50]);
brightnessSlideVal = uicontrol('style','text','FontSize',14,'position',[210 415 100 20],'String','.05','Tag','brightnessSlideVal');

smoothSilderLabel = uicontrol('style','text','string','Gaussian Pixel Range','position',[5 550 200 25]);
smoothSlider = uicontrol('style','slider','Tag','smoothSlider','string','Slider','Value',1,'Min',1,'Max',20,'Callback',@smoothSliderPressed,'position',[10 500 200 50]);
smoothSlideVal = uicontrol('style','text','FontSize',14,'position',[210 515 100 20],'String','1','Tag','smoothSlideVal');

spectraFinderSilderLabel = uicontrol('style','text','string','Auto Spectra Scalar','position',[5 650 200 25]);
spectraFinderSlider = uicontrol('style','slider','Tag','spectraFinder','string','Slider','Value',5,'Min',1,'Max',100,'Callback',@spectraFinderSliderPressed,'position',[10 600 200 50]);
spectraFinderSlideVal = uicontrol('style','text','FontSize',14,'position',[210 615 100 20],'String','10','Tag','spectraFinderSlideVal');

manualSpectraButtonLabel = uicontrol('style','text','string','Select Spectra Center','position',[10 760 125 25]);
manualSpectraButton = uicontrol('style','pushbutton','Tag','manualSpectraButton','Callback',@selectManualSpectra,'position',[10 700 125 50]);

%% Functions
function selectManualSpectra(~,~)                                % begin selectManualSpectra function with no inputs
    selectManualSpectraFN(1);
end                                                              % end function

function spectraFinderSliderPressed(~,~)
    spectraFinderSliderPressedFN(1);
end                                                          % end function

function smoothSliderPressed(~,~)                            % begin smoothButtonPressed function with no inputs
    smoothSliderPressedFN(1);
end

function brightnessSliderPressed(~,~)                        % begin brightnessSliderPressed
    brightnessSliderPressedFN(1);
end
