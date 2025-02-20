function [Front_sorted, Ranking] = Crowding_distance(Sorted_individuals, Objective_values, Front_size, m)
 
   % Sorted_list - sorted by number of Pareto front chromosomes of sorting Pareto front
   % Objective_values = [A_s, C] - [availability, cost] of sorting Pareto front
   % Front_size - number of individuals in sorted Pareto front

    Objective_values_sorted = sortrows(Objective_values);
    Crow_dist = NaN;
    Crow_dist(1,1) = inf;
    for i = 2:(Front_size-1)
        Crow_dist(i,1) = abs((Objective_values_sorted(i+1,1))-(Objective_values_sorted(i-1,1)))/(max(Objective_values_sorted(:,1))-min(Objective_values_sorted(:,1)))+...
            abs((Objective_values_sorted(i-1,2))-(Objective_values_sorted(i+1,2)))/(max(Objective_values_sorted(:,2))-min(Objective_values_sorted(:,2)));
    end
    Crow_dist(Front_size,1) = inf;

    Ranking = [Objective_values_sorted, Crow_dist];
    Ranking = sortrows(Ranking, 3, "descend");
    Front_sorted = zeros(m,10,Front_size);
    for i = 1:Front_size
        for j = 1:Front_size
            if Ranking(i,1) == Objective_values(j,1) && Ranking(i,2) == Objective_values(j,2)
                Front_sorted(1:m,1:10,i) = Sorted_individuals(1:m,1:10,j);                
            end
        end
    end
end