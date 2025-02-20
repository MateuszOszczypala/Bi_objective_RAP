function CTMC = CTMC_warm_standby(n, k, working_failure_rate, warm_standby_failure_rate, warm_standby_switching_rate, repair_rate)
    
    State_space = zeros(2*n - 2*k + 3, 3);
    
    % Working states with k working components and remaining in warm standby or failed
    j = 0;
    for i = 1:(n-k+1)
        State_space(i, 1) = k; % number of working components
        State_space(i, 2) = n - k - j; % number of warm standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    % Failure states with k-1 operational components and n-k+1 failed components
    j = 0;
    for i = (n-k+2):(2*n-2*k+3)
        State_space(i, 1) = k - 1; % number of working components
        State_space(i, 2) = n - k + 1 - j; % number of warm standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    % Initialize CTMC matrix
    CTMC = zeros(2*n - 2*k + 3, 2*n - 2*k + 3);
    
    % Transition rates
    for i = 1:(2*n - 2*k + 3)
        for j = 1:(2*n - 2*k + 3)
            if State_space(i,1) - State_space(j,1) == 1 && State_space(j,3) - State_space(i,3) == 1
                % Failure of working component
                CTMC(i, j) = State_space(i,1) * working_failure_rate;
            elseif State_space(i,2) - State_space(j,2) == 1 && State_space(j,3) - State_space(i,3) == 1
                % Failure of warm standby component
                if State_space(i,1) == k - 1
                    CTMC(i, j) = 0; % Non-failing components in subsystem failure state
                else
                    CTMC(i, j) = State_space(i,2) * warm_standby_failure_rate;
                end
            elseif State_space(i,2) - State_space(j,2) == 1 && State_space(j,1) - State_space(i,1) == 1
                % Switch
                CTMC(i, j) = warm_standby_switching_rate;
            elseif State_space(i,3) - State_space(j,3) == 1 && State_space(j,2) - State_space(i,2) == 1
                % Repair
                CTMC(i, j) = State_space(i,3) * repair_rate;
            end
        end
    end
    
    % Diagonal elements
    for i = 1:(2*n - 2*k + 3)
        CTMC(i, i) = -sum(CTMC(i, :));
    end
end
