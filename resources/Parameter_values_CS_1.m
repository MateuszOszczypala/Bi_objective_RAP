% Weight constraint
Weight = 60;
% Another levels of weight constraints:
% Weight = 60;
% Weight = 80;
% Weight = 100;
% Weight = 120;

% System characteristics
% number of subsystems
m = 5;

% minimal number (k) for subsystems
k = [1 1 1 1 1];

% sum of all k number
K = sum(k);

% lambda failure rates for active component

% working_failure_rate = round(rand(5,1), 2);
% warm_standby_failure_rate = round((0.5*rand(1)+0.2)*working_failure_rate, 2);
working_failure_rate = [0.75 0.26 0.51 0.70 0.89];
warm_standby_failure_rate = [0.50 0.17 0.34 0.47 0.59];

% beta switching rates for standby component to active
% cold_standby_switching_rate = round(5+2*rand(5,1), 2);
% warm_standby_switching_rate = round((1+2*rand(1))*cold_standby_switching_rate, 2);
cold_standby_switching_rate = [5.30 6.65 6.08 6.99 5.16];
warm_standby_switching_rate = [9.99 12.54 11.46 13.18 9.73];

% mu repiar rates
% repair_rate = round(1+rand(5,1), 2);
repair_rate = [1.14 1.87 1.58 1.55 1.14];

% c_unit unit cost
% unit_cost = round(4+6*rand(5,1), 2);
unit_cost = [6.50 4.30 9.42 9.67 6.95];

% component weight
% unit_weight = round(1+3*rand(5,1), 2);
unit_weight = [3.56 2.87 2.05 2.54 2.21];

% population size
population_size = 200;

% number of generation
max_iteration = 1000;