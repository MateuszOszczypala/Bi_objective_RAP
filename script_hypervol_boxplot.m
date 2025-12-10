%SCRIPT FOR THE BOXPLOTS
clear;clc;close all;

for i=1:6
    for ii=1:4
        eval("load results_aggregated/T"+i+"_"+ii+".mat;");
    end
end
T_all = T1_1(:,[1,2]);
cntr = 0;
for i=1:6
    for ii=1:4
        cntr = cntr + 1;
        eval("T = T"+i+"_"+ii+"(:,[1,2,6]);");
        best_hypervol = -inf;
        for iii=1:height(T)
            valmax = max(max(T{iii,3}{:}));
            temp_name = T{iii,"name"}{:};
            temp_sbi = T{iii,"sbi"};
            id = find(T_all{:,1} == string(temp_name) & T_all{:,2} == temp_sbi);
            if isempty(id)
                T_all{end+1,"name"} = T{iii,"name"};
                T_all{end,"sbi"} = temp_sbi;
                T_all{end,2+cntr} = mean(T{iii,3}{:});
            else
                T_all{id,2+cntr} = mean(T{iii,3}{:});
            end
            if valmax > best_hypervol
                best_hypervol = valmax;
            end
        end
        T_all{:,2+cntr} = T_all{:,2+cntr}./best_hypervol;
    end
end

sbi_max_vals = zeros(1,38);
nonsbi_max_vals = zeros(1,38);
sbi_mean_vals = zeros(1,38);
nonsbi_mean_vals = zeros(1,38);
all_vals = zeros(height(T_all),38);
ids_nonsbi = 1:2:height(T_all);
ids_sbi = 2:2:height(T_all);

for i=1:24
    temp = T_all{:,2+i};
    all_vals = all_vals+ temp;
end
for i=1:24
    temp_sbi = T_all{ids_sbi,2+i};
    sbi_max_vals = sbi_max_vals+max(temp_sbi);
    sbi_mean_vals = sbi_mean_vals+mean(temp_sbi);
    temp_nonsbi = T_all{ids_nonsbi,2+i};
    nonsbi_max_vals = nonsbi_max_vals+max(temp_nonsbi);
    nonsbi_mean_vals = nonsbi_mean_vals+mean(temp_nonsbi);
end
sbi_max_vals = sbi_max_vals/24; sbi_max_vals = 1-sbi_max_vals;
sbi_mean_vals = sbi_mean_vals/24; sbi_mean_vals = 1-sbi_mean_vals;
nonsbi_max_vals = nonsbi_max_vals/24; nonsbi_max_vals = 1-nonsbi_max_vals;
nonsbi_mean_vals = nonsbi_mean_vals/24; nonsbi_mean_vals = 1-nonsbi_mean_vals ;
all_vals = all_vals/24;

starting_id = 2;
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
xvals = 1:38;

sel_xs = [10,11,19,20,28,29,37,38];

T_sel_sbi = table;
iter = 1;
for i=1:65
    T_sub = T_all(2*i,:);
    for j=1:6
        T_sel_sbi{iter,"name"} = T_sub{1,"name"};
        T_sel_sbi{iter,"CS"} = "CS"+j;
        temp_vals = T_sub{1,2+(j-1)*4+1}([sel_xs]) + T_sub{1,2+(j-1)*4+2}([sel_xs]) + ...
            T_sub{1,2+(j-1)*4+3}([sel_xs]) + T_sub{1,2+(j-1)*4+4}([sel_xs]);
        temp_vals = 1-temp_vals/4; temp_vals = max(temp_vals,1e-8);
        T_sel_sbi{iter,'1e3'} = temp_vals(1);
        T_sel_sbi{iter,'2e3'} = temp_vals(2);
        T_sel_sbi{iter,'1e4'} = temp_vals(3);
        T_sel_sbi{iter,'2e4'} = temp_vals(4);
        T_sel_sbi{iter,'1e5'} = temp_vals(5);
        T_sel_sbi{iter,'2e5'} = temp_vals(6);
        T_sel_sbi{iter,'1e6'} = temp_vals(7);
        T_sel_sbi{iter,'2e6'} = temp_vals(8);
        iter = iter + 1;
    end
end

T_sel_nosbi = table;
iter = 1;
for i=1:65
    T_sub = T_all(2*i-1,:);
    for j=1:6
        T_sel_nosbi{iter,"name"} = T_sub{1,"name"};
        T_sel_nosbi{iter,"CS"} = "CS"+j;
        temp_vals = T_sub{1,2+(j-1)*4+1}([sel_xs]) + T_sub{1,2+(j-1)*4+2}([sel_xs]) + ...
            T_sub{1,2+(j-1)*4+3}([sel_xs]) + T_sub{1,2+(j-1)*4+4}([sel_xs]);
        temp_vals = 1-temp_vals/4; temp_vals = max(temp_vals,1e-8);
        T_sel_nosbi{iter,'1e3'} = temp_vals(1);
        T_sel_nosbi{iter,'2e3'} = temp_vals(2);
        T_sel_nosbi{iter,'1e4'} = temp_vals(3);
        T_sel_nosbi{iter,'2e4'} = temp_vals(4);
        T_sel_nosbi{iter,'1e5'} = temp_vals(5);
        T_sel_nosbi{iter,'2e5'} = temp_vals(6);
        T_sel_nosbi{iter,'1e6'} = temp_vals(7);
        T_sel_nosbi{iter,'2e6'} = temp_vals(8);
        iter = iter + 1;
    end
end


figure
tiledlayout(6,2,'TileSpacing','compact','Padding','compact');
nexttile
boxplot(T_sel_sbi{1:6:end,3:end})
title("CS1, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{1:6:end,3:end})
title("CS1, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_sbi{2:6:end,3:end})
title("CS2, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{2:6:end,3:end})
title("CS2, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_sbi{3:6:end,3:end})
title("CS3, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{3:6:end,3:end})
title("CS3, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_sbi{4:6:end,3:end})
title("CS4, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{4:6:end,3:end})
title("CS4, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);


nexttile
boxplot(T_sel_sbi{5:6:end,3:end})
title("CS5, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{5:6:end,3:end})
title("CS5, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);


nexttile
boxplot(T_sel_sbi{6:6:end,3:end})
title("CS6, with SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);

nexttile
boxplot(T_sel_nosbi{6:6:end,3:end})
title("CS6, without SBI")
grid on;
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
xticklabels(ticks_str(sel_xs))
xlabel("Evaluations",fontsize=14)
ylabel("Rel. distance to best-found HV",fontsize=14)
ylim([1e-8,1e0]);
