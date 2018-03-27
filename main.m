clear all;clc;close all;
warning off;
addpath export_fig/

%load the data points
load data.mat
%plot the groud truth curve
figure(1)
clf
hold on;
xx = linspace(1,4*pi,50);
yy = sin(.5*xx);
err = ones(size(xx))*0.3;
% plot the x and y color the area around the line by err (here the std)
h = shadedErrorBar(x,y,err,{'b-','color','b','LineWidth',2},0);
%plot the noisy observations
plot(x,t,'ro','MarkerSize',8,'LineWidth',1.5);
hold off; 
% Make it look good
grid on;
set(gca,'FontWeight','bold','LineWidth',2)
xlabel('x');
ylabel('t');

% Save the image into a decent resolution
export_fig sampleplot -png -transparent -r150

%% PART - 1: Regression with energy minimization

%With 50 data points
load data.mat
EM_wo_reg_50();
close all; clear all; clc;

%With 200 data points
load data200.mat
EM_wo_reg_200();
close all; clear all; clc;

%% PART-2: Error minimization with the regularization term 

%With 50 data points
load data.mat
EM_reg_50();
close all; clear all; clc;

%With 200 data points
load data200.mat
EM_reg_200();
close all; clear all; clc;

%% PART - 3: The ML (maximal likelihood) estimator of the Bayesian approach

%With 50 data points
load data.mat
MLE_wo_reg_50();
close all; clear all; clc;

%With 200 data points
load data200.mat
MLE_wo_reg_200();
close all; clear all; clc;

%% PART-4: The MAP (maximum a posteriori) estimator of the Bayesian approach

%With 50 data points
load data.mat
MAP_reg_50();
close all; clear all; clc;

%With 200 data points
load data200.mat
MAP_reg_200();
close all; clear all; clc;
