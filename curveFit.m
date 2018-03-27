%start code for project #1: linear regression
%pattern recognition, CSE583/EE552
%Pavan Gurudath, 2018

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

clc; clear all; close all;
% [x y t] = generateData();
load data.mat
M = [0 1 3 6 9 20]; %Order
N = length(x);
t=t';

for k=1:length(M)
    X{k} = define_x(x,M(k));
    w_star{k} = zeros(M(k)+1,1);
    w_star{k} =(X{k}'*X{k})\X{k}'*t;
    y_x_wstar{k} = X{k}*w_star{k};
    E_star{k} = 0.5*((y_x_wstar{k} - t).^2);
    fig = figure(k);
    clf;
    hold on;
    % % plot the x and y 
    plot(x,y,'b-','color','b','LineWidth',2);
    % plot the best fit curve
    plot(x,y_x_wstar{k},'k-','LineWidth',2);
    %plot the noisy observations
    plot(x,t,'ro','MarkerSize',8,'LineWidth',1.2);
    hold off; 
    % Make it look good
    grid on;
    set(gca,'FontWeight','bold','LineWidth',2)
    xlabel('x')
    ylabel('t')
    title(['Regression (without regularization) of polynomial order = ', num2str(M(k))]);
    legend('sinusoidal wave without gaussian noise',['curve fit with order =',num2str(M(k))],'training data points');
    saveas(fig,['EM_wo_Reg_Order',num2str(M(k)),'.png']);
    
    
    error{k} = 0.5*((X{k}*w_star{k} - t)')*(X{k}*w_star{k} - t);
    RMS_error{k} = sqrt(2*error{k}/length(x));
end
RMSvec = cell2mat(RMS_error);
fig = figure();
plot(M,RMSvec,'r-','LineWidth',2);
title('RMS error vs Order (Without Regularization)');
xlabel('Order M');
ylabel('RMS error');
saveas(fig,'RMS_error_wo_Reg.png');


%% PART-2: Error minimization with the regularization term 
clc;
clear all;
close all;

% [x y t]=generateData();
load data.mat
N=length(x);
t=t';
M = [0 1 3 6 9 20];
lambda = [1e-18 1e-15 1e-13 1e-2 ];

for i = 1:length(lambda)
    for k = 1:length(M)
        X{i,k} = define_x(x,M(k));
        w_star{i,k} = zeros(M(k)+1,1);
        %Setting lambda
        temp = eye(M(k));
        %Increasing the order by 1 and setting the first row and col to be zero
        lambda_mat{i,k} = lambda(i)*[zeros(1,M(k)+1);zeros(M(k),1) temp]; 
        
        w_star{i,k} =(X{i,k}'*X{i,k} + lambda_mat{i,k})\X{i,k}'*t;
        y_x_wstar{i,k} = X{i,k}*w_star{i,k};
        E_star{i,k} = 0.5*((y_x_wstar{i,k} - t).^2)+lambda(i)/2*(w_star{i,k}'*w_star{i,k});
        fig = figure(k);
        clf;
        hold on;
        % % plot the x and y 
        plot(x,y,'b-','color','b','LineWidth',2);
        % plot the best fit curve
        plot(x,y_x_wstar{i,k},'y-','LineWidth',2);
        %plot the noisy observations
        plot(x,t,'ro','MarkerSize',8,'LineWidth',1.5);
        hold off; 
        % Make it look good
        grid on;
        set(gca,'FontWeight','bold','LineWidth',2)
        xlabel('x')
        ylabel('t')
        title(['Regression (with regularization) of polynomial order = ', num2str(M(k)),'and ln(lambda)=',num2str(log10(lambda(i)))]);
        legend('sinusoidal wave without gaussian noise',['curve fit with order =',num2str(M(k))],'training data points');
        saveas(fig,['EM_w_Reg_Order',num2str(M(k)),'_lambda',num2str(log10(lambda(i))),'.png']);
        error{i,k} = 0.5*((X{i,k}*w_star{i,k} - t)')*(X{k}*w_star{k} - t)+lambda(i)/2*(w_star{i,k}'*w_star{i,k});
        RMS_error{i,k} = sqrt(2*error{i,k}/length(x));
    end
end

RMSvec = cell2mat(RMS_error);
% Plotting the graph of RMS error versus ln lambda for the M=9 polynomial
for i = 1:length(lambda)
        f = figure;
        plot(M,RMSvec(i,:),'r-','LineWidth',2);
        title(['RMS error vs order for lambda = ',num2str(log10(lambda(i)))]);
        xlabel('order');
        ylabel('RMS error');
        saveas(f,['RMS_error_with_Reg_',num2str(log10(lambda(i))),'.png']);
end

%% PART - 3: The ML (maximal likelihood) estimator of the Bayesian approach

clc;
clear all;
close all;
% [x y t]=generateData();
load data.mat
N=length(x);
t=t';

M = [0 1 3 6 9 20];

for k = 1:length(M)
    X{k} = define_x(x,M(k));
    
    w_star{k} = zeros(M(k)+1,1);
    w_star{k} =(X{k}'*X{k})\X{k}'*t;
    mean_ML{k} = X{k}*w_star{k}; %Mean is y(xn,w)
    beta_ML = N/((X{k}*w_star{k} - t)'*(X{k}*w_star{k} - t));
    
    temp_bar = ones(N,1);
    fig3 = figure(k);
    
    h = shadedErrorBar(x,mean_ML{k}, sqrt((1/beta_ML)*temp_bar),{'b-','color','b','LineWidth',1.5},0);
    hold on;
    plot(x,t,'ro','MarkerSize',8,'LineWidth',1.5);
    hold off; 
    % Make it look good
    grid on;
    set(gca,'FontWeight','bold','LineWidth',1.5)
    xlabel('x');
    ylabel('t');
    title(['Regression(w/o regularisation) with polynomial order = ', num2str(M(k))]);

    saveas(fig3,['MLE_wo_reg_order_',num2str(M(k)),'.png']);
    error{k} = 0.5*(X{k}*w_star{k} - t)'*(X{k}*w_star{k} - t);
    RMS_error{k} = sqrt(2*error{k}/N);
end
RMSvec = cell2mat(RMS_error);
f3 = figure;
plot(M,RMSvec,'r-','LineWidth',1.5);
title('RMS (MLE) error vs Order');
xlabel('Order');
ylabel('RMS error');
saveas(f3,['MLE_RMS_error_wo_reg_','.png']);


%% PART-4: The MAP (maximum a posteriori) estimator of the Bayesian approach

clc;
clear all;
close all;
% [x y t]=generateData();
load data.mat;
N=length(x);
t=t';

M = [0 1 3 6 9 20];
nu=0.3;
beta_MAP = 1/(nu^2);
alpha_MAP = [0.005 0.0001 0.1];

for i = 1:length(alpha_MAP)
    for k = 1:length(M)
        X{i,k} = define_x(x,M(k));
        w_star{i,k} = zeros(M(k)+1,1);
        %Setting lambda
        temp = eye(M(k));
        %Increasing the order by 1 and setting the first row and col to be zero
        alpha_mat{i,k} = alpha_MAP(i)*[zeros(1,M(k)+1);zeros(M(k),1) temp]; 
    
        w_star{i,k} =(beta_MAP*X{i,k}'*X{i,k} + alpha_mat{i,k})\(beta_MAP*X{i,k}'*t);
        mean_MAP{i,k} = X{i,k}*w_star{i,k};
        error{i,k} = (beta_MAP/2)*(X{i,k}*w_star{i,k} - t)'*(X{i,k}*w_star{i,k} - t) + (alpha_MAP(i)/2)*w_star{i,k}'*w_star{i,k};
        RMS_error{i,k} = sqrt(2*error{i,k}/N);
        temp_bar = ones(length(x),1);
        f4 = figure();
        
        h = shadedErrorBar(x,mean_MAP{i,k}, (sqrt(1/beta_MAP)*temp_bar),{'b-','color','b','LineWidth',2},0);
        hold on; 
        plot(x,t,'ro','MarkerSize',8,'LineWidth',1.5);
        hold off; 
        % Make it look good
        grid on;
        set(gca,'FontWeight','bold','LineWidth',1.5)
        xlabel('x')
        ylabel('t')
        title(['order = ', num2str(M(k)),'; alpha = ',num2str(alpha_MAP(i))]);
        saveas(f4,['MAP_order_',num2str(M(k)),'_alpha_' num2str(log10(alpha_MAP(i))),'.png']);
    end
end

RMSvec = cell2mat(RMS_error);
for i = 1:length(alpha_MAP)
    f = figure;
    plot(M,RMSvec(i,:),'r-','LineWidth',1.5);
    title(['RMS (MAP) error vs Order for alpha = ',num2str(alpha_MAP(i))]);
    xlabel('Order');
    ylabel('RMS error');
    saveas(f,['MAP_RMS_error_',num2str(log10(alpha_MAP(i))),'.png']);
end


