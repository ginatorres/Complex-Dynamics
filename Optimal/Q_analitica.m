clear all
close all
A=[0 1;0 0];
B=[0;1];
C=[1 0];
tau=0.9;
h=1;
d=1
n=size(A,2)
Q=[1 -0.3;-0.3 1];
R=1;
N=[0;0];

%El control Óptimo directo...
[Kd,Sd,Ed]=lqrd(A,B,Q,R,N,h);


%Contruimos las matrices optimas ampliadas
%esto deberia estar en un archivo separado
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
[Ka,Sa,Ea]=dlqr(phia,gammaa,Q1,Q2,Q12)
%Matriz de Lazo cerrado
phi_cl=phia-gammaa*Ka;
%Valores y Vectores Propios
[Ma,Ea]=eig(phi_cl); 


%% Modelo Alternativo
digits(4)
I=eye(n);
Z=zeros(n,d);
S=[I Z]; %Matriz  de seleccion
P=[zeros(1,d+1) eye(1);eye(d+1) zeros(d+1,1)]
%Combinacion sin Repeticion
k=2; %2 para obtener PCNC
pcl=S*Ma*Ea*P^k*S'*(S*Ma*P^k*S')^(-1);
pcnc=eig(pcl)

%% Kcomplex para calcular Q 
[phi,gamma]=c2d(A,B,h);
%Tomando dos de los 3 polos del modelo ampliado PCNC, polos complejos no
%conjugados
%Diseñamos una Kcompleja la cual es óptima
Kcomplex=place(phi,gamma,pcnc)
%%Valores propios con Kcomplex
phi_cl=phi-gamma*Kcomplex
Epcnc=eig(phi_cl);

Q=[Q1(1:2,1:2)]
t=Q1(1:2,3)
q=Q1(3,3)
% Encontramos Qc! Revisar último tèrmino.
Qc=Q+(inv(pcl))'*Kcomplex'*t'+(inv(pcl))'*Kcomplex'*q*Kcomplex*inv(pcl)+(inv(pcl))'*Kcomplex'*n*Kcomplex+t



