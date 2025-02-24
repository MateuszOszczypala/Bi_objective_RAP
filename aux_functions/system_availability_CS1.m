function system_availability_value = system_availability_CS1(A) % series system of 5 subsystems
    % A_sub subsystems availability
    system_availability_value = prod(A);
end