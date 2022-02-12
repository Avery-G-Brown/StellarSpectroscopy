function spectraFinderSliderPressedFN(~)
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
end