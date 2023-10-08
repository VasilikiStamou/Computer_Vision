clear;clc;close all;tic;
%% Read all videos
% high quality video
high1 = VideoReader('video1_high.avi');
high2 = VideoReader('video2_high.avi');
% low quality video
low1 = VideoReader('video1_low.avi');
low2 = VideoReader('video2_low.avi');
%% Initialize useful matrices and vectors
nol = 2; %number of levels
noi = 10; %number or iterations

%Gauss variance vector
a = [ 6 12 18 ];
N = 10e+2; %number of iterations

L = 2;

% PSNR for high1,high2,low1,low2
PSNRh_1 = zeros(length(a),L);
PSNRh_lk_1 = zeros(length(a),L);

PSNRh_2 = zeros(length(a),L);
PSNRh_lk_2 = zeros(length(a),L);

PSNRl_1 = zeros(length(a),L);
PSNRl_lk_1 = zeros(length(a),L);

PSNRl_2 = zeros(length(a),L);
PSNRl_lk_2 = zeros(length(a),L);


%% Run the main loop
for j = 1:length(a)
    for i = 1:L %high1.NumberOfFrames-1
        % High1 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['High1:j = ' num2str(j)]);
        tic;
        for k = 1:N
            temp = high1.read(i);
            img = high1.read(i+1);
            noise = -a(j)^(1/3) + (a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment ...
            (img,temp,nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRh_1(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRh_lk_1(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
        
        % High2 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['High2:j = ' num2str(j)]);
        for k = 1:N
            temp = high2.read(i);
            img = high2.read(i+1);
            noise = -a(j)^(1/3) + (a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment ...
            (img,temp,nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRh_2(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRh_lk_2(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
    
        % Low1 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['Low1:j = ' num2str(j)]);
        for k = 1:N
            temp = low1.read(i);
            img = low1.read(i+1);
            noise = -a(j)^(1/3) + (a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment ...
            (img,temp,nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRl_1(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRl_lk_1(j,i) = mean(20*log10(255./mean(mesos_lk,2)));    
    
        % Low2 video
        mesos = zeros(N,noi);
        mesos_lk = zeros(N,noi);
        disp(['Low2:j = ' num2str(j)]);
        for k = 1:N
            temp = low2.read(i);
            img = low2.read(i+1);
            noise = -a(j)^(1/3) + (a(j)^(1/3)-(-a(j)^(1/3))).*rand(size(img));
            img = uint8(double(img) + (noise));
            [results,results_lk,MSE,rho,MSELK] = ecc_lk_alignment ...
            (img,temp,nol,noi,'affine',eye(2,3));
            mesos(k,:) = MSE;
            mesos_lk(k,:) = MSELK;
        end
        PSNRl_2(j,i) = mean(20*log10(255./mean(mesos,2)));
        PSNRl_lk_2(j,i) = mean(20*log10(255./mean(mesos_lk,2)));
        toc;
    end
end
% Get PSNR frames mean
m_PSNRh_1 = mean(PSNRh_1(:,1:L),2);
m_PSNRh_lk_1 = mean(PSNRh_lk_1(:,1:L),2);
m_PSNRh_2 = mean(PSNRh_2(:,1:L),2);
m_PSNRh_lk_2 = mean(PSNRh_lk_2(:,1:L),2);
    
m_PSNRl_1 = mean(PSNRl_1(:,1:L),2);
m_PSNRl_lk_1 = mean(PSNRl_lk_1(:,1:L),2);
m_PSNRl_2 = mean(PSNRl_2(:,1:L),2);
m_PSNRl_lk_2 = mean(PSNRl_lk_2(:,1:L),2);    

q6_uniform = [m_PSNRh_1 m_PSNRh_lk_1 m_PSNRl_1 m_PSNRl_lk_1;
    m_PSNRh_2 m_PSNRh_lk_2 m_PSNRl_2 m_PSNRl_lk_2 ];
save('partA_6_uniform.mat','q6_uniform');