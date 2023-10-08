close all ; clear; clc;
img = im2double(imread('./photos/apple.jpg'));
level=5; 
pyrtype='Gaussian';
switch pyrtype
    case'Laplacian'
%% Laplacian from Gaussian
[ Gpyr ] = genPyr( img, 'gauss', level );
[ perfpyr ] = genPyr( img, 'lap', level );
Lpyr = cell(1,level);
Lpyr{length(Gpyr)}= Gpyr{length(Gpyr)} ;
for p = length(Gpyr)-1:-1:1
    osz = size(Gpyr{p+1})*2-1;
	Gpyr{p} = Gpyr{p}(1:osz(1),1:osz(2),:);
	Lpyr{p} = Gpyr{p}- pyr_expand(Gpyr{p+1});
end
%% Plot some levels
subplot(2, 3, 1);imshow(Lpyr{3}, []); title('Laplacian From Gaussian level 3')
subplot(2, 3, 2);imshow(Lpyr{4}, []); title('Laplacian From Gaussian level 4')
subplot(2, 3, 3);imshow(Lpyr{5}, []); title('Laplacian From Gaussian level 5')

subplot(2, 3, 4);imshow(perfpyr{3}, []); title('Laplacian Pyramid level 3')
subplot(2, 3, 5);imshow(perfpyr{4}, []); title('Laplacian Pyramid level 4')
subplot(2, 3, 6);imshow(perfpyr{5}, []); title('Laplacian Pyramid level 5')
    case 'Gaussian'
%% Gaussian from Laplacian
[ Lpyr ] = genPyr( img, 'lap', level );
[ perfpyr ] = genPyr( img, 'gauss', level );

Gpyr = cell(1,level);
Gpyr{length(Lpyr)}= Lpyr{length(Lpyr)} ;
for p = length(Lpyr)-1:-1:1
    %osz = size(Gpyr{p+1})*2-1;
    Gpyr{p}=Lpyr{p}+pyr_expand(Gpyr{p+1});
end


%% Plot some levels
subplot(2, 3, 1);imshow(Gpyr{1}, []); title('Gaussian From Laplacian level 1')
subplot(2, 3, 2);imshow(Gpyr{3}, []); title('Gaussian From Laplacian level 3')
subplot(2, 3, 3);imshow(Gpyr{5}, []); title('Gaussian From Laplacian level 5')

subplot(2, 3, 4);imshow(perfpyr{1}, []); title('Gaussian Pyramid level 1')
subplot(2, 3, 5);imshow(perfpyr{3}, []); title('Gaussian Pyramid level 3')
subplot(2, 3, 6);imshow(perfpyr{5}, []); title('Gaussian Pyramid level 5')
end



