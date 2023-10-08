close all ; clear; clc;
%photos_set = dir('./photos/*.jpg');
%path = fullfile(photos_set(1).folder, photos_set(1).name);
%img = imread(path); level=5; type='gauss';
%% Load image
img = im2double(imread('./photos/apple.jpg')); imshow(img);
%level=2; type='lap';
%% Generate pyramids
%Generate pyramid
[ pyr1 ] = genPyr( img, 'gauss', 5 );
%Generate pyramid
[ pyr2 ] = genPyr( img, 'lap', 5 );

%% Plot some levels
figure(1)
subplot(2, 3, 1);imshow(pyr1{1}, []); title('Gaussian Pyramid level 1')
subplot(2, 3, 2);imshow(pyr1{3}, []); title('Gaussian Pyramid level 3')
subplot(2, 3, 3);imshow(pyr1{5}, []); title('Gaussian Pyramid level 5')

subplot(2, 3, 4);imshow(pyr2{1}, []); title('Laplacian Pyramid level 1')
subplot(2, 3, 5);imshow(pyr2{3}, []); title('Laplacian Pyramid level 3')
subplot(2, 3, 6);imshow(pyr2{5}, []); title('Laplacian Pyramid level 5')

%% Reconstruct using Laplacian
rec_img = pyrReconstruct(pyr2); imshow(rec_img);
figure(2)
subplot(1,3,1);imshow(img);title('Original Image');
subplot(1,3,2);imshow(pyr2{5});title('Compresed Image');
subplot(1,3,3);imshow(rec_img);title('Reconstructed Image');
%% Blend two images
imga = im2double(imread('./photos/apple.jpg'));
imgb = im2double(imread('./photos/orange.jpg')); % size(imga) = size(imgb)
imga = imresize(imga,[size(imgb,1) size(imgb,2)]);
[M N ~] = size(imga);
v = 230;
level = 5;
limga = genPyr(imga,'lap',level); % the Laplacian pyramid
limgb = genPyr(imgb,'lap',level);

figure(3)
subplot(2, 3, 1);imshow(limga{1}, []); title('Laplacian Pyramid level 1')
subplot(2, 3, 2);imshow(limga{3}, []); title('Laplacian Pyramid level 3')
subplot(2, 3, 3);imshow(limga{5}, []); title('Laplacian Pyramid level 5')

subplot(2, 3, 4);imshow(limgb{1}, []); title('Laplacian Pyramid level 1')
subplot(2, 3, 5);imshow(limgb{3}, []); title('Laplacian Pyramid level 3')
subplot(2, 3, 6);imshow(limgb{5}, []); title('Laplacian Pyramid level 5')

maska = zeros(size(imga));
maska(:,1:v,:) = 1;
maskb = 1-maska;


blurh = fspecial('gauss',30,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');
limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = pyrReconstruct(limgo);
imgo1 = maska.*imga + maskb.*imgb;

figure(4);
subplot(1,2,1);imshow(imgo);title('Blend by pyramid')
subplot(1,2,2);imshow(imgo1);title('Blend by feathering')


%imshow(maska.*imga)
%imshow(maskb.*imgb)
%imshow(maska.*imga+maskb.*imgb)
