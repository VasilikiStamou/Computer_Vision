clear;clc;close all;

kernelWidth = 5; % default
cw = .375; 
ker1d = [.25-cw/2 .25 cw .25 .25-cw/2];

figure; hold on; 
subplot(3,2,1);plot(ker1d);title('Number of convolutions = 0');

ker = ker1d;
count=1;
for i=1:2:10
    count=count+1;
    ker=conv(ker,ker1d);
    subplot(3,2,count);plot(ker);
    title(sprintf('Number of convolutions = %s',num2str(i)));
end
hold off;