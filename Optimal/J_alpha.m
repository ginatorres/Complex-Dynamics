%Variación J y parte compleja de Q
clear all
A=[0 1;0 0];
B=[0;1];
C=[1 0];
tau=0.9;
h=1;
n=size(A,2);
Q=[1 -0.3;-0.3 1];
R=1;
%N=[1; 1]
[Kd,Sd,Ed]=lqrdg(A,B,Q,1,1);

xo=[1; 1];
J=xo'*Sd*xo;


Qx=zeros(n,n,10);
Jj=zeros(n,10);
m=0
for alpha=0:0.1:1
m=m+1;
qq=Q+[0 -alpha*i;alpha*i 0];
Qx(:,:,m)=qq;
[k,s,e,Qd,Nd,Rd]=lqrdg(A,B,qq,1,1);
Jx=xo'*s*xo;
Jj(:,m)=Jx;
end
%Gráfica
alpha=0:0.1:1;
plot(alpha,Jj)

