function system_availability_values = system_availability_CS2(A) % series-parallel system with 5 subsystems
    % A - subsystems availability   
    system_availability_values = 1-(1-A(1)*A(2))*(1-(A(3)+A(4)-A(3)*A(4))*A(5));
end