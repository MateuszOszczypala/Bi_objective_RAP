% SCRIPT FOR FINDING PARETO FRONTS OF LAST POPULATIONS
clear;clc;clf;
addpath("aux_functions\")

global CS Weight;

vals_table = [1*ones(4,1),[60,80,100,120]',5*ones(4,1);
              2*ones(4,1),[60,80,100,120]',5*ones(4,1);
              3*ones(4,1),[60,80,100,120]',5*ones(4,1);
              4*ones(4,1),[100,120,140,160]',10*ones(4,1);
              5*ones(4,1),[50,60,70,80]',10*ones(4,1);
              6*ones(4,1),[80,100,120,140]',15*ones(4,1)];



for it=1:length(vals_table)
    CS = vals_table(it,1); Weight = vals_table(it,2); D = vals_table(it,3);
    disp([CS,Weight])
    temp = dir("results_analyzed");
    x = [];
    for i=3:length(temp)
        name = temp(i).name;
        file = "results_CS"+CS+"_Weight"+Weight+"_"+name;
        try load("results_analyzed/"+name+"/"+file+".mat")
            for j=1:10
            x = [x;results(j).last_population];
            end
        end
    
        try load("results_analyzed/"+name+"/"+file+"_SBI.mat")
            for j=1:10
            x = [x;results(j).last_population];
            end
        end
    end

obj1 = zeros(length(x),1);
obj2 = zeros(length(x),1);

for i=1:length(x)
    [system_availability_val,total_system_cost] = obj_true_CS(x(i,:));
    obj1(i,1) = system_availability_val;
    obj2(i,1) = total_system_cost;
end

[ndf_index, df_index] = non_dominated_front([-obj1,obj2]');
    save("results_aggregated/data_CS_"+CS+"_W_"+Weight+"_lastpops.mat");
end