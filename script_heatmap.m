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

ticks_str = [(1:9)+"e2",(1:9)+"e3",(1:9)+"e4",(1:9)+"e5","1e6","2e6"];
starting_id = 10; %10 equiv to 1e3 evals

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