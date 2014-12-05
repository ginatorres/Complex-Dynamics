clear all
%Implementación Doble Integrador
A=[0 -21.3;0 0];
B=[0;-21.3];
C=[1 0];
re=-9;
im=20;
pa=-9;
Cs=eye(size(A,2));%for the simulink block
D=0;
Ds=zeros(size(A,2),1);%for the simulation
polos=[re+im*i pa];
h=0.05;
addpath ../; %Entra al path donde estan las funciones gacker,dl2extended
[k,tau,p]=gacker(A,B,h,exp(polos*h));
tauc=double(tau(2))
k=real(k(2,:));
K=double(k)
tauf=0.03;
[pha,gma]=dl2extended(A,B,C,tauf,h,1);
Ka=place(double(pha),double(gma),exp([re+im*i re-im*i pa]*h));
rmpath ../; %se sale del path
[Ad,Bd]=c2d(A,B,h);
eig(Ad-Bd*K)
log(eig(Ad-Bd*K))/h % polos discretos a continuos
sim('Comparativa_dinamica_ampliado_complejo_di_puro');
figure
plot(estado1(:,1),estado1(:,2),'r');
hold on
plot(estado1(:,1),estado1(:,3),'b');
