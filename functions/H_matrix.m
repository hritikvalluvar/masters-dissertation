function H = H_matrix(size)
    e = ones(size, 1, 'single');
    I = eye(size, 'single');
    H = I - (1.0/size) * (e * e');
end