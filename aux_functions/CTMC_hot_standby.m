function CTMC = CTMC_hot_standby(n, k, working_failure_rate, repair_rate)
   
    State_space = zeros(n-k+2, 3);
    
    % Working states with k working components and remaining in hot standby or failed
    j = 0;
    for i = 1:(n-k+1)
        State_space(i, 1) = k; % number of working components
        State_space(i, 2) = n - k - j; % number of hot standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    % Failure state with k-1 operational components and all others failed
    State_space(n-k+2, 1) = k - 1; % number of working components
    State_space(n-k+2, 2) = 0; % number of hot standby components
    State_space(n-k+2, 3) = n - k + 1; % number of failed components
    
    % Initialize CTMC matrix
    CTMC = zeros(n-k+2, n-k+2);
    
    % Transition rates
    for i = 1:(n-k+2)
        for j = 1:(n-k+2)
            if State_space(i,1) - State_space(j,1) == 1
                % Failure of operational component
                CTMC(i, j) = (State_space(i,1)+State_space(i,2)) * working_failure_rate;
            elseif State_space(i,3) - State_space(j,3) == 1
                % Repair
                CTMC(i, j) = State_space(i,3) * repair_rate;
            end
        end
    end
    
    % Diagonal elements
    for i = 1:(n-k+2)
        CTMC(i, i) = -sum(CTMC(i, :));
    end
end
