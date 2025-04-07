clear;clc;%close all;
figure
w = warning ('off','all');

str = "results_NSGAIII-SBI";

global archive_obj_vals archive_sols iter;

N =200; % pop size
n_iter = 100; % number of iterations
nfes =n_iter*N; % number of function calls


archive_obj_vals = cell(n_iter,1);
archive_sols = cell(n_iter,1);
iter = 0;

hold on;
grid on; legend;
%NSGAIII
%[r1_NSIII,r2_NSIII] = platemo('algorithm',@NSGAIII,'problem',@calcobj_RAP_CS1,'N',N,'maxFE',nfes);
%p = plot(r2_NSIII(:,2),-r2_NSIII(:,1),'+','DisplayName','NSGAIII-rand'); drawnow;
 [r1_NSIII_SBI,r2_NSIII_SBI] = platemo('algorithm',@NSGAIII,'problem',@calcobj_RAP_CS1_SBI,'N',N,'maxFE',nfes);
 plot(r2_NSIII_SBI(:,2),-r2_NSIII_SBI(:,1),'o','DisplayName','NSGAIII-SBI'); drawnow;

temp_obj_vals = [];
temp_sols = []; 
for i=1:n_iter
    temp_obj_vals = [temp_obj_vals;archive_obj_vals{i,:}];
    temp_sols = [temp_sols;archive_sols{i,:}];
end

[ndf_index, df_index] = non_dominated_front(temp_obj_vals');
non_dominated_solutions = temp_sols(ndf_index,:);
non_dominated_obj_vals = temp_obj_vals(ndf_index,:);

results.non_dominated_solutions = non_dominated_solutions;
results.non_dominated_obj_vals = non_dominated_obj_vals;
results.objective_valus_all = archive_obj_vals;
results.last_population = archive_sols{end,:};

save(str+".mat","results");