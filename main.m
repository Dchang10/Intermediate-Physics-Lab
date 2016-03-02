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
ddS = 0.005; % twice the width of the dot in m;
dT = 0; % uncertainty in the fitted period. Due to many-point fitting, taken to be essentially 0;
dL = 0.050; % uncertainty in distance between the mirror and the screen, m
%% processing
if exist([fileName '.mat'])
    load([fileName '.mat']);
else
     [t, l_x] = videoanalysis(fileName, Ext, l_max, l_min);
end
%{
close all; clf; 
plot(t, l_x, 'r.');
xlabel('time, s'); 
ylabel('position on the screen, cm');
legend('\DeltaS(t)');
%}

%% Extracting fitting parameters:
[t1, fit1, xshift1, T1, amp1, lambda1, phi1] = findFit(t, l_x, t1_start, t1_finish);
[t2, fit2, xshift2, T2, amp2, lambda2, phi2] = findFit(t, l_x, t2_start, t2_finish);
dS = abs(xshift1-xshift2)/100;
T = mean([T1 T2]);

%% Plotting

close all; clf; 
plot(t, l_x, 'r.', t1, fit1, 'b', t2, fit2, 'k');
xlabel('time, s'); 
ylabel('position on the screen, cm');
l = legend('Dot position x(t)', 'Fitting 1', 'Fitting 2');
l.FontSize = 12;

%% Value Computation
[G, g, G_error] = findG(dS, ddS, T, dT, L, dL);
clc; fprintf('Experimental gravitational constant is G = %e m^3 kg^(-1) s^(-2); \nIt is %3.2f %% different from the real value. \n', G, g);
fprintf('Fractional uncertainty of experimental value is %0.3f. \n', G_error);

save('parameters.mat', 'T', 'G', 'g', 'G_error');
