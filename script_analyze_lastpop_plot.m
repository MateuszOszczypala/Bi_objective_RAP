%SCRIPT FOR ANALYSIS OF THE LAST POPULATION OF THE ALGORITHMS
clear;clc;clf;

%CS = 1; weights = [60,80,100,120];
%CS = 2; weights = [60,80,100,120]; 
%CS = 3; weights = [60,80,100,120];
%CS = 4; weights = [100,120,140,160];
%CS = 5; weights = [50,60,70,80]; 
%CS = 6; weights = [80,100,120,140];

%CS = 1; W = 120; load("results_aggregated\T1_4.mat"); T_temp = T1_4;
%CS = 2; W = 120; load("results_aggregated\T2_4.mat"); T_temp = T2_4;
%CS = 3; W = 120; load("results_aggregated\T3_4.mat"); T_temp = T3_4;
%CS = 4; W = 160; load("results_aggregated\T4_4.mat"); T_temp = T4_4;
%CS = 5; W = 80; load("results_aggregated\T5_4.mat"); T_temp = T5_4;
CS = 6; W = 140; load("results_aggregated\T6_4.mat"); T_temp = T6_4;
maxvals = max(T_temp{:,"max_vals"});

load("results_aggregated\data_CS_"+CS+"_W_"+W+"_lastpops.mat");
%f = figure;f.Position = [100,18,560,420];
hold on
plot(obj1,obj2,'x','Color',[0.7,0.7,0.7],'DisplayName','all solutions')
grid on
plot(-maxvals(1),maxvals(2),'kd','DisplayName',"Reference for HV");

%plot(obj1(ndf_index),obj2(ndf_index),'rx')

x_nondom = x(ndf_index,:);
x_nondom_subsys = x_nondom(:,D+1:end);
unique(x_nondom_subsys,'rows')
x_subsys = x(:,D+1:end);

T(1,:) = [sum(sum(x_subsys == 0))/prod(size(x_subsys)),sum(sum(x_subsys == 1))/prod(size(x_subsys)),...
    sum(sum(x_subsys == 2))/prod(size(x_subsys)),sum(sum(x_subsys == 3))/prod(size(x_subsys))];
T(2,:) = [sum(sum(x_nondom_subsys == 0))/prod(size(x_nondom_subsys)),sum(sum(x_nondom_subsys == 1))/prod(size(x_nondom_subsys)),...
    sum(sum(x_nondom_subsys == 2))/prod(size(x_nondom_subsys)),sum(sum(x_nondom_subsys == 3))/prod(size(x_nondom_subsys))]

T'

temp = sum(x_nondom_subsys == 2,2)/D;
s0 = temp<0.2;
s1 = temp>=0.2& temp<0.4;
s2 = temp>=0.4&temp<0.6;
s3 = temp>=0.6&temp<0.8;
s4 = temp>=0.8;
obj1_n = obj1(ndf_index);
obj2_n = obj2(ndf_index);

k = 1;
plot(obj1_n(s0),obj2_n(s0),'x','DisplayName','mixed: <0.2')
plot(obj1_n(s1),obj2_n(s1),'o','DisplayName','mixed: 0.2-0.4')
plot(obj1_n(s2),obj2_n(s2),'+','DisplayName','mixed: 0.4-0.6')
plot(obj1_n(s3),obj2_n(s3),'d','DisplayName','mixed: 0.6-0.8')
plot(obj1_n(s4),obj2_n(s4),'*','DisplayName','mixed: >0.8')
legend(Location="southoutside",FontSize=10,NumColumns=7);
a = calc_HV([-obj1_n,obj2_n],maxvals);
title("CS = "+CS+", W = "+W+", Front HV = "+a,FontSize=14);
xlabel('Availability',FontSize=14);
ylabel('Cost',FontSize=14);

f = gcf;
f.Position = [390 311 884 611];

%exportgraphics(f,"pareto_CS"+CS+".png",'Resolution',300)