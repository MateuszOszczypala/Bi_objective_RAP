function [system_availability_val,total_system_cost] = obj_true_CS1(x)
% System characteristics
% number of subsystems
m = 15;
decoded_chromosomes = x(1:m);
redundancy_strategy = x(m+1:end);
% Weight constraint
Weight = 150;

% System characteristics
% minimal number (k) for subsystems
%k = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
k = [1 2 2 1 2 2 1 3 1 3 1 2 1 2 1];

% sum of all k number
K = sum(k);

% lambda failure rates for active component
working_failure_rate = [0.18 0.22 0.26 0.31 0.22 0.17 0.52 0.55 0.34 0.46 0.35 0.15 0.27 0.33 0.68];
warm_standby_failure_rate = working_failure_rate * 0.1;

% beta switching rates for standby component to active
cold_standby_switching_rate = [10 10 10 10 10 10 10 10 10 10 10 10 10 10 10];
warm_standby_switching_rate = cold_standby_switching_rate * 2;

% mu repiar rates
repair_rate = [0.3 0.4 0.5 0.4 0.45 0.50 0.55 0.65 0.75 0.8 0.65 0.6 0.7 0.5 0.8];

% c_unit unit cost
unit_cost = [12 9 8 7.5 8.5 11.5 5 4.5 8 7.5 9.5 12.5 8.5 7 4];

% component weight
unit_weight = [1 2 1.5 2.5 3.5 1.5 4 4.5 2 6.5 2.5 2.5 3.5 1 4];
       
% Allocate the components into subsystems
standby_components = components_placement(m, decoded_chromosomes, Weight-sum(k.*unit_weight), unit_weight);
n = k + standby_components;
% Calculate the availability of subsystems
for num_subsystem = 1:m
    % Create the CTMC model for the subsystems 
    if redundancy_strategy(num_subsystem) == 0 % cold standby
        CTMC_model = CTMC_cold_standby(n(num_subsystem), ...
            k(num_subsystem), working_failure_rate(num_subsystem), cold_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
    elseif redundancy_strategy(num_subsystem) == 1 % warm standby
        CTMC_model = CTMC_warm_standby(n(num_subsystem), ...
            k(num_subsystem), working_failure_rate(num_subsystem), warm_standby_failure_rate(num_subsystem), warm_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
    elseif redundancy_strategy(num_subsystem) == 2 % mixed standby
        CTMC_model = CTMC_mixed_standby(n(num_subsystem), ...
            k(num_subsystem), working_failure_rate(num_subsystem), warm_standby_failure_rate(num_subsystem), warm_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
    elseif redundancy_strategy(num_subsystem) == 3 % hot standby
        CTMC_model = CTMC_hot_standby(n(num_subsystem), ...
            k(num_subsystem), working_failure_rate(num_subsystem), repair_rate(num_subsystem));
    end                           
        
    % Calculate ergodic probabilities
    ergodic_probabilities_of_CTMC = Ergodic_prob(CTMC_model)';
    
    % Calculate the subsystem availability         
    subsystem_availability_values(num_subsystem) = subsystem_availability(n(num_subsystem), ...
        k(num_subsystem), ergodic_probabilities_of_CTMC, redundancy_strategy(num_subsystem));
    
end

% Calculate the system availability
system_availability_val = system_availability(subsystem_availability_values);

% Calculate the system cost


total_system_cost = Cost(n, unit_cost);
end

