close all;clear; clc;
%% Load images 
background = im2double(imread('./photos/P200.jpg'));
dog1 = im2double(imread('./photos/dog1.jpg'));
dog2 = im2double(imread('./photos/dog2.jpg'));
cat = im2double(imread('./photos/cat.jpg'));
flower = im2double(imread('./photos/flower.jfif'));
[m,n]=size(background);
%% Create masks 
mask_dog1 = im2double(imread('./Q3-masks/dog1.bmp'));
mask_dog2 = im2double(imread('./Q3-masks/dog2.bmp'));
mask_cat = im2double(imread('./Q3-masks/cat.bmp'));

mask_flower = flower > 0.015;

mask_background = 1-mask_dog1-mask_dog2-mask_cat;
    %% Create an affine2d class object
    %Create affine2d's argument matrix A
    A1 = [ 1/3 0 0;
          0 1/3 0;
          0   0 1];
      
    A2 = [ 1/7.5 0 0;
          0 1/7.5 0;
          0   0 1];  
      
    tform1 = affine2d(A1');
    tform2 = affine2d(A2');
    %% Apply scaling to image with imwarp
    [dog1_temp] = imwarp(dog1,tform1);
    [mask_dog1] = imwarp(mask_dog1,tform1);
    
    [dog2_temp] = imwarp(dog2,tform2);
    [mask_dog2] = imwarp(mask_dog2,tform2);
    
    [cat_temp] = imwarp(cat,tform2);
    [mask_cat] = imwarp(mask_cat,tform2);
    %% Blur 
    blurh = fspecial('gauss',[15 15],15); % feather the border
    mask_dog1 = imfilter(mask_dog1,blurh,'replicate');
    mask_dog2 = imfilter(mask_dog2,blurh,'replicate');
    mask_cat = imfilter(mask_cat,blurh,'replicate');
    mask_background = imfilter(mask_background,blurh,'replicate');
    %% generate a valid (x,y) for the image dog1 to fit
    [k,l,~] = size(dog1_temp);
    m_new = 1615;
    n_new = 1498;
    %% Place image
    background(m_new:m_new+k-1,n_new:n_new+l-1,:) = mask_dog1.*dog1_temp ...
        + (ones(k,l)-mask_dog1).*background(m_new:m_new+k-1,n_new:n_new+l-1,:);

    %% generate a valid (x,y) for the image dog2 to fit
    [k,l,~] = size(dog2_temp);
    m_new = 1800;
    n_new = 1450;
    %% Place image
    background(m_new:m_new+k-1,n_new:n_new+l-1,:) = mask_dog2.*dog2_temp ...
        + (ones(k,l)-mask_dog2).*background(m_new:m_new+k-1,n_new:n_new+l-1,:);
    %% generate a valid (x,y) for the image cat to fit
    [k,l,~] = size(cat_temp);
    m_new = 1900;
    n_new = 755; 
    %% Place image
    background(m_new:m_new+k-1,n_new:n_new+l-1,:) = mask_cat.*cat_temp ...
        + (ones(k,l)-mask_dog2).*background(m_new:m_new+k-1,n_new:n_new+l-1,:);
        %% generate a valid (x,y) for the image flower to fit
    [k,l,~] = size(flower);
    m_new = 1900;
    n_new = 1480; 
    %% Place image
    background(m_new:m_new+k-1,n_new:n_new+l-1,:) = mask_flower.*flower ...
        + (ones(k,l)-mask_flower).*background(m_new:m_new+k-1,n_new:n_new+l-1,:);
    figure(1);imshow(background);
    