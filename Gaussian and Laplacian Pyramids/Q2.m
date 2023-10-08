close all; clear; clc;
%% Load images
imga = im2double(imread('./photos/woman.png'));
imgb = im2double(imread('./photos/hand.png')); 
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);

%% Create masks
[M N ~] = size(imga);
level = 5;
maska = zeros(size(imga));
%pick the right coordinates for the eye
    %imshow(imga(85:115,72:135,:)); 
    %imshow(imga(90:115,72:145,:));
    maska(85:115,72:135,:) = 1; 
maskb = 1-maska;
%blurh = fspecial('gauss',[11 50],15); % feather the border
blurh = fspecial('gauss',[15 50],15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

%% Create pyramids - Not used 
limga = genPyr(imga,'lap',level); % the Laplacian pyramid
limgb = genPyr(imgb,'lap',level);
limgo = cell(1,level); % the blended pyramid
%for p = 1:level
%	[Mp Np ~] = size(limga{p});
%	maskap = imresize(maska,[Mp Np]);
%	maskbp = imresize(maskb,[Mp Np]);
%	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
%end
%imgo = pyrReconstruct(limgo);
%figure,imshow(imgo) % blend by pyramid

%% Results - Blend by feathering
imgo1 = maska.*imga+maskb.*imgb;
figure(1)
subplot(1,2,1);imshow(imga(90:115,72:145,:));title('Region we want to use');
subplot(1,2,2);imshow(imgo1);title('Result'); % blend by feathering
figure(2)
subplot(2,2,1);imshow(maska);title('Mask a');
subplot(2,2,2);imshow(maskb);title('Mask b');
subplot(2,2,3);imshow(maska.*imga);title('Mask a conv with woman');
subplot(2,2,4);imshow(maskb.*imgb);title('Mask b conv with hand');

