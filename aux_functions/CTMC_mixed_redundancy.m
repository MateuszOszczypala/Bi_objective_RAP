function CTMC = CTMC_mixed_redundancy(n, k, lambda, beta, mu)
    S = NaN(3*n-3*k+3,3); % size of state space: 3*n-3*k+3 rows (states), 3 columns (state sign)
    % S = (Active, Standby, Failed)
    
    j = 0;
    % working states k+1
    for i = 1:(n-k)
        S(i,1) = k+1;
        S(i,2) = n-k-1-j;
        S(i,3) = j;
        j = j+1;
    end
    
    j = 0;
    % working states k
    for i = (n-k+1):(2*n-2*k+1)
        S(i,1) = k;
        S(i,2) = n-k-j;
        S(i,3) = j;
        j = j+1;
    end
    
    j = 0;
    % failed states k-1
    for i = (2*n-2*k+2):(3*n-3*k+3)
        S(i,1) = k-1;
        S(i,2) = n-k+1-j;
        S(i,3) = j;
        j = j+1;
    end
    
    CTMC = zeros(3*n-3*k+3,3*n-3*k+3);
    for i = 1:(3*n-3*k+3)
        for j = 1:(3*n-3*k+3)
            if S(i,1)-S(j,1)==1 && S(j,3)-S(i,3)==1 % failure
                CTMC(i,j) = S(i,1)*lambda;
            elseif S(i,2)-S(j,2)==1 && S(j,1)-S(i,1)==1 % switch
                CTMC(i,j) = min(min(S(i,2),2),k+1-S(i,1))*beta;
            elseif S(i,3)-S(j,3)==1 && S(j,2)-S(i,2)==1 % repair
                CTMC(i,j) = S(i,3)*mu;
            end
        end
    end
    
    % diagonal
    for i = 1:(3*n-3*k+3)
        diagonal = -sum(CTMC(i,:));
        CTMC(i,i) = diagonal;
    end
end
