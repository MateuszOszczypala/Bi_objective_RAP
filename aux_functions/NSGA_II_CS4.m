clear;
%% Non-dominated sorting genetic algorithm (NSGA-II) for RAP
initime = cputime;

% Weight constraint
Weight = 100;
% Another levels of weight constraints:
% Weight = 100;
% Weight = 120;
% Weight = 140;
% Weight = 160;

% System characteristics
% number of subsystems
m = 10;

% minimal number (k) for subsystems
k = [1 2 3 4 5 6 7 8 9 10];

% sum of all k number
K = sum(k);

% lambda failure rates for active component

%working_failure_rate = round(0.5*rand(10,1), 2);
%warm_standby_failure_rate = round((0.2*rand(1)+0.1)*working_failure_rate, 2);
working_failure_rate = [0.43 0.49 0.09 0.47 0.13 0.20 0.05 0.04 0.11 0.07];
warm_standby_failure_rate = [0.13 0.14 0.03 0.14 0.04 0.06 0.01 0.01 0.03 0.02];

% beta switching rates for standby component to active
% cold_standby_switching_rate = round(5+2*rand(10,1), 2);
% warm_standby_switching_rate = round((1+2*rand(1))*cold_standby_switching_rate, 2);
cold_standby_switching_rate = [5.13 6.88 5.04 6.37 6.57 6.07 6.77 6.80 6.25 5.28];
warm_standby_switching_rate = [7.36 9.88 7.24 9.14 9.43 8.71 9.72 9.76 8.97 7.58];

% mu repiar rates
% repair_rate = round(2+rand(10,1), 2);
repair_rate = [2.18 2.04 2.11 2.62 2.94 2.35 2.41 2.98 2.95 2.68];
%{
for i = 1:10
    unit_cost(i) = round(0.2*(10-i)+rand(1), 2);
    unit_weight(i) = round(0.1*(10-i)+rand(1), 2);
end
%}

% unit cost
unit_cost = [2.79 1.94 1.64 1.88 1.41 1.55 1.15 0.91 0.92 0.85];

% unit weight
unit_weight = [1.67 1.46 1.00 1.13 1.10 0.98 0.88 0.78 1.10 0.97];

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

        system_availability_values(num_individual, num_iteration) = system_availability_CS4(subsystem_availability_values(:,num_individual,num_iteration));
        
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
