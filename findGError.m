function [G_error] = findGError(d, dd, r, dr, b, db, ddS, dM, T, dT, dL)

dB = 2*dd*d+5*dr*r;

dA = sqrt(((2*db*b+4*2*dd*d)*(b^2+4*d^2)^(1/2))^2 + (3*db*b^2)^2) * b^3/(b^2 + 4*d^2)^(3/2);

G_error = sqrt( (2*db*b)^2 + ddS^2 + dM^2 + dd^2 + (2*dT*T)^2 + dL^2 + dB^2 + dA^2 );

return;