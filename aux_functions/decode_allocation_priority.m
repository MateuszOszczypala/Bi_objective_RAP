function w = decode_allocation_priority(m, chromosomes)
w(1:m) = NaN; % priorities

for j = 1:m
    w(j) = bin2dec(num2str(chromosomes(j, 1:8)));
end