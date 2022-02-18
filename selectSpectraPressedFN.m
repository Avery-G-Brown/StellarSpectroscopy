function selectSpectraPressedFN(~,~)                            % begin selectManualSpectra function with no inputs
finderUpperRange = findall(gcf,'tag','spectraFinderUpperRange');
finderLowerRange = findall(gcf,'tag','spectraFinderLowerRange');
if finderUpperRange ~= 0                                                 % if that exists
    delete(finderUpperRange);                                            % delete it
    delete(finderLowerRange);
end
prevScat = findall(gcf,'tag','spectra');                         % find the previous scatter plot
if prevScat ~= 0                                                 % if that exists
    delete(prevScat);                                            % delete it
end
prevLine = findall(gcf,'tag','spectraRange');                % find the previous line
if prevLine ~= 0                                             % if that line exists
    delete(prevLine);                                        % delete it
end
[x,y]=ginput(2);                                             % selection of two points on image
imagePlace = findall(gcf,'Type','Image');                    % find image location in figure
currentScalar = imagePlace(1).UserData;                         % get current image brightness scalar
data = (imagePlace(1).CData)/currentScalar;                     % get original data by dividing by scalar
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
end           