function [G, G_prop, G_error] = findG(dS, ddS, T, dT, L, dL)
b = 46.5*10^(-3);
db = 0;
d = 50*10^(-3);
dd = 0;
r = 9.55*10^(-3);
dr = 0;
M = 1.5;
dM = 0.010;

Ge = pi^2*b^2*dS*(d^2+(5/2)*r^2)/(M*d*T^2*L);
correction = 1 - b^3/(b^2+4*d^2)^(3/2);
G_real = 6.67408*10^(-11);

G = Ge/correction;
G_prop = 100*abs(G-G_real)/G_real;
G_error = findGError(d, dd, r, dr, b, db, ddS, dM, T, dT, dL);
return;