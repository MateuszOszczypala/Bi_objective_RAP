% Weight constraint
%Weight = 50;
% Another levels of weight constraints:
% Weight = 50;
% Weight = 60;
% Weight = 70;
% Weight = 80;

% System characteristics
% number of subsystems
m = 10;

% minimal number (k) for subsystems
k = [3 3 2 2 4 4 2 2 3 3];

% sum of all k number
K = sum(k);

% lambda failure rates for active component

%working_failure_rate = round(0.5+0.5*rand(10,1), 2);
%warm_standby_failure_rate = round((0.2*rand(1)+0.1)*working_failure_rate, 2);
working_failure_rate = [0.86 0.98 0.65 0.57 0.63 0.70 0.55 0.54 0.61 0.57];
warm_standby_failure_rate = [0.26 0.28 0.06 0.28 0.18 0.22 0.12 0.12 0.16 0.14];

% beta switching rates for standby component to active
% cold_standby_switching_rate = round(5+2*rand(10,1), 2);
% warm_standby_switching_rate = round((1+2*rand(1))*cold_standby_switching_rate, 2);
cold_standby_switching_rate = [5.13 6.88 5.04 6.37 6.57 6.07 6.77 6.80 6.25 5.28];
warm_standby_switching_rate = [7.36 9.88 7.24 9.14 9.43 8.71 9.72 9.76 8.97 7.58];

% mu repiar rates
% repair_rate = round(2+rand(10,1), 2);
repair_rate = [2.18 2.04 2.11 2.62 2.94 2.35 2.41 2.98 2.95 2.68];

% unit cost
% unit_cost = round(3*rand(10,1), 2)
unit_cost = [2.79 1.94 1.64 1.88 1.41 1.55 1.15 0.91 0.92 0.85];

% unit weight
% unit_weight = round(2*rand(10,1), 2)
unit_weight = [1.67 1.46 1.00 1.13 1.10 0.98 0.88 0.78 1.10 0.97];
