function  [k,tau,px] = gacker(A,B,h,polos)
syms k1 k2 tau  
global A
global B
global h
global polos
%1. Discretización
h=1
n=size(A,2)
[phi,gamma]=c2d(A,B,h)
%Lo=-place(phi,gamma,p);
%Modelo ampliado 
[A1 B1]=c2d(A,B,tau)
[A2 B2]=c2d(A,B,h-tau)
phi=A1*A2
gamma0=B2
gamma1=A2*B1

phiamp=[phi gamma1;zeros(1,size(A,2)) 0];
gammaamp=[gamma0;1];
Cc=[1 zeros(1,n)];
Dd=0;
%2. Ackermann
%K=[0 0...1]*Co^(-1)*P(phiamp)*[0;0;...;1]
%donde: P(phiamp) es el polinomio deseado evaluado en la matriz phiamp
%2a. Controlability Matrix
%C=[gammaamp phiamp*gammaamp phiamp^2*gammaamp] %Solo para orden 3
%Dimension checking
na = size(phiamp,1);
nu = size(gammaamp,2);
%co = zeros(n,n*nu);
co(:,1:nu) = vpa(gammaamp);
for k=1:na-1
  co(:,k*nu+1:(k+1)*nu) =phiamp*co(:,(k-1)*nu+1:k*nu);
end
% %Con un arrayfun si la dimensiòn de la matriz de controlabilidad fuera
% %bastante grande
% y = arrayfun(@(k) phiamp*co(:,(k-1)*nu+1:k*nu),1:n-1,'UniformOutput',0);
% %Habría que construir la matriz concatenando con los  vectores que hay en y
% Co=cat(2,co,y{1},y{2})

%Creando el vector de polos y asignandolos para su uso en la funciòn
%Si va y habrìa que hacerlo!!!!
%2b. Polinomio característico, Cayley Hamilton
% for i=1:length(polos)
% eval(sprintf('p%d=polos(i)',i))
% end
% ó
% p.info = 'polos';
% p=[]
% arrayfun(@(i) eval(sprintf('p.p%d=polos(i)',i)),1:length(polos))
% ó
% arrayfun(@(i) eval(sprintf('p%d=polos(i)',i)),1:length(polos))

x=phiamp
px=eye(na,na)
%Polinomio deseado
for j=1:na
%px=collect((x-p1*eye(3))*(x-p2*eye(3))*(x-p3*eye(3))) %the "alpha" coefficients
px=eval(px*(x-polos(j)*eye(na)));
end
%2c.Control Gain
k=[zeros(1,n),1]*inv(co)*px 
%k=[0 0 1]*inv(co)*px 
%tdaux=k*[0;0;1]*
tdaux=k*[zeros(n,1);1]
tau=vpa(solve(tdaux,tau))






