%Retardos_Costes
%Este script calcula el coste de control òptimo LQR para diferentes retardos
%RESULTADO:El coste es mayor a medida que aumenta el retardo.
clear all
close all
A=[0 1;0 0];
B=[0;1];
C=[1 0];
h=1;
d=1
n=size(A,2)
Q=[1 -0.3;-0.3 1];
R=1;
N=[0;0];

%El control Óptimo directo sin retraso
[Kd,Sd,Ed]=lqrd(A,B,Q,R,N,h);
xo=[1;1;1]
for m=1:9
tau=0.1*m;
%Contruimos las matrices optimas ampliadas
addpath ../;
[phia,gammaa]=dl2extended(A,B,C,tau,h,1); %modelo extendido
phia=double(phia);
gammaa=double(gammaa);

syms t;
phi=expm(A*t);
gamma=int(phi,t,0,t)*B;
q1=int(phi'*Q*phi,t,0,t);
q1=matlabFunction(q1,'vars',[t]);
q12=int(phi'*(Q*gamma+N),t,0,t);
q12=matlabFunction(q12,'vars',[t]);
q2=int(gamma'*Q*gamma+2*gamma'*N+R);
q2=matlabFunction(q2,'vars',[t]);
phi=matlabFunction(phi,'vars',[t]);
gamma=matlabFunction(gamma,'vars',[t]);

%Obtenido del paper Optimal Online Sampling Period Assignment:Theory and
%Experiments. 
Q1a=[q1(tau)+phi(tau)'*q1(h-tau)*phi(tau);q12(tau)'*phi(tau)];% En el paper dice q12(tau)'+phi(tau)
Q1b=[phi(tau)'*q12(tau);q2(tau)+gamma(tau)'*q1(h-tau)*gamma(tau)];%En el paper dice q12(tau)+phi(tau)'
Q1=[Q1a Q1b];
Q12=[phi(tau)'*q12(h-tau);gamma(tau)'*q12(h-tau)];
Q2=q2(h-tau);
Qd=[Q1 Q12;Q12' Q2];
[Ka,Sa,Ea]=dlqr(phia,gammaa,Q1,Q2,Q12);
Ks(1,:,m)=Ka;
J(m)=xo'*Sa*xo;
end
tau=0.1:0.1:0.9;
plot(tau,J,'r');
xlabel('retardo,\tau');
ylabel('J, coste');

