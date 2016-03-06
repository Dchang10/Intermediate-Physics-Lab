% findG computes experimental Gravitational constant (G), Error (Gerror)
% with respect to the "true" value, and Uncertainty. The first part of the
% function defines parameters specified by the manufacturer (found in the
% manual). prefix "d" indicates the uncertainty in the parameter (also
% specified by the manufacturer.
function [G, G_prop, G_error] = findG(dS, ddS, w, dw, L, dL)
%% Device parameters:
b = 46.5*10^(-3);
db = 0;
d = 50*10^(-3);
dd = 0;
r = 9.55*10^(-3);
dr = 0;
M = 1.5;
dM = 0.010;

%% main
% Computes the return
Ge = pi^2*b^2*dS*(d^2+(5/2)*r^2)/(M*d*(2*pi/w)^2*L);
correction = 1 - b^3/(b^2+4*d^2)^(3/2);
G_real = 6.67408*10^(-11); % "true" value of G

G = Ge/correction;
G_prop = 100*abs(G-G_real)/G_real;
G_error = findGError(d, dd, r, dr, b, db, ddS, dM, w, dw, dL);
return;