function system_availability_value = system_availability_CS4(A) % large system of 10 subsystems in series connection
    % A - subsystems availability
    system_availability_value = prod(A);
end