%%Script para encontrar Q y R mediante fminsearch desde la solucion de la
%%ecuacion de Riccati partiende de una Kcompleja óptima
clc;
clear all;
close all;
global phi
global gamma
global Kcomplex
%global R
%Sistema Doble Integrador
A=[0 1;0 0];
B=[0;1];
h=1;
n=size(A,2)
[phi,gamma]=c2d(A,B,h);
%Parámetros para encontrar Kcompleja óptima
Qi=[3 0;0 3];Ri=1+i
k=20
P=diag([2,2]);
%Manual DLQR
while k>=1
K(k,:)=inv(Ri+gamma'*P*gamma)*gamma'*P*phi;
P=(phi-gamma*K(k,:))'*P*(phi-gamma*K(k,:))+Qi+K(k,:)'*Ri*K(k,:); %equivalente a la matriz P
k=k-1;
end
%%Kcomplex=dlqr(phi,gamma,Qi,Ri)%Not for complex

% Tomamos el primer valor de K
Kcomplex=K(1,:)

%Fminsearch para encontrar un Q y un R dado una Kcompleja, la cual es
%óptima.
options = optimset('MaxFunEvals',10^9,'TolFun',10^-12,'MaxIter',10^9);
[XOUT,FVAL,EXITFLAG]=fminsearch(@obj2,[20   0    0    3   1 1],options)
