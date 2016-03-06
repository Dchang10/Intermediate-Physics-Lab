%% general inputs:
clear all; clf; close all; clc;
fileName = 'cav';
Ext = 'mp4';
t1_start = 30; % start time for 1st equillibrium, sec
t1_finish = 2820; % end time for 1st equillibrium, sec
t2_start = 2850; % start time for 2nd equillibrium, sec
t2_finish = 5530; % end time for 2nd equillibrium, sec
L = 2.185; % distance from the mirror to the screen
l_max = 62.8; % rightmost position of the point during the experiment, cm
l_min = 48.7; % leftmost position of the point during the experiment, cm

%% incertainty inputs:
dL = 0.050; % uncertainty in distance between the mirror and the screen, m
%% processing
if exist([fileName '.mat'])
load([fileName '.mat']);
else
[t, l_x] = videoanalysis(fileName, Ext, l_max, l_min);
end

%% Extracting fitting parameters:
[t1, x1, fit1, vshift1, dvshift1, w1, dw1, amp1, lambda1, phi1] = findFit(t, l_x, t1_start, t1_finish);
[t2, x2, fit2, vshift2, dvshift2, w2, dw2, amp2, lambda2, phi2] = findFit(t, l_x, t2_start, t2_finish);
dS = abs(vshift1-vshift2)/100;
w = mean([w1, w2]);
T = 2*pi/w;

%% Plotting
% Checks if the plots already exist in the folder. No - computes saves 3
% plots.
if ~exist('fullData.png')
set(0, 'DefaultAxesFontSize', 16);
clf; close all;
fig1 = figure('Units', 'inches', 'OuterPosition', [2, 2, 4, 3]);
plot(t, l_x, 'r:', t1, fit1, 'b', t2, fit2, 'k');
xlabel('time, s');
ylabel('position on the screen, cm');
l = legend('Measured x(t)', 'Fitting 1', 'Fitting 2');
l.FontSize = 16;
saveas(fig1, 'fullData.png');

clf; close all;
fig2 = figure('Units', 'inches', 'OuterPosition', [2, 2, 4, 3]);
plot(t1, x1, 'r:', t1, fit1, 'b');
xlabel('time, s');
ylabel('position on the screen, cm');
l = legend('Measured x_1(t)', 'Fitting 1');
l.FontSize = 16;
saveas(fig2, 'data1.png');

clf; close all;
fig3 = figure('Units', 'inches', 'OuterPosition', [2, 2, 4, 3]);
plot(t2, x2, 'r:', t2, fit2, 'k');
xlabel('time, s');
ylabel('position on the screen, cm');
l = legend('Measured x_2(t)', 'Fitting 2');
l.FontSize = 16;
saveas(fig3, 'data2.png');
end


%% Value Computation
ddS = dvshift1+dvshift2;
dw = max([dw1, dw2]);
[G, g, G_error] = findG(dS, ddS, w, dw, L, dL);
clc; fprintf('Experimental gravitational constant is G = %e m^3 kg^(-1) s^(-2); \nIt is %3.2f %% different from the real value. \n', G, g);
fprintf('Fractional uncertainty of experimental value is %0.3f. \n', G_error);

save('parameters.mat');
