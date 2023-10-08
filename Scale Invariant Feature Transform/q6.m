clear all; close all; clc;
figure;imshow('./image tests-q6/scene.pgm');
figure;imshow('./image tests-q6/book.pgm');
%% 
% The "sift" command calls the appropriate binary to extract
% SIFT features and returns them in matrix form.
[image, descrips, locs] = sift('./image tests-q6/scene.pgm');
%%
% Use "showkeys" to display the keypoints superimposed on the image
showkeys(image, locs);
%%
% The "match" command is given two image file names.  It extracts
%SIFT features from each image, matches the features between the two
%images, and displays the results.
match('./image tests-q6/scene.pgm','./image tests-q6/book.pgm');

%Can also try these
 %match('./image tests-q6/scene.pgm','./image tests-q6/box.pgm');
 %match('./image tests-q6/scene.pgm','./image tests-q6/basmati.pgm');

% The result shows the two input images next to each other, with 
% lines connecting the matching locations.  Most of the matches 
% should be correct (as can be roughly judged by the fact that 
% they select the correct object in a cluttered image), but there 
% will be a few false outliers that could be removed by enforcing
% viewpoint consistency constraints.