clear;clc;close all;
%% read image
im=rgb2gray(imread('pudding.png'));
[m,n]=size(im);
%% Initialize useful parameters
image = ones(2*m,2*n,1);
scales = randi(100,1,1); %generate number of scales(max:100)
%% Loop - Scale image and place to the overall image
for i=1:scales
    %% Generate scale along axis x and axis y
    scalex = rand();
    scaley = rand();
    %% Create an affine2d class object
    %Create affine2d's argument matrix A
    A = [ scalex 0 0;
          0 scaley 0;
          0   0    1];
    tform = affine2d(A');
    %% Apply scaling to image with imwarp
    [im_temp] = imwarp(im,tform);
    im_temp = im2double(im_temp);
    %% generate a valid (x,y) for the image to fit
    [k,l,~] = size(im_temp);
    m_new = randi(2*m-k-1,1,1);
    n_new = randi(2*n-l-1,1,1);
    %% Place image
    imhist(im_temp)
    %imshow(im_temp)
    express = im_temp > 0.2;
    image(m_new:m_new+k-1,n_new:n_new+l-1) = express.*im_temp ...
        + (ones(k,l)-express).*image(m_new:m_new+k-1,n_new:n_new+l-1);
end
figure;imshow(image)