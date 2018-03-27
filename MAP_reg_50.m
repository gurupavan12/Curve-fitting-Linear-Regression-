%% PART-4: The MAP (maximum a posteriori) estimator of the Bayesian approach

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