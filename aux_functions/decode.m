function w = decode(m, X)
w(1:m) = NaN; % priorities

for j = 1:m
    w(j) = bin2dec(num2str(X(j, 1:8)));
end