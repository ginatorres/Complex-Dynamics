%Script que prueba la función gacker la cual nos permite encontrar el k y
%tau dados ciertos parámetros de nuestro modelo, donde se ha hecho el controlador K=[k1 k2 0] en el modelo ampliado, esto para tau<h.
clear all
%Prueba gacker para un doble integrador.
global A
global B
global h
global polos
%Planta del Doble Integrador
A=[0 1;0 0]
%A=rand(3)
B=[0;1]
%B=rand(3,1)
C=[1 0]
%C=rand(1,3)
D=[0]
%Periodo de Muestreo
h=1
n=size(A,2)
digits(4)
%Polos deseados
 r1a=0.4
 r2a=0.3
 i2a=0.5
 
 u1=r2a-i2a*i;
 u2=r2a+i2a*i;
 u3=r1a;
 u4=-r1a
   
polos=[u1 u2 u3]; 
[k,tau]=gacker(A,B,h,polos)
tau=tau(find(tau > 0)) %Encontrar el valor positivo 

%Controlador
K=subs(k,tau) %El k3 puede considerarse 0!


%% Probar este controlador con el del modelo complejo
%******Modelo Complejo****%
d=1
I=eye(n);
Z=zeros(n,d);
S=[I Z]; %Matriz  de selección
P=[zeros(1,d+1) eye(1);eye(d+1) zeros(d+1,1)]
%Modelo Ampliado
[A1 B1]=c2d(A,B,tau)
[A2 B2]=c2d(A,B,h-tau)
phi=A1*A2
gamma0=B2
gamma1=A2*B1
phiamp=[phi gamma1;zeros(1,size(A,2)) 0];
gammaamp=[gamma0;1];
Cc=[1 zeros(1,n)];
Dd=0;
%Matriz de Lazo cerrado
phi_cl=phiamp-gammaamp*K
[M,E]=eig(phi_cl)

%Combinación sin Repetición
k=(factorial(n+d))/(factorial(n)*factorial(d))
%MATRIZ DEL NUEVO MODELO
Solucion_simplificada2=S*M*E*P^k*S'*(S*M*P^k*S')^(-1);
%*******************************%

