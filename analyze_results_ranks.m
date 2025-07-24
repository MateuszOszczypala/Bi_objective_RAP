clear;clc;close all;

%CS = 1; weights = [60,80,100,120];
%CS = 2; weights = [60,80,100,120]; 
%CS = 3; weights = [60,80,100,120];
%CS = 4; weights = [100,120,140,160];
%CS = 5; weights = [50,60,70,80];
CS = 6; weights = [80,100,120,140];

%CS = 6; Weight = 120;
%CS = 5; Weight = 80;

temp = dir("results_analyzed");
for cntr = 1:4
    Weight = weights(cntr);
    T = table;
    for i=3:length(temp)
        name = temp(i).name;
        file = "results_CS"+CS+"_Weight"+Weight+"_"+name;
        try load("results_analyzed/"+name+"/"+file+".mat")
            T{end+1,"name"} = {name};
            T{end,"sbi"} = 0;
            T{end,"ticks"} = results.ticks;
            T{end,"pareto_front_vals"} = {results.pareto_front_vals};
            temp_vals = zeros(10,2);
            for ii=1:10
                temp_vals(ii,:) = max(T{end,"pareto_front_vals"}{ii}{end});
            end
            T{end,"max_vals"} = max(temp_vals);
        end
        try load("results_analyzed/"+name+"/"+file+"_SBI.mat")
            T{end+1,"name"} = {name};
            T{end,"sbi"} = 1;
            T{end,"ticks"} = results.ticks;
            T{end,"pareto_front_vals"} = {results.pareto_front_vals};
            temp_vals = zeros(10,2);
            for ii=1:10
                temp_vals(ii,:) = max(T{end,"pareto_front_vals"}{ii}{end});
            end
            T{end,"max_vals"} = max(temp_vals);
        end
    end
    
    max_vals = max(T{:,"max_vals"});
    for i=1:height(T)
        hypervol_vals = zeros(10,38);
        for ii=1:10
            for iii=1:38
                temp_vals = T{i,"pareto_front_vals"}{ii}{iii};
                if min(size(temp_vals)) == 1
                    hypervol_vals(ii,iii) = prod(max_vals-temp_vals);
                else
                    hypervol_vals(ii,iii) = calc_HV(temp_vals,max_vals);
                end
            end
        end
        T{i,"hypervol_vals"} = {hypervol_vals};
    end

    nr_points = 38;
    nr_reps = 10;
    alpha = 0.05;
    friedman_ranks = zeros(height(T),nr_points);
    wilcoxon_test_p = zeros(height(T),nr_points);
    wilcoxon_test_p_bonf_holm = zeros(height(T),nr_points);
    for i=1:nr_points
        temp_vals = zeros(nr_reps,height(T));
        for ii=1:height(T)
            temp_vals(:,ii) = T{ii,"hypervol_vals"}{:}(:,i);
        end
        [~,~,res] = friedman(-temp_vals,1,"off");
        friedman_ranks(:,i) = res.meanranks;
        [minval,minpos] = min(res.meanranks);
        idxs = 1:height(T);idxs(minpos) = [];
        for ii=1:height(T)
            if ii == minpos
                wilcoxon_test_p(ii,i) = NaN;
            else
                p = ranksum(temp_vals(:,ii),temp_vals(:,minpos));
                wilcoxon_test_p(ii,i) = p;
            end
        end
        wilcoxon_test_p_bonf_holm(idxs,i) = bonf_holm(wilcoxon_test_p(idxs,i),alpha);
        wilcoxon_test_p_bonf_holm(minpos,i) = NaN;
    end
    tied_or_best = (wilcoxon_test_p_bonf_holm>=alpha) + isnan(wilcoxon_test_p_bonf_holm);
    for i=1:height(T)
        T{i,"friedman_ranks"} = friedman_ranks(i,:);
        T{i,"wilcoxon_test_p_bonf_holm"} = wilcoxon_test_p_bonf_holm(i,:);
        T{i,"tied_or_best"} = tied_or_best(i,:);
    end
    eval("T"+cntr+" = T;");
end

%C = colororder("glow12");
nr_algs = 150;
C = [linspace(0,1,nr_algs)',linspace(1,0,nr_algs)',linspace(0.2,0.8,nr_algs)'];

for cntr = 1:4
eval("T = T"+cntr);
figure
hold on;
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
ticks_num = 1:38;
cntr = 0;
starting_id = 10; %10 equiv to 1e3 evals
used_ticks = ticks_num(starting_id:end);
used_names = {};
for i=1:height(T)
    if T{i,"sbi"}
        name = T{i,"name"}{:} + "-SBI";
        linestyle = "-";
    else
        name = T{i,"name"}{:};
        linestyle = "--";
    end
    temp_vals = T{i,"tied_or_best"}(starting_id:end);
    if sum(temp_vals) > 1
        cntr = cntr + 1;
        used_names{cntr} = name;
        idxs_found = find(temp_vals > 0);
        plot(used_ticks(idxs_found),cntr*ones(1,length(idxs_found)),'-x','DisplayName',name,...
            'MarkerSize',12,'LineWidth',3,'Color',C(i,:));
    end
end
ax = gca;
ax.XTick = ticks_num(starting_id:end);
ax.XTickLabels = ticks_str(starting_id:end);
ax.YTickLabels = used_names;
ax.YTick = 1:cntr;
axis([used_ticks(1)-0.5,used_ticks(end)+0.5,0.5,cntr+0.5])
grid on;

end