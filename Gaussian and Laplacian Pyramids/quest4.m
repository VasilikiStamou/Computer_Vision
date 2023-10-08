clear;clc;close all;

kernelWidth = 5; cw = .375; 
h = [.25-cw/2 .25 cw .25 .25-cw/2];

N = 256; n = 1:N;
signal = 2*sin(2*pi*n/112) + 1.5*cos(2*pi*n/8+pi/4);
g{1} = signal';

figure;hold on;
subplot(2,2,1);plot(g{1}); title('Original signal')

for i=1:3    
    eN = [1 zeros(1,N-1)];
    hN = [h zeros(1,N-5)];
    T = toeplitz(1/16*eN,hN');
    N=N/2;
    g{i+1} = kron(eye(N),[1 0])*T*g{i};
    subplot(2,2,i+1);plot(g{i+1}); 
    title(sprintf('Level  %s of Gaussian Pyramid',num2str(i)));
end
hold off
