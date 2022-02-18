function brightnessSliderPressedFN(~,~)
obj = gco;                                                       % get current object(slider)
val = (obj.Value);                                               % get value of slider
imagePlace = findall(gcf,'Type','Image');                        % find image location
currentScalar = imagePlace(1).UserData;                          % get current image brightness scalar
data = (imagePlace(1).CData)/currentScalar;                      % get original data by dividing by scalar
brightnessSliderVal = findall(gcf,'Tag','brightnessSilderLabel');% find slider label location
brightnessSliderVal.UserData = val;                              % set slider user data to new val
brightnessSliderVal.String = "Brightness Scalar - " + val;       % set slider label to new val
imagePlace(1).CData = data*(val);                                % set image color data to original data * new scalar
imagePlace(1).UserData = val;                                    % set user data as current scalar to allow for original data recovery
end