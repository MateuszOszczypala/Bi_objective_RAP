% SCRIPT FOR THE HEATMAP OF RANKS
clear;clc;close all;

for i=1:6
    for ii=1:4
        eval("load results_aggregated/T"+i+"_"+ii+".mat;");
    end
end

T_all = T1_1(:,[1,2,9]);
T_all.Properties.VariableNames{3} = 'CS1_1_tied_or_best';
cntr = 0;
for i=1:6
    for ii=1:4
        cntr = cntr + 1;
        if i==1 && ii==1
            continue;
        end
        eval("T = T"+i+"_"+ii+";");
        t = height(T);
        for iii=1:t
            temp_name = T{iii,"name"}{:};
            temp_sbi = T{iii,"sbi"};
            id = find(T_all{:,1} == string(temp_name) & T_all{:,2} == temp_sbi);
            if isempty(id)
                T_all{end+1,"name"} = T{iii,"name"};
                T_all{end,"sbi"} = temp_sbi;
                T_all{end,2+cntr} = T{iii,9};
            else
                T_all{id,2+cntr} = T{iii,9};
            end
        end
        T_all.Properties.VariableNames{2+cntr} = char("CS"+i+"_"+ii+"_tied_or_best");
    end
end

for i=1:height(T_all)
    temp = zeros(1,38);
    for ii=1:24
        temp = temp + T_all{i,2+ii};
    end
    T_all{i,27} = temp;
end

figure
ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
starting_id = 2; %10 equiv to 1e3 evals

matrix = T_all{:,27}; matrix = matrix(:,starting_id:end);
matrix_row_sum = sum(matrix,2);
[~,ids] = sort(matrix_row_sum,'descend');
names = {};
for i=1:height(T_all)
    names{i} = T_all{i,1}{:};
    if T_all{i,2}
        names{i} = strcat(names{i},'-SBI');
    end
end

h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);

DE_based = {'CMODEFTR','MyODEMR','GDE3','NSBiDiCo','DSPCMDE'};
Indic_based = {'BCEIBEA','IBEA','TSTI','ICMA'};
Decom_based = {'BCEMOEAD','MOEADCMA','DEAGNG'};
Swarm_based = {'dMOPSO','MMOPSO','CMOPSO','NMPSO','MOPSOCD'};
Gen_based = {'NSGAII','NSGAIIARSBX','MFOSPEA2','SPEAR','SPEA2','gNSGAII','ToP','TSNSGAII','DCNSGAIII','ANSGAIII','NSGAIII'};
ML_adaptive = {'CAMOEA','AGEMOEAII','AGEMOEA','DRLOSEMCMO'};
Two_stage = {'MSCEA','CMOEAMSG','CMOEAMS','C3M','MSCMO'};
Multitask = {'CCMO','MTCMO','BiCo','SSCEA','CMEGL','IMTCMO','MCCMO'};
Other = {'NSLS','MaOEADDFC','MyOC','onebyoneEA','MOBCA','NNIA','CAEAD','EFRRR','RSEA','RMMEDA','PICEAg','PESAII'};
Reference = {'hpaEA','NRVMOEA','ARMOEA','RVEAiGNG','RVEAa','RVEA','CLIA','tDEACPBI','tDEA'};
sum(contains(T_all{:,1},Reference))

% temp = Gen_based;
% ids = contains(T_all{:,1},temp);
% h = heatmap(matrix(ids,:));
% h.YData = names(ids);
% h.XData = ticks_str(starting_id:end);
% h.ColorLimits = [0,24];
% h = heatmap(matrix(:,:));
% h.YData = names(:);
% h.XData = ticks_str(starting_id:end);
% h.ColorLimits = [0,24];

tiledlayout(38,15,"TileSpacing","none","Padding","compact")
nexttile([6,2])
text(-0.2,0.5,'DE-based','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([6,13]);
temp = DE_based;
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24];
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([5,2])
text(-0.2,0.5,'Indicator-based','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([5,13]);
temp = Indic_based; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([8,2])
text(-0.2,0.5,'Multitask','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([8,13]);
temp = Multitask; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([7,2])
text(-0.2,0.5,'Swarm-based','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([7,13]);
temp = Swarm_based; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([12,2])
text(-0.2,0.5,'GA-based','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([12,13]);
temp = Gen_based;
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24];
h.ColorbarVisible = 'off';
xlabel("Evaluations")


figure
tiledlayout(39,15,"TileSpacing","none","Padding","compact")
nexttile([5,2])
text(-0.2,0.5,'ML-adaptive','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([5,13]);
temp = ML_adaptive;
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
%title('ML-adaptive');
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([7,2])
text(-0.2,0.5,'Two-stage','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([7,13]);
temp = Two_stage; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
%title('Two-stage');
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([4,2])
text(-0.2,0.5,'Decom-based','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([4,13]);
temp = Decom_based; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
%title('Decom-based');
h.ColorbarVisible = 'off';
s=struct(h);s.XAxis.Visible='off';

nexttile([10,2])
text(-0.2,0.5,'Reference','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([10,13]);
temp = Reference;
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
h.ColorbarVisible = 'off';

s=struct(h);s.XAxis.Visible='off';

nexttile([13,2])
text(-0.2,0.5,'Other','Rotation',90,'HorizontalAlignment','center',FontSize=13);
axis off;
nexttile([13,13]);
temp = Other; 
ids = contains(T_all{:,1},temp);
h = heatmap(matrix(ids,:));
h.YData = names(ids);
h.XData = ticks_str(starting_id:end);
h.ColorLimits = [0,24]; 
%title('Other');
h.ColorbarVisible = 'off';
xlabel("Evaluations")