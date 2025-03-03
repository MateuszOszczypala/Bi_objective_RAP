function standby_components = components_placement(m, decoded_chromosomes, available_weight, unit_weight)
    for i = 1:m
        weight_placement(i) = (decoded_chromosomes(i)/255)*available_weight;
        a(i) = weight_placement(i)/unit_weight(i);
        standby_components(i) = floor(a(i));
    end
    
    if sum(standby_components.*unit_weight) < available_weight
        r = available_weight - sum(standby_components.*unit_weight);
        d = (a-standby_components);
        while r >= min(unit_weight)
            d_max = max(d);
            for i = 1:m
                if r >= unit_weight(i)
                    if d(i) == d_max
                       standby_components(i) = standby_components(i) + 1;
                       r = r - unit_weight(i);
                       d(i) = d(i)/m;
                    end
                else
                    d(i) = 0;
                end
            
            end
        end
    end
end
