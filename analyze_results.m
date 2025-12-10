clear;clc;clf;

%CS = 1; weights = [60,80,100,120];
%CS = 2; weights = [60,80,100,120]; 
%CS = 3; weights = [60,80,100,120];
%CS = 4; weights = [100,120,140,160];
%CS = 5; weights = [50,60,70,80];
%CS = 6; weights = [80,100,120,140]; 

%CS = 6; Weight = 120;
CS = 6; Weight = 80;

temp = dir("results_analyzed");
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

hold on;
linewidth = 2;
it = 1;
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
    if T{i,"sbi"}
        name = T{i,"name"}{:} + "-SBI";
        linestyle = "-";
        it = it + 1;
    else
        name = T{i,"name"}{:};
        linestyle = "--";
    end
    p(i) = plot(T{i,"ticks"},mean(T{i,"hypervol_vals"}{:}),'DisplayName',name,'LineStyle',linestyle,'LineWidth',linewidth);
end
ax = gca;
ax.XScale = 'log';
grid on;
l = legend(p);
l.Location = 'southeast';
l.NumColumns = 5;
ax.XLim = [200 2000000];