function b = A(X, x_inds, y_inds)
[~,n] = size(x_inds);
b = zeros(n,1);
for i = 1:n
    x = x_inds(i);
    y = y_inds(i);
    b(i) = X(x,x) + X(y,y) - X(x,y) - X(y,x);
end
 