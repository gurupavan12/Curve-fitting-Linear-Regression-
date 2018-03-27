%% PART-2: Error minimization with the regularization term 

N=length(x);
t=t';
M = [0 1 3 6 9 20];
lambda = [1e-18 1e-15 1e-13];

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
        saveas(fig,['EM_w_Reg_Order_200_',num2str(M(k)),'_lambda',num2str(log10(lambda(i))),'.png']);
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
        saveas(f,['EM_RMS_error_with_Reg_200_lambda_',num2str(log10(lambda(i))),'.png']);
end
