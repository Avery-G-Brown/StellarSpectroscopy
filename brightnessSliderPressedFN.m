function brightnessSliderPressedFN(~)
obj = gco;                                                   % get current object(slider)
val = (obj.Value);                                           % get value of slider
imagePlace = findall(gcf,'Type','Image');                    % find image location
currentScalar = imagePlace.UserData;                         % get current image brightness scalar
data = (imagePlace.CData)/currentScalar;                     % get orininal data by dividing by scalar
brightnessSlideVal = findall(gcf,'Tag','brightnessSlideVal');% find slider label location
brightnessSlideVal.String = val;                             % set slider label to new val
imagePlace.CData = data*(val);                               % set image color data to original data * new scalar
imagePlace.UserData = val;                                   % set user data as current scalar to allow for original data recovery
end