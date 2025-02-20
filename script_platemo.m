clear;clc;%close all;
figure
w = warning ('off','all');

global archive_obj_vals archive_sols;

archive_obj_vals = [];
archive_sols = [];

N =200; % pop size
n_iter = 100; % number of iterations
nfes =n_iter*N; % number of function calls

hold on;
grid on; legend;
%NSGAIII
[r1_NSIII,r2_NSIII] = platemo('algorithm',@NSGAIII,'problem',@calcobj_RAP_CS1,'N',N,'maxFE',nfes);
p = plot(r2_NSIII(:,2),-r2_NSIII(:,1),'+','DisplayName','NSGAIII-rand'); drawnow;
[r1_NSIII_SBI,r2_NSIII_SBI] = platemo('algorithm',@NSGAIII,'problem',@calcobj_RAP_CS1_SBI,'N',N,'maxFE',nfes);
plot(r2_NSIII_SBI(:,2),-r2_NSIII_SBI(:,1),'o','Color',p.Color,'DisplayName','NSGAIII-SBI'); drawnow;