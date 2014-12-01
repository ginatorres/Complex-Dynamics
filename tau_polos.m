clear all
close all
%%Planta del Doble Integrador
A=[0 1;0 0]
%A=rand(3)
B=[0;1]
%B=rand(3,1)
C=[1 0]
%C=rand(1,3)
D=[0]

n=size(A,2)
h=1
%Polos 
p1=-3+20*i
p2=0.5
p=[p1 p1' p2]
digits(4)
m=2
poles=zeros(1,n+1,m);
ks=zeros(1,n+1,m)
taux=zeros(1,m)
for m=1:4 %HASTA M=21 LOS POLOS SON ESTABLES MAS ALLÀ FUERA DEL CIRCULO UNITARIO OJO,
%polosf= [p1*m p1'*m p2*m]
polosf=[exp((p1)*h)*m, exp((p1')*h)*m, exp((p2)*h)*m];
poles(:,:,m)=polosf
[k,tau]=gacker(A,B,h,poles(:,:,m));
K=subs(k,tau); %El k3 puede considerarse 0!
ks(1,:,m)=K(2,:)
%pos=find(tau> 0)
%taux(1,m)=tau(pos,m)
taux(1,m)=tau(1)% REVISAR! TAU Y K IGUALES PARA TODOS POLOS!
end

%GRAFICAR

