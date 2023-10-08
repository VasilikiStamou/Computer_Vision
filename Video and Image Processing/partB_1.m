clear all; clc; close all;
load('img.mat');
img = uint8(img);
frames = 2;
% struct containing all the frames
video(frames) = struct('cdata',[],'colormap',[]);
% insert frames to img1
video(1) = im2frame(img,gray(256));
video(2) = im2frame(img,gray(256));