function [t_list, x_list, fit_x, vshift, dvshift, w, dw, amp, lambda, phi] = findFit(t, l_x, t_start, t_finish)

ids = find(t>t_start & t<t_finish);
%%
t_list = 1:length(ids);
x_list = 1:length(ids);
for i = 1:length(ids)
t_list(i) = t(ids(i));
x_list(i) = l_x(ids(i));
end
%%
[x_max, time_max] = findpeaks(x_list, t_list, 'MinPeakProminence', 1);
period = 1:(length(time_max)-1);
for i =1:(length(time_max)-1)
period(i) = time_max(i+1) - time_max(i);
end


w_g = 2*pi/mean(period);
vshift_g = mean(x_list);
b_g = - log((x_max(1)-vshift_g)/(x_max(2)-vshift_g))/(time_max(1) - time_max(2));
amp_g = (x_max(1)-vshift_g)*exp(b_g*time_max(1));
phase_g = pi;

%%
g = [amp_g, b_g, phase_g, vshift_g, w_g];
myFitType = fittype('vshift + amp*exp(-b*t).*cos(w*t+phase)', 'independent', 't', 'dependent', 'pos');
ft = fit(t_list', x_list', myFitType, 'StartPoint', g, 'Lower', [0.8*amp_g, 0.8*b_g, -1*phase_g, 0.8*vshift_g, 0.8*w_g], 'Upper', [1.2*amp_g, 1.2*b_g, 1.5*phase_g, 1.2*vshift_g, 1.2*w_g]);

fit_x = 1:length(t_list);
for i = 1:length(t_list)
fit_x(i) = ft(t_list(i));
end

vshift = ft.vshift;
amp = ft.amp;
lambda = ft.b;
phi = ft.phase;
w = sqrt((ft.w)^2-lambda^2);

uncertainties = confint(ft);
dvshift = abs(diff(uncertainties(:,4)));
dw = abs(diff(uncertainties(:,5)));

return;