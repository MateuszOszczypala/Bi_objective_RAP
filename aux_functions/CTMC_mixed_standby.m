function CTMC = CTMC_mixed_standby(n, k, working_failure_rate, warm_standby_failure_rate, warm_standby_switching_rate, repair_rate)
    
    State_space = zeros(3*n-3*k+3, 3);

    j = 0;
    % Working states with k+1 active components
    for i = 1:(n-k)
        State_space(i, 1) = k+1; % number of working components
        State_space(i, 2) = n-k-1-j; % number of hot standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    j = 0;
    % Working states with k active components
    for i = (n-k+1):(2*n-2*k+1)
        State_space(i, 1) = k; % number of working components
        State_space(i, 2) = n-k-j; % number of hot standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    j = 0;
    % Failed states with k-1 active components
    for i = (2*n-2*k+2):(3*n-3*k+3)
        State_space(i, 1) = k-1; % number of working components
        State_space(i, 2) = n-k+1-j; % number of hot standby components
        State_space(i, 3) = j; % number of failed components
        j = j + 1;
    end
    
    % Initialize CTMC matrix
    CTMC = zeros(3*n-3*k+3, 3*n-3*k+3);
    
    % Transition rates
    for i = 1:(3*n-3*k+3)
        for j = 1:(3*n-3*k+3)
            if State_space(i,1) - State_space(j,1) == 1 && State_space(j,3) - State_space(i,3) == 1
                % Failure of active component
                CTMC(i, j) = State_space(i,1) * working_failure_rate;
            elseif State_space(i,2) - State_space(j,2) == 1 && State_space(j,3) - State_space(i,3) == 1
                % Failure of warm standby component
                if State_space(i,1) == k - 1
                    CTMC(i, j) = 0; % according to the assumption of non-failing components in subsystem failure state
                else
                    CTMC(i, j) = State_space(i,2) * warm_standby_failure_rate;
                end
            elseif State_space(i,2) - State_space(j,2) == 1 && State_space(j,1) - State_space(i,1) == 1
                % Switch
                CTMC(i, j) = (min(min(State_space(i,2), 2), k + 1 - State_space(i,1))) * warm_standby_switching_rate;
            elseif State_space(i,3) - State_space(j,3) == 1 && State_space(j,2) - State_space(i,2) == 1
                % Repair
                CTMC(i, j) = State_space(i,3) * repair_rate;
            end
        end
    end
    
    % Diagonal elements
    for i = 1:(3*n-3*k+3)
        CTMC(i, i) = -sum(CTMC(i, :));
    end
end
