function err = REER(X,M)
err = norm(X-M,'fro') / norm(M,'fro');
end