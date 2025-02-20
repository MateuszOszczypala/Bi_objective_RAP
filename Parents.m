function [Par, A_C_D_F] = Parents(Sorted_individuals, Domination_Pareto, Objective_values, pop_size, m)
   % Count the number of individuals in each front

   % Par - parents for new generation
   % Sorted_individuals - sorted by number of Pareto front chromosomes of all population
   % Domination_Pareto - Number of Pareto front
   % Objective_values = [A_s, C] - [availability, cost]
   % pop_size - population size
   % m - number of subsystems
    
    edge = 0;
    F = 1;
    for j = 1:pop_size
        if  j == pop_size || Domination_Pareto(j) < Domination_Pareto(j+1)          
            [Front_sorted, Ranking] = Crowding_distance(Sorted_individuals(1:m,1:10,edge+1:j), Objective_values(edge+1:j,1:2), j-edge, m);            
            Chromosomes(1:m,1:10,edge+1:j) = Front_sorted; % Sorted individuals
            Front_num(1:j-edge,1) = F;
            A_C_D_F(edge+1:j,1:4) = [Ranking, Front_num]; % Availability, cost, distance, front
            F = F+1;
            edge = j;
            clear Front_num;
        end
    end
    Par = Chromosomes(1:m,1:10,1:(pop_size/2));
end