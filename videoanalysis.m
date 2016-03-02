% 
% This function processes the video 'fileName.Ext' with the following
% arguments:
% 1. fileName = 'str' -- name of the file withought an extension;
% 2. Ext = 'str' -- extension of the file withought a dot; acceptable formats:
% avi, mpg, mp4, m4v, mov (see VideoReader documentation for details);
% 3. l_max = double -- rightmost position the dot ever reached during the
% experiment, measured aling the meter stick in cm;
% 4. l_min = double -- leftmost position the dot ever reached during the
% experiment, measured aling the meter stick in cm;
% 
% The function returns two vectors [t, l_x]:
% 1. t -- time series vector;
% 2. l_x -- position of the dot (center) in cm relative to the leftmost
% point.
%
% The function has additional inputs, frame_step and THR. 
% 1. frame_step specifies how many frames to skip over when analysisng the video;
% 2. THR specifies the threshhold for the brightness of the dot. 
%
function [t, l_x] = videoanalysis(fileName, Ext, l_max, l_min)


%% Inputs:
frame_step = 110; % frame intervals that do not get analyzed
THR = 30; % brightness threshnold

%% 
vid = VideoReader([fileName '.' Ext]);
numFrames = vid.NumberOfFrames;
Frames = 1:frame_step:numFrames; % list of frames to process (1/sec)
fprintf('Part 1: selecting frames to process -- DONE \n');
%% Figure to sellect the area
frames2disp = 1:720:numFrames;
ims2show = zeros(vid.Height, vid.Width, length(frames2disp));
for k = 1:length(frames2disp)
    ims2show(:,:,k) = rgb2gray(read(vid,frames2disp(k)));
end
im2show = max(ims2show, [], 3);
imshow(im2show, [])
fprintf('Part 2: create a trace -- DONE \n');

title('Draw a rectangle to include the path of the light.')
disp('On the figure, draw a rectangle to include the path of the light.')
point_rect = round(getrect); % draw a rectangle
close all;
fprintf('Part 3: record a rectangle -- DONE \n');

%% Time series data

t = 1:length(Frames); % define a time vector
grayIm = zeros(point_rect(4)+1, point_rect(3)+1, length(Frames));

for f=1:length(Frames)
    grayim = rgb2gray(read(vid, Frames(f))); % convert images into grayscale
    grayIm(:,:,f) = grayim(point_rect(2):(point_rect(2)+point_rect(4)),point_rect(1):(point_rect(1)+point_rect(3))); 
    % ^ extract a window with the point
    t(f) = vid.CurrentTime; % store frame timestamp into the vector
    clc;
    fprintf( 'analyzing Frames \n' );
    fprintf( '%i/%i \n', f, length(Frames));
end
fprintf('Part 4: time series recording -- DONE \n');

%% Position Data
x_pos = 1:length(Frames);
for f=1:length(Frames)
    takeIm = grayIm(:,:,f);
    binIm = (takeIm > max(takeIm(:) - THR));
    binImC = regionprops(binIm, 'centroid');
    c = binImC(1).Centroid;
    x_pos(f) = c(1);
    clc;
    fprintf( 'analyzing Frames \n' );
    fprintf( '%i/%i \n', f, length(Frames));
end

fprintf('Part 5: position series recording -- DONE \n');

%%
l_x = 1:length(x_pos);
for i=1:length(x_pos)
    l_x(i) = (x_pos(i)-min(x_pos))*(l_max-l_min)/(max(x_pos)-min(x_pos));
end

save([fileName, '.mat'], 't', 'l_x');
return;
