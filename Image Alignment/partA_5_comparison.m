clear all; close all; clc;
load('partA_4.mat');
load('partA_5_img.mat');
load('partA_5_template.mat');
load('partA_5_both.mat');
vectory = [q4; q5_template; q5_img; q5_both ];
vectorx = [1:4];
% Plot
figure('Name','Comparison for question 5 and 4');
subplot(1,2,1);
semilogy(vectorx,vectory(1:2:end,1),'-+',vectorx,vectory(1:2:end,2),'-+',...
    vectorx,vectory(1:2:end,3),'-+',vectorx,vectory(1:2:end,4),'-+');
title('Comparison for question 5 and 4 - High1 and Low1');
xlabel(''); ylabel('PSNR_{dB}');
legend('PSNR high\_1','PSNR high\_LK\_1','PSNR low\_1','PSNR low\_LK\_1');
subplot(1,2,2);
semilogy(vectorx,vectory(2:2:end,1),'-+',vectorx,vectory(2:2:end,2),'-+',...
    vectorx,vectory(2:2:end,3),'-+',vectorx,vectory(2:2:end,4),'-+');
title('Comparison for question 5 and 4 - High2 and Low2');
xlabel(''); ylabel('PSNR_{dB}');
legend('PSNR high\_2','PSNR high\_LK\_2','PSNR low\_2','PSNR low\_LK\_2');
