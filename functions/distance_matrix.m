function D = distance_matrix(X)
    [dim, num] = size(X);
    D = zeros(num, num, 'single');
    for i = 1:num
        for j = 1:num
            D(i, j) = sum((X(:, i) - X(:, j)).^2);
        end
    end
end
