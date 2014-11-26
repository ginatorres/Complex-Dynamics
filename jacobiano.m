%Procedimiento realizado para conocer si haciendo que K_n+1=0 no es posible
%encontrar soluci�n, a trav�s del Jacobiano.
%Septiembre 2/14. Habr�a que revisar y generalizar que pasa cuando no solo
%el Kn+1 es cero sino cuando otros valores lo son. 
%Octubre 2/14 Evualuado lo anterior para el caso del doble integrador, hay soluci�n
%solo para cuando K2=0 pero no para K1=0 pues K1 no depende de tau. Pero el
%valor de tau obtenido con gacker es distinto del obtenido cuando el K3 es
%0.

close all
clear all
syms  tau 
digits(4)
% %Planta del Doble Integrador
A=[0 1;0 0]
% A=rand(3)
B=[0;1]
% B=rand(3,1)
C=[1 0]
% C=rand(1,3)
D=[0]
%Triple Integrador
% A=[0 1 0;0 0 1;0 0 0];
% B=[0;0;1];
% C=[1 0 0 ];
% D=[0];
%Discretizaci�n
h=1
n=size(A,2)
[phi,gamma]=c2d(A,B,h)
%Lo=-place(phi,gamma,p);

%Modelo ampliado 
[A1 B1]=c2d(A,B,tau)
[A2 B2]=c2d(A,B,h-tau)
phiamp=[A1*A2 A2*B1;zeros(1,size(A,2)) 0];
gammaamp=[B2;1];
Cc=[1 zeros(1,n)];
Dd=0;
%Construyendo la K dependiendo de la dimensi�n de la variable
na=size(phiamp,2)
K=[]
for i=1:na
dat_txt{i} = ['K' num2str(i)]
end
ks=sym(dat_txt)
K=[ks(1:n),0]
%K=[ks]*[0 0 0;0 1 0;0 0 1] %Para cambiar la K que vale 0
phi_cl=phiamp+gammaamp*K
%1. Polinomio caracter�stico
%pol=poly(phi_cl)% No funciona para simb�lico
syms x 
I=eye(na)
pol=(x*I-phi_cl)
dpol=vpa(det(pol))
c=simplify(dpol,'Steps',30)%Polinomio caracter�stico
% 2. Sacar los coeficientes que dependen de K1,K2,TAU
[ux,t] = coeffs(c,x) %Coeficientes del polinomio caracter�stico
size(ux)
%Kk=[K(1) K(3)]%Para recortar la K dependiendo de cual elemento haya sido 0
%3. Jacobiano
J=jacobian(ux(2:na+1),[K(1:n),tau])
%J=jacobian(ux(2:na+1),[Kk,tau])
%4. Difeomorfismo 
difeo=simplify(vpa(det(J)))
%*En el caso del ejemplo cuando K2=0 no hay soluci�n para tau, es decir no
%es posible encontrar tau si [K2,K3]=[0,0]. En conclusi�n es un difeomorfismo para todos
%los valores de K1,K2,K3, excepto para cuando K2=0 

%*En el caso rand(2) para A,B,C, es un difeomorfimo global, hay soluciones
%infinitas pues la matriz jacobiano no tiene determinante 0, y depende de todas las variables. 
