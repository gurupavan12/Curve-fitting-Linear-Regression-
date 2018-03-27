%starter code for project 1: linear regression
%pattern recognition, CSE583/EE552
%Weina Ge, Aug 2008

%generate noisy observations from the "ground true" curve
function [x, y, t] = generateData()
npts = 50; %number of sample points -- change this number when you want to vary the sample size
x = linspace(1,4*pi,npts);
y = sin(.5*x);

%define the noise model
nmu = 0;
nsigma = 0.3;
noise = nmu+nsigma.*randn(1,npts); %generate npts number of samples from the N(nmu,nsigma^2)
t  = y + noise; %noisy observation

%save the data points
save data.mat x y t

% f=figure;
% plot(x,t,'ro','MarkerSize',8,'LineWidth',1.5);
% xlabel('Data points');
% ylabel('t');
% hold on;
% plot(x,y,'b-','MarkerSize',8,'LineWidth',1.5);
% title('Data points and trajectory ');
% legend('Data points','trajectory');
% saveas(f,'DataPointAndTrajectory.png');
return 
end