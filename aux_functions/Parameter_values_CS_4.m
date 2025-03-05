% Weight constraint
Weight = 700;
% Another levels of weight constraints:
% Weight = 700;
% Weight = 800;
% Weight = 900;
% Weight = 1000;

% System characteristics
% number of subsystems
m = 10;

% minimal number (k) for subsystems
k = [1 2 3 4 5 6 7 8 9 10];

% sum of all k number
K = sum(k);

% lambda failure rates for active component

% working_failure_rate = round(rand(10,1), 2);
% warm_standby_failure_rate = round((0.5*rand(1)+0.2)*working_failure_rate, 2);
working_failure_rate = [0.28 0.25 0.45 0.23 0.80 0.99 0.03 0.54 0.09 0.80];
warm_standby_failure_rate = [0.19 0.17 0.31 0.16 0.56 0.69 0.02 0.38 0.06 0.56];

% beta switching rates for standby component to active
% cold_standby_switching_rate = round(5+2*rand(10,1), 2);
% warm_standby_switching_rate = round((1+2*rand(1))*cold_standby_switching_rate, 2);
cold_standby_switching_rate = [5.13 6.88 5.04 6.37 6.57 6.07 6.77 6.80 6.25 5.28];
warm_standby_switching_rate = [7.36 9.88 7.24 9.14 9.43 8.71 9.72 9.76 8.97 7.58];

% mu repiar rates
% repair_rate = round(1+rand(10,1), 2);
repair_rate = [1.18 1.04 1.11 1.62 1.94 1.35 1.41 1.98 1.95 1.68];
%{
for i = 1:10
    unit_cost(i) = round(0.2*(10-i)+rand(1), 2);
    unit_weight(i) = round(0.1*(10-i)+rand(1), 2);
end
%}

% unit cost
unit_cost = [2.79 1.94 1.64 1.88 1.41 1.55 1.15 0.91 0.92 0.35];

% unit weight
unit_weight = [1.67 1.46 1.00 1.13 1.10 0.98 0.88 0.28 1.10 0.97];

% population size
population_size = 200;

% number of generation
max_iteration = 10000;

system_cost_primary = sum(unit_cost.*k, "all");
system_weight_primary = sum(unit_weight.*k, "all");