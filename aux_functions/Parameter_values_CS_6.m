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