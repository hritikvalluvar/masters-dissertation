function [Up] = PCA(J, p)

global U;
global S;
global singular_values;

% if isempty(U)
%     % Perform PCA
%     [U,S,V]=svd(J','econ');
% end

% Extract the diagonal matrix of singular values
singular_values = diag(S);
[U,S,V]=svd(J','econ');
% Select the top p singular values and corresponding columns of U and V
Up = U(:, 1:p);
figure, plot(singular_values), xlabel('Principal Components','FontSize',16), ylabel('Variance Explained','FontSize',16);
fprintf('Size of Up: [%d, %d]\n', size(Up));
end