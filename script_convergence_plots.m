clear;clc;clf;

%CS = 1; weights = [60,80,100,120];
%CS = 2; weights = [60,80,100,120]; 
%CS = 3; weights = [60,80,100,120];
%CS = 4; weights = [100,120,140,160];
%CS = 5; weights = [50,60,70,80];
%CS = 6; weights = [80,100,120,140]; 

%CS = 1; Weight = 120;
%CS = 2; Weight = 120;
%CS = 3; Weight = 120;
%CS = 4; Weight = 160;
%CS = 5; Weight = 80;
CS = 6; Weight = 140;


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


%sel_names = ["NSGAII","NNIA","CMOPSO","CMODEFTR","NSGAIIARSBX","EMyOC","AGEMOEA","C3M","CMOEAMS","EFRRR","MOPSOCD"];
%sel_names = ["NSGAII","NNIA","CMOPSO","CMODEFTR","NSGAIIARSBX","CMOEAMS","CAEAD","DSPCMDE","MOPSOCD"];
sel_names = ["NSGAII","NNIA","CMOPSO","CMODEFTR","NSGAIIARSBX","CMOEAMS","CAEAD","DSPCMDE","MOPSOCD","SPEAR","GDE3","IMTCMO","C3M","ICMA"];
%sel_names = Swarm_based

hold on;
%linewidth = 2;
it = 1;
for i=1:height(T)
    if ~sum(ismember(sel_names,T{i,"name"}{:}))
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
        linewidth = 1;
    else
        name = T{i,"name"}{:};
        linestyle = "--";
        linewidth = 1;
    end
    plot(T{i,"ticks"},mean(T{i,"hypervol_vals"}{:}),'HandleVisibility','off','LineStyle',linestyle,'LineWidth',linewidth,'Color',[0.8,0.8,0.8]);
    end
end

it = 1;
C = colororder;
for i=1:height(T)
    if sum(ismember(sel_names,T{i,"name"}{:}))
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
        if it < 8
            linestyle = "-";
        else
            linestyle = "-.";
        end
        %linestyle = "-";
        linewidth = 2;
        sel_color = C(mod(it-1,7)+1,:);
        it = it + 1;
    else
        name = T{i,"name"}{:};
        if it < 8
            linestyle = "--";
        else
            linestyle = ":";
        end
        linewidth = 2;
        sel_color = C(mod(it-1,7)+1,:);
    end
    plot(T{i,"ticks"},mean(T{i,"hypervol_vals"}{:}),'DisplayName',name,...
        'LineStyle',linestyle,'LineWidth',linewidth,'Color',sel_color );
    end
end

ax = gca;
ax.XScale = 'log';
grid on;
l = legend;
l.Location = 'eastoutside';
l.NumColumns = 1;
ax.XLim = [200 2000000];
xlabel("Evaluations","FontSize",14)
ylabel("Hypervolume","FontSize",14)
title("CS"+CS+", W = "+Weight,"FontSize",14);
f = gcf;
f.Position = [175         557        1214         681];
exportgraphics(f,"figures/convergece_CS"+CS+".png",'Resolution',400)
