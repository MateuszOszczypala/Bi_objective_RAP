%SCRIPT FOR THE EXAMPLE HV PLOT
clear;clc;clf;

r_p = [0.2,100];

P_points = [0.3,50;
          0.5,70;
          0.6,80;
          0.7,85;
          0.9,95];
O_points = [0.35, 73;
    0.23,55;
    0.42,95;
    0.43,88;
    0.52,81;
    0.63,88;
    0.77,99;
    0.15,66;
    0.63,105];

hold on
plot(r_p(1),r_p(2),"kd",'MarkerFaceColor','k');
scatter(P_points(:,1),P_points(:,2),... 
    "MarkerFaceColor","r");
p = [0.2,100;
    0.2,50;
    0.3,50;
    0.3,70;
    0.5,70;
    0.5,80;
    0.6,80;
    0.6,85;
    0.7,85;
    0.7,95;
    0.9,95;
    0.9,100];
pgon = polyshape(p);

plot(pgon);
scatter(O_points(:,1),O_points(:,2));

a = area(pgon)
calc_HV([-P_points(:,1),P_points(:,2)],[-0.2,100])
legend({"Reference for HV","Pareto front points",...
    "Hypervolume","Dominated Points"},fontsize=15,...
    location = "southeast");
axis([0,1,40,113]);
xlabel("Availability",fontsize=15);
ylabel("Cost",fontsize=15);
title("Hypervolume = "+a,fontsize=15)
grid on;
f = gcf;
f.Position = [304   422   750   455];

exportgraphics(f,"HVplot.png",'Resolution',300)