A=[0 1;0 0];
B=[0;1];
C=[1 0];
Cs=eye(size(A,2));%for the simulink block
D=0;
Ds=zeros(size(A,2),1);%for the simulation
polos=[-5+80*i -2];
h=0.1;
addpath ../;
[k,tau,p]=gacker(A,B,h,polos);
tauc=double(tau(2));
k=real(k(2,:));
K=double(k)
tauf=0.06;
[pha,gma]=dl2extended(A,B,C,tauf,h,1)
Ka=place(double(pha),double(gma),exp([-5+80*i -5-80*i -2]*h))
rmpath ../;
[Ad,Bd]=c2d(A,B,h);
log(eig(Ad-Bd*K))/h