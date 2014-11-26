% Este script es una funciòn  que permite encontrar la matriz de lazo cerrado del modelo
% complejo a travès de la ecuaciòn de proyección, partiendo del modelo ampliado. 
% Los valores de retorno son las matrices de lazo cerrado del modelo complejo y sus valores propios. 
function [SOLS2,EIGS] = mcomplex(A,B,tau,h,polos,d)
global A;
global B;
global h;
global polos;

%1. Discretización
h=1;
n=size(A,2);
[phi,gamma]=c2d(A,B,h);
%Lo=-place(phi,gamma,p);
%Modelo ampliado 
[A1 B1]=c2d(A,B,tau);
[A2 B2]=c2d(A,B,h-tau);
phi=A1*A2;
gamma0=B2;
gamma1=A2*B1;

phiamp=[phi gamma1;zeros(1,size(A,2)) 0];
gammaamp=[gamma0;1];
Cc=[1 zeros(1,n)];
Dd=0;
%Ley de Control para el modelo ampliado
L=-acker(phiamp,gammaamp,polos);
K=[L(1:n) 0]
%Matriz de Lazo cerrado
phi_cl=phiamp+gammaamp*K;
%Valores y Vectores Propios
[M,E]=eig(phi_cl); 
%Complex Model
I=eye(n);
Z=zeros(n,d);
%Matriz  de seleccion
S=[I Z];
%Matriz de rotación
P=[zeros(1,d+1) eye(1);eye(d+1) zeros(d+1,1)];
%Combinación sin Repetición
nsol=(factorial(n+d))/(factorial(n)*factorial(d))
SOLS2=zeros(n,n,nsol);
EIGS=zeros(n,1,nsol);
for k=1:nsol
Sols2=S*M*E*P^k*S'*(S*M*P^k*S')^(-1);
vps=eig(Sols2);
SOLS2(:,:,k)=Sols2;
EIGS(:,:,k)=vps;
end
