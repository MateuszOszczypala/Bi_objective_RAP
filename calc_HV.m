function [hv] = calc_HV(sols,reference)
% sols includes the objective values of the pareto solutions
    B = sortrows(sols,'ascend');
    rv_f1 = reference(1);
    rv_f2 = reference(2);
    hv = 0;
    for i=1:length(sols)
        if B(i,2) > rv_f2
            continue
        else
            hv = hv + (rv_f2-B(i,2))*(rv_f1-B(i,1));
            rv_f2 = B(i,2);
        end
    end
end

