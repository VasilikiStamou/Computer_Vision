%% linear innterpolation %%
%% Read images
clear; clc; close all;
windmill = im2double(rgb2gray(imread('windmill_back.jpeg')));
mill = im2double(rgb2gray(imread('windmill.png')));
mill_mask = im2double(rgb2gray(imread('windmill_mask.png')));
frames = 120;
cmap = [];
% struct containing all the frames
F(frames) = struct('cdata',[],'colormap',cmap);
[m,n,~] = size(mill);
theta = 0;
step = - 2.5;
%% Create proper affine2d class objects
% Create affine2d's argument matrix A for translation
tx = ceil(m/2);
ty = ceil(n/2);
A = [ 1  0  0;
      0  1  0;
      tx ty 1];
tform_tr = affine2d(A);
%% Translate image to center
[mill] = imwarp(mill,tform_tr,'Interp','nearest','FillValues',1);
[mill_mask,imref_temp] = imwarp(mill_mask,tform_tr,...
    'Interp','nearest','FillValues',1);
%% Main Loop
for i = 1:frames
    %% create frame background
    image = windmill;
    %% Rotate by theta degrees
    A = [ cosd(theta) sind(theta) 0;
         -sind(theta) cosd(theta) 0;
              0           0       1];
   tform_rt = affine2d(A');
   [im_] = imwarp(mill,imref_temp,tform_rt,'Interp','nearest','FillValues',1);
   [im_mask] = imwarp(mill_mask,imref_temp,tform_rt,...
       'Interp','nearest','FillValues',1);
   %% Place image - center of image must be placed on (456,656)
   [m,n,~] = size(im_);
   express = im_mask > 0.1;
   start_n = 656-ceil(n/2); end_n = start_n + n-1;
   start_m = 456-ceil(m/2); end_m = start_m + m-1;
   image(start_m:end_m,start_n:end_n) = ...
       (ones(size(im_))- express).*im_ + ...
       express.*image(start_m:end_m,start_n:end_n);
   %% Increase theta
   theta = theta + step;
   %% Update movie F
   F(i) = im2frame(im2uint8(image),gray(256));
end 
%% Play the results in 40 fps
implay(F,40);
save('transf_windmill_nearest.mat','F');
   