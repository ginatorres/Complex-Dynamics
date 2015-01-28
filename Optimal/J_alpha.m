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
Q=[10 0;0 1];
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
Nn=N+[alpha*i;-alpha*i]
%qq=Q+[-alpha*i 0;0 alpha*i ]; % No es simètrica
Qx(:,:,m)=qq;
%[k,s,e,Qd,Nd,Rd]=lqrdg(A,B,qq,1,h);
[K,S,E,Qd,Nd,Rd]=lqrdg(A,B,qq,R,N,h)
ks(1,:,m)=K;
Ss(:,:,m)=S
Jx=0.5*(xo'*S*xo);
Jj(1,m)=Jx;
end
%Gráfica
alpha=0:.1:4;
plot(alpha,Jj,'r')
xlabel('alpha, coeficiente complejo')
ylabel('J, coste')
[phi,gamma]=c2d(A,B,h)

%Jx =(xo'*Qd*xo + (-inv(Rd)*gamma'*S*xo)'*Rd*(-inv(Rd)*gamma'*S*xo) + 2*xo'*Nd*(-inv(Rd)*gamma'*S*xo))
%No da lo mismo que J=xo'*S*xo, pues debería hacer la sumatoria de 0 hasta N

%Relación parte compleja de Q y retraso tau
for m=1:10
pcl=phi-gamma*ks(1,:,m)
pcls(:,:,m)=pcl
Es(:,:,m)=eig(pcls(:,:,m))%Polos complejos no conjugados entonces d=2, debo estudiar el gacker para periodos màs largos que el periodo de muestreo
end

%% Usando la solución iterativa de la ecuación de ricatti en discreto
%Manualmente con el tèrmino cruzado N Página 311 Astrom
%Coste con matrices de pesado con parámetros complejos
Qx=zeros(n,n,10);
Jj=zeros(1,10);
ks=zeros(1,n,10)
m=0;
for alpha=0:0.1:4  
m=m+1;
qq=Qd+[0 -alpha*i;alpha*i 0];
%qq=Q+[-alpha*i 0;0 alpha*i ]; % No es simètrica
Qx(:,:,m)=qq;
k=10
while k>=1
Km(k,:)=vpa(inv(Rd+gamma'*S*gamma)*(gamma'*S*phi+Nd'));
S=(phi-gamma*Km(k,:))'*S*(phi-gamma*Km(k,:))+Qd-Nd'*Km(k,:)'-Nd*Km(k,:)+Km(k,:)'*Rd*Km(k,:);
k=k-1;
end
ks(1,:,m)=Km;
Jx=0.5*(xo'*S*xo);
Jj(1,m)=Jx;
end


