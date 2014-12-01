function  [phiamp,gammaamp,Cc,Dd] = dl2extended(A,B,C,tau,h,d)
%1. Discretización
n=size(A,2);
[phi,gamma]=c2d(A,B,h);
%Modelo ampliado 
[A1 B1]=c2d(A,B,tau);
[A2 B2]=c2d(A,B,h-tau);
phi=A1*A2;
gamma0=B2;
gamma1=A2*B1;
tau=(d-1)*h+tau;
if d==1
%Modelo Anpliado Retrasos mas cortos que el periodo de muestreo
phiamp=[phi gamma1;zeros(1,size(A,2)) 0];
gammaamp=[gamma0;1];
Cc=[1 zeros(1,n)];
Dd=0;
else
%Modelo Ampliado Retraso Mayor que el periodo de muestreo tau>h 
%d=2 y mayor
phiamp=[phi gamma1 gamma0 zeros(n,d-2);zeros(d-1,n+1) eye(d-1,d-1);zeros(1,n) zeros(1,d)];
gammaamp=[zeros(n+(d-1),1);1];
Cc=[1 zeros(1,n+(d-1))];
Dd=0;
end
phiamp=vpa(phiamp);
gammaamp=vpa(gammaamp);






