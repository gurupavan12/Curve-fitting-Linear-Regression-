%% PART - 3: The ML (maximal likelihood) estimator of the Bayesian approach

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

    saveas(fig3,['MLE_wo_reg_200_order_',num2str(M(k)),'.png']);
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