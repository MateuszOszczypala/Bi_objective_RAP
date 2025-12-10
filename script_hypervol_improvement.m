%SCRIPT FOR COMPUTING HYPERVOLUME IMPROVEMENT 
clear;clc;close all;
 
for i=1:6
    for ii=1:4
        eval("load results_aggregated/T"+i+"_"+ii+".mat;");
    end
end
figure
tiledlayout(1,1,"Padding","tight"); nexttile;
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
%xvals = 1:38;
xvals = [(1:9)*1e2,(1:9)*1e3,(1:9)*1e4,(1:9)*1e5,1e6,2e6];


hold on;
plot(xvals(starting_id:end),sbi_max_vals(starting_id:end),'LineWidth',2,'LineStyle','--');
plot(xvals(starting_id:end),sbi_mean_vals(starting_id:end),'LineWidth',2);
plot(xvals(starting_id:end),nonsbi_max_vals(starting_id:end),'LineWidth',2,'LineStyle','--');
plot(xvals(starting_id:end),nonsbi_mean_vals(starting_id:end),'LineWidth',2);
grid on;
ax = gca;
legend({"Virtual best with sbi", "Average with sbi", "Virtual best without sbi", "Average without sbi"},...
    location="northwest",fontsize=14)
ax.XTick = xvals(starting_id:end);
ax.XTickLabels = ticks_str(starting_id:end);
xlabel("Evaluations",fontsize=14);
ylabel("Relative distance to best-found HV",fontsize=14)
set(gca,'Ydir','reverse')
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlim([1e3,2e6])
ax.XTickLabelRotation =60;

%figure
% tiledlayout(1,1, 'Padding', 'none');
% nexttile;
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
starting_id = 10; %10 equiv to 1e3 evals

[~,ids] = sort(all_vals(:,end),'descend');
names = {};
for i=1:height(T_all)
    names{i} = T_all{i,1}{:};
    if T_all{i,2}
        names{i} = strcat(names{i},'-SBI');
    end
end

% h = heatmap(1-all_vals(ids,starting_id:end));
% h.YData = names(ids);
% h.XData = ticks_str(starting_id:end);
% temp_colormap = h.Colormap;
% h.Colormap = parula;
% h.Colormap = flipud(h.Colormap);
% h.ColorScaling = "log";
%h.CellLabelFormat = '%0.0e';
%h.FontSize = 4;
%h.InnerPosition = [0.065    0.025   0.88   0.965];

figure
tiledlayout(1,1,"Padding","tight"); nexttile;
h = heatmap(1-all_vals(ids_nonsbi,starting_id:end));
h.YData = names(ids_nonsbi);
h.XData = ticks_str(starting_id:end);
temp_colormap = h.Colormap;
h.Colormap = parula;
h.Colormap = flipud(h.Colormap);
h.ColorScaling = "log";
h.CellLabelFormat = '%0.0e';
%h.FontSize = 5;
%h.InnerPosition = [0.065    0.025   0.88   0.965];

figure
tiledlayout(1,1,"Padding","tight"); nexttile;
h = heatmap(1-all_vals(ids_sbi,starting_id:end));
h.YData = names(ids_sbi);
h.XData = ticks_str(starting_id:end);
temp_colormap = h.Colormap;
h.Colormap = parula;
h.Colormap = flipud(h.Colormap);
h.ColorScaling = "log";
h.CellLabelFormat = '%0.0e';

positions = 0*all_vals;
for i=1:38
    [~,ids] = sort(all_vals(:,i),'descend');
    positions(ids,i) = 1:height(T_all);
end

starting_id = 10;
alg_ids = [94,34,80,52,88,30,110,54,28,42,40,26,96,100,10,56,78,122];

figure
xvals = 1:38;
tiledlayout(1,1,"Padding","tight"); nexttile;
hold on; it = 1;
for i=alg_ids
    algname = T{i,"name"}{1};
    if T{i,"sbi"}
        algname = algname + "-SBI";
    end
    if it <= 7
        linestyle = "-";
    elseif it <= 14
        linestyle = "--";
    else
        linestyle = ":";
    end
    plot(xvals(starting_id:end),positions(i,starting_id:end),...
        'LineWidth',2,LineStyle=linestyle,Marker='.',MarkerSize=12,...
        DisplayName=algname);
    it = it + 1;
end
legend(location="eastoutside",fontsize=14);
grid on;
ax = gca;
ax.XTick = xvals(starting_id:end);
ax.XTickLabels = ticks_str(starting_id:end);
set(gca,'Ydir','reverse')
xlabel("Evaluations",fontsize=14);
ylabel("Method rank",fontsize=14);
axis([10,38,1,8])