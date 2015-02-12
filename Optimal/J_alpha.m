%Variación J y parte compleja de Q, en este script se desea revisar como
%afecta al incluir una parte compleja en la matriz de pesado Q al coste,
%RESULTADO: El coste disminuye a medida que la parte compleja de Q (alpha) y N aumentan 
%esto se debe a que aunque al calcular el coste la parte compleja de la solución de Ricatti no
%influye, si lo hace en sus elementos reales. Es decir que a medida que
%alpha aumenta, todos los elementos de la solución de Ricatti disminuyen.
clear all
A=[0 1;0 0];
B=[0;1];
C=[1 0];
h=1;
n=size(A,2);
Q=[10 0;0 10];
R=1;
%N=[1; 1]
[Kd,Sd,Ed]=lqrdg(A,B,Q,1,1);

%Cálculo del Coste
xo=[1; 1];
J=0.5*(xo'*Sd*xo);

%Coste con matrices de pesado con parámetros complejos
Qx=zeros(n,n,10);
Ss=zeros(n,n,10);
Jj=zeros(1,10);
ks=zeros(1,n,10)
N=[0.1;0.1]
m=0;
for alpha=0:0.1:4  
m=m+1;
qq=Q+[0 -alpha*i;alpha*i 0];
%Nn=N+[alpha*i;-alpha*i]
Qx(:,:,m)=qq;
[K,S,E,Qd,Nd,Rd]=lqrdg(A,B,qq,R,N,h)
ks(1,:,m)=K;
Qds(:,:,m)=Qd
Ss(:,:,m)=S
Jx=0.5*(xo'*S*xo);
Jj(1,m)=Jx;
Es(:,:,m)=E;
%[phi,gamma]=c2d(A,B,h);
%phcl=phi-gamma*K;
% [ms,es]=eig(phcl);
% ess(:,:,m)=es
% mss(:,:,m)=ms
end
%Gráfica
alpha=0:.1:4;
plot(alpha,Jj,'r')

%% Relación del Coste con la Parte real polos y compleja de los polos obtenidos con los distinos Ks, a través del parámetro complejo alpha de Q
pr=real(Es)%Parte real
pc=imag(Es)%Parte compleja
pa=abs(Es)%Modulo

pr=reshape(pr,2,m)
pc=reshape(pc,2,m)
pa=reshape(pa,2,m)
figure, 
plot(alpha,pr(1,:),'r+',alpha,pr(2,:),'g+')
figure,
plot(alpha,pc(1,:),'ro',alpha,pc(2,:),'go')
xlabel('alpha, coeficiente complejo')
ylabel('Partes reales y complejas valores propios')
figure, 
plot(alpha,pa(1,:),'r+',alpha,pa(2,:),'g+')
figure
plot(pa(1,:),Jj)
xlabel('Módulo Valores propios')
ylabel('Coste')

