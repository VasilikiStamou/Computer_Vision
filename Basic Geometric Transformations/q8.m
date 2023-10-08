clear;clc;close all;
% convert to grayscale in order to save memory
beach = rgb2gray(imread('beach.jpg'));
mask = rgb2gray(imread('ball_mask.jpg'));
ball = rgb2gray(imread('ball.jpg'));
%compute black background to the ball and the ball's mask
mask = imcomplement(mask);
ball = mask-imcomplement(ball);
%% Translate to center of image 
[m,n,~] = size(ball);
t_x = floor(m/2);
t_y = floor(n/2);
A = [ 1   0  0;
      0   1  0;
     t_x t_y 1];
 tform = affine2d(A);
 %Apply translation to image with imwarp
 [ball,ballref] = imwarp(ball,tform,'cubic','FillValues',0);
 [mask,maskref] = imwarp(mask,tform,'cubic','FillValues',0);
 %% Scale Ball by 1/4
 scalex = 1/4;
 scaley = 1/4;
 %create affine2d for scale
 A = [ scalex   0    0;
          0   scaley 0;
          0     0    1];
tform = affine2d(A);
 %Apply scaling to image with imwarp
[ball_sc,ball_ref] = imwarp(ball,ballref,tform,'cubic','FillValues',0);
[mask_sc,mask_ref] = imwarp(mask,maskref,tform,'cubic','FillValues',0);
%% Plot the descending cosine
% length(cosine pulse) + max #of columns of rotated image < #of columns of the beach image
% max #rows of rotated image + max width of cosine < #of rows of the beach image
N = 250; % #of samples
step = 0.01; %time quantum
n = 0:0.01:N*step-step; %discrete
x = abs(cos(2*pi*n).*exp(-1*n));
x(x==0)=1;
%normalize the signal
x = (x-min(x))./(max(x)-min(x));
% multiply with beach height
[M,~,~] = size(beach);
[K,~,~] = size(ball_sc);
x = floor(x*(M-(K+K/2)-1));
%% Loop: Rotation -> Translation -> Save to temp -> Rotation 
%define rotation angle
theta = 0; step = 2;
%define number of loops
loops = length(x);
cmap = colormap(gray(256));
%prepare struct for movie
F(loops) = struct('cdata',[],'colormap',cmap);
t_x = zeros(1,loops);
t_y = zeros(1,loops);
count=1; %scale freq
for i = 1:loops
    count = count+0.05;
    %% Update theta angle
    theta = theta + step;
    %% Rotation 
    rotation = [ cosd(theta) sind(theta) 0;
                -sind(theta) cosd(theta) 0;
                     0           0       1];
    tform = affine2d(rotation');
    %Apply rotation to image with imwarp
    [ball_temp,Ball_ref] = imwarp(ball_sc,ball_ref,tform,'cubic','FillValues',1);
    [mask_temp,Mask_ref] = imwarp(mask_sc,mask_ref,tform,'cubic','FillValues',1);
    %% Scale
    scalex = 1/count;
    scaley = 1/count;
    A = [ scalex   0    0;
          0   scaley 0;
          0     0    1];
       tform = affine2d(A);
     %Apply scaling to image with imwarp
    [Ball_temp] = imwarp(ball_temp,Ball_ref,tform,'cubic','FillValues',0);
    [Mask_temp] = imwarp(mask_temp,Mask_ref,tform,'cubic','FillValues',0);
    %% Place rotated image appropriately
    [m,n,~] = size(Ball_temp);
    t_y(i) = 400 - floor(n/2);
    t_x(i) = max(x) - x(i) + 1;
    %calculate beach image indeces
    xx = [t_x(i) t_x(i)+m-1];
    yy = [t_y(i) t_y(i)+n-1];
    %% Create frame 
    temp = beach;
    temp(xx(1):xx(2),yy(1):yy(2)) = temp(xx(1):xx(2),yy(1):yy(2)) - Mask_temp;
    temp(xx(1):xx(2),yy(1):yy(2)) = temp(xx(1):xx(2),yy(1):yy(2)) + Ball_temp;
    %% Update movie structure
    F(i) = im2frame(temp,cmap);
end
save('transf_beach_q8.mat','F');
implay(F);
