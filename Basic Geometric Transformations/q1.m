clear;clc;close all;
im = im2double(imread('ball.jpg'));

%Μητρώα γεωμετρικών μετασχηματισμών
Ttranslation = [1 0 100; 0 1 -200; 0 0 1];
Trotation = [cosd(45) sind(45) 0; -sind(45) cosd(45) 0; 0 0 1];

%Για τα μητρώα που έχουμε ορίσει μας είναι απαραίτητη η affine2d
translation = affine2d(Ttranslation');
rotation = affine2d(Trotation');
%% Apply rotation
%Αφού ορίσαμε τα αντικείμενα γεωμετρικού μετασχηματισμόυ μπορούμε να
%χρησιμοποιήσουμε την συνάρτηση imwarp

%rotatedImage = imwarp(im,rotation);
%[rotatedImage,refIm]= imwarp(im,rotation);
%[rotatedImage,refIm] = imwarp(im,rotation,'FillValues',[0 255 0]);

[rotatedImage,refIm] = imwarp(im,rotation,'FillValues',255,'Interp','cubic');

%% Apply translation
[translatedImage,reFIm] = imwarp(im,translation,'FillValues',255,'Interp','cubic');

%% Visualization
imref2d(size(im)); %Get spatial referencing information about the image

figure;
subplot(1,3,1);imshow(im,imref2d(size(im)));title('Original Image')
subplot(1,3,2);imshow(rotatedImage,refIm);title('Rotated Image (by 45 degrees)')
subplot(1,3,3);imshow(translatedImage,reFIm);title('Translated Image (x:by 100 y:by -200)')

%When viewing the translated image, it might appear that the 
%transformation had no effect. The transformed image looks identical 
%to the original image. The reason that no change is apparent in the 
%visualization is because imwarp sizes the output image to be just large
%enough to contain the entire transformed image but not the entire 
%output coordinate space. Notice, however, that the coordinate values 
%have been changed by the transformation.
%%
implay('ball.avi')