function [c, ceq] = confun(Qx)
% restricciones de desigualdades lineales o no lineales
%Caso 1 y Caso 2. R real y mayor que 0
c=[-Qx(1,5)];
%Caso 3.  R compleja y mayor que 0
%c = [-Qx(9)-Qx(10)*i];
% restricciones de igualdades lineales o no lineales
ceq = []; 