function X_m = genGauss(K, mu, covm)
% Generates K samples of D-dimensional Gaussian data
% with specified mean mu and covariance matrix covm
% using the inverse whitening transform.

% Generate K samples of standard normal (sphere) data
D = length(mu);
data = randn(K, D);

% Eigendecomposition of covariance matrix
[V, E] = eig(covm);

% Apply inverse whitening transform: stretch + rotate + shift
% This gives data with EXACTLY the prescribed covariance
X_m = (data * sqrt(E) * V') + mu(:)';
end