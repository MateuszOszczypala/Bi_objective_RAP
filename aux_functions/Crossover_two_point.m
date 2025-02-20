function offspring = Crossover_two_point(parents, pop_size, m)
% One ponit crossover with tournament selection    
  
   offspring(1:m,1:10,1:(pop_size/2)) = NaN;
   selected_for_tournament = 4;

    for i = 1:(pop_size/2)
        for j = 1:(pop_size/2)
            q = randperm(pop_size/2, selected_for_tournament*2);
            r1 = sort(q(1:selected_for_tournament));
            r2 = sort(q(selected_for_tournament+1:selected_for_tournament*2));
            p1 = rand(1);
            p2 = rand(1);

            if p1 <= 0.4
                parent1 = r1(1);
            elseif p1 <= 0.7
                parent1 = r1(2);
            elseif p1 <= 0.9
                parent1 = r1(3);
            else
                parent1 = r1(4);
            end
            
            if p2 <= 0.4
                parent2 = r2(1);
            elseif p2 <= 0.7
                parent2 = r2(2);
            elseif p2 <= 0.9
                parent2 = r2(3);
            else
                parent2 = r2(4);
            end            

            point_1 = round(8*rand(1));
            point_2 = round((9 - point_1)*rand(1)) + point_1;    
            offspring(1:m,1:point_1,i) = parents(1:m,1:point_1,parent1);
            offspring(1:m,point_1+1:point_2,i) = parents(1:m,point_1+1:point_2,parent2);
            offspring(1:m,point_2+1:10,i) = parents(1:m,point_2+1:10,parent1);
        end
    end 
end