function [M,inds,delta] = gen_data(m,n,r,SR, noise)
Ml = randn(m,r);
Mr = randn(r,n);
M = Ml*Mr;
assert(rank(M) == r);
k = ceil(SR*m*n);
inds = randsample(1:(m*n),k,false);
S = noise*rand(m,n);
M = M+S;
delta = .1*norm(S(inds),'fro');

