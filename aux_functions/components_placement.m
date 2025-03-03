function standby_components = components_placement(m, decoded_chromosomes, available_weight, unit_weight)
    priority = zeros(1, m);  
    for i = 1:m
        priority(i) = (decoded_chromosomes(i)/255);
        max_comp(i) = floor(available_weight/unit_weight(i));
    end
    standby_components = floor(max_comp.*priority);
    while sum(standby_components.*unit_weight) > available_weight
        for i = 1:m
            if priority(i) == min(priority) && standby_components(i)>0
                standby_components(i) = standby_components(i) - 1;
                priority(i) = priority(i)*2;
            end
            if standby_components(i) == 0
                priority(i) = inf;
            end
        end
    end
end
