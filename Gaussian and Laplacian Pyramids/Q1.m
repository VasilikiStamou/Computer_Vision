close all; clear; clc;
%% Load images
imga = im2double(imread('./photos/apple.jpg'));
imgb = im2double(imread('./photos/orange.jpg')); % size(imga) = size(imgb)
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);

%% Create masks
[M N ~] = size(imga);
v = floor((N-1)/2);
level = 5;
maska = zeros(size(imga));
maska(:,1:v,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',30,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

%% Create pyramids
lap_imga = genPyr(imga,'lap',level); % the Laplacian pyramid
lap_imgb = genPyr(imgb,'lap',level);
B = cell(1,level); % the blended pyramid

for p = 1:level
	[Mp Np ~] = size(lap_imga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	B{p} = lap_imga{p}.*maskap + lap_imgb{p}.*maskbp;
end
imgo = pyrReconstruct(B);
figure,imshow(imgo) % blend by pyramid
