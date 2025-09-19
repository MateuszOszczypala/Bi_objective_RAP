clear;clc;close all;

for i=1:6
    for ii=1:4
        eval("load results_aggregated/T"+i+"_"+ii+".mat;");
    end
end
figure
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

max_vals = zeros(1,38);
mean_vals = zeros(1,38);
all_vals = zeros(height(T_all),38);
for i=1:24
    temp = T_all{:,2+i};
    max_vals = max_vals+max(temp);
    mean_vals = mean_vals+mean(temp);
    all_vals = all_vals+ temp;
end
max_vals = max_vals/24;
mean_vals = mean_vals/24;
all_vals = all_vals/24;

starting_id = 2;
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
xvals = 1:38;

hold on;
for i=1:height(T_all)
    plot(xvals(starting_id:end),max_vals(starting_id:end));
    plot(xvals(starting_id:end),mean_vals(starting_id:end));
end
grid on;
ax = gca;
ax.XTick = xvals(starting_id:end);
ax.XTickLabels = ticks_str(starting_id:end);

figure
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
starting_id = 2; %10 equiv to 1e3 evals

[~,ids] = sort(mean(all_vals,2),'descend');
names = {};
for i=1:height(T_all)
    names{i} = T_all{i,1}{:};
    if T_all{i,2}
        names{i} = strcat(names{i},'-SBI');
    end
end

h = heatmap(1-all_vals(ids,starting_id:end));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
temp_colormap = h.Colormap;
h.Colormap = parula;
h.Colormap = flipud(h.Colormap);
h.ColorScaling = "lin";
h.CellLabelFormat = '%0.0e';
h.FontSize = 4;
h.InnerPosition = [0.065    0.025   0.88   0.965];