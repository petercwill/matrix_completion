rng(10); % for reproducibility
N = 10;
noise = 0.05;
t = 3*pi/2 * (1 + 2*rand(N,1));
h = 11 * rand(N,1);
X = [t.*cos(t), h, t.*sin(t)] + noise*randn(N,3);
K = X*X';
scatter3(X(:,1),X(:,2),X(:,3))
nn = knnsearch(X,X,'K',4);
eta = zeros(N,N);
for i = 1:N
    for j = 2:4
        eta(i,nn(i,j)) = 1;
    end
end
eta(eta*eta' == 1) = 1;
is = [];
js = [];
x = []
counter = 1;
other_counter = 1;
c = containers.Map
for i = 1:N
    for j = 1:N
        if(eta(i,j) == 1)
            fprintf("ETA : %d,%d\n",i,j);
            other_counter = other_counter + 1;
            is = [is,i];
            js = [js,j];
            eta(j,i) = 0;
            key = strcat(num2str(i),',',num2str(i));
            if(~ isKey(c,key))
                c(key) = counter;
                fprintf("ADDING : %d,%d, %f\n",i,i,K(i,i));
                x = [x,K(i,i)];
                counter = counter + 1;
            end
            key = strcat(num2str(j),',',num2str(j));
            if(~ isKey(c,key))
                fprintf("ADDING : %d,%d, %f\n",j,j,K(j,j));
                c(key) = counter;
                x = [x,K(j,j)];
                counter = counter + 1;
            end
            key = strcat(num2str(i),',',num2str(j));
            if(~ isKey(c,key))
                fprintf("ADDING : %d,%d, %f\n",i,j,K(i,j));
                c(key) = counter;
                x = [x,K(i,j)];
                counter = counter + 1;
            end
        end
    end
end
[~,N] = size(is);
A = sparse(N,N);
for k = 1:N
    i = is(k);
    j = js(k);
    key1 = strcat(num2str(i),',',num2str(i));
    key2 = strcat(num2str(j),',',num2str(j));
    key3 = strcat(num2str(i),',',num2str(j));
    A(k,c(key1)) = 1;
    A(k,c(key2)) = 1;
    A(k,c(key3)) = -2;
end

tic
[m,n] = size(M);
X = randn(size(M));
X(inds) = M(inds);
Z = randn(size(M));
tol = 2*10^-4;
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