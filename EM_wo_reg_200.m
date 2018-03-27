%PART - 1 Regression with energy minimization for 50 points


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
    saveas(fig,['EM_wo_Reg_200_Order',num2str(M(k)),'.png']);
    
    
    error{k} = 0.5*((X{k}*w_star{k} - t)')*(X{k}*w_star{k} - t);
    RMS_error{k} = sqrt(2*error{k}/length(x));
end
RMSvec = cell2mat(RMS_error);
fig = figure();
plot(M,RMSvec,'r-','LineWidth',2);
title('RMS error vs Order (Without Regularization)');
xlabel('Order M');
ylabel('RMS error');
saveas(fig,'EM_RMS_error_wo_Reg_200.png');
