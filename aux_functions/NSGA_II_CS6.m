clear;
%% Non-dominated sorting genetic algorithm (NSGA-II) for RAP
initime = cputime;

% Weight constraint
Weight = 80;
% Another levels of weight constraints:
% Weight = 80;
% Weight = 100;
% Weight = 120;
% Weight = 140;

% System characteristics
% number of subsystems
m = 15;

% minimal number (k) for subsystems
k = [2 2 3 3 2 2 1 1 2 2 3 3 2 2 1];

% sum of all k number
K = sum(k);

% lambda failure rates for active component

% working_failure_rate = round(0.3+0.4*rand(1, 15), 2);
% warm_standby_failure_rate = round((0.2*rand(1)+0.1)*working_failure_rate, 2);
working_failure_rate = [0.67 0.61 0.32 0.63 0.59 0.45 0.42 0.60 0.48 0.52 0.35 0.30 0.67 0.57 0.37];
warm_standby_failure_rate = [0.07 0.06 0.03 0.06 0.06 0.05 0.04 0.06 0.05 0.05 0.04 0.03 0.07 0.06 0.04];

% beta switching rates for standby component to active
% cold_standby_switching_rate = round(5+2*rand(1, 15), 2);
% warm_standby_switching_rate = round((1+2*rand(1))*cold_standby_switching_rate, 2);
cold_standby_switching_rate = [6.61 6.88 5.68 6.94 5.15 6.28 5.64 5.06 5.61 5.84 6.71 5.58 5.68 5.19 6.09];
warm_standby_switching_rate = [19.09 19.87 16.41 20.05 14.88 18.14 16.29 14.62 16.21 16.87 19.38 16.12 16.41 14.99 17.59];

% mu repiar rates
% repair_rate = round(2+rand(1, 15), 2);
repair_rate = [2.96 2.27 2.63 2.87 2.68 2.49 2.85 2.79 2.31 2.92 2.94 2.64 2.60 2.30 2.72];

% unit cost
% unit_cost = round(0.2+3*rand(1, 15), 2);
unit_cost = [1.97 1.09 1.73 1.06 1.45 1.61 2.05 1.87 2.41 0.87 0.92 1.80 2.47 1.63 1.39];

% unit weight
% unit_weight = round(0.2+2*rand(1, 15), 2);
unit_weight = [1.07 0.32 1.26 1.72 0.82 0.63 0.41 1.96 1.47 0.83 1.11 0.74 0.60 1.81 0.93];
% population size
population_size = 200;

% number of generation
max_iteration = 10000;

% size declaration
n(1:m,1:population_size,1:max_iteration) = NaN; % total number of components in subsystem

% populations(gen(binary value), chromosome(subsystem), system, generation)
populations(1:m, 1:10, 1:population_size, 1:max_iteration) = NaN;

subsystem_availability_values(1:m, 1:population_size, 1:max_iteration) = NaN;
system_availability_values(1:population_size, 1:max_iteration) = NaN;
total_system_cost(1:population_size, 1:max_iteration) = NaN;
redundancy_strategy(1:m, 1:population_size, 1:max_iteration) = NaN;

% initial generation for genes 1-8 - Scaled Binomial Initialization
for num_individual = 1:population_size
    for f = 1:m
        for gene = 1:8
            if rand(1) <= sqrt((num_individual-0.5)/population_size)
                g = 0;
            else
                g = 1;                
            end
            populations(f, gene, num_individual, 1) = g;
        end
    end
end
% initial generation for genes 9-10 - Standard random initialization
for num_individual = 1:population_size
    for f = 1:m
        for gene = 9:10
            if rand(1) <= 0.5
                g = 0;
            else
                g = 1;                
            end
            populations(f, gene, num_individual, 1) = g;
        end
    end
end

for num_iteration = 1:max_iteration
    % Evaluation of systems configuration
    for num_individual = 1:population_size

        % Decode the chromosomes
        decoded_chromosomes = decode_allocation_priority(m, populations(1:m, 1:10, num_individual, num_iteration));

        % Decode the strategies
        redundancy_strategy(1:m, num_individual, num_iteration) = decode_strategy(m, populations(1:m, 1:10, num_individual, num_iteration));
       
        % Allocate the components into subsystems
        standby_components = components_placement(m, decoded_chromosomes, Weight-sum(k.*unit_weight), unit_weight);        
        n(1:m,num_individual,num_iteration) = k + standby_components;
        % Calculate the availability of subsystems
        for num_subsystem = 1:m
            
            % Create the CTMC model for the subsystems 
            if redundancy_strategy(num_subsystem, num_individual, num_iteration) == 0 % cold standby
                CTMC_model = CTMC_cold_standby(n(num_subsystem,num_individual,num_iteration), ...
                    k(num_subsystem), working_failure_rate(num_subsystem), cold_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
            elseif redundancy_strategy(num_subsystem, num_individual, num_iteration) == 1 % warm standby
                CTMC_model = CTMC_warm_standby(n(num_subsystem,num_individual,num_iteration), ...
                    k(num_subsystem), working_failure_rate(num_subsystem), warm_standby_failure_rate(num_subsystem), warm_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
            elseif redundancy_strategy(num_subsystem, num_individual, num_iteration) == 2 % mixed standby
                CTMC_model = CTMC_mixed_standby(n(num_subsystem,num_individual,num_iteration), ...
                    k(num_subsystem), working_failure_rate(num_subsystem), warm_standby_failure_rate(num_subsystem), warm_standby_switching_rate(num_subsystem), repair_rate(num_subsystem));
            elseif redundancy_strategy(num_subsystem, num_individual, num_iteration) == 3 % hot standby
                CTMC_model = CTMC_hot_standby(n(num_subsystem,num_individual,num_iteration), ...
                    k(num_subsystem), working_failure_rate(num_subsystem), repair_rate(num_subsystem));
            end                           
                
            % Calculate ergodic probabilities
            ergodic_probabilities_of_CTMC = Ergodic_prob(CTMC_model)';
            
            % Calculate the subsystem availability         
            subsystem_availability_values(num_subsystem,num_individual,num_iteration) = subsystem_availability(n(num_subsystem,num_individual,num_iteration), ...
                k(num_subsystem), ergodic_probabilities_of_CTMC, redundancy_strategy(num_subsystem, num_individual, num_iteration));
            
        end

        % Calculate the system availability

        system_availability_values(num_individual, num_iteration) = system_availability_CS6(subsystem_availability_values(:,num_individual,num_iteration));
        
        % Calculate the system cost
        total_system_cost(num_individual, num_iteration) = Cost(n(:,num_individual,num_iteration)', unit_cost);
    end
    % Idnicate the Pareto fronts
    [sorted_individuals, domination_Pareto, objective_values] = Pareto_front(population_size, system_availability_values(1:population_size, num_iteration), total_system_cost(1:population_size, num_iteration), populations(1:m, 1:10, 1:population_size, num_iteration), m);
    
    % Parents selection for next generation
    [selected_parents, avaialbility_cost_dominance_front] = Parents(sorted_individuals, domination_Pareto,  objective_values, population_size, m);
       
    % Crossover two-point
    offspring = Crossover_two_point(selected_parents, population_size, m);
    
    % Mutation
    offspring_mutated = Mutation(offspring);

    % Save the parents as a half of new generation
    populations(1:m, 1:10, 1:population_size/2, num_iteration+1) = selected_parents;
    % Save the offspring as a half of new generation
    populations(1:m, 1:10, population_size/2+1:population_size, num_iteration+1) = offspring_mutated;
end

% computation time
fintime = cputime;
computation_time = fintime - initime;

% plot(objective_values(:,2), objective_values(:,1), "o");
