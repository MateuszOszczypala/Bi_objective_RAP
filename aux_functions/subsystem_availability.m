function Subsystem_availabilities = subsystem_availability(n, k, Ergodic_prob, redundancy_strategy)
    
    if redundancy_strategy == 0 % cold standby
        Subsystem_availabilities = sum(Ergodic_prob(1:n-k+1));
    
    elseif redundancy_strategy == 1 % warm standby
        Subsystem_availabilities = sum(Ergodic_prob(1:n-k+1));

     elseif redundancy_strategy == 2 % mixed standby
         Subsystem_availabilities = sum(Ergodic_prob(1:2*n-2*k+1));
    
    elseif redundancy_strategy == 3 % hot standby 
        Subsystem_availabilities = sum(Ergodic_prob(1:n-k+1));  
           
    end
end
