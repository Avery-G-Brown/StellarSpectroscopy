function smoothSliderPressedFN(~,~)                              % begin smoothButtonPressed function with no inputs
obj = gco;                                                   % get current object (slider)
val = round(obj.Value,0);                                    % get value of slider rounded to nearest whole number
spectraPlace = findall(gcf,'tag','Spectra');                 % find spectra plot location
data = spectraPlace.UserData;                                % get "unsmoothed" data from user data of spectra plot
smoothSliderVal = findall(gcf,'Tag','smoothSilderLabel');      % find label for slider
smoothSliderVal.UserData = val;                               % set slider user data to new val
smoothSliderVal.String = "Gaussian Pixel Range - " + val;     % set slider label to 
smoothed = smoothdata(data,'gaussian',val);                  % smooth data using guassian function with a domain of val
spectraPlace.YData = smoothed;                               % set spectra plot y data to smoothed data
end