function strategy = decode_strategy(m, chromosomes)
strategy(1:m) = NaN;

for j = 1:m
    strategy(j) = bin2dec(num2str(chromosomes(j, 9:10)));   
end