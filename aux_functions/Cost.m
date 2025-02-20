function [system_cost] = Cost(n, c_unit)
    system_cost = sum(n.*c_unit);
end