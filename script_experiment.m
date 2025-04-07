clear;clc; close all;
addpath("aux_functions/");
addpath("Algorithms");

alg_name = "NSGAII";
nr_reps = 10;
pop_size = 200;
n_iter = 100;
do_plot = 0;
do_save = 1;

% CS1
%CS = 1; weights = [60,80,100,120]; d = 10;
% CS2
%CS = 2; weights = [60,80,100,120]; d = 10;
% CS3
%CS = 3; weights = [60,80,100,120]; d = 10;
% CS4
%CS = 4; weights = [100,120,140,160]; d = 20;
% CS5
%CS = 5; weights = [50,60,70,80]; d = 20;
% CS6
%CS = 6; weights = [80,100,120,140]; d = 30;

%run_experiment(alg_name,sbi,experiment_CS,experiment_d,experiment_weight,nr_reps,pop_size,n_iter,do_plot,do_save)

%make table of experiment setups
T = table;
for i=1:4
    T{i,"alg_name"} = alg_name;
    T{i,"sbi"} = 0;     T{i,"experiment_CS"} = CS;
    T{i,"experiment_d"} = d;     T{i,"experiment_weight"} = weights(i);
    T{i,"nr_reps"} = nr_reps;     T{i,"pop_size"} = pop_size;
    T{i,"do_plot"} = do_plot;     T{i,"do_save"} = do_save;
end
temp = T;
temp.sbi = ones(4,1);
T = [T;temp];

parfor i=1:height(T)
    alg_name = T{i,"alg_name"};     sbi = T{i,"sbi"};     experiment_CS = T{i,"experiment_CS"}; 
    experiment_d = T{i,"experiment_d"};     experiment_weight = T{i,"experiment_weight"};
    nr_reps = T{i,"nr_reps"} ;    pop_size = T{i,"pop_size"};
    do_plot = T{i,"do_plot"} ;    do_save =  T{i,"do_save"};
    run_experiment(alg_name,sbi,experiment_CS,experiment_d,experiment_weight,nr_reps,pop_size,n_iter,do_plot,do_save)
end