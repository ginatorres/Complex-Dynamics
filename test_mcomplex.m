%Test function mcomplex.m, la cual nos permite encontrar el modelo complejo
%a partir del modelo ampliado.
%Doble integrator
A=[0 1;0 0]
B=[0;1]
C=[1 0];
D=[0];
%Paràmetros del sistema
tau=0.1438 % Delay
h=1 %Sampling time
d=1
%POLOS DESEADOS
u1=0.3-0.5i
u2=u1'
u3=0.4
polos=[u1 u2 u3]; 
%FUNCIÓN.
[SOLS2,EIGS]= mcomplex(A,B,tau,h,polos,d)



