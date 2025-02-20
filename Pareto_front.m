function [sorted_individuals, domination_Pareto, objective_values] = Pareto_front(pop_size, A_s, C, X, m)

    % pop_size - population size
    % As - availability of system
    % C - cost of system
    % X - chromosomes
    % m - number of subsystems
    % Front1 - Pareto front F1
    % Sorted_individuals
    
    dominated = ones(1,pop_size);
    for i = 1:pop_size
        for j = 1:pop_size
            if A_s(j)>=A_s(i) && C(j)<C(i)
                dominated(i) = dominated(i)+1;
            elseif A_s(j)>A_s(i) && C(j)<=C(i)
                dominated(i) = dominated(i)+1;
            end
        end
    end    
    sorted_individuals = NaN(m,10,pop_size);
    domination_Pareto = NaN(pop_size,1);
    objective_values = NaN(pop_size,2);
    a = 1;
    for i = 1:pop_size
        if dominated(i) == 1            
            sorted_individuals(1:m,1:10,a) = X(1:m,1:10,i);
            domination_Pareto(a) = dominated(i);
            objective_values(a,1:2) = [A_s(i), C(i)];
            a = a+1;
        end
    end
    
    for j = 2:max(dominated)
        for i = 1:pop_size
            if dominated(i) == j
                sorted_individuals(1:m,1:10,a) = X(1:m,1:10,i);
                domination_Pareto(a) = dominated(i);
                objective_values(a,1:2) = [A_s(i), C(i)];
                a = a+1;
            end
        end
    end       
end