function Offspring = Crossover_one_point(Par, pop_size, m)
% One ponit crossover with tournament selection    
  
   Offspring(1:m,1:8,1:(pop_size/2)) = NaN;
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

            point = round(9*rand(1));              
            Offspring(1:m,1:point,i) = Par(1:m,1:point,parent1);
            Offspring(1:m,point+1:10,i) = Par(1:m,point+1:10,parent2);
        end
    end
end