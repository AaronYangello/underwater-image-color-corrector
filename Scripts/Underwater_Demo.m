%% House Keeping
clear;
clc;
projectPath = 'E:\Rowan Repos\RowanSP18_2\Computer Vision\Project';
addpath(genpath(projectPath));

%% Multiple Image Demo
files = dir(fullfile([projectPath '\InputRaw'], '*.jpg'));

[length,~] = size(files);

    for j = 0:length-1
        if(mod(j,4) == 0) 
            figure;
        end
        I = imread(files(j+1).name);
        uwb = Underwater_WhiteBalance(I, 1, false);
        filtered = Underwater_MutiScaleFusion(uwb, false);
        subplot(2,2,mod(j,4) + 1),imshowpair(I,filtered,'montage');
        title(files(j+1).name);
    end

%% One Image at a Time

%Ours
I = imread('Shark3.jpg');
uwb = Underwater_WhiteBalance(I, 1, true);
fus = Underwater_MutiScaleFusion(uwb, true);
figure;
subplot(131),imshow(I), title('Original Image');
subplot(132),imshow(uwb), title('White Balanced Image');
subplot(133),imshow(fus), title('Output Image (After Fusion)');
suptitle('Image Progression');

%Matlab
%A would-be white pixel
x = 426; y = 353;
gray_val = [I(y,x,1) I(y,x,2) I(y,x,3)];
matlab = chromadapt(I,gray_val);
c = newline;
figure;
subplot(121),imshow(matlab), title(['Matlab Suggested Whitebalance ' c ' (No Red Compensation)']);
subplot(222),imshow(uwb), title('Ancuti et al. Suggested White Balance');
subplot(224),imshow(fus), title('Ancuti et al. with Multi-Scale Fusion');
suptitle('Matlab vs. Ancuti et al.');

%% Underwater Filter
