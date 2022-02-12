
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
prevLine = findall(gcf,'tag','spectraRange');                % find the previous line
if prevLine ~= 0                                              % if that line exists
    delete(prevLine);                                            % delete it
end
[x,y]=ginput(2);                                             % selection of two points on image
imagePlace = findall(gcf,'Type','Image');                    % find image location in figure
currentScalar = imagePlace.UserData;                         % get current image brightness scalar
data = (imagePlace.CData)/currentScalar;                     % get original data by dividing by scalar
imageLength = length(data);                                  % get image size
slope = (y(2)-y(1))/(x(2)-x(1));                             % equation for the line between the two points
line = slope.*([1:1:imageLength]-x(1))+y(1);                 % create line as a function of x within image length
hold on                                                      % prevents line from replacing image
plot(line,'color','Blue','LineWidth',2,'Tag','spectraRange');% create line on plot based on picked positions
place = findall(gcf,'tag','Spectra');                        % find spectra graph location
place.XData = [1:1:imageLength];                             % set x to image length
thing = zeros(1,imageLength);                                % define thing array
for i = 1:imageLength                                        % for all x values
    thing(i) = data((round(line(i))),i);                     % set thing to values of image at the line inersects
end
place.YData = thing;                                         % plot thing on spectra graph
place.UserData = thing;                                      % save data in user data as well to preserve original
end                                                              % end function

function spectraFinderSliderPressed(~,~)
prevScat = findall(gcf,'tag','spectra');                         % find the previous scatter plot
if prevScat ~= 0                                                 % if that exists
    delete(prevScat);                                            % delete it
end
prevLine = findall(gcf,'tag','spectraRange');                    % find the users line
if isempty(prevLine)                                             % if there is no line
    error('Select spectra center first')                         % throw error to select spectra first
end
obj = gco;                                                       % Get current object (slider)
val = round(obj.Value);                                          % get value of slider
lineThing = findall(gcf,'tag','spectraRange');                   % find line location
linePlace = findall(lineThing,'type','Line');                    % find line within location
lineVal = linePlace.YData;                                       % retreive y data from line
spectraSlideVal = findall(gcf,'Tag','spectraFinderSlideVal');    % find slider label location
spectraSlideVal.String = val;                                    % set slider label to new val
imagePlace = findall(gcf,'Type','Image');                        % find image location
currentScalar = imagePlace.UserData;                             % get current image brightness scalar
data = (imagePlace.CData)/currentScalar;                         % get original data by dividing by scalar
imageLength = length(data);                                      % get size of image
lineLength = length(lineVal);                                    % get size of line
newData = zeros(1,imageLength);                                  % define newData array
for i = 1:lineLength                                             % for 1:length of line
    for j = -val:val                                             % j = +- val range
        newData(round(lineVal(i))+j,i) = data(round(lineVal(i))+j); % get j pixels above and below line and save as newData
    end
end
maxes = zeros(1,imageLength);                                    % define maxes array
maxesPlaces = zeros(1,imageLength);                              % define maxes places array
for i=1:imageLength                                              % for 1:length of image
    maxes(i) = max(newData(:,i));                                % max of newData column save as max of column
end
for i=1:imageLength                                              % for 1:length of image
    maxLoc = find((newData(:,i) == maxes(i)));
    maxesPlaces(i) = maxLoc(1);
end
hold on                                                      % prevents scatter from replacing image
scatter([1:1:length(data)],maxesPlaces,'filled','Red','Tag','spectra'); % create scatter plot on top of image
place = findall(gcf,'tag','Spectra');                        % find spectra plot location
place.XData = [1:1:imageLength];                             % set x axis to image size
imageMaxes = zeros(1,imageLength);                           % define imageMaxes array
for i = 1:imageLength                                        % for 1: length of image
    imageMaxes(i) = data(maxesPlaces(i),i);                  % get data of max locations and save to imageMaxes
end
place.YData = imageMaxes;                                    % set y data of spectra plot to imageMaxes
place.UserData = imageMaxes;                                 % set user data of spectra plot to imageMaxes
end                                                          % end function

function smoothSliderPressed(~,~)                            % begin smoothButtonPressed function with no inputs
obj = gco;                                                   % get current object (slider)
val = round(obj.Value,0);                                    % get value of slider rounded to nearest whole number
spectraPlace = findall(gcf,'tag','Spectra');                 % find spectra plot location
data = spectraPlace.UserData;                                % get "unsmoothed" data from user data of spectra plot
smoothSlideVal = findall(gcf,'Tag','smoothSlideVal');        % find label for slider
smoothSlideVal.String = val;                                 % set label to new slider value
smoothed = smoothdata(data,'gaussian',val);                  % smooth data using guassian function with a domain of val
spectraPlace.YData = smoothed;                               % set spectra plot y data to smoothed data
end                                                              % end function

 function brightnessSliderPressed(~,~)                        % begin brightnessSliderPressed
     brightnessSliderPressedFN(1);
 end