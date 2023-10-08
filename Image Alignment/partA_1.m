%% Load Image 
clear;clc;close all;
img = rgb2gray(imread('Lenna.png'));
%% Generate the Template - Apply a small translation to the image
% Create proper affine2d objects
sh_y = 0.1;
sh_x = 0.1;
A = [ 1   sh_x 0;
     sh_y   1  0;
      0     0  1];
tform = affine2d(A');
% Apply geometric transformation with imwarp
img_ = imwarp(img,tform,'cubic','FillValues',1);
imshow(img_)
%% Call ecc_lk_alignment function
tic; [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment...
                                    (img_,img,2,2,'affine',eye(2,3));
time = toc;                                
