function [system_availability_val,total_system_cost] = obj_true_CS(x)
global CS Weight;

if CS <= 3
    Parameter_values_CS_1_2_3;
elseif CS <= 4
    Parameter_values_CS_4;
elseif CS <= 5 
    Parameter_values_CS_5;
else
    Parameter_values_CS_6;
end

decoded_chromosomes = x(1:m);
redundancy_strategy = x(m+1:end);

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
switch CS
    case 1
        system_availability_val = system_availability_CS1(subsystem_availability_values);
    case 2
        system_availability_val = system_availability_CS2(subsystem_availability_values);
    case 3
        system_availability_val = system_availability_CS3(subsystem_availability_values);
    case 4
        system_availability_val = system_availability_CS4(subsystem_availability_values);
    case 5
        system_availability_val = system_availability_CS5(subsystem_availability_values);
    case 6
        system_availability_val = system_availability_CS6(subsystem_availability_values);
end

% Calculate the system cost


total_system_cost = Cost(n, unit_cost);
end

