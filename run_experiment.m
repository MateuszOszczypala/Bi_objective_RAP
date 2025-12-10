function [results] = run_experiment(alg_name,sbi,experiment_CS,experiment_d,experiment_weight,nr_reps,pop_size,n_iter,do_plot,do_save)
w = warning ('off','all');

global archive_obj_vals archive_sols iter;
global CS Weight d;

N =pop_size; % pop size
%n_iter = 200; % number of iterations
nfes =n_iter*N; % number of function calls

CS = experiment_CS; Weight = experiment_weight; d = experiment_d;

if sbi == 1
    str = "results_CS"+ CS + "_"+ "Weight"+ Weight + "_" + alg_name + "_SBI";
else
    str = "results_CS"+ CS + "_"+ "Weight"+ Weight + "_" + alg_name;
end

for rep=1:nr_reps
archive_obj_vals = cell(n_iter,1);
archive_sols = cell(n_iter,1);
iter = 0;

if sbi == 1
    [r1,r2] = platemo('algorithm',str2func(alg_name),'problem',@calcobj_RAP_CS_SBI,'N',N,'maxFE',nfes);
else
    [r1,r2] = platemo('algorithm',str2func(alg_name),'problem',@calcobj_RAP_CS,'N',N,'maxFE',nfes);
end

if do_plot
    hold on;
    grid on;
    plot(r2(:,2),-r2(:,1),'o','DisplayName',obj_f_name+"_"+alg_name); drawnow;
end

% temp_obj_vals = [];
% temp_sols = []; 
% for i=1:length(archive_obj_vals)
%    temp_obj_vals = [temp_obj_vals;archive_obj_vals{i,:}];
%    temp_sols = [temp_sols;archive_sols{i,:}];
% end
temp_obj_vals = cell2mat(archive_obj_vals);
temp_sols = cell2mat(archive_sols);

%size(temp_obj_vals)

%[ndf_index, df_index] = non_dominated_front(temp_obj_vals');
%non_dominated_solutions = temp_sols(ndf_index,:);
%non_dominated_obj_vals = temp_obj_vals(ndf_index,:);
non_dominated_solutions = [];
non_dominated_obj_vals = [];

results(rep).pop_size = pop_size;
results(rep).alg_name = alg_name;
results(rep).sbi = sbi;
results(rep).n_iter = n_iter;
results(rep).nfes = nfes;
results(rep).non_dominated_solutions = non_dominated_solutions;
results(rep).non_dominated_obj_vals = non_dominated_obj_vals;
results(rep).objective_valus_all = temp_obj_vals;
results(rep).last_population = archive_sols{end,:};
end

if do_save
    save("results/"+alg_name+"/"+str+".mat","results", '-v7.3');
end

end

