function Offspring_mutated = Mutation(Offspring)

    prob_mut = 0.10; % probability of mutation
    for i = 1:size(Offspring,3)        
            for j = 1:size(Offspring,2)
                   for l = 1:size(Offspring,1)                          
                            if rand(1) <= prob_mut
                                Offspring_mutated(l,j,i) = abs(Offspring(l,j,i)-1);
                            else
                                Offspring_mutated(l,j,i) = Offspring(l,j,i);
                            end                       
                    end             
            end        
    end
end