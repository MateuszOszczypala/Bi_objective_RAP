%% Ergodic probabilities of CTMC

function Ergodic = Ergodic_prob(L)

    % L CTMC matrix
    L_tr = L.'; % Transpose
    L_tr(1,1:size(L,1)) = 1;
    
    P = zeros(size(L,1),1);
    P(1,1) = 1;
    
    Ergodic = (L_tr^(-1))*P;
end