function [X_hat, iter, time, opt_val] = ADM(M, inds, delta)
tic
[m,n] = size(M);
X = randn(size(M));
X(inds) = M(inds);
Z = randn(size(M));
tol = 10^-4;
stop_criteria = inf;
iter = 0;
beta = 2.5 / (m*n)^.5;
gamma = 1.6;
while(stop_criteria > tol)
    iter = iter +1;
    B = X - (1/beta)*Z;
    Y = B;
    temp = B(inds) - M(inds);
    Y(inds) = (min(delta / norm(temp, 'fro'), 1) - 1)*temp +B(inds);
    [U,S,V] = svd(Y+(1/beta)*Z, 'econ');
    S_hat = diag(max(diag(S) - (1/beta),0));
    X_new = U*S_hat*V';
    stop_criteria = REER(X, X_new);
    X = X_new;
    Z = Z - gamma*beta*(X-Y);
    %fprintf('Iter: %d, Err: %f, Tol: %f\n',iter, REER(X,M), stop_criteria);
end
time = toc;
[u,s,v] = svd(X);
opt_val = sum(sum(s));
X_hat = X;
