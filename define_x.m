function X = define_x(x,M)
    N=length(x);
    X = zeros(N,M+1);
    for i=1:M+1
        X(:,i) = x.^(i-1);
    end
end
